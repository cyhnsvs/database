/****** Object:  Procedure [export].[USP_Bursa_PNL_QTR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_PNL_QTR]
(
	@idteProcessDate DATE
)
AS
/*
Description : PROFIT AND LOSS INFO TO BURSA
Test Input	: EXEC [export].[USP_Bursa_PNL_QTR] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-1)]) 
	FROM CQBTempDB.export.Tb_FormData_3263
	WHERE CAST([ReportDate (dateinput-1)] as date) <= @idteProcessDate;

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
		PNLCode				VARCHAR(5),
		[Value]				DECIMAL(15,2)
	);

	INSERT INTO #Detail
	(
		 RecordType	
		,POCode		
		,PositionDate
		,PNLCode		
		,[Value]											
	)
	SELECT 
		1,
		[ParticipatingOrganisation (textinput-1)], --'012',
		[ReportDate (dateinput-1)],
		[PNLCode (selectbasic-2)],
		[PNLValue (textinput-2)]
	FROM CQBTempDB.export.Tb_FormData_3263
	WHERE [ReportDate (dateinput-1)] = @ReportDate;

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
		RecordType + ',' + POCode  + ',' + PNLCode + ',' + CAST([Value] AS VARCHAR)
	FROM #Detail;
	
	DROP TABLE #Header;
	DROP TABLE #Detail;

END