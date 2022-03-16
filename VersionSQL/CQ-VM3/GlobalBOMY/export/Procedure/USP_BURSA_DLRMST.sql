/****** Object:  Procedure [export].[USP_BURSA_DLRMST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BURSA_DLRMST]
	(
		@idteProcessDate DATE
    )
AS
BEGIN
	-- EXEC [export].[USP_BURSA_DLRMST] '2020-06-01'

	SET NOCOUNT ON;
	
	CREATE TABLE #BURSA_DLRMST
	(
		RecordType    int,
		DealerCode    VARCHAR(6),
		DealerName	  VARCHAR(40),
		DealerType	  varchar(1)
	);

	insert into #BURSA_DLRMST
	(
	    RecordType,
		DealerCode,
		DealerName,
		DealerType
	)

	select 
	1,
	TBFD.[DealerCode (textinput-35)],
	TBFD.[Name (textinput-3)],
	TBFD.[DealerType (selectsource-3)]
	FROM CQBTEMPDB.EXPORT.TB_FORMDATA_1377 TBFD ;

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #BURSA_DLRMST);

	CREATE TABLE #BURSA_DLRMSTControl
	(
		RecordType  varchar(50),
		CurrentApplicateDate Varchar(50),
		TotalRecord int
	);
	INSERT INTO #BURSA_DLRMSTControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord
	)
	VALUES (0,CONVERT(VARCHAR,@idteProcessDate,103),@Count);

	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + ',' + CurrentApplicateDate +  ',' + CAST(TotalRecord AS VARCHAR)
	FROM #BURSA_DLRMSTControl
	UNION ALL
	SELECT 
		CAST(RecordType AS VARCHAR) + ',' + DealerCode + ',' +  DealerName + ',' +  DealerType 
	FROM #BURSA_DLRMST;

	DROP TABLE #BURSA_DLRMSTControl
	DROP TABLE #BURSA_DLRMST

END