/****** Object:  Procedure [export].[USP_ORMS_DT_CHRGCD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_DT_CHRGCD]
(
	@idteProcessDate DATE
)
AS
/*
Description : 
Test Input	: EXEC [export].[USP_ORMS_DT_CHRGCD] '2020-06-01'
*/
BEGIN
	-- Header Record
	
	CREATE TABLE #Data
	(
		RecordType		VARCHAR(1),
		ChargeCode  	VARCHAR(3),
		Description		VARCHAR(60)
	)
	INSERT INTO #Data
	(
		RecordType,
		ChargeCode,
		Description
	)
	SELECT
		'1',
		LEFT(TransType,3),
		LEFT(TransTypeDesc,60)
		FROM GlobalBO.setup.Tb_TransactionType;
	
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Data);

	-- Data Record
	CREATE TABLE #Header
	(
		RecordType				VARCHAR(1),
		TotalRecordCount		VARCHAR(8),
	);

	INSERT INTO #Header
	(
		 RecordType		
		,TotalRecordCount
	)
	VALUES(0,@Count)
	
	-- RESULT SET 
	SELECT RecordType +'|'+ ChargeCode +'|'+ Description
	FROM #Data
	UNION ALL
	SELECT RecordType + '|' + TotalRecordCount				
	FROM #Header

	DROP TABLE #Data
	DROP TABLE #Header

END