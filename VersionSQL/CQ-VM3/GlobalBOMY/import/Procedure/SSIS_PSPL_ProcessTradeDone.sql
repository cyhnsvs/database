/****** Object:  Procedure [import].[SSIS_PSPL_ProcessTradeDone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[SSIS_PSPL_ProcessTradeDone]

AS
BEGIN
	SET NOCOUNT ON;
	
	-- company id hard-coded to 1

	declare @intCpartyId bigint ,
			@IntFundSourceId bigint,
			@decVatRate decimal(23,6) = '0.07',
			@dteCreatedDate datetime2(0) = getdate() ,
			@StrCpartyAcctNo VARCHAR(50),
			@intCompanyId INT = 1,
			@TargetRows int,
			@SourceRows int;


	select @intCpartyId = CorporateClientId , @StrCpartyAcctNo = TradingAcctNo  from GlobalBO.setup.Tb_CounterPartyAccount where cpartyacctno ='PSPL' and CompanyId = 1 ;
	select @IntFundSourceId = FundSourceId from GlobalBO.setup.Tb_FundSource where CompanyId = 1 and FundSourceCd = 'PSPL';

	BEGIN TRY
		BEGIN TRANSACTION;
		

		--DELETE from [GlobalBO].[contracts].[Tb_OrderManual] where CreatedBy like '%TRADEDONE%'

		INSERT INTO [GlobalBO].[contracts].[Tb_OrderManual](
		    [CompanyId]
           ,[AcctNo]
           ,[AcctExecutiveCd]
           ,[SourceId]
           ,[OrderNo]
           ,[SubOrderNo]
           ,[ProductId]
           ,[InstrumentId]
           ,[InstrumentName]
           ,[ContractCd]
           ,[ContractMonth]
           ,[SetlDate]
           ,[InterestSetlDate]
           ,[ExchCd]
           ,[Symbol]
           ,[SymbolSuffix]
           ,[StrikePrice]
           ,[CPInd]
           ,[TradedCurrCd]
           ,[TradedQty]
           ,[TradedPrice]
           ,[OrderQty]
           ,[OrderPrice]
           ,[TransType]
           ,[TradeType]
           ,[Channel]
           ,[TradeDate]
           ,[TimeSlotId]
           ,[AmalgamationInd]
           ,[Facility]
           ,[CPartyId]
           ,[CPartyAcctNo]
           ,[FundSourceId]
           ,[SetlCurrCd]
           ,[TradeSetlExchRate]
           ,[DeliveryMethod]
           ,[CustodianId]
           ,[CustodianAcctNo]
           ,[CloseOutRef]
           ,[BrokerageGroupId]
           ,[BrokerageInclusionId]
           ,[BrokerageInclusion]
           ,[TradeAllocationId]
           ,[TradeConfirmationInd]
           ,[AccruedInterestAmount]
           ,[BrokerageAmount]
           ,[BrokerageExpense]
           ,[ExchFeeAmount]
           ,[ExchFeeTax]
           ,[ChargesAmount]
           ,[ChargesTax]
           ,[CPBrokerageAmount]
           ,[CPExchFeeAmount]
           ,[CPExchFeeTax]
           ,[CPChargesAmount]
           ,[CPChargesTax]
           ,[Tag1]
           ,[Tag2]
           ,[Tag3]
           ,[Tag4]
           ,[Tag5]
           ,[ProcessInfo]
           ,[OrderStatus]
           ,[RecordId]
           ,[ActionInd]
           ,[CurrentUser]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[InterestRate])
		SELECT
			@intCompanyId AS [CompanyId]
           , CASE 
				WHEN A.SourceFileName LIKE '%MANTRADEDONE%' 
				then A.[Acct_no] else A.CustomerRef 
			end  AS [AcctNo]
           ,A.Remisier_code AS [AcctExecutiveCd]
           ,'Manual' AS [SourceId]
           ,ORDER_NO AS [OrderNo]
           ,Orderid AS [SubOrderNo]
           ,B.[ProductId]
           ,b.[InstrumentId]
           ,b.ShortName AS [InstrumentName]
           ,'' as [ContractCd]
           ,'' as [ContractMonth]
           ,NULL AS [SetlDate]
           ,NULL AS [InterestSetlDate]
           ,B.ListedExchCd as [ExchCd]
           ,'' AS [Symbol]
           ,'' AS [SymbolSuffix]
           ,0 as [StrikePrice]
           ,'N' as [CPInd]
           ,RTRIM(A.[TradedCurr]) AS [TradedCurrCd]
           ,A.[ExecutedQty] as [TradedQty]
           ,A.[Executed_Price] as [TradedPrice]
           ,A.[ExecutedQty] as  [OrderQty]
           ,A.[Executed_Price] as [OrderPrice]
           ,CASE 
				WHEN A.[Side] =1 THEN 'TRBUY' 
				WHEN A.Side = 2 THEN 'TRSELL' 
			END as [TransType]
           ,'' as [TradeType]
           ,CASE 
				WHEN LastModifiedUT ='1' THEN  'Agent' 
				WHEN LastModifiedUT ='C1' THEN 'Offline' ELSE LastModifiedUT  
			END  AS Channel  
           ,CAST(A.[Executed_Time] AS DATE) AS [TradeDate]
           ,'ExchRate_0000_0000' AS [TimeSlotId]
           ,'-' as [AmalgamationInd]
           ,'B' as [Facility]
		   ,@intCpartyId AS [CPartyId]
           ,@StrCpartyAcctNo AS [CPartyAcctNo]
           ,@IntFundSourceId AS [FundSourceId]
           ,RTRIM(A.[SettlementCurr]) AS [SetlCurrCd]
           ,A.[ExchangeRate] AS [TradeSetlExchRate]
           ,'' AS [DeliveryMethod]
           ,@intCpartyId as [CustodianId]
           ,@StrCpartyAcctNo as [CustodianAcctNo]
           ,'' as [CloseOutRef]
           ,0 AS [BrokerageGroupId]
           ,0 AS [BrokerageInclusionId]
           ,'1100' AS [BrokerageInclusion]
           ,'0' AS [TradeAllocationId]
           ,'N' AS [TradeConfirmationInd]
           ,0 AS [AccruedInterestAmount]
           ,NULL AS [BrokerageAmount]
           ,NULL AS [BrokerageExpense]
           ,NULL AS [ExchFeeAmount]
           ,NULL AS [ExchFeeTax]
           ,0 AS [ChargesAmount]
           ,0 AS [ChargesTax]
           ,NULL AS [CPBrokerageAmount]
           ,NULL AS [CPExchFeeAmount]
           ,NULL AS [CPExchFeeTax]
           ,0 AS [CPChargesAmount]
           ,0 AS [CPChargesTax]
           ,'' AS [Tag1]
           ,ORDER_NO AS [Tag2]
           ,'' AS [Tag3]
           ,'' as [Tag4]
           ,'' as [Tag5]
           ,'000000XXXX000XXXXXXX00XXXXXX0X1100020000' as [ProcessInfo]
           , CASE 
				WHEN A.SourceFileName LIKE '%MANTRADEDONE%' then 'C' else  'A' 
			end as [OrderStatus]
           ,newid() as [RecordId]
           ,'I' as [ActionInd]
           ,'' as [CurrentUser]
           ,A.SourceFileName AS [CreatedBy]
           ,@dteCreatedDate AS [CreatedDate]
           ,NULL AS [ModifiedBy]
           ,NULL AS [ModifiedDate]
           ,0 AS [InterestRate]
		FROM [import].[PSPL_TradeDone] AS A
		INNER JOIN [GlobalBO].[setup].[Tb_Instrument] B 
			ON (A.[Company_code] = B.[InstrumentCd])
		INNER JOIN GlobalBO.setup.Tb_ProductCategory AS C 
			ON B.ProductId = C.ProductId AND B.CompanyId = C.CompanyId
		WHERE C.CompanyId = @intCompanyId
		UNION ALL
		SELECT
			@intCompanyId AS [CompanyId]
           , CASE 
				WHEN A.SourceFileName LIKE '%MANTRADEDONE%' 
				then A.[Acct_no] else A.CustomerRef 
			end  AS [AcctNo]
           ,A.Remisier_code AS [AcctExecutiveCd]
           ,'Manual' AS [SourceId]
           ,ORDER_NO AS [OrderNo]
           ,Orderid AS [SubOrderNo]
           ,B.[ProductId]
           ,b.[InstrumentId]
           ,b.ShortName AS [InstrumentName]
           ,'' as [ContractCd]
           ,'' as [ContractMonth]
           ,NULL AS [SetlDate]
           ,NULL AS [InterestSetlDate]
           ,B.ListedExchCd as [ExchCd]
           ,'' AS [Symbol]
           ,'' AS [SymbolSuffix]
           ,0 as [StrikePrice]
           ,'N' as [CPInd]
           ,RTRIM(A.[TradedCurr]) AS [TradedCurrCd]
           ,A.[ExecutedQty] as [TradedQty]
           ,A.[Executed_Price] as [TradedPrice]
           ,A.[ExecutedQty] as  [OrderQty]
           ,A.[Executed_Price] as [OrderPrice]
           ,CASE 
				WHEN A.[Side] =1 THEN 'TRBUY' 
				WHEN A.Side = 2 THEN 'TRSELL' 
			END as [TransType]
           ,'' as [TradeType]
           ,CASE 
				WHEN LastModifiedUT ='1' THEN  'Agent' 
				WHEN LastModifiedUT ='C1' THEN 'Offline' ELSE LastModifiedUT  
			END  AS Channel  
           ,CAST(A.[Executed_Time] AS DATE) AS [TradeDate]
           ,'ExchRate_0000_0000' AS [TimeSlotId]
           ,'-' as [AmalgamationInd]
           ,'B' as [Facility]
		   ,@intCpartyId AS [CPartyId]
           ,@StrCpartyAcctNo AS [CPartyAcctNo]
           ,@IntFundSourceId AS [FundSourceId]
           ,RTRIM(A.[SettlementCurr]) AS [SetlCurrCd]
           ,A.[ExchangeRate] AS [TradeSetlExchRate]
           ,'' AS [DeliveryMethod]
           ,@intCpartyId as [CustodianId]
           ,@StrCpartyAcctNo as [CustodianAcctNo]
           ,'' as [CloseOutRef]
           ,0 AS [BrokerageGroupId]
           ,0 AS [BrokerageInclusionId]
           ,'1100' AS [BrokerageInclusion]
           ,'0' AS [TradeAllocationId]
           ,'N' AS [TradeConfirmationInd]
           ,0 AS [AccruedInterestAmount]
           ,NULL AS [BrokerageAmount]
           ,NULL AS [BrokerageExpense]
           ,NULL AS [ExchFeeAmount]
           ,NULL AS [ExchFeeTax]
           ,0 AS [ChargesAmount]
           ,0 AS [ChargesTax]
           ,NULL AS [CPBrokerageAmount]
           ,NULL AS [CPExchFeeAmount]
           ,NULL AS [CPExchFeeTax]
           ,0 AS [CPChargesAmount]
           ,0 AS [CPChargesTax]
           ,'' AS [Tag1]
           ,ORDER_NO AS [Tag2]
           ,'' AS [Tag3]
           ,'' as [Tag4]
           ,'' as [Tag5]
           ,'000000XXXX000XXXXXXX00XXXXXX0X1100020000' as [ProcessInfo]
           , CASE 
				WHEN A.SourceFileName LIKE '%MANTRADEDONE%' then 'C' else  'A' 
			end as [OrderStatus]
           ,newid() as [RecordId]
           ,'I' as [ActionInd]
           ,'' as [CurrentUser]
           ,A.SourceFileName AS [CreatedBy]
           ,@dteCreatedDate AS [CreatedDate]
           ,NULL AS [ModifiedBy]
           ,NULL AS [ModifiedDate]
           ,0 AS [InterestRate]
		FROM [import].[PSPL_TradeDone_MAN] AS A
		INNER JOIN [GlobalBO].[setup].[Tb_Instrument] B 
			ON (A.[Company_code] = B.[InstrumentCd])
		INNER JOIN GlobalBO.setup.Tb_ProductCategory AS C 
			ON B.ProductId = C.ProductId AND B.CompanyId = C.CompanyId
		WHERE C.CompanyId = @intCompanyId

		/***** Update Stats *****/
		SELECT @TargetRows = @@ROWCOUNT
		SELECT @SourceRows = COUNT(1) FROM [import].[PSPL_TradeDone]


		EXECUTE [import].[TS_UpdateRowCount] 
			@iintCompanyId   = @intCompanyId
			,@istrCheckedFor = '[GlobalBOMY].[import].[SSIS_PSPL_ProcessTradeDone]'
			,@istrCol1       = '[GlobalBOMY].[import].[PSPL_TradeDone]'
			,@istrCol2       = '[GlobalBO].[contracts].[Tb_OrderManual]'
			,@iintCol3       = @SourceRows -- Source count
			,@iintCol4       = @TargetRows -- target count
			,@strcol5        = '' -- additional count

		/***** Archive *****/
		INSERT INTO [import].[PSPL_TradeDone_Archive](
			[order_no],[ref_no],[OrderID],[Status],[OrdStatus],[Acct_no],[Company_code],[Side],[Order_time],[Price],
			[OrderQty],[ExecutedQty],[Executed_Price],[Market],[Remisier_code],[Symbol],[SymbolSfx],[Executed_time],
			[CustomerRef],[TradedCurr],[SettlementCurr],[ExchangeRate],[ClientSettCurr],[Originator],[OriginatorUT],
			[LastModified],[LastModifiedUT],[InverseExchangeRate],[SourceFileName],[ImportedDateTime],[ArchiveDateTime])
		SELECT
			[order_no],[ref_no],[OrderID],[Status],[OrdStatus],[Acct_no],[Company_code],[Side],[Order_time],[Price],
			[OrderQty],[ExecutedQty],[Executed_Price],[Market],[Remisier_code],[Symbol],[SymbolSfx],[Executed_time],
			[CustomerRef],[TradedCurr],[SettlementCurr],[ExchangeRate],[ClientSettCurr],[Originator],[OriginatorUT],
			[LastModified],[LastModifiedUT],[InverseExchangeRate],[SourceFileName],[ImportedDateTime],GETDATE()
		FROM
			[import].[PSPL_TradeDone];

		TRUNCATE TABLE [import].[PSPL_TradeDone];

		/***** Archive_MAN *****/
		INSERT INTO [import].[PSPL_TradeDone_MAN_Archive](
			[order_no],[ref_no],[OrderID],[Status],[OrdStatus],[Acct_no],[Company_code],[Side],[Order_time],[Price],
			[OrderQty],[ExecutedQty],[Executed_Price],[Market],[Remisier_code],[Symbol],[SymbolSfx],[Executed_time],
			[CustomerRef],[TradedCurr],[SettlementCurr],[ExchangeRate],[ClientSettCurr],[Originator],[OriginatorUT],
			[LastModified],[LastModifiedUT],[InverseExchangeRate],[SourceFileName],[ImportedDateTime],[ArchiveDateTime])
		SELECT
			[order_no],[ref_no],[OrderID],[Status],[OrdStatus],[Acct_no],[Company_code],[Side],[Order_time],[Price],
			[OrderQty],[ExecutedQty],[Executed_Price],[Market],[Remisier_code],[Symbol],[SymbolSfx],[Executed_time],
			[CustomerRef],[TradedCurr],[SettlementCurr],[ExchangeRate],[ClientSettCurr],[Originator],[OriginatorUT],
			[LastModified],[LastModifiedUT],[InverseExchangeRate],[SourceFileName],[ImportedDateTime],GETDATE()
		FROM
			[import].[PSPL_TradeDone_MAN];

		TRUNCATE TABLE [import].[PSPL_TradeDone_MAN];

		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION; 
				
		--SET @strValidationCode='E100003';        
		--SET @ostrMessage=' There was a problem processing your request.'+@strValidationCode +',SP - [import].[SSIS_PSPL_ProcessTradeDone]';        
      
		--PRINT @ostrMessage;
		--PRINT 'ERROR_MESSAGE: ' + ERROR_MESSAGE();

		EXECUTE utilities.usp_RethrowError'import.SSIS_PSPL_ProcessTradeDone' 

	END CATCH

END