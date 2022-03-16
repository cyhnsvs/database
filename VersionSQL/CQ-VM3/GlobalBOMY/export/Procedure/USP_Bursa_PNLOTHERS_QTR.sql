/****** Object:  Procedure [export].[USP_Bursa_PNLOTHERS_QTR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_PNLOTHERS_QTR]
(
	@idteProcessDate DATE
)
AS
/*
Description : REVENUE AND EXPENSE INFO TO BURSA
Test Input	: EXEC [export].[USP_Bursa_PNLOTHERS_QTR] '2020-06-01'
*/
BEGIN
	-- Header Record
	CREATE TABLE #Header
	(
		RecordType		VARCHAR(1),
		ReportingDate	VARCHAR(10),
		RecordCount		VARCHAR(10)
	)

	-- Data Record
	CREATE TABLE #Detail
	(
		RecordType			VARCHAR(1),
		POCode				VARCHAR(6),
		PositionDate		VARCHAR(10),
		PNLCategory			VARCHAR(5),
		PNLName				VARCHAR(100),
		[Value]				DECIMAL(15,2)

	)
	INSERT INTO #Detail
	(
		 RecordType	
		,POCode		
		,PositionDate
		,PNLCategory
		,PNLName		
		,[Value]											
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		'',
		'',
		0

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)

	INSERT INTO #Header
	(
		RecordType,
		ReportingDate,
		RecordCount
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count)

	-- RESULT SET 
	SELECT 
		RecordType + ',' + ReportingDate + ',' + RecordCount
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + ',' + POCode  + ',' + PNLCategory  + ',' + PNLName + ',' + CAST([Value] AS VARCHAR)
	FROM #Detail

	DROP TABLE #Header;
	DROP TABLE #Detail;
END