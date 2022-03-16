/****** Object:  Procedure [export].[USP_Bursa_CLIENTCDS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CLIENTCDS]
(
	@idteProcessDate DATE
)
AS
/*
Description : CLIENT MASTER CDS ACCOUNT OF ALL CLIENT  
Test Input	: EXEC [export].[USP_Bursa_CLIENTCDS] '2020-06-01'
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
	CREATE TABLE #ClientCDS
	(
		RecordType			VARCHAR(1),
		ClientCode			VARCHAR(12),
		CDSAccount			VARCHAR(15),
		ContractType		VARCHAR(1),
		DealerCode			VARCHAR(6),
		StatusFlag			VARCHAR(1)
	);
	INSERT INTO #ClientCDS
	(
		 RecordType	
		,ClientCode	
		,CDSAccount	
		,ContractType
		,DealerCode	
		,StatusFlag		
	)
	SELECT 
		1,
		[AccountNumber (textinput-5)],
		[CDSNo (textinput-19)],
		'A',
		[DealerCode (selectsource-21)],
		'N'
	FROM CQBTempDB.export.Tb_FormData_1410 Client  
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON Client.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)];

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #ClientCDS);

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
		RecordType + ',' + ClientCode + ',' + CDSAccount + ',' + ContractType + ',' + DealerCode + ',' + StatusFlag 
	FROM #ClientCDS

	DROP TABLE #Header
	DROP TABLE #ClientCDS
END