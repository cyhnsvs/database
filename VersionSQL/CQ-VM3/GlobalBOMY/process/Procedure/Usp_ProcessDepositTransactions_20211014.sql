/****** Object:  Procedure [process].[Usp_ProcessDepositTransactions_20211014]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_ProcessDepositTransactions_20211014]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.[Usp_ProcessDepositTransactions]
Created By        : Nathiya Palanisamy
Created Date      : 24/12/2020
Last Updated Date : 
Description       : this sp is used to import the Deposit Transactions into GBO Local Receipt.
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_ProcessDepositTransactions] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);

	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @iintSourceRows INT, @iintTargetRows INT

		SET @iintSourceRows = (SELECT COUNT(*) FROM import.Tb_ECOS_DepositInfo)

		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[RPS].[Tb_ReceiptTransaction]');
		
		INSERT INTO [GlobalBOLocal].[RPS].[Tb_ReceiptTransaction] (
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
			,ReceiptId
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
			'CHDP' AS TransType,
			@dteBusinessDate AS TransDate,
			'' AS TransReference,
			0 AS QtyToSettle,
			Amount AS AmountToSettle, --TODO
			0 AS IntToSettle,
			0 AS TradedQty,
			0 AS TradedPrice,
			Currency AS TradedCurrCd,
			Amount AS NetAmtInTradedCurr,
			0 AS IntAmtInTradedCurr,
			Currency AS SetlCurrCd,
			Amount AS NetAmtInSetlCurr,
			0 AS IntAmtInSetlCurr,
			@dteBusinessDate,
			ChequeDate AS SetlDate,
			0 AS LotSize,
			'' AS InstrumentCd,
			'GBOMY-ECOS_Deposit' AS CreatedBy,
			GETDATE() AS CreatedOn,
			0 AS ReceiptId,
			'' AS Batchid,
			'' AS remarks,
			NULL AS ContractInd,
			NULL AS PartialInd,
			NULL AS BatchIdNonTrade,
			AccountNo AS AcctNo,
			RefNo AS TransNo,
			0 AS IsReversed,
			NULL AS RevBatchId,
			NULL AS RevBatchIdNonTrade,
			NULL AS RevRemarks,
			NULL AS RevTransNo,
			1 AS FundSourceId,
			NULL AS ModifiedBy,
			NULL AS ModifiedOn,
			NULL AS ReverseReasonCd,
			NULL AS UserRemarks
		FROM [import].[Tb_ECOS_DepositInfo] AS A;

		INSERT INTO GlobalBOLocal.RPS.Tb_ReceiptBankDetails
		(
			 [Type]
			,Currency
			,BankCode
			,Amount
			,PaymentReference
			,SetOption
			,CreatedBy
			,CreatedDate
			,CompanyBank
			,ClientBank
			,ReceiptReference
			,ReceiptAmount
			,TransDate
			,SetlDate
			,ReceiptId
			,Batchid
			,remarks
			,ExcessAmount
			,RefundExcess
		)
		SELECT 
			PaymentType,
			Currency,
			ChequeBank,
			Amount,
			ChequeNo,
			'',
			'GBOMY-ECOS_Deposit',
			GETDATE(),
			CashBookID,
			ChequeBank,
			ChequeNo,
			Amount,
			@dteBusinessDate,
			@dteBusinessDate,
			RefNo,
			'',
			'',
			NULL,
			NULL
		FROM 
			GlobalBOMY.import.[Tb_ECOS_DepositInfo] 
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[RPS].[Tb_ReceiptTransaction]');
	
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
			CAST(@dteBusinessDate AS CHAR(10))+'|'+ CAST(R.ReceiptId AS varchar),
			1,
			RB.TransDate,
			R.AcctNo,
			R.TransType,
			RB.Currency,
			'Cash Deposit',
			0,
			RB.ReceiptAmount,
			RB.ReceiptId,
			'',
			'',
			RB.ClientBank,
			1,
			RB.SetlDate,
			RB.ReceiptReference,
			RB.CompanyBank,
			'GBOMY-ECOS_Deposit',
			GETDATE()
		FROM 
			GlobalBOLocal.RPS.Tb_ReceiptTransaction R
		INNER JOIN
			GlobalBOLocal.RPS.Tb_ReceiptBankDetails RB ON R.ReceiptId = RB.ReceiptId
		
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'GBOMY-ECOS_Deposit',@ointBatchid output,@strmessage Output;

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
												  SELECT LogDateTime, 'GlobalBOMY.process.Usp_ProcessDepositTransactions', '', [MessageLog] 
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
												  SELECT LogDateTime, 'GlobalBOTH.process.Usp_ProcessDepositTransactions', '', [MessageLog] 
												  from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END