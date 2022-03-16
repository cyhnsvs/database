/****** Object:  Procedure [export].[USP_Bursa_CT_WK]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CT_WK]
(
	@idteProcessDate DATE
)
AS
/*
Description : CLIENT TRUST MONIES, REMISIER'S DEPOSITES, OVERPLEDGING ÒF SHARES TO BURSA
Test Input	: EXEC [export].[USP_Bursa_CT_WK] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-1)]) 
	FROM CQBTempDB.export.Tb_FormData_3177
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
		DepositType			VARCHAR(2),
		ClientTotal			DECIMAL(13,0),
		DepositValue		DECIMAL(15,2)
	);

	INSERT INTO #Detail
	(
		 RecordType		
		,POCode			
		,PositionDate	
		,DepositType		
		,ClientTotal		
		,DepositValue		
	)
	SELECT 
		1,
		[POCode (textinput-1)],
		CONVERT(VARCHAR,@idteProcessDate,103),
		[DepositType (selectbasic-1)],
		[ClientTotal (textinput-2)],
		[DepositValue (textinput-3)]
	FROM CQBTempDB.export.tb_formdata_3177
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
		RecordType + ',' + POCode + ',' + PositionDate + ',' + DepositType + ',' + CAST(ClientTotal AS VARCHAR) + ',' + CAST(DepositValue AS VARCHAR)
	FROM #Detail;

	DROP TABLE #Detail;
	DROP TABLE #Header;

END