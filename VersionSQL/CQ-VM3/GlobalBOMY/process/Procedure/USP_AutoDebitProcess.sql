/****** Object:  Procedure [process].[USP_AutoDebitProcess]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[USP_AutoDebitProcess]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : process.[USP_AutoDebitProcess]
Created By        : Subramani V
Created Date      : 22/04/2021
Last Updated Date : 
Description       : this sp is used to import the Deposit Transactions instrument IN and OUT into GBO.
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[USP_AutoDebitProcess] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);

	BEGIN TRY
		BEGIN TRANSACTION;

		CREATE TABLE #AutoDebitProcess (
		TransNo						VARCHAR(50) DEFAULT(''),
		TransDate					date,
		AcctNo						VARCHAR(20),
		CurrCd						VARCHAR(3) DEFAULT(''),
		TradedQty					DECIMAL(24,9) DEFAULT(0),
		Amount						DECIMAL(24,9) DEFAULT(0),
		ReferenceNo					VARCHAR(50) DEFAULT(''),
		SubTransType				VARCHAR(50) DEFAULT(''),
		Tag1						VARCHAR(200) DEFAULT(''),
		Tag2						VARCHAR(200) DEFAULT(''),
		Tag3						VARCHAR(200) DEFAULT(''),
		CreatedBy					VARCHAR(64) DEFAULT(''),
		FundSourceId				Bigint DEFAULT(1),
		SetlDate					DATE DEFAULT(''),
		ExchRateBased				DECIMAL(24,9) DEFAULT(1),
		);

		INSERT INTO #AutoDebitProcess (
			TransNo,
			TransDate,
			AcctNo,
			CurrCd,
			TradedQty,
			Amount,
			ReferenceNo,
			SubTransType,
			Tag1,
			Tag2,
			Tag3,
			CreatedBy,
			FundSourceId,
			SetlDate,
			ExchRateBased
		)
		SELECT
			TransNo,
			TransDate,
			AcctNo,
			CurrCd,
			TradedQty,
			Amount,
			ReferenceNo,
			SubTransType,
			Tag1,
			Tag2,
			Tag3,	
			CreatedBy,
			FundSourceId,
			SetlDate,
			ExchRateBased
		FROM GlobalBO.transmanagement.Tb_Transactions 
		WHERE (ABS(AMOUNT)>1 AND ABS(AMOUNT)<=100) AND TransType='CHWD' AND SubTransType IN ('IBG','CQ') AND CreatedBy <> 'AutoDebitProcess_LessThanRM100';

		-- Reduce 1 RM Transaction where Amount <= 100
		UPDATE GlobalBO.transmanagement.Tb_Transactions 
		SET Amount= -ABS(ABS(Amount)-1), AmountBased= -ABS(ABS(Amount)-1), AmountClientBased= -ABS(ABS(Amount)-1), ModifiedBy = 'AutoDebitProcess_LessThanRM100', ModifiedDate = GETDATE()
		WHERE (ABS(Amount)>1 AND ABS(Amount)<=100) AND TransType='CHWD' AND SubTransType IN ('IBG','CQ');

		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');
		
		-- Reduced 1 RM to be insert into Tb_NonTradeTransactionInstruction Table.
		INSERT INTO [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction] (
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
			CAST(@dteBusinessDate AS CHAR(10))+'|'+TransNo+'|'+ReferenceNo,
			1,
			@dteBusinessDate,
			AcctNo,
			'CHDN',
			'SVCHG',
			CurrCd,
			'Service Charge for WD Amount less than RM 100',
			0 ,
			1 AS Amount,
			0,		
			TransNo,	
			'' AS Tag1,
			Tag2,
			Tag3,
			'Cash',
			B.SetlDate,
			ExchRateBased,
			'AutoDebitProcess_LessThanRM100',
			GETDATE() 
		FROM #AutoDebitProcess AS B;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'AutoDebitProcess_LessThanRM100',@ointBatchid output,@strmessage Output;
		
		COMMIT TRANSACTION
		
		DECLARE @loop BIT
		SET @loop = 1
		WHILE (@loop = 1)
		BEGIN
		
			IF EXISTS(select 1 from GlobalBO.interface.Tb_InterfaceExecution with(nolock) 
							where SourceFileName='BACKEND_INSERT' --AND ExecutionStatus IN ('I','P','T','U','V'))
						  AND (ExecutionStatus IN ('I','P','T','U','V') OR (ExecutionStatus='F' AND Remarks LIKE '%deadlock%')))
			BEGIN 
				WAITFOR DELAY '00:00:10'
			END
			ELSE
			BEGIN
				SET @loop = 0;
				BREAK;
			END
		END

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.[process].[USP_AutoDebitProcess]', '', [MessageLog] 
		from @logs;
	
		-- Reject transaction with <= 1 RM value.
		UPDATE TA 
		SET AppStatus = 'R', ApprovedBy='AutoDebitProcess_LessThanRM1', AppDate = GETDATE() --'Less than minimum values'
		FROM GlobalBO.transmanagement.Tb_TransactionApproval TA
		INNER JOIN GlobalBO.transmanagement.Tb_Transactions TR ON TA.ReferenceID = TR.RecordId
		WHERE (ABS(AMOUNT)<=1) AND TransType='CHWD' AND SubTransType IN ('IBG','CQ') AND AppLevel = '3' AND CreatedBy <> 'AutoDebitProcess_LessThanRM100';

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
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
		SELECT LogDateTime, 'GlobalBOMY.[process].[USP_AutoDebitProcess]', '', [MessageLog] 
		from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END