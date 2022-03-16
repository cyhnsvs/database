/****** Object:  Procedure [process].[Usp_Process_SELL_IBG_Transactions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_Process_SELL_IBG_Transactions]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.[Usp_Process_SELL_IBG_Transactions]
Created By        : Nishanth Chowdhary
Created Date      : 15/10/2021
Last Updated Date : 
Description       : this sp is used to create the IBG transactions for TRSELL contracts due today EOD
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_Process_SELL_IBG_Transactions] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);

	BEGIN TRY
		

		declare @ointBatchid bigint=0,
				@intNonTradeBatchId bigint=0,
				@strmessage varchar(3000);
        
		DECLARE @intPaymentId BIGINT,
				@istrCreatedBy VARCHAR(64);

		DECLARE @iintSourceRows INT, @iintTargetRows INT;

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);
				
		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');
		
		SELECT TOP 1 @istrCreatedBy = 'AUTO/TRSELL_IBG';

		--SELECT @dteBusinessDate =  GlobalBOLocal.[dbo].[Udf_FetchSetupDate] (@iintCompanyId,'BusDate');
		
		EXECUTE GlobalBO.setup.Usp_FetchAndUpdateBatchKeys      
				@iintCompanyId,      
				'SettledCloseOut',      
				1,      
				@intPaymentId OUTPUT;      
    	
		IF @intPaymentId IS NULL      
		BEGIN      
			EXECUTE utilities.usp_RethrowError 'BatchKeys Setup is not available.';      
		END    
	
		SET @istrCreatedBy = 'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) + '|' + @istrCreatedBy ;
		
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'EXEC - [GlobalBOLocal].[RPS].[Usp_GetSettlementInstructionForAccounts]');

		--BEGIN TRANSACTION
		
		DROP TABLE IF EXISTS #Tb_AccountsSIInd;

		CREATE TABLE #Tb_AccountsSIInd (
			[RunningID] [int] NOT NULL,
			[AcctNo] [varchar](20) NOT NULL,
			[DeductTrustPurchases] CHAR(1) NOT NULL DEFAULT 'N',
			[DeductTrustNonTradeDebitTrans] CHAR(1) NOT NULL DEFAULT 'N',
			[TransferCreditToTrust] CHAR(1) NOT NULL DEFAULT 'N',
			SettlementMode CHAR(1) NOT NULL DEFAULT '1'
			) ON [PRIMARY]

		INSERT INTO #Tb_AccountsSIInd
		exec globalbolocal.[RPS].[Usp_GetSettlementInstructionForAccounts] 'SIInd';

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into #SellContracts_SetlToday');

		DROP TABLE IF EXISTS #SellContracts_SetlToday;

		SELECT CO.*, FI.[Bank (Dropdown)] AS BankCode, FI.[Account Number (TextBox)] AS BankAcctNo, FI.[Account Holder Name (TextBox)] AS BankAcctName
		INTO #SellContracts_SetlToday
		--select * 
		FROM 
			(SELECT * FROM #Tb_AccountsSIInd where TransferCreditToTrust='N') AS S
		INNER JOIN 
			(SELECT CO.AcctNo, CO.ContractNo, CO.ContractPartNo, CO.ContractAmendNo, CO.Tag1, A.ChequeName, A.ExtRefKey, CO.TransType, CO.ContractDate, CO.SetlDate, 
					I.InstrumentCd, CO.SetlCurrCd,
					CO.NetAmountSetl-ISNULL(TP.PaymentMade,0) AS NetAmountSetlBalance, CO.NetAmountSetl, TP.PaymentMade, 
					CO.TradedQty-ISNULL(TP.FreeQty,0) AS RemainingQty, CO.TradedQty, TP.FreeQty 
			 FROM GlobalBO.contracts.Tb_ContractOutstanding AS CO
			 INNER JOIN GlobalBO.setup.Tb_Instrument AS I
			 ON CO.InstrumentId = I.InstrumentId
			 INNER JOIN GlobalBO.setup.Tb_Account AS A
			 ON CO.AcctNo = A.AcctNo
			 LEFT JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid AS TP
			 ON CO.ContractNo =TP.ContractNo AND CO.ContractAmendNo = TP.ContractAmendNo AND CO.ContractPartNo = TP.ContractPartNo
			 WHERE CO.SetlDate= @dteBusinessDate AND CO.TransType='TRSELL' AND CO.AcctNo <> CO.CustodianAcctNo
			) AS CO
		ON S.AcctNo = CO.AcctNo
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS AC
			ON CO.AcctNo = AC.[AccountNumber (textinput-5)]
		INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS C
			ON AC.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
		LEFT JOIN CQBTempDB.export.Tb_FormData_1410_grid6 AS FI
			ON C.RecordID = FI.RecordID AND FI.[ (Radio Button)] = 'Y'
		WHERE NetAmountSetlBalance > 0;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_SettlementInstruction]');

	
		BEGIN TRANSACTION;

		INSERT INTO GlobalBOLocal.[import].[Tb_SettlementInstruction]
			([CompanyId]
			,[ExtTransactionId]
			,[ReceiptNo]
			,[SetlInstructionType]
			,[ExtContractRefNo]
			,[FreeQty]
			,[PaymentRefNo]
			,[PaymentDesc]
			,[TransDate]
			,[BankCd]
			,[TransType]
			,[SubTransType]
			,[CurrCd]
			,[Amount]
			,[ExchRate]
			,[SetlAmount]
			,[Tag1]
			,[Tag2]
			,[Tag3]
			,[Tag4]
			,[Tag5]
			,[BatchId]
			,[PickInd]
			,[ContractInd]
			,[PartialInd]
			,[RejectReason]
			,[InterfaceDataExecutionId]
			,[RefSetlInstructionId]
			,[CreatedBy]
			,[CreatedDate]
			,AccruedInterestAmountSetl)
		SELECT
			@iintCompanyId AS [CompanyId]
			,'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) + '-' + ContractNo+ '/' + CAST(ContractPartNo as varchar(50)) AS [ExtTransactionId]
			,'' AS [ReceiptNo]
			,2 AS [SetlInstructionType]
			,ContractNo+ '/' + CAST(ContractPartNo as varchar(50)) AS [ExtContractRefNo]
			,0 AS [FreeQty] -- RemainingQty
			,'' AS [PaymentRefNo]
			,'' AS [PaymentDesc]
			,@dteBusinessDate AS [TransDate]
			,'' AS [BankCd]
			,'SETLWD' AS [TransType]
			,'' AS [SubTransType]
			,A.SetlCurrCd AS [CurrCd]
			,A.NetAmountSetl AS [Amount]
			,1 AS [ExchRate]
			,A.NetAmountSetl AS [SetlAmount]
			,'' AS [Tag1]
			,'PAYMENTS-' + cast(@intPaymentId as varchar(30)) +
			'|CASH DEPOSIT '+B.CurrCd + ' ' +  CAST(CAST(B.CHDPAmount AS DECIMAL(28,2)) AS VARCHAR(30)) + 
			'|Qty-' + CAST(RemainingQty  AS VARCHAR(50)) + 
						'|PaymentAmount-' +  CAST(ABS(A.NetAmountSetl)  AS VARCHAR(50)) + 
						'|IntAmountSetl-0'  AS [Tag2]
			,A.BankCode AS [Tag3]
			,A.BankAcctNo AS [Tag4]
			,'' AS [Tag5]
			,0 AS [BatchId]
			,'N' AS [PickInd]
			,'D' ContractInd
			,'N' [PartialInd]
			,NULL AS [RejectReason]
			,NULL AS [InterfaceDataExecutionId]
			,NULL AS [RefSetlInstructionId]
			,@istrCreatedBy AS [CreatedBy]
			,GETDATE () AS [CreatedDate]
			,0 AS IntToSettle
		FROM #SellContracts_SetlToday AS A INNER JOIN 
			(SELECT AcctNo , SetlCurrCd as CurrCd , sum(NetAmountSetl) as CHDPAmount FROM #SellContracts_SetlToday group by AcctNo , SetlCurrCd) as b 
		on a.AcctNo = b.AcctNo and a.SetlCurrCd = b.CurrCd;

		--DECLARE @ointBatchId BIGINT, @ostrReturnMessage VARCHAR(8000);

		EXECUTE GlobalBOLocal.import.Usp_ProcessSettlementInstructionByBatch NULL, @iintCompanyId, @istrCreatedBy, @ointBatchId output, @ostrReturnMessage output;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - execute Usp_ProcessSettlementInstructionByBatch');

		IF @ointBatchId = 0
		BEGIN
			SET @ostrReturnMessage = @ostrReturnMessage + ',Settlement Instruction BatchId = 0' ;
			EXECUTE utilities.usp_RethrowError @ostrReturnMessage;
		END

		--select * from  GlobalBOLocal.[import].[Tb_SettlementInstructionArchive] where BatchId = @ointBatchId;

		INSERT INTO GlobalBOLocal.[import].[Tb_NonTradeTransactionInstruction]			 
			(
			[CompanyId]    
			,[ExtTransactionId]    
			,[NonTradeTransInstructionType]    
			,[TransNo]    
			,[TransDate]    
			,[AcctNo]    
			,[TransType]    
			,[SubTransType]    
			,[InstrumentCd]    
			,[CurrCd]    
			,[TransCurrCd]    
			,[TradedPrice]    
			,[TradedQty]    
			,[TransDesc]    
			,[ReferenceNo]    
			,[GLAccount]    
			,[ExchRate]    
			,[TaxAmount]    
			,[Amount]    
			,[SetlCurrCd]    
			,[SetlAmount]    
			,[Tag1]    
			,[Tag2]    
			,[Tag3]    
			,[Tag4]    
			,[Tag5]    
			,[RefTransNo]    
			,[BatchId]    
			,[PickInd]    
			,[RejectReason]    
			,[InterfaceDataExecutionId]    
			,[RefSetlInstructionId]    
			,[CreatedBy]    
			,[CreatedDate]    
			,[CustodianAcctNo]    
			,[FundSourceCd]    
			,[SetlDate])      
		SELECT     
				@iintCompanyId AS  [CompanyId]    
				,'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) + '-' + '-CHWD-' + AcctNo + '-' + SetlCurrCd AS [ExtTransactionId]  
				,1 AS [NonTradeTransInstructionType]    
				,'' AS [TransNo]    
				,@dteBusinessDate AS  [TransDate]    
				,AcctNo as [AcctNo]    
				,'CHWD' AS [TransType]    
				,'IBG' AS [SubTransType]    
				--,'' AS [SubTransType] 
				,NULL AS [InstrumentCd]    
				,SetlCurrCd AS [CurrCd]    
				,SetlCurrCd AS [TransCurrCd]    
				,0 AS [TradedPrice]    
				,0 AS [TradedQty]    
				,'Auto Payment for Sales via IBG' AS [TransDesc]     
				,NULL AS [ReferenceNo]
				,NULL AS [GLAccount]    
				,1 AS [ExchRate]    
				,0 AS [TaxAmount]    
				,ABS(sum(NetAmountSetl)) AS [Amount]    
				,SetlCurrCd AS [SetlCurrCd]    
				,ABS(sum(NetAmountSetl)) AS [SetlAmount]    
				,'' AS [Tag1]    
				,'PAYMENTS-' +  cast(@intPaymentId as varchar(30))  AS [Tag2]    
				,BankCode AS [Tag3]    
				,BankAcctNo AS [Tag4]    
				,'' AS [Tag5]     
				,NULL AS [RefTransNo]    
				,0 AS [BatchId]    
				,'N' AS [PickInd]    
				,NULL AS [RejectReason]    
				,NULL AS [InterfaceDataExecutionId]    
				,NULL AS [RefSetlInstructionId]    
				,@istrCreatedBY AS [CreatedBy]    
				,GETDATE() AS [CreatedDate]    
				,NULL AS [CustodianAcctNo]    
				,'Cash' AS [FundSourceCd]  
				,SetlDate AS [SetlDate]
		FROM #SellContracts_SetlToday
		GROUP BY AcctNo, SetlCurrCd, AcctNo, BankAcctName, BankCode, BankAcctNo, SetlDate

		UNION ALL

		SELECT     
				@iintCompanyId AS  [CompanyId]    
				,'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) + '-' + '-CHDP-' + AcctNo + '-' + SetlCurrCd AS [ExtTransactionId]  
				,1 AS [NonTradeTransInstructionType]    
				,'' AS [TransNo]    
				,@dteBusinessDate AS  [TransDate]    
				,AcctNo as [AcctNo]    
				,'CHDP' AS [TransType]    
				,'' AS [SubTransType]    
				--,'' AS [SubTransType] 
				,NULL AS [InstrumentCd]    
				,SetlCurrCd AS [CurrCd]    
				,SetlCurrCd AS [TransCurrCd]    
				,0 AS [TradedPrice]    
				,0 AS [TradedQty]    
				,'Auto Payment for Sales via IBG' AS [TransDesc]     
				,NULL AS   [ReferenceNo]
				,NULL AS [GLAccount]    
				,1  AS [ExchRate]    
				,0 AS [TaxAmount]    
				,ABS(sum(NetAmountSetl)) AS [Amount]    
				,SetlCurrCd AS  [SetlCurrCd]    
				,ABS(sum(NetAmountSetl))  AS [SetlAmount]    
				,'' AS [Tag1]    
				,'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) AS [Tag2]    
				,BankCode AS [Tag3]    
				,BankAcctNo AS [Tag4]    
				,'' AS [Tag5]     
				,NULL AS [RefTransNo]    
				,0 AS [BatchId]    
				,'N' AS [PickInd]    
				,NULL AS [RejectReason]    
				,NULL AS [InterfaceDataExecutionId]    
				,NULL AS [RefSetlInstructionId]    
				,@istrCreatedBY AS [CreatedBy]    
				,GETDATE() AS [CreatedDate]    
				,NULL AS [CustodianAcctNo]    
				,'Cash' AS [FundSourceCd]  
				,SetlDate AS [SetlDate]
		FROM #SellContracts_SetlToday
		GROUP BY AcctNo, SetlCurrCd, SetlDate, BankCode, BankAcctNo;

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL , @iintCompanyId, @istrCreatedBY,@intNonTradeBatchId  OUTPUT,@ostrReturnMessage  OUTPUT ;    
    
		IF @intNonTradeBatchId = 0 
		BEGIN    
			SET @ostrReturnMessage = @ostrReturnMessage + ',NonTradeTransactionInstructionBatchId is 0';  
			EXECUTE utilities.usp_RethrowError @ostrReturnMessage;    
		END   

		--select * from  GlobalBOLocal.[import].[Tb_NonTradeTransactionInstructionArchive] where BatchId = @intNonTradeBatchId;

		INSERT INTO GlobalBOLocal.[RPS].[Tb_PaymentTransaction]           
			(          
					TransType         
				,TransDate         
				,TransReference        
				,QtyToSettle         
				,AmountToSettle        
				,IntToSettle     
				,PaymentExchRate
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
				,FundSourceId  
				,IsReversed
		) 
		SELECT           
			'TRSELL' AS TransType   
			,@dteBusinessDate         
			,ContractNo+ '/' + CAST(ContractPartNo as varchar(50))  AS TransReference        
			,RemainingQty  AS QtyToSettle        
			,NetAmountSetl AS AmountToSettle        
			,0 AS IntToSettle 
			,1 ExchRate
			,RemainingQty AS TradedQty 
			,0 AS TradedPrice         
			,SetlCurrCd AS TradedCurrCd        
			,NetAmountSetl AS NetAmtInTradedCurr       
			,0 AS IntAmtInTradedCurr       
			,SetlCurrCd         
			,NetAmountSetl AS NetAmtInSetlCurr       
			,0 AS IntAmtInSetlCurr       
			,@dteBusinessDate        
			,SetlDate         
			,0 AS LotSize
			,ISNULL(InstrumentCd,'')
			,@istrCreatedBy    
			,GETDATE()           
			,@intPaymentId    
			,@ointBatchId    
			,NULL  
			,'D' AS ContractInd  
			,'N' AS PartialInd  
			,@intNonTradeBatchId  
			,AcctNo  
			,1  
			,0
		FROM #SellContracts_SetlToday;
				
		INSERT INTO GlobalBOLocal.[RPS].[Tb_Payment]          
			(          
				[Type]           
				,Currency            
				,CompanyBank             
				,ClientBank             
				,PaymentReference            
				,PaymentAmount                
				,TransDate             
				,SetlDate         
				,CreatedBy        
				,CreatedDate     
				,PaymentId    
				,Batchid    
				,remarks  
				, BankCode
			
			)          
		SELECT 'IBG' AS [Type]           
			,SetlCurrCd AS Currency            
			,BankCode AS CompanyBank             
			,BankAcctNo AS ClientBank             
			,BankAcctName AS PaymentReference            
			,ABS(SUM(NetAmountSetl)) AS PaymentAmount                
			,@dteBusinessDate AS TransDate             
			,SetlDate                
			,@istrCreatedBy            
			,GETDATE()        
			,@intPaymentId    
			,@intNonTradeBatchId    
			,'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) + '-' + '-CHWD-' + AcctNo + '-' + SetlCurrCd  
			,BankCode
		FROM #SellContracts_SetlToday
		GROUP BY AcctNo , SetlCurrCd,BankAcctName,BankCode,BankAcctNo,SetlDate;  

		--select * from GlobalBOLocal.[RPS].[Tb_PaymentTransaction]   where PaymentId = @intPaymentId;
		--select * from GlobalBOLocal.[RPS].[Tb_Payment]   where PaymentId = @intPaymentId

		COMMIT TRANSACTION;


		--select * FROM [import].[Tb_ECOS_DepositInfo] As A where RefNo='CD27300164'
		--select * from GlobalBOLocal.Setup.Tb_Lookup AS L where L.CodeType='ReceiptType';

	--COMMIT TRANSACTION;
	
/*	DECLARE @loop BIT
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
	

	INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Execute GlobalBOLocal.import.Usp_ProcessSettlementInstructionByBatch');

	insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
	SELECT LogDateTime, 'GlobalBOMY.process.Usp_Process_SELL_IBG_Transactions', '', [MessageLog] 
	from @logs;
	
	SET @iintTargetRows = @@ROWCOUNT
	*/


	--IF (@iintSourceRows = @iintTargetRows)
	--BEGIN
	--	SELECT 'Settlement Transactions Created Sucessfully'
	--END
	--ELSE
	--BEGIN
	--	--ROLLBACK TRANSACTION;
	--	SELECT 'Settlement Transactions Created Failed as Source Count & Target count not matching. Source Count ' + CAST(@iintSourceRows as varchar(50)) + ',Target Count ' + CAST(@iintTargetRows as varchar(50))
	--END
		

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION; 

		
		execute GlobalBOLocal.utilities.usp_GetErrorDetails @ostrReturnMessage output

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOTH.process.Usp_Process_SELL_IBG_Transactions', '', [MessageLog] 
		from @logs;

    		 
	END CATCH

END