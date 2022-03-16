/****** Object:  Procedure [process].[USP_AutoDebitServiceChargeForInActiveAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[USP_AutoDebitServiceChargeForInActiveAccounts]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : process.[USP_AutoDebitServiceChargeForInActiveAccounts]
Created By        : Nathiya Palanisamy
Created Date      : 12/05/2021
Last Updated Date : 
Description       : this sp is used to Auto debit 10.00RM as service charge from client's trust for inactive accounts 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[USP_AutoDebitServiceChargeForInActiveAccounts] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

	BEGIN TRY
		BEGIN TRANSACTION;

		CREATE TABLE #InActiveAccount (
			AcctNo			VARCHAR(20),
			CashBalance		DECIMAL(24,9),
			CurrCd			VARCHAR(3),
			FundSourceCd	VARCHAR(20)
		);
		INSERT INTO #InActiveAccount (
			AcctNo,
			CashBalance,
			CurrCd,
			FundSourceCd
		)
		SELECT
			T.AcctNo,
			C.Balance,
			C.CurrCd,
			F.FundSourceCd
		FROM 
			CQBTempDB.export.Tb_FormData_1409 A
		INNER JOIN
			GlobalBO.holdings.Tb_Cash C ON C.AcctNo = A.[AccountNumber (textinput-5)]  
		INNER JOIN 
			GlobalBO.setup.Tb_FundSource F ON C.FundSourceId = F.FundSourceId  AND C.CompanyId = F.CompanyId
		LEFT JOIN
			GlobalBO.transmanagement.Tb_TransactionsSettled T ON T.AcctNo = A.[AccountNumber (textinput-5)]
		WHERE 
			(T.TransType IS NULL OR T.TransType IN ('TRBUY','TRSELL'))
		AND 
			((T.ContractDate IS NOT NULL AND ContractDate < DATEADD(year,-3,@dteBusinessDate))
			OR
			(T.ContractDate IS NULL AND [AccountOpenedDate (dateinput-19)] < DATEADD(year,-3,@dteBusinessDate)))
		AND
			C.CompanyId = @iintCompanyId AND C.CurrCd = 'MYR' AND Balance > 0 AND C.FundSourceId = 1 -- Cash
		AND
			[ParentGroup (selectsource-3)] NOT IN ('M','G','V','P','CE1','CE3','CE2','I')

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');
		
		-- Service charge Transactions
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
			'IA-' + CAST(@dteBusinessDate AS CHAR(10))+'|'+ AcctNo + '|' + FundSourceCd,
			1,
			@dteBusinessDate,
			AcctNo,
			'CHDN',
			'SVCHG',
			CurrCd,
			'Debit Note',
			0,
			CASE WHEN CashBalance > 10.00 THEN 10.00 ELSE CashBalance END,
			0,		
			AcctNo + '|' + FundSourceCd,	
			'',
			'',
			'',
			FundSourceCd,
			@dteBusinessDate,
			'',
			'AutoDebit_InActiveAcct',
			GETDATE() 
		FROM  #InActiveAccount 
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'AutoDebitProcess_InActiveAccounts',@ointBatchid output,@strmessage Output;

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
												  SELECT LogDateTime, 'GlobalBOMY.Process.USP_AutoDebitServiceChargeForInActiveAccounts', '', [MessageLog] 
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
												  SELECT LogDateTime, 'GlobalBOTH.process.USP_AutoDebitServiceChargeForInActiveAccounts', '', [MessageLog] 
												  from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END