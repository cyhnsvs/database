/****** Object:  Procedure [export].[USP_BTX_IDSS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_IDSS]
(
	@idteProcessDate DATE
)
AS
-- EXEC [export].[USP_BTX_IDSS] '2021-09-12'
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(8)
	);
	INSERT INTO #Header
	(
		 RecordType	
		,HeaderDate
	)
	VALUES ('H',REPLACE(@idteProcessDate,'-',''));
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,ClientCode				CHAR(20)
		,BranchCode				CHAR(3)
		,IDSSLimit				CHAR(16)
		,DealerCode				CHAR(4)
	);
	
	INSERT INTO #Detail
	(
		 RecordType	
		,ClientCode	
		,BranchCode	
		,IDSSLimit
		,DealerCode
	)
	SELECT 
		1,
		[AccountNumber (textinput-5)],
		'001',
		CASE WHEN [MaxNetLimit (textinput-70)] = '' THEN '0' ELSE CAST([MaxNetLimit (textinput-70)] AS VARCHAR) END,
		[DealerCode (selectsource-21)]
	FROM CQBTempDB.export.Tb_FormData_1409 Account
	WHERE [IDSSInd (multipleradiosinline-10)] = 'Y';

	UPDATE	#Detail
	SET		IDSSLimit =  CAST(CASE WHEN DealerCode = 'D321' OR (DealerCode <> 'D321' AND CAST(IDSSLimit AS DECIMAL(13,2)) >= 40.00)
							  THEN CAST(IDSSLimit AS DECIMAL(13,2))  /1.2
							  ELSE 0
						 END AS DECIMAL(13,2));
	-- BATCH TRAILER

	
	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(8)
	);
	INSERT INTO #Trailer
	(
		 RecordType		
		,TrailerCount	
	)
	VALUES(0,@Count);
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate 
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + ClientCode + BranchCode + RIGHT(REPLICATE('0',16) + CAST(RTRIM(IDSSLimit) AS VARCHAR),16) 
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + RIGHT(REPLICATE('0',8) + CAST(RTRIM(TrailerCount) AS VARCHAR),8)
	FROM #Trailer;


	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END



        