/****** Object:  Procedure [process].[Usp_ProcessWithdrawTransactions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_ProcessWithdrawTransactions]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.[Usp_ProcessWithdrawTransactions]
Created By        : Nathiya Palanisamy
Created Date      : 04/01/2021
Last Updated Date : 
Description       : this sp is used to import the Withdraw Transactions into GBO.
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
		--BEGIN TRANSACTION;
		
		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		DECLARE @intPaymentId BIGINT,
				@istrCreatedBy VARCHAR(64);

		DECLARE @iintSourceRows INT, @iintTargetRows INT;
		
		EXECUTE GlobalBO.setup.Usp_FetchAndUpdateBatchKeys @iintCompanyId, 'SettledCloseOut', 1, @intPaymentId OUTPUT;    
  
		IF @intPaymentId IS NULL    
		BEGIN    
			EXECUTE utilities.usp_RethrowError 'BatchKeys Setup is not available.';    
		END   

		SELECT @iintSourceRows = COUNT(1) FROM import.Tb_ECOS_WithdrawalInfo;
		SELECT TOP 1 @istrCreatedBy = SourceFileName FROM import.Tb_ECOS_WithdrawalInfo;
		SET @istrCreatedBy = 'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) + '|' + @istrCreatedBy;

		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);
		
		UPDATE EW
		SET EW.Status='R', LastUpdated = GETDATE(), UpdatedBy=@istrCreatedBy, Remarks = 'Incomplete acct no'
		FROM GlobalBOMY.import.Tb_ECOS_WithdrawalInfo AS EW
		LEFT JOIN CQBTempDB.export.Tb_FormData_1409 AC 
		ON EW.ClientCode = AC.[AccountNumber (textinput-5)]
		WHERE AC.[AccountNumber (textinput-5)] IS NULL OR LEN(RTRIM(EW.ClientCode)) <> 9;

		UPDATE EW
		SET EW.Status='R', LastUpdated = GETDATE(), UpdatedBy=@istrCreatedBy, Remarks = 'Insufficient trust money'
		FROM GlobalBOMY.import.Tb_ECOS_WithdrawalInfo AS EW
		LEFT JOIN GlobalBO.holdings.Tb_Cash AS C
		ON EW.ClientCode = C.AcctNo
		WHERE Status <> 'R' AND ISNULL(C.Balance,0) + ISNULL(C.UnavailableBalance,0) < EW.WithdrawalAmt;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');
		
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
			Tag4,
			Tag5,
			[FundSourceCd],
			[SetlDate],
			CreatedBy,
			CreatedDate,
			PickInd,
			ExchRate,
			SetlAmount,
			SetlCurrCd,
			TransCurrCd
		)
		SELECT
			[CompanyId] = @iintCompanyId,
			ExtTransactionId = 'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) +'|'+ convert(varchar, @dteBusinessDate, 112) +'|'+RequestNo,
			[NonTradeTransInstructionType] = 1,
			[TransDate] = CAST(SUBSTRING(RequestDate, 7, 4) + '-'+SUBSTRING(RequestDate,4, 2)  + '-'+left(RequestDate,2)  AS DATE),  --CAST(A.RequestDate AS DATE),
			[AcctNo] = CAST(ClientCode AS VARCHAR),
			[TransType] = 'CHWD',
			[SubTransType] = WithdrawalType,
			[CurrCd] = 'MYR',
			[TransDesc] = 'Auto Withdrawal from ECOS - ' + @istrCreatedBy,
			[TaxAmount] = 0,
			[Amount] = CAST(ABS(CAST (LEFT(WithdrawalAmt,13)+'.'+RIGHT(WithdrawalAmt,2) as decimal(15,2))) AS DECIMAL(18,2)),					
			[ReferenceNo] = CAST(RequestNo AS VARCHAR), 
			Tag1 = CAST(A.RequestNo AS VARCHAR),
			Tag2 = CAST(A.BankDeposit AS VARCHAR),
			Tag3 = '',
			Tag4 = CAST(BankAcctNo AS VARCHAR),
			Tag5 = CAST(WithdrawalType AS VARCHAR),
			[FundSourceCd] = 'Cash',
			[SetlDate] = CAST(SUBSTRING(RequestDate, 7, 4) + '-'+SUBSTRING(RequestDate,4, 2)  + '-'+left(RequestDate,2)  AS DATE)  ,--CAST(A.RequestDate AS DATE),
			[CreatedBy] = @istrCreatedBy,
			[CreatedDate] = GETDATE(),
			'N' AS PickInd,
			1 AS ExchRate,
			CAST(ABS(CAST (LEFT(WithdrawalAmt,13)+'.'+RIGHT(WithdrawalAmt,2) as decimal(15,2))) AS DECIMAL(18,2)),
			'MYR',
			'MYR'
		FROM [GlobalBOMY].[import].Tb_ECOS_WithdrawalInfo As A
		WHERE Status <> 'R';
		
		
		--SELECT * FROM [GlobalBOMY].[import].Tb_ECOS_WithdrawalInfo As A WHERE Status <> 'R';
		--select * from  [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction];
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');
		        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL, 1, @istrCreatedBy, @ointBatchid output, @strmessage Output;

		IF @ointBatchId = 0      
				BEGIN    
				SET @ostrReturnMessage = @ostrReturnMessage + ',Settlement Instruction BatchId = 0' ;  
					EXECUTE utilities.usp_RethrowError @ostrReturnMessage;    
				END 
		
		--select * from  [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstructionArchive] where BatchId = @ointBatchId
		--select * from  [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction];

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');
		
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
					'CHWD'      
					,CAST(RequestDate AS DATE) AS  TransDate         
					,'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) +'|'+ convert(varchar, @dteBusinessDate, 112) +'|'+RequestNo AS TransReference        
					,0 AS QtyToSettle      
					,CAST(ABS(CAST (LEFT(WithdrawalAmt,13)+'.'+RIGHT(WithdrawalAmt,2) as decimal(15,2))) AS DECIMAL(18,2)) AS AmountToSettle        
					,0 AS IntToSettle 
					,1 AS ExchRate
					,0 AS TradedQty
					,0 AS TradedPrice         
					,'MYR' AS TradedCurrCd        
					,CAST(ABS(CAST (LEFT(WithdrawalAmt,13)+'.'+RIGHT(WithdrawalAmt,2) as decimal(15,2))) AS DECIMAL(18,2)) AS NetAmtInTradedCurr       
					,0 AS IntAmtInTradedCurr       
					,'MYR' AS SetlCurrCd         
					,CAST(ABS(CAST (LEFT(WithdrawalAmt,13)+'.'+RIGHT(WithdrawalAmt,2) as decimal(15,2))) AS DECIMAL(18,2)) AS NetAmtInSetlCurr       
					,0 AS IntAmtInSetlCurr       
					,@dteBusinessDate AS BusinessDate        
					,CAST(RequestDate AS DATE) SetlDate         
					,0 AS LotSize
					,'' AS InstrumentCd
					,@istrCreatedBy    
					,GETDATE()           
					,@intPaymentId    
					,@ointBatchId    
					,NULL  
					,'S' AS ContractInd  
					,'N' AS PartialInd  
					,@ointBatchId  
					,CAST(ClientCode AS VARCHAR)
					,1
					,0
				FROM           
					[GlobalBOMY].[import].Tb_ECOS_WithdrawalInfo 
				WHERE Status <> 'R';


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
			
			)          
			SELECT           
				WithdrawalType AS [Type]           
				,'MYR' AS Currency            
				,CAST(BankDeposit AS VARCHAR) AS CompanyBank             
				,CAST(BankAcctNo AS VARCHAR) AS ClientBank             
				,RequestNo AS PaymentReference            
				,CAST(ABS(CAST (LEFT(WithdrawalAmt,13)+'.'+RIGHT(WithdrawalAmt,2) as decimal(15,2))) AS DECIMAL(18,2)) AS PaymentAmount                
				,CAST(RequestDate AS DATE) AS TransDate             
				,CAST(RequestDate AS DATE) AS SetlDate                
				,@istrCreatedBy            
				,GETDATE()        
				,@intPaymentId    
				,@ointBatchId    
				,'PAYMENTS-' +  cast(@intPaymentId as varchar(30)) +'|'+ convert(varchar, @dteBusinessDate, 112) +'|'+RequestNo  AS remarks 
				
			FROM           
				[GlobalBOMY].[import].Tb_ECOS_WithdrawalInfo
			WHERE Status <> 'R';;      
        

		/*
		
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

		*/

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_ProcessWithdrawTransactions', '', [MessageLog] 
		from @logs;
	
		/*
		SET @iintTargetRows = @@ROWCOUNT

		IF (@iintSourceRows = @iintTargetRows)
		BEGIN
			--COMMIT TRANSACTION;
			SELECT 'Withdraw Transaction Created Sucessfully'
		END
		ELSE
		BEGIN
			--ROLLBACK TRANSACTION;
			SELECT 'Withdraw Transaction Created Failed as Source Count & Target count not matching. Source Count ' + @iintSourceRows + ',Target Count ' + @iintTargetRows
		END
		*/

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
		SELECT LogDateTime, 'GlobalBOTH.process.Usp_ProcessWithDrawTransactions', '', [MessageLog] 
		from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END