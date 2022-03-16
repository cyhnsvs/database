/****** Object:  Procedure [export].[USP_Bursa_EXPLANATORY_MTH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_EXPLANATORY_MTH]
(
	@idteProcessDate DATE
)
AS
/*
Description : Explanatory Notes TO BURSA
Test Input	: EXEC [export].[USP_Bursa_EXPLANATORY_MTH] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-1)]) 
	FROM CQBTempDB.export.Tb_FormData_3288
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
		IssueCode			VARCHAR(3),
		Notes				VARCHAR(500)
	);

	INSERT INTO #Detail
	(
		  RecordType		
		 ,POCode			
		 ,PositionDate	
		 ,IssueCode		
		 ,Notes					
	)
	SELECT 
		1,
		[POCode (textinput-1)],
		CONVERT(VARCHAR,@idteProcessDate,103),
		[IssueCode (selectbasic-1)],
		[Notes (textarea-1)]
	FROM CQBTempDB.export.Tb_FormData_3288
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
		RecordType + ',' + POCode + ',' + PositionDate + ',' + IssueCode + ',' + Notes
	FROM #Detail;

	DROP TABLE #Detail;
	DROP TABLE #Header;

END