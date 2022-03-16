/****** Object:  Procedure [process].[Usp_ProcessDepositTransactions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_ProcessDepositTransactions]
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
		--BEGIN TRANSACTION;

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		DECLARE @intReceiptId BIGINT,
				@istrCreatedBy VARCHAR(64);

		DECLARE @iintSourceRows INT, @iintTargetRows INT;

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);
				
		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');

		EXECUTE GlobalBO.setup.Usp_FetchAndUpdateBatchKeys @iintCompanyId, 'SettledCloseOut', 1, @intReceiptId OUTPUT;    
  
		IF @intReceiptId IS NULL    
		BEGIN    
			EXECUTE utilities.usp_RethrowError 'BatchKeys Setup is not available.';    
		END   

		SELECT @iintSourceRows = COUNT(1) FROM import.Tb_ECOS_DepositInfo ;		
		SELECT TOP 1 @istrCreatedBy = SourceFileName FROM import.Tb_ECOS_DepositInfo ;
		SET @istrCreatedBy = 'RECEIPTS-' +  cast(@intReceiptId as varchar(30)) + '|' + @istrCreatedBy;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		BEGIN TRANSACTION
		
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
			[CompanyId] = @iintCompanyId,
			ExtTransactionId = 'RECEIPTS-' +  cast(@intReceiptId as varchar(30)) +'|'+ convert(varchar, @dteBusinessDate, 112) +'|'+ChequeNo,
			[NonTradeTransInstructionType] = 1,
			[TransDate] = @dteBusinessDate,
			[AcctNo] = AccountNo,
			[TransType] = 'CHDP',
			[SubTransType] = L.Value3,
			[CurrCd] = Currency,
			[TransDesc] = 'Auto Deposit from ECOS - ' + @istrCreatedBy,
			[TaxAmount] = 0,
			[Amount] = ABS(CAST (LEFT(Amount,13)+'.'+RIGHT(Amount,2) as decimal(15,2))),	
			[ReferenceNo] = ChequeNo,
			Tag1 = A.RefNo,
			Tag2 = A.ChequeBank,
			Tag3 = A.CashBookID,
			[FundSourceCd] = 'Cash',
			[SetlDate] = A.ChequeDate,
			[TradeSetlExchrate] = CAST (LEFT(ExchRate,3)+'.'+RIGHT(ExchRate,6) as decimal(9,6)),
			Tag5 = A.PaymentType,
			[CreatedBy] = @istrCreatedBy,
			[CreatedDate] = GETDATE()
		--select count(1) 
		FROM [import].[Tb_ECOS_DepositInfo] As A
		INNER JOIN GlobalBO.setup.Tb_Account AS AC
		ON A.AccountNo = AC.AcctNo
		INNER JOIN GlobalBOLocal.Setup.Tb_Lookup AS L
		ON REPLACE(A.PaymentType,'C','A') = L.Value1 AND L.CodeType='ReceiptType';
		
		--select * FROM [import].[Tb_ECOS_DepositInfo] As A where RefNo='CD27300164'
		--select * from GlobalBOLocal.Setup.Tb_Lookup AS L where L.CodeType='ReceiptType';

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');
		
		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,@istrCreatedBy,@ointBatchid output,@strmessage Output;
		
		IF (@ointBatchid = 0)
			EXEC GlobalBOLocal.utilities.usp_RethrowError @strmessage;

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
			'RECEIPTS-' +  cast(@intReceiptId as varchar(30)) +'|'+ convert(varchar, @dteBusinessDate, 112) +'|'+ChequeNo AS TransReference,
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
			@istrCreatedBy AS CreatedBy,
			GETDATE() AS CreatedOn,
			@intReceiptId AS ReceiptId,
			'' AS Batchid,
			'' AS remarks,
			NULL AS ContractInd,
			NULL AS PartialInd,
			@ointBatchid AS BatchIdNonTrade,
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
			'' AS SetOption,
			@istrCreatedBy AS CreatedBy,
			GETDATE() AS CreatedDate,
			CashBookID AS CompanyBank,
			ChequeBank AS ClientBank,
			ChequeNo AS ReceiptReference,
			Amount AS ReceiptAmount,
			@dteBusinessDate AS TransDate,
			ChequeDate AS SetlDate,
			@intReceiptId AS ReceiptId,
			@ointBatchid AS Batchid,
			'RECEIPTS-' +  cast(@intReceiptId as varchar(30)) +'|'+ convert(varchar, @dteBusinessDate, 112) +'|'+ChequeNo AS remarks,
			NULL AS ExcessAmount,
			NULL AS RefundExcess
		FROM GlobalBOMY.import.[Tb_ECOS_DepositInfo];

		INSERT INTO [import].[Tb_ECOS_DepositInfoArchive]
           ([AccountNo]
           ,[PaymentType]
           ,[ChequeDate]
           ,[ChequeNo]
           ,[ChequeBank]
           ,[ClientAccountNo]
           ,[RefNo]
           ,[CashBookID]
           ,[Currency]
           ,[ExchRate]
           ,[Amount]
           ,[Commission]
           ,[BankInd]
           ,[Remarks]
           ,[SourceFileName]
           ,[CreatedOn]
           ,[ArchiveOn])
	 SELECT 
			[AccountNo]
           ,[PaymentType]
           ,[ChequeDate]
           ,[ChequeNo]
           ,[ChequeBank]
           ,[ClientAccountNo]
           ,[RefNo]
           ,[CashBookID]
           ,[Currency]
           ,[ExchRate]
           ,[Amount]
           ,[Commission]
           ,[BankInd]
           ,[Remarks]
           ,[SourceFileName]
           ,[CreatedOn]
           ,GETDATE() AS [ArchiveOn]
	FROM [import].[Tb_ECOS_DepositInfo];

	INSERT INTO [import].[Tb_ECOS_DepositInfo_Archival]
           ([AccountNo]
           ,[PaymentType]
           ,[ChequeDate]
           ,[ChequeNo]
           ,[ChequeBank]
           ,[ClientAccountNo]
           ,[RefNo]
           ,[CashBookID]
           ,[Currency]
           ,[ExchRate]
           ,[Amount]
           ,[Commission]
           ,[BankInd]
           ,[Remarks]
           ,[SourceFileName]
           ,[CreatedOn]
           ,[Status]
		   ,[LastUpdated]
		   ,[UpdatedBy]
		   ,[BusinessDate]
		   ,[ArchivalDate]
		   )
	 SELECT 
			[AccountNo]
           ,[PaymentType]
           ,[ChequeDate]
           ,[ChequeNo]
           ,[ChequeBank]
           ,[ClientAccountNo]
           ,[RefNo]
           ,[CashBookID]
           ,[Currency]
           ,[ExchRate]
           ,[Amount]
           ,[Commission]
           ,[BankInd]
           ,[Remarks]
           ,[SourceFileName]
           ,[CreatedOn]
		   ,[Status]
		   ,[LastUpdated]
		   ,[UpdatedBy]
           ,GETDATE() AS [BusinessDate]
		   ,GETDATE() AS [ArchivalDate]
	FROM [import].[Tb_ECOS_DepositInfo];

	DELETE FROM [import].[Tb_ECOS_DepositInfo];

	--COMMIT TRANSACTION;
	
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
		SELECT 'Deposit Transaction Created Sucessfully'
	END
	ELSE
	BEGIN
		--ROLLBACK TRANSACTION;
		SELECT 'Deposit Transaction Created Failed as Source Count & Target count not matching. Source Count ' + CAST(@iintSourceRows as varchar(50)) + ',Target Count ' + CAST(@iintTargetRows as varchar(50))
	END
		

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
		SELECT LogDateTime, 'GlobalBOTH.process.Usp_ProcessDepositTransactions', '', [MessageLog] 
		from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END