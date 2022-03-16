/****** Object:  Procedure [import].[SSIS_PSPL_ProcessStockInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[SSIS_PSPL_ProcessStockInfo]	
AS
BEGIN
	SET NOCOUNT ON;

	-- select distinct SecurityType from [import].[PSPL_StockInfo];
	-- select distinct ProductCd from GlobalBO.setup.Tb_ProductCategory;

	BEGIN TRY
		BEGIN TRANSACTION


		DECLARE @SourceRows int, @TargetRows int;		
		DECLARE @intCompanyId INT;

		SET @intCompanyId = 1;

	
		UPDATE  [import].[PSPL_ManStockInfo]  SET CompanyCode='FUEVFVND.VN' where  CompanyCode ='FUEVFVND.V'		
		UPDATE  [import].[PSPL_ManStockInfo]  SET CompanyCode='E1VFVN30.VN' where  CompanyCode ='E1VFVN30.V'

		
		CREATE TABLE #Tb_Instrument(
			[CompanyId]             bigint not null,
			[CompanyCode]           varchar(50) not null,
			[CompanyName]	        varchar(150) null,
			[ChineseName]	        varchar(100) null,
			[MinQty]                int null,
			[CurrencyCode]          char(3) null,
			[CurrCode]				char(3) null,
			[SecurityCode]          varchar(50) null,
			[Market]                char(4) null,
			[Exchange]              char(4) null,
			ExChcd					char(4) null,
			[CountryCd]             char(2) null,
			[Symbol]                varchar(10) null,
			[StartDate]             datetime null,
			[ExpiryDate]            datetime null,
			[CounterStatus]         char(1) null,
			[ProductId]             bigint null,
			[ISINCode]              varchar(50),
			[PrimaryTradingCounter] varchar(50) null,
			[Action]                int   default('1'),
			CreatedBy				varchar(64),
			CreatedDate				datetime2(0)
		);


		insert into #Tb_Instrument(
			[CompanyId],
			[CompanyCode],
			[CompanyName],
			[ChineseName],
			[MinQty],
			[CurrencyCode],
			[CurrCode]	,
			[SecurityCode],
			[Market],
			[Exchange],
			ExChcd,
			[CountryCd],
			[Symbol],
			[StartDate],
			[ExpiryDate],
			[CounterStatus],
			[ProductId],
			[ISINCode],
			[PrimaryTradingCounter],
			[Action],
			CreatedBy,
			CreatedDate
			)
		SELECT
			@intCompanyId,
			[CompanyCode],
			[CompanyName],
			[ChineseName],
			case when MinQty = '' then 0 else [MinQty] end ,
			[CurrencyCode],
			'XXX' AS CurrCode,
			[SecurityCode],
			[Market],
			[Exchange],
			'XXXX' AS ExChcd,
			'XX' AS [CountryCd],
			[Symbol],
			[StartDate],
			[ExpiryDate],
			[CounterStatus],
			[ProductId] = 1, --B.[ProductId], 
			[ISINCode],
			[PrimaryTradingCounter],
			3,
			SourceFileName,
			ImportedDateTime
		FROM 
			[import].[PSPL_StockInfo]
		where (isnumeric(MinQty) = 1 or MinQty = '') and SourceFileName not like '%TRSTOCKINFO%'

		UNION ALL

		SELECT
			@intCompanyId,
			[CompanyCode],
			[CompanyName],
			[ChineseName],
			case when MinQty = '' then 0 else [MinQty] end ,
			[CurrencyCode],
			'XXX' AS CurrCode,
			[SecurityCode],
			RIGHT(RTRIM([CompanyCode]),2) AS  [Market],
			[Exchange],
			'XXXX' AS ExChcd,
			'XX' AS [CountryCd],
			[Symbol],
			[StartDate],
			[ExpiryDate],
			[CounterStatus],
			[ProductId] = 1, --B.[ProductId], 
			[ISINCode],
			'' AS [PrimaryTradingCounter],
			3,
			SourceFileName,
			ImportedDateTime
		FROM 
			[import].[PSPL_ManStockInfo]		 

			

		DECLARE @tblMarket AS TABLE(
			PsplMarket    varchar(10), 
			GboMarket     char(4))

		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('ASX','XASX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SSE','XSHG')		
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SZSE','XSHE')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('FRA','XETR')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SEHK','XHKG')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SEHK','XHKG')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('IDX','XIDX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('TSE','XTKS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('KLSE','XKLS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('PHI','XPHS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('PH','XPHS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SGX','XSES')		
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SET','XBKK')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('BIST','XIST')		
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('MI','XKLS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('AU','XASX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('AI','XASX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('TW','XTAI')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('HK','XHKG')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SI','XSES')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('GY','XETR')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('CA','XTSE')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('II','XIDX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('ID','XIDX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('LK','XCOL')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('LSE','XLON')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('JI','XTKS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('MY','XKLS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('KR','XKRX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('HI','XHKG')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('JP','XTKS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('VN','XSTC')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('SG','XSES')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('xxxx','XXXX')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('NASD','XNAS')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('NYSE','XASE')
		insert into @tblMarket (PsplMarket, GboMarket) VALUES ('AMEX','NYSE')
		
		UPDATE A
		SET A.ExChcd =  B.GboMarket
		FROM #Tb_Instrument A 
		INNER JOIN @tblMarket B 
			ON A.Market = B.PsplMarket  

		UPDATE A
		SET A.ExChcd =  B.GboMarket
		FROM #Tb_Instrument A 
		INNER JOIN @tblMarket B 
			ON A.Exchange = B.PsplMarket  
		where a.Exchange <> ''
	
		

		/***** Currency *****/

		DECLARE @tblCurrency AS TABLE(
			PsplCurrency    varchar(10), 
			GboCurrency     char(3))

		
		-- select distinct CurrencyCode from  #PSPL_StockInfo where CurrencyCode not in (select currCd from GlobalBO.setup.Tb_Currency)
		
		INSERT INTO @tblCurrency(PsplCurrency, GboCurrency) VALUES ('HK$','HKD')
		INSERT INTO @tblCurrency(PsplCurrency, GboCurrency) VALUES ('AU$','AUD')
		INSERT INTO @tblCurrency(PsplCurrency, GboCurrency) VALUES ('S$ ','SGD')
		INSERT INTO @tblCurrency(PsplCurrency, GboCurrency) VALUES ('US$','USD')
		
		-- INSERT INTO @tblCurrency(PsplCurrency, GboCurrency) VALUES ('RMB','??') 

		UPDATE A
		SET A.CurrCode = ISNULL(B.GboCurrency, A.CurrencyCode)
		FROM #Tb_Instrument A 
		LEFT OUTER JOIN @tblCurrency B 
			ON A.CurrencyCode = B.PsplCurrency;

		
		UPDATE A  SET A.CountryCd = C.CountryCd 
		FROM  #Tb_Instrument A 
		INNER JOIN GlobalBO.setup.Tb_Exchange AS C  
			ON A.ExChcd = C.ExchCd;
		
		--SELECT * FROM #Tb_Instrument WHERE ExChcd = 'XXXX' OR CurrCode ='XXX';

			
		DELETE A FROM 
		(
		SELECT CompanyCode, ROW_NUMBER () over (partition by CompanyCode order by  createdby desc ) as rownum 
		FROM #Tb_Instrument A
		) a
		where a.rownum > 1

		
		UPDATE B
		SET B.[Action] = 2 -- UPDATE
		FROM #Tb_Instrument b 
		INNER JOIN GlobalBO.setup.Tb_Instrument A
			ON( B.[CompanyCode]  = A.[InstrumentCd] )
		where 
				A.[FullName]       <> B.CompanyName OR
				A.[ShortName]      <> LEFT(B.CompanyName,50) OR
				A.[AliasName]       <> B.ChineseName OR
				A.[LotSize]         <> B.MinQty OR
				A.[ExtRefKey]       <> B.SecurityCode OR
				A.[ListedCountryCd] <> B.[CountryCd] OR
				A.[HomeCountryCd]   <> B.[CountryCd] OR
				A.[HomeExchCd]      <> B.Exchange OR
				A.[ListedExchCd]    <> B.Exchange OR
				A.[Symbol]          <> B.Symbol OR
				A.[ListedDate]      <> B.StartDate OR
				A.[ExpiryDate]      <> B.ExpiryDate OR
				A.[DelistedDate]    <> B.ExpiryDate OR
				A.[Status]          <> B.CounterStatus	OR			
				A.[ISINCd]          <> B.ISINCode  ;
				


		UPDATE A
		SET A.[Action] = 1 -- NEW	
		FROM #Tb_Instrument A 
		WHERE NOT EXISTS ( SELECT 1 FROM GlobalBO.setup.Tb_Instrument B
							WHERE B.InstrumentCd = A.CompanyCode)


		UPDATE A
		SET A.[Action] = 4 -- DUPLICATE
		FROM #Tb_Instrument A
		INNER JOIN (
				SELECT CompanyCode FROM #Tb_Instrument
					GROUP BY CompanyCode HAVING COUNT(*) > 1
				) B ON A.CompanyCode = B.CompanyCode;


		UPDATE  #Tb_Instrument 
		SET [ACTION] = 5 -- INVALID ExchangeCode
		WHERE ISNULL(ExChcd,'') = 'XXXX';



		IF EXISTS (SELECT 1 FROM #Tb_Instrument WHERE [ACTION]  = 4)
		BEGIN
			EXECUTE utilities.usp_RethrowError   ' Duplicate instrument;'
		END
		
		
		IF EXISTS (SELECT 1 FROM #Tb_Instrument WHERE [ACTION]  = 5)
		BEGIN
			EXECUTE utilities.usp_RethrowError   ' Invalid exchange cod;'  
			--SELECT * FROM #Tb_Instrument WHERE [ACTION]  = 5
		END

		

			

		IF NOT EXISTS (SELECT 1 FROM #Tb_Instrument WHERE [ACTION]  IN (4,5))
		BEGIN

		    INSERT INTO [GlobalBO].[setup].[Tb_Instrument](
				[CompanyId],[InstrumentCd],[FullName],[ShortName],
				[AliasName],[LotSize],[TradedCurrCd],[ExtRefKey],[ListedCountryCd], [HomeCountryCd],
				[HomeExchCd],[ListedExchCd],[Symbol],[ListedDate],[ExpiryDate],[DelistedDate],
				[Status],[ProductId],[ISINCd],[UnderlyingAsset],
				[RecordId],[ActionInd],[CurrentUser],[CreatedBy],[CreatedDate])
			SELECT
				CompanyId,CompanyCode,CompanyName,LEFT(CompanyName,50),
				ChineseName,MinQty,CurrencyCode,SecurityCode,CountryCd,CountryCd, --Market,Market,
				Exchange,Exchange,Symbol,StartDate,ExpiryDate,ExpiryDate,
				CounterStatus,ProductId,ISINCode,PrimaryTradingCounter,
				NEWID(),'','',CreatedBy , CreatedDate
			FROM #Tb_Instrument 
			WHERE [Action] = 1;

			--SELECT @TargetRows = @@ROWCOUNT;

			UPDATE A SET 
				A.[FullName]        = B.CompanyName,
				A.[ShortName]       = LEFT(B.CompanyName,50),
				--A.[AliasName]       = B.ChineseName,
				A.[LotSize]         = B.MinQty,
				A.[ExtRefKey]       = B.SecurityCode,
				A.[ListedCountryCd] = B.[CountryCd], --B.Market,
				A.[HomeCountryCd]   = B.[CountryCd], --B.Market,
				A.[HomeExchCd]      = B.Exchange,
				A.[ListedExchCd]    = B.Exchange,
				A.[Symbol]          = B.Symbol,
				A.[ListedDate]      = B.StartDate,
				A.[ExpiryDate]      = B.ExpiryDate,
				A.[DelistedDate]    = B.ExpiryDate,
				A.[Status]          = B.CounterStatus,
				--A.[ProductId]       = B.ProductId,
				A.[ISINCd]          = B.ISINCode,
				A.[UnderlyingAsset] = B.PrimaryTradingCounter,
				A.[RecordId]        = NEWID(),
				A.[ModifiedBy]      = b.CreatedBy,
				A.[ModifiedDate]    = b.CreatedDate
			FROM 
			    [GlobalBO].[setup].[Tb_Instrument] AS A
			    INNER JOIN #Tb_Instrument AS B ON A.InstrumentCd = B.CompanyCode
			WHERE 
				B.[Action] = 2;


		
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XHKG', HomeExchCd = 'XHKG' where ListedExchCd = ''  AND ListedCountryCd = 'hk'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XSES', HomeExchCd = 'XSES' where ListedExchCd = ''  AND ListedCountryCd = 'SG'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XTKS', HomeExchCd = 'XTKS' where ListedExchCd = ''  AND ListedCountryCd = 'JP'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XIDX', HomeExchCd = 'XIDX' where ListedExchCd = ''  AND ListedCountryCd = 'iD'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XKLS', HomeExchCd = 'XKLS' where ListedExchCd = ''  AND ListedCountryCd = 'MY'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XIDX', HomeExchCd = 'XIDX' where ListedExchCd = ''  AND ListedCountryCd = 'DE'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XASX', HomeExchCd = 'XASX' where ListedExchCd = ''  AND ListedCountryCd = 'AU'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XLON', HomeExchCd = 'XLON' where ListedExchCd = 'LSE'   
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XNAS', HomeExchCd = 'XNAS' where ListedExchCd = 'NASD'   
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XASX', HomeExchCd = 'XFRA' where ListedExchCd = 'FRA '   
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'NYSE', HomeExchCd = 'NYSE' where ListedExchCd = 'AMEX'   
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XNYS', HomeExchCd = 'XNYS' where ListedExchCd = 'NYSE'   

		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XKRX', HomeExchCd = 'XKRX' where ListedExchCd = ''  AND ListedCountryCd = 'KR'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XPHS', HomeExchCd = 'XPHS' where ListedExchCd = ''  AND ListedCountryCd = 'PH'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XSTC', HomeExchCd = 'XSTC' where ListedExchCd = ''  AND ListedCountryCd = 'VN'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XTSE', HomeExchCd = 'XTSE' where ListedExchCd = ''  AND ListedCountryCd = 'CA'
		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XTAI', HomeExchCd = 'XTAI' where ListedExchCd = ''  AND ListedCountryCd = 'TW'

		UPDATE GlobalBO.setup.Tb_Instrument SET ListedExchCd = 'XSHE', HomeExchCd = 'XSHE' where ListedExchCd in ('sse','szse') AND ListedCountryCd = 'CN'
			 
		END
				
		select ListedExchCd, ListedCountryCd from GlobalBO.setup.Tb_Instrument where   ListedExchCd NOT IN (select EXCHCD from globalbo.setup.tb_exchange )  GROUP BY ListedExchCd, ListedCountryCd
		
				--select * into dbo.Temp_Instrument from #Tb_Instrument
		/***** Update Stats *****/

		SELECT @SourceRows = COUNT(1) FROM [import].[PSPL_StockInfo]
		select @TargetRows = COUNT(1) from #Tb_Instrument where [Action]  in (1,2);

		--print '@TargetRows = ' + cast(@TargetRows as varchar)

		EXECUTE [import].[TS_UpdateRowCount] 
			@iintCompanyId   = @intCompanyId
			,@istrCheckedFor = '[GlobalBOMY].[import].[SSIS_PSPL_ProcessStockInfo]'
			,@istrCol1       = '[GlobalBOMY].[import].[PSPL_StockInfo]'
			,@istrCol2       = '[GlobalBO].[setup].[Tb_Instrument]'
			,@iintCol3       = @SourceRows -- Source count
			,@iintCol4       = @TargetRows -- target count
			,@strcol5        = '' -- additional count	
						
		/***** Archive *****/
		INSERT INTO [import].[PSPL_StockInfo_Archive] (
			[CompanyCode],[CompanyName],[ChineseName],[MinQty],[CurrencyCode],[SecurityID],[SecurityCode],
			[Market],[Exchange],[Symbol],[Symbolsfx],[StartDate],[ExpiryDate],[CounterStatus],[SecurityType],
			[ISINCode],[PrimaryTradingCounter],[SourceFileName],[ImportedDateTime],[ArchiveDateTime])
		SELECT
			[CompanyCode],[CompanyName],[ChineseName],[MinQty],[CurrencyCode],[SecurityID],[SecurityCode],
			[Market],[Exchange],[Symbol],[Symbolsfx],[StartDate],[ExpiryDate],[CounterStatus],[SecurityType],
			[ISINCode],[PrimaryTradingCounter],[SourceFileName],[ImportedDateTime],GETDATE()
		FROM 
			[import].[PSPL_StockInfo]
		
		TRUNCATE TABLE [import].[PSPL_StockInfo];

				
		INSERT INTO [import].[PSPL_ManStockInfo_Archive]
           ([CompanyCode],[CompanyName],[ChineseName],[MinQty],[CurrencyCode],[SecurityID],[SecurityCode],[Market],[Exchange],[Symbol]
           ,[Symbolsfx],[StartDate],[ExpiryDate] ,[CounterStatus],[SecurityType],[ISINCode],[SourceFileName],[ImportedDateTime],[ArchivedDateTime])
		SELECT 
			[CompanyCode],[CompanyName],[ChineseName],[MinQty],[CurrencyCode],[SecurityID],[SecurityCode],[Market],[Exchange],[Symbol]
           ,[Symbolsfx],[StartDate],[ExpiryDate] ,[CounterStatus],[SecurityType],[ISINCode],[SourceFileName],[ImportedDateTime],GETDATE() AS [ArchivedDateTime]
		FROM 
			[import].[PSPL_ManStockInfo]

			
		TRUNCATE TABLE [import].[PSPL_ManStockInfo];
	

		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION; 
				

		EXECUTE utilities.usp_RethrowError ',import.SSIS_PSPL_ProcessStockInfo' 

	END CATCH

END