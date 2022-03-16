/****** Object:  Procedure [import].[SSIS_PSPL_ProcessExchangeRate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[SSIS_PSPL_ProcessExchangeRate]
	--@ostrMessage VARCHAR(4000) OUTPUT   
AS
BEGIN
	SET NOCOUNT ON;
	
	-- company id hard-coded to 1
	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);
	DECLARE @intCompanyId INT;
	--DECLARE @strFileName varchar(100) ='EXCHANGERATE_AM';
	--DECLARE @dteBusinessDate Date;
			
	--select top 1 @dteBusinessDate = RecordDate from [import].[PSPL_ExchangeRate]

	SET @intCompanyId = 1;

	BEGIN TRY
		BEGIN TRANSACTION;

			--DELETE A
			--FROM GlobalBO.[setup].[Tb_ExchangeRateHistory] AS A INNER JOIN [import].[PSPL_ExchangeRate] AS B ON A.BusinessDate =  CAST(B.RecordDate AS DATE)  and a.OtherCurrCd = b.OtherCurrencyCode 
			--WHERE CompanyId = @intCompanyId  AND TimeSlotId = CASE WHEN SourceFileName LIKE '%PM%' THEN  'ExchRate_PSPL_00PM' ELSE 'ExchRate_PSPL_00AM' END ;

		INSERT INTO GlobalBO.[setup].[Tb_ExchangeRateHistory]
           ([BusinessDate]
           ,[BaseCurrCd]
           ,[OtherCurrCd]
           ,[TimeSlotId]
           ,[CompanyId]
           ,[BuyExchRate]
           ,[SellExchRate]
           ,[AvgExchRate]
           ,[CreatedBy]
           ,[CreatedDate])           
		SELECT
			CAST(RecordDate AS DATE),
			[BaseCurrencyCode],
			[OtherCurrencyCode],
			CASE 
				WHEN SourceFileName LIKE '%PM%' 
				THEN  'ExchRate_PSPL_00PM' 
				ELSE 'ExchRate_PSPL_00AM' 
			END AS TimeSlotId,
			@intCompanyId,
			CAST(LEFT(bidrate, LEN(bidrate)- 9) + '.' + right(bidrate,9) AS DECIMAL(28,9)),
			CAST(LEFT(OfferRate, LEN(OfferRate)- 9) + '.' + right(OfferRate,9) AS DECIMAL(28,9)),
			(CAST(LEFT(bidrate, LEN(bidrate)- 9) + '.' + right(bidrate,9) AS DECIMAL(28,9)) + CAST(LEFT(OfferRate, LEN(OfferRate)- 9) + '.' + right(OfferRate,9) AS DECIMAL(28,9)))/2 as [AverageRate],
			SourceFileName,
			getdate()
		FROM 
			[import].[PSPL_ExchangeRate]

		/***** Update Stats *****/
		SELECT @TargetRows = @@ROWCOUNT
		SELECT @SourceRows = COUNT(*) FROM [import].[PSPL_ExchangeRate]
		
		EXECUTE [import].[TS_UpdateRowCount] 
			@iintCompanyId   = @intCompanyId
			,@istrCheckedFor = '[GlobalBOMY].[import].[SSIS_PSPL_ProcessExchangeRate]'
			,@istrCol1       = '[GlobalBOMY].[import].[PSPL_ExchangeRate]'
			,@istrCol2       = '[GlobalBO].[setup].[Tb_ExchangeRateHistory]'
			,@iintCol3       = @SourceRows -- Source count
			,@iintCol4       = @TargetRows -- target count
			,@strcol5        = '' -- additional count

		/***** Archive *****/
		INSERT INTO [import].[PSPL_ExchangeRate_Archive](
			[RecordDate],[BaseCurrencyCode],[OtherCurrencyCode],[BidRate],[OfferRate],
			[AverageRate],[SourceFileName],[ImportedDateTime],[ArchiveDateTime])
		SELECT
			[RecordDate],[BaseCurrencyCode],[OtherCurrencyCode],[BidRate],[OfferRate],
			[AverageRate],[SourceFileName],[ImportedDateTime],GETDATE()
		FROM
			[import].[PSPL_ExchangeRate];

		TRUNCATE TABLE [import].[PSPL_ExchangeRate];
		
		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION; 

		EXECUTE utilities.usp_RethrowError'import.SSIS_PSPL_ProcessExchangeRate';
		 
	END CATCH

END