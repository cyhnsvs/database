/****** Object:  Procedure [export].[USP_ORMS_DT_STKMAS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_DT_STKMAS]
(
	@idteProcessDate DATE
)
AS
--EXEC [export].[USP_ORMS_DT_STKMAS] '2020-07-30'
BEGIN

	SET NOCOUNT ON;
	
	--declare @idteProcessDate date = '2021-07-30'

	DECLARE @idtePreviousBusinessDate AS DATE, @idtePreviousBusinessDate1 AS DATE;
	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));

	CREATE TABLE #StockDetails
	(
		RecordType varchar(1),
		TradingDate varchar(10),
		StockCode varchar(10),
		StockShortName varchar(20),
		LastDonePrice Decimal(10,6),
		OpeningPrice Decimal(10,6),
		Change Decimal(10,6),
		Volume Decimal(11,0),
		HighPrice Decimal(10,6),
		LowPrice Decimal(10,6)
    );

	INSERT INTO #StockDetails
	(
		RecordType,
		TradingDate,
		StockCode,
		StockShortName,
		LastDonePrice,
		OpeningPrice,
		Change,
		Volume,
		HighPrice,
		LowPrice
	)
	SELECT
		1,
		CONVERT(varchar,ISNULL(TC.BusinessDate,@idteProcessDate),120),
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		LEFT(TI.FullName,20),
		ISNULL(TC.ClosingPrice,0),
		ISNULL(TC1.ClosingPrice,0),
		ISNULL(TC1.ClosingPrice,0) - ISNULL(TC.ClosingPrice,0),
		ISNULL(TC.BidVol + TC.AskVol,0),
		ISNULL(TC.BidPrice,0),
		ISNULL(TC.AskPrice,0)
	FROM GlobalBO.setup.Tb_Instrument TI
	LEFT JOIN GlobalBO.setup.Tb_ClosingPrice TC 
		ON TI.InstrumentId = TC.InstrumentId AND TC.BusinessDate = @idteProcessDate
	LEFT JOIN GlobalBO.setup.Tb_ClosingPrice TC1 
		ON TC1.InstrumentId = TI.InstrumentId AND TC1.BusinessDate = @idtePreviousBusinessDate
	WHERE TI.InstrumentCd LIKE '%.XKLS%';

	--select [HighPrice (textinput-21)],[LowPrice (textinput-22)],* from CQBTempDB.export.Tb_FormData_1345
	--select * from import.Tb_BTX_YYYYMMDD

	-- CONTROL RECORD
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(1) FROM #StockDetails)

	CREATE TABLE #StockDetailsControl
	(
		RecordType  varchar(50),
		CurrentApplicateDate Varchar(50),
		TotalRecord int
	);

	INSERT INTO #StockDetailsControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord
	)
	VALUES ('0', @idteProcessDate, @Count);

	SELECT 
		RecordType + '|' + TradingDate + '|' + StockCode + '|' + StockShortName + '|' + CAST(LastDonePrice as varchar(50)) + '|'  +  
		CAST(OpeningPrice as varchar(50)) + '|' + CAST(Change as varchar(50)) + '|' + CAST(Volume as varchar(50)) + '|' + 
		CAST(HighPrice as varchar(50)) + '|' + CAST(LowPrice as varchar(50)) 
	FROM #StockDetails

	UNION ALL

	-- CONTROL RECORD - RESULT SET
	SELECT  RecordType + '|' + CONVERT(varchar,CurrentApplicateDate,120) +  '|' + CAST(TotalRecord AS VARCHAR)
	FROM #StockDetailsControl

	DROP TABLE #StockDetails;
	DROP TABLE #StockDetailsControl;

END