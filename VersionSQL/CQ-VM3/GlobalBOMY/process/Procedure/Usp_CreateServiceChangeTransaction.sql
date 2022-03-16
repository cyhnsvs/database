/****** Object:  Procedure [process].[Usp_CreateServiceChangeTransaction]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_CreateServiceChangeTransaction]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.[Usp_CreateServiceChangeTransaction]
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
Exec [process].[Usp_CreateServiceChangeTransaction] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);

	BEGIN TRY
		BEGIN TRANSACTION;


		SELECT * FROM GlobalBO.transmanagement.Tb_Transactions WHERE (ABS(AMOUNT)>1 AND ABS(AMOUNT)<99) AND (TransType='CHWD' OR TransType='SETLWD')
		UPDATE GlobalBO.transmanagement.Tb_Transactions SET AMOUNT= -ABS(ABS(Amount)-1) WHERE  (ABS(AMOUNT)>1 AND ABS(AMOUNT)<99) AND (TransType='CHWD' OR TransType='SETLWD')


		DECLARE @iintSourceRows INT, @iintTargetRows INT

		SET @iintSourceRows = (SELECT COUNT(*) FROM import.Tb_BURSA_CFT002)

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
			[CompanyId],
			[ExtTransactionId]  ,
			1 AS NonTradeTransInstructionType,
			[TransDate],
			[AcctNo],
			[TransType],
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
			TradeSetlExchrate ,
			CreatedBy,
			GETDATE() 
		FROM
			 (
				SELECT
					[CompanyId] = @iintCompanyId,
					[TransDate] =TransDate,
					[AcctNo] = A.AcctNo,
					[TransType] =A.TransType,
					[CurrCd] = CurrCd,
					[TransDesc] = '',
					[TaxAmount] = 0 ,--A.FeeAccountCurrency,
					[Amount] = A.Amount,--CAST(ABS(A.Amount) AS DECIMAL(15,2)),					
					[TradedQty] = A.TradedQty,--CAST(ABS(A.Amount) AS DECIMAL(15,2)),					
					[ReferenceNo] = A.ReferenceNo , --+ '|' + A.FrontOfficeLinkID  + '|' + A.TransactionNumber + '|' + a.CounterpartID,
					Tag1 = A.Tag1,
					Tag2 = A.Tag2,
					Tag3 = A.Tag3,
					[CreatedBy] = A.CreatedBy,
					[FundSourceCd] = A.FundSourceId,
					[SetlDate] = A.SetlDate,
					[TradeSetlExchrate] = ExchRateBased,--ExchRate,
					ExtTransactionId = CAST(@dteBusinessDate AS CHAR(10))+'|'+A.ReferenceNo
				FROM
					GlobalBO.transmanagement.Tb_Transactions As A WHERE (ABS(AMOUNT)>1 AND ABS(AMOUNT)<99) AND (TransType='CHWD' OR TransType='SETLWD')
			) AS B
		
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'AutoDebitProcess',@ointBatchid output,@strmessage Output;

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
												  SELECT LogDateTime, 'GlobalBOMY.process.Usp_ProcessTITOTransactions', '', [MessageLog] 
												  from @logs;
	
		SET @iintTargetRows = @@ROWCOUNT

		IF (@iintSourceRows = @iintTargetRows)
		BEGIN
		COMMIT TRANSACTION;
		SELECT 'Deposit Transaction Created Sucessfully'
		END
		ELSE
		BEGIN
		ROLLBACK TRANSACTION;
		SELECT 'Deposit Transaction Created Failed as Source Count & Target count not matching. Source Count ' + @iintSourceRows + ',Target Count ' + @iintTargetRows
		END

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
												  SELECT LogDateTime, 'GlobalBOTH.process.Usp_ProcessTITOTransactions', '', [MessageLog] 
												  from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END