/****** Object:  Procedure [process].[USP_AutoDebitServiceChargeForDTAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[USP_AutoDebitServiceChargeForDTAccounts]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : process.[USP_AutoDebitServiceChargeForDTAccounts]
Created By        : Nathiya Palanisamy
Created Date      : 12/05/2021
Last Updated Date : 
Description       : this sp is used to Auto debit 30.00RM as service charge from client's trust for DT accounts  on 1st of every month
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[USP_AutoDebitServiceChargeForDTAccounts] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

	BEGIN TRY
		--BEGIN TRANSACTION;

		--SELECT * FROM GlobalBOMY.import.Tb_Account where AccountGroup IN ('CE1','CE2','CE3')
		--SELECT * FROM GlobalBOMY.import.Tb_Cash_ACBAL where ACCTNO like '%J' and SUBACCTTYP='CA' and CAST(AVAILACBAL as decimal(24,9))<0
		--select * from GlobalBO.holdings.Tb_Cash where AcctNo='024422205'
		--select * from GlobalBO.holdings.Tb_Cash where AcctNo='015281505'

		CREATE TABLE #DTAccount (
			AcctNo			VARCHAR(20),
			CashBalance		DECIMAL(24,9),
			CurrCd			VARCHAR(3),
			FundSourceCd	VARCHAR(20)
		);

		INSERT INTO #DTAccount (
			AcctNo,
			CashBalance,
			CurrCd,
			FundSourceCd
		)
		SELECT
			AcctNo,
			--CI.[CustomerName (textinput-3)],
			--[Tradingaccount (selectsource-31)],
			Balance,
			CurrCd,
			FundSourceCd
		FROM GlobalBO.holdings.Tb_Cash C 
		INNER JOIN GlobalBO.setup.Tb_FundSource F 
		ON C.FundSourceId = F.FundSourceId  AND C.CompanyId = F.CompanyId
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON C.AcctNo = A.[AccountNumber (textinput-5)]
		INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS CI
		ON A.[CustomerID (selectsource-1)] = CI.[CustomerID (textinput-1)]
		WHERE C.CompanyId = 1 AND C.CurrCd = 'MYR' AND Balance > 0 AND C.FundSourceId = 1 -- Cash
		AND RIGHT(AcctNo,2) = '05' AND A.[Tradingaccount (selectsource-31)] = 'A'
		--AND C.AcctNo = '017389505'
		--AND [AccountGroup (selectsource-2)] IN ('CE1','CE2','CE3');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');
		
		
		-- Service charge Transactions
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
			'DT-' + CAST(@dteBusinessDate AS CHAR(10))+'|'+AcctNo + '|' + FundSourceCd,
			1,
			@dteBusinessDate,
			AcctNo,
			'CHDN',
			'SVCHG',
			CurrCd,
			'Maintenance Charge for DT Accounts',
			0,
			CASE WHEN CashBalance > 30.00 THEN 30.00 ELSE CashBalance END,
			0,		
			AcctNo + '|' + FundSourceCd,	
			'',
			'',
			'',
			FundSourceCd,
			@dteBusinessDate,
			'',
			USER_NAME(),
			GETDATE() 
		FROM  #DTAccount;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'AutoDebitProcess_DTAccounts',@ointBatchid output,@strmessage Output;

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
		SELECT LogDateTime, 'GlobalBOMY.Process.USP_AutoDebitServiceChargeForDTAccounts', '', [MessageLog] 
		from @logs;

		--COMMIT TRANSACTION
		
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
		SELECT LogDateTime, 'GlobalBOTH.process.USP_AutoDebitServiceChargeForDTAccounts', '', [MessageLog] 
		from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END