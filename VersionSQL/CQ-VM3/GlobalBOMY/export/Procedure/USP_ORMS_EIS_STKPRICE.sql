/****** Object:  Procedure [export].[USP_ORMS_EIS_STKPRICE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_STKPRICE]
(
	@idteProcessDate DATE
)
AS
/*
Counter Price
EXEC [export].[USP_ORMS_EIS_STKPRICE] '2020-06-01'
*/
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType			VARCHAR(1)			
		,TradingDate		VARCHAR(10)
		,StockCode			VARCHAR(6)
		,StockShortName		VARCHAR(12)
		,LastDonePrice		DECIMAL(8,5)
		,ReferencePrice		DECIMAL(8,5)
		,Change				DECIMAL(8,5)
		,Volume				DECIMAL(9,0)
		,High				DECIMAL(8,5)
		,Low				DECIMAL(8,5)

	)
	INSERT INTO #Detail
	(
		 RecordType		
		,TradingDate	
		,StockCode		
		,StockShortName	
		,LastDonePrice	
		,ReferencePrice	
		,Change			
		,Volume			
		,High			
		,Low						
	)
	SELECT
		1,
		BusinessDate,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		I.ShortName,
		C.ClosingPrice,
		C.ClosingPrice,
		0,
		CAST((C.BidVol + C.AskVol) AS VARCHAR),
		BidPrice,
		AskPrice
	FROM GlobalBO.setup.tb_instrument I
	INNER JOIN GlobalBO.setup.tb_Closingprice C 
		ON I.InstrumentId = C.InstrumentId
	WHERE
		I.InstrumentCd LIKE '%XKLS%'

	-- BATCH TRAILER	
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)

	CREATE TABLE #Trailer
	(
		 RecordType				CHAR(1)
		,BatchDate				CHAR(10)
		,TotalRecord			INT
	)
	INSERT INTO #Trailer
	(
		 RecordType				
		,BatchDate	
		,TotalRecord							
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count)

	-- RESULT SET
	SELECT 
		 RecordType + '|' + TradeDate + '|' + StockCode + '|' + StockShortName + '|' + CAST(LastDonePrice AS VARCHAR) + '|' + CAST(ReferencePrice AS VARCHAR) + '|' + 
		 CAST(Change AS VARCHAR)  + '|' + CAST(Volume AS VARCHAR)  + '|' + CAST(High AS VARCHAR)  + '|' + CAST(Low AS VARCHAR) 	
	FROM
		#Detail
	UNION ALL
	SELECT 
		RecordType + '|' + BatchDate + '|' + CAST(TotalRecord AS VARCHAR) 
	FROM 
		#Trailer

	DROP TABLE #Detail
	DROP TABLE #Trailer

END