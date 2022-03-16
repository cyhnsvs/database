/****** Object:  Procedure [export].[USP_Bursa_GEARING_MTH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_GEARING_MTH]
(
	@idteProcessDate DATE
)
AS
/*
Description : GEARING RATIO AND SHAREHOLDER'S FUNDS TO BURSA
Test Input	: EXEC [export].[USP_Bursa_GEARING_MTH] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-1)]) 
	FROM CQBTempDB.export.Tb_FormData_3180
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
		UtilisedValue		DECIMAL(15,2),
		ESFValue			DECIMAL(15,2),
		SFValue				DECIMAL(15,2)
	);

	INSERT INTO #Detail
	(
		 RecordType		
		,POCode			
		,PositionDate	
		,UtilisedValue	
		,ESFValue		
		,SFValue								
	)
	SELECT 
		1,
		[POCode (textinput-1)],
		CONVERT(VARCHAR,@idteProcessDate,103),
		[UtilisedValue (textinput-2)],
		[ESFValue (textinput-3)],
		[SFValue (textinput-4)]
	FROM CQBTempDB.export.Tb_FormData_3180
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
		RecordType + ',' + POCode + ',' + PositionDate + ',' + CAST(UtilisedValue AS VARCHAR) + ',' + CAST(ESFValue AS VARCHAR) + ',' + CAST(SFValue AS VARCHAR)
	FROM #Detail;

	DROP TABLE #Detail;
	DROP TABLE #Header;

END