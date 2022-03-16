/****** Object:  Procedure [process].[Usp_ProcessWithdrawTransactions_20211015]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_ProcessWithdrawTransactions_20211015]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.[Usp_ProcessWithdrawTransactions]
Created By        : Nathiya Palanisamy
Created Date      : 04/01/2021
Last Updated Date : 
Description       : this sp is used to import the Withdraw Transactions into GBO Local Payment.
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_ProcessWithdrawTransactions] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);

	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @iintSourceRows INT, @iintTargetRows INT

		SET @iintSourceRows = (SELECT COUNT(*) FROM [GlobalBOMY].[import].[Tb_EFMACS_CWD])

		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);


		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[RPS].[Tb_PaymentTransaction]');
		
		INSERT INTO [GlobalBOLocal].[RPS].[Tb_PaymentTransaction](
			 TransType
			,TransDate
			,TransReference
			,QtyToSettle
			,AmountToSettle
			,IntToSettle
			,TradedQty
			,TradedPrice
			,TradedCurrCd
			,NetAmtInTradedCurr
			,IntAmtInTradedCurr
			,SetlCurrCd
			,NetAmtInSetlCurr
			,IntAmtInSetlCurr
			,BusinessDate
			,SetlDate
			,LotSize
			,InstrumentCd
			,CreatedBy
			,CreatedOn
			,PaymentId
			,Batchid
			,remarks
			,ContractInd
			,PartialInd
			,BatchIdNonTrade
			,AcctNo
			,TransNo
			,IsReversed
			,RevBatchId
			,RevBatchIdNonTrade
			,RevRemarks
			,RevTransNo
			,FundSourceId
			,ModifiedBy
			,ModifiedOn
			,ReverseReasonCd
			,UserRemarks
		)
		SELECT
			'CHDP',
			CAST(TransactionDate AS date),
			ReferenceNo,
			0,
			WithdrawalAmt,
			0,
			0,
			0,
			'MYR',
			WithdrawalAmt,
			0,
			'MYR',
			WithdrawalAmt,
			0,
			@dteBusinessDate,
			@dteBusinessDate,
			'',
			'',
			'GBOMY-ECOS_Withdraw',
			GETDATE(),
			ReferenceNo,
			'',
			'',
			NULL,
			NULL,
			NULL,
			ClientCode,
			ReferenceNo,
			0,
			NULL,
			NULL,
			NULL,
			NULL,
			1,
			NULL,
			NULL,
			NULL,
			NULL
		FROM
			[import].[Tb_EFMACS_CWD] AS A	

		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[RPS].[Tb_PaymentTransaction]');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[RPS].[Tb_Payment]');

		INSERT INTO GlobalBOLocal.RPS.Tb_Payment
		(
			 [Type]
			,Currency
			,BankCode
			,PaymentReference
			,SetOption
			,CreatedBy
			,CreatedDate
			,CompanyBank
			,ClientBank
			,PaymentAmount
			,TransDate
			,SetlDate
			,PaymentId
			,Batchid
			,remarks
			,ExcessAmount
			,RefundExcess
		)
		SELECT 
			WithdrawalType,
			'MYR',
			BankDeposited,
			BankAcct,
			'',
			'GBOMY-ECOS_Withdraw',
			GETDATE(),
			BankDeposited,
			BankDeposited,
			WithdrawalAmt,
			@dteBusinessDate,
			@dteBusinessDate,
			ReferenceNo,
			'',
			'',
			NULL,
			NULL
		FROM 
			GlobalBOMY.import.[Tb_EFMACS_CWD] 
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[RPS].[Tb_Payment]');
	

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
			[ReferenceNo],
			Tag1,
			Tag2,	
			Tag3,	
			[FundSourceCd],
			[SetlDate],
			Tag4,
			Tag5,
			CreatedBy,
			CreatedDate
		)
		SELECT 
			@iintCompanyId,
			CAST(@dteBusinessDate AS CHAR(10))+'|'+ CAST(P.PaymentId AS varchar),
			1,
			PB.TransDate,
			P.AcctNo,
			P.TransType,
			PB.Currency,
			'Cash Withdrawal',
			0,
			PB.PaymentAmount,
			PB.PaymentId,
			'',
			'',
			PB.ClientBank,
			1,
			PB.SetlDate,
			PB.PaymentReference,
			PB.CompanyBank,
			'GBOMY-ECOS_Withdraw',
			GETDATE()
		FROM 
			GlobalBOLocal.RPS.Tb_PaymentTransaction P
		INNER JOIN
			GlobalBOLocal.RPS.Tb_Payment PB ON P.PaymentId = PB.PaymentId

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
			[ReferenceNo],	
			Tag1,
			Tag2,	
			Tag3,
			[FundSourceCd],
			[SetlDate],
			Tag4,
			Tag5,
			--TradeSetlExchrate ,
			CreatedBy,
			GETDATE() 
		FROM
			 (
				SELECT
					[CompanyId] = @iintCompanyId,
					[TransDate] = CAST(A.TransactionDate AS DATE),
					[AcctNo] = CAST(ClientCode AS VARCHAR),
					[TransType] = 'CHWD',
					[CurrCd] = '',
					[TransDesc] = 'Cash Withdrawal',
					[TaxAmount] = 0 ,
					[Amount] = CAST(WithdrawalAmt AS DECIMAL(18,2)),					
					[ReferenceNo] = CAST(ReferenceNo AS VARCHAR), 
					Tag1 = CAST(A.ClientBranchCode AS VARCHAR),
					Tag2 = CAST(A.AvailableTrustAmt AS VARCHAR),
					Tag3 = CAST(A.BankDeposited AS VARCHAR),
					Tag4 = CAST(BankAcct AS VARCHAR),
					Tag5 = CAST(WithdrawalType AS VARCHAR),
					[CreatedBy] = SourceFileName,
					[FundSourceCd] = '', -- CAST(SourceID AS VARCHAR),
					[SetlDate] = '',
					[TradeSetlExchrate] = 0,
					ExtTransactionId = CAST(@dteBusinessDate AS CHAR(10))+'|'+ CAST(ReferenceNo AS varchar)
				FROM
					[GlobalBOMY].[import].[Tb_EFMACS_CWD] As A
			) AS B
		
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'GBOMY-ECOS_Withdraw',@ointBatchid output,@strmessage Output;

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
												  SELECT LogDateTime, 'GlobalBOMY.process.Usp_ProcessWithdrawTransactions', '', [MessageLog] 
												  from @logs;
	
		SET @iintTargetRows = @@ROWCOUNT

		IF (@iintSourceRows = @iintTargetRows)
		BEGIN
		COMMIT TRANSACTION;
		SELECT 'Withdraw Transaction Created Sucessfully'
		END
		ELSE
		BEGIN
		ROLLBACK TRANSACTION;
		SELECT 'Withdraw Transaction Created Failed as Source Count & Target count not matching. Source Count ' + @iintSourceRows + ',Target Count ' + @iintTargetRows
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
												  SELECT LogDateTime, 'GlobalBOTH.process.Usp_ProcessWithDrawTransactions', '', [MessageLog] 
												  from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END