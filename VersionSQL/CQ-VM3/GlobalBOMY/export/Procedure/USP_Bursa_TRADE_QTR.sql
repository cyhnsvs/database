/****** Object:  Procedure [export].[USP_Bursa_TRADE_QTR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_TRADE_QTR]
(
	@idteProcessDate DATE
)
AS
/*
Description : TRADE INFO TO BURSA
Test Input	: EXEC [export].[USP_Bursa_TRADE_QTR] '2020-06-01'
*/
BEGIN
	-- Header Record
	CREATE TABLE #Header
	(
		RecordType		VARCHAR(1),
		ReportingDate	VARCHAR(10),
		RecordCount		VARCHAR(10)
	);

	-- Data Record
	CREATE TABLE #Detail
	(
		RecordType			VARCHAR(1),
		POCode				VARCHAR(6),
		PositionDate		VARCHAR(10),
		MarketType			VARCHAR(2),
		TradeMode			VARCHAR(3),
		ClientType			VARCHAR(3),
		TradeValue			DECIMAL(15,2)

	);
	INSERT INTO #Detail
	(
		 RecordType		
		,POCode			
		,PositionDate	
		,MarketType		
		,TradeMode		
		,ClientType		
		,TradeValue									
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		'',
		'',
		'',
		0

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);

	INSERT INTO #Header
	(
		RecordType,
		ReportingDate,
		RecordCount
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count);

	-- RESULT SET 
	SELECT 
		RecordType + ',' + ReportingDate + ',' + RecordCount
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + ',' + POCode + ',' + PositionDate + ',' + MarketType + ',' + TradeMode  + ',' + ClientType + ',' + CAST(TradeValue AS VARCHAR)
	FROM #Detail;

	DROP TABLE #Header;
	DROP TABLE #Detail;

END