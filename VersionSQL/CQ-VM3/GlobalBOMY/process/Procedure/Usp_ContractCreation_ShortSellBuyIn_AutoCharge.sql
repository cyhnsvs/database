/****** Object:  Procedure [process].[Usp_ContractCreation_ShortSellBuyIn_AutoCharge]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_ContractCreation_ShortSellBuyIn_AutoCharge]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : process.[Usp_ContractCreation_ShortSellBuyIn_AutoCharge]
Created By        : Nishanth
Created Date      : 20/09/2021
Last Updated Date : 
Description       : this sp is used to create a debit transaction to charge 1% for short sell buying in contracts created today
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_ContractCreation_ShortSellBuyIn_AutoCharge] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);
	DECLARE @SSBI_Rate decimal(24,9);

	SELECT @SSBI_Rate = Rate
	FROM GlobalBO.setup.Tb_TierGroup AS TG
	INNER JOIN GlobalBO.setup.Tb_Tier AS T
	ON TG.TierGroupId = T.TierGroupId
	WHERE TierGroupCd='SC-1.000000000';

	BEGIN TRY
		BEGIN TRANSACTION;
		
		SELECT * 
		INTO #Contracts_SSBI
		FROM GlobalBO.contracts.Tb_ContractOutstanding
		WHERE Facility = 'B';

		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');
		
		INSERT INTO [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction](
			[CompanyId],
			[ExtTransactionId],
			[NonTradeTransInstructionType], 
			[TransDate],
			[AcctNo],
			[TransType],
			[SubTransType],
			[CurrCd],
			[TransDesc],
			[TaxAmount],
			[Amount],
			[TradedQty],			
			[ReferenceNo],
			Tag1,
			Tag2,	
			Tag3,	
			[FundSourceCd],
			[SetlDate],
			Tag4,
			CreatedBy,
			CreatedDate
		)
		SELECT
			@iintCompanyId,
			CAST(@dteBusinessDate AS CHAR(10))+'/'+ContractNo+'/'+ContractPartNo+'/'+ContractAmendNo,
			1,
			@dteBusinessDate,
			AcctNo,
			'CHDN',
			'SVCHG',
			SetlCurrCd,
			'',
			0,
			ROUND(@SSBI_Rate/100 * NetAmountSetl,2),
			0,		
			ContractNo+'/'+ContractPartNo+'/'+ContractAmendNo,	
			'Service Charge for Short Sell Buy In Transaction' AS Tag1,
			'' Tag2,
			'' Tag3,
			FundSourceId,
			@dteBusinessDate,
			'' AS Tag4,
			CreatedBy,
			GETDATE() 
		FROM #Contracts_SSBI AS B
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'ContractCreation_ShortSellBuyIn_AutoCharge',@ointBatchid output,@strmessage Output;

		DECLARE @loop BIT
		SET @loop = 1
		WHILE (@loop = 1)
		BEGIN
		
			IF EXISTS(select 1 from GlobalBO.interface.Tb_InterfaceExecution with(nolock) 
							where SourceFileName='BACKEND_INSERT' --AND ExecutionStatus IN ('I','P','T','U','V'))
						  AND (ExecutionStatus IN ('I','P','T','U','V') OR (ExecutionStatus='F' AND Remarks LIKE '%deadlock%')))
			BEGIN 
				WAITFOR DELAY '00:00:15'
			END
			ELSE
			BEGIN
				SET @loop = 0;
				BREAK;
			END
		END

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.[process].[Usp_ContractCreation_ShortSellBuyIn_AutoCharge]', '', [MessageLog] 
		from @logs;
	
		COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION; 

		 DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);


        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
												  SELECT LogDateTime, 'GlobalBOMY.[process].[Usp_ContractCreation_ShortSellBuyIn_AutoCharge]', '', [MessageLog] 
												  from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END