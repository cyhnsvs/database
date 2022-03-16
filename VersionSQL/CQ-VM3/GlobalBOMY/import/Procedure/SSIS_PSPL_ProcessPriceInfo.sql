/****** Object:  Procedure [import].[SSIS_PSPL_ProcessPriceInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[SSIS_PSPL_ProcessPriceInfo]	
AS
BEGIN
	SET NOCOUNT ON;
	
	-- CompanyCode set to 1
	DECLARE @TargetRows int, @SourceRows int;
	DECLARE @strValidationCode VARCHAR(10);
	DECLARE @iintCompanyId BIGINT;
	DECLARE @dteBusinessDate DATE;

	SET @iintCompanyId = 1;
	SET @dteBusinessDate = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');

	BEGIN TRY
		BEGIN TRANSACTION

		
	
		UPDATE  [import].[PSPL_PriceInfo_MAN]  SET CompanyCode='FUEVFVND.VN' where  CompanyCode ='FUEVFVND.V'
		UPDATE  [import].[PSPL_PriceInfo_MAN]  SET CompanyCode='E1VFVN30.VN' where  CompanyCode ='E1VFVN30.V'


		DELETE D FROM 
			[GlobalBO].[setup].[Tb_ClosingPrice] AS D   INNER JOIN 
			 (
				SELECT 	B.InstrumentId 
				FROM (
					SELECT CompanyCode, Market, LastDone FROM [import].[PSPL_PriceInfo]
					UNION
					SELECT CompanyCode, Market, LastDone FROM [import].[PSPL_PriceInfo_MAN]
					) A
				INNER JOIN [GlobalBO].[setup].[Tb_Instrument] B 
					ON A.CompanyCode = B.InstrumentCd AND CompanyId = @iintCompanyId
				GROUP BY B.InstrumentId
			) AS C ON D.InstrumentId = C.InstrumentId

		WHERE D.BusinessDate =  @dteBusinessDate AND D.CompanyId = @iintCompanyId;
		
		INSERT INTO [GlobalBO].[setup].[Tb_ClosingPrice](
			[CompanyId],
			[BusinessDate],
			[ProductId],
			[InstrumentId],
			[ExchCd],
			[TradedCurrCd],
			[Symbol],
			[BidPrice],
			[AskPrice],
			[ClosingPrice],
			[BidVol],
			[AskVol],
			[ClosingPriceCompanyBased],
			CreatedDateTime
			)
		SELECT 
			[CompanyId] = @iintCompanyId,
			[BusinessDate] = @dteBusinessDate,
			[ProductId] = b.ProductId,
			[InstrumentId] = B.InstrumentId, --a.CompanyCode,
			[ExchCd] = b.ListedExchCd,
			[TradedCurrCd] = b.TradedCurrCd,
			[Symbol] = ISNULL(b.Symbol,''),
			[BidPrice] = 0,
			[AskPrice] = 0,
			[ClosingPrice] = a.LastDone,
			[BidVol] = 0,
			[AskVol] = 0,
			[ClosingPriceCompanyBased] = 0,
			GETDATE()
		 FROM (
			SELECT CompanyCode, Market, LastDone FROM [import].[PSPL_PriceInfo]
			UNION
			SELECT CompanyCode, Market, LastDone FROM [import].[PSPL_PriceInfo_MAN]
			) A
		INNER JOIN [GlobalBO].[setup].[Tb_Instrument] B 
			ON (A.CompanyCode = B.InstrumentCd AND CompanyId = @iintCompanyId)
		GROUP BY
			b.ProductId,B.InstrumentId,b.ListedExchCd,b.TradedCurrCd, ISNULL(b.Symbol,''),a.LastDone
		
		/***** Update Stats *****/
		SELECT @TargetRows = @@ROWCOUNT
		SELECT @SourceRows = COUNT(*) FROM [import].[PSPL_PriceInfo]

		EXECUTE [import].[TS_UpdateRowCount] 
			@iintCompanyId   = @iintCompanyId
			,@istrCheckedFor = '[GlobalBOMY].[import].[SSIS_PSPL_ProcessPriceInfo]'
			,@istrCol1       = '[GlobalBOMY].[import].[PSPL_PriceInfo]'
			,@istrCol2       = '[GlobalBO].[setup].[Tb_ClosingPrice]'
			,@iintCol3       = @SourceRows -- Source count
			,@iintCol4       = @TargetRows -- target count
			,@strcol5        = '' -- additional count		
		

		/***** Archive *****/
		INSERT INTO [import].[PSPL_PriceInfo_Archive](
			[CompanyCode],[Market],[LastDone],[SourceFileName],[ImportedDateTime],[ArchiveDateTime])
		SELECT
			[CompanyCode],[Market],[LastDone],[SourceFileName],[ImportedDateTime],GETDATE()
		FROM
			[import].[PSPL_PriceInfo]

		INSERT INTO [import].[PSPL_PriceInfo_MAN_Archive](
			[CompanyCode],[Market],[LastDone],[Temp column],[SourceFileName],[ImportedDateTime],[ArchiveDateTime])
		SELECT
			[CompanyCode],[Market],[LastDone],[Temp column],[SourceFileName],[ImportedDateTime],GETDATE()
		FROM
			[import].[PSPL_PriceInfo_MAN]
		
		TRUNCATE TABLE [import].[PSPL_PriceInfo];
		TRUNCATE TABLE [import].[PSPL_PriceInfo_MAN];

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION; 
					
		

		EXECUTE utilities.usp_RethrowError'import.SSIS_PSPL_ProcessPriceInfo'  ;   

	END CATCH

END