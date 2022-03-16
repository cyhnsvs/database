/****** Object:  Procedure [export].[USP_ORMS_EIS_STKMAS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_STKMAS]
(
	@idteProcessDate DATE
)
AS
/*
Stock CLosing
EXEC [export].[USP_ORMS_EIS_STKMAS] '2020-05-27'
*/
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType			VARCHAR(1)
		,TradeDate			VARCHAR(10)	
		,StockCode			VARCHAR(10)
		,StockShortName		VARCHAR(12)	
		,LastDonePrice		DECIMAL(24,9)
		,ReferencePrice		DECIMAL(24,9)
		,Change				DECIMAL(24,9)
		,Volume				DECIMAL(24,0)
		,High				DECIMAL(24,9)
		,Low				DECIMAL(24,9)
	)
	INSERT INTO #Detail
	(
		 RecordType		
		,TradeDate		
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


	DECLARE @count INT
	SET @count = (SELECT COUNT(*) FROM #Detail)

	CREATE TABLE #Trailer
	(
		 RecordType		VARCHAR(1)
		,ApplicantDate	VARCHAR(10)
		,TotalRecord	INT
	)
	INSERT INTO #Trailer VALUES (0,@idteProcessDate,@count)

	-- RESULT SET
	SELECT 
		 RecordType + '|' + TradeDate + '|' + StockCode + '|' + StockShortName + '|' + CAST(LastDonePrice AS VARCHAR) + '|' + CAST(ReferencePrice AS VARCHAR) + '|' + 
		 CAST(Change AS VARCHAR)  + '|' + CAST(Volume AS VARCHAR)  + '|' + CAST(High AS VARCHAR)  + '|' + CAST(Low AS VARCHAR) 	
	FROM
		#Detail
	UNION ALL
	SELECT
		RecordType + '|' + ApplicantDate + '|' + CAST(TotalRecord AS VARCHAR)
	FROM
		#Trailer
		
	DROP TABLE #Detail
	DROP TABLE #Trailer

END