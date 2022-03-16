/****** Object:  Procedure [export].[USP_Bursa_SBL_WK]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_SBL_WK]
(
	@idteProcessDate DATE
)
AS
/*
Description : CLIENT WITH COLLATERAL BELOW 102% TO BURSA
Test Input	: EXEC [export].[USP_Bursa_SBL_WK] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-1)]) 
	FROM CQBTempDB.export.Tb_FormData_3178
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
		ClientID			VARCHAR(12),
		ClientName			VARCHAR(60),
		BorrowingValue		DECIMAL(15,2),
		CollateralValue		DECIMAL(15,2),
		[Action]			VARCHAR(300)
	);

	INSERT INTO #Detail
	(
		  RecordType		
		 ,POCode			
		 ,PositionDate	
		 ,ClientID		
		 ,ClientName		
		 ,BorrowingValue	
		 ,CollateralValue	
		 ,[Action]				
	)
	SELECT 
		1,
		[POCode (textinput-1)],
		CONVERT(VARCHAR,@idteProcessDate,103),
		[ClientID (textinput-2)],
		[ClientName (textinput-3)],
		[BorrowingValue (textinput-4)],
		[CollateralValue (textinput-5)],
		[Action (textinput-6)]
		FROM CQBTempDB.export.tb_formdata_3178
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
		RecordType + ',' + POCode + ',' + PositionDate + ',' + ClientID + ',' + ClientName + ',' + CAST(BorrowingValue AS VARCHAR) + ',' + CAST(CollateralValue AS VARCHAR)  + ',' + [Action]
	FROM #Detail;

	DROP TABLE #Detail;
	DROP TABLE #Header;

END