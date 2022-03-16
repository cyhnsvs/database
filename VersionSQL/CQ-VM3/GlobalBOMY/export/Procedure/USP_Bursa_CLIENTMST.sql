/****** Object:  Procedure [export].[USP_Bursa_CLIENTMST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CLIENTMST]
(
	@idteProcessDate DATE
)
AS
/*
Description : CLIENT MASTER INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_CLIENTMST] '2020-06-01'
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
	CREATE TABLE #ClientMaster
	(
		RecordType			VARCHAR(1),
		ClientCode			VARCHAR(12),
		UniqueClientCode	VARCHAR(20),
		ClientParentCode	VARCHAR(12),
		ClientName1			VARCHAR(60),
		ClientName2			VARCHAR(60),
		ClientName3			VARCHAR(60),
		ClientCountry		VARCHAR(2),
		ClientType			VARCHAR(5),
		ClientStatus		VARCHAR(1),
		NetAgreementFlag	VARCHAR(1)
	);
	INSERT INTO #ClientMaster
	(
		 RecordType			
		,ClientCode			
		,UniqueClientCode	
		,ClientParentCode	
		,ClientName1			
		,ClientName2			
		,ClientName3			
		,ClientCountry		
		,ClientType			
		,ClientStatus		
		,NetAgreementFlag	
	)
	SELECT 
		1,
		[AccountNumber (textinput-5)],
		[IDNumber (textinput-5)],
		[AccountNumber (textinput-5)],
		Client.[FirstName (textinput-150)],
		Client.[MiddleName (textinput-151)],
		Client.[LastName (textinput-152)],
		[CountryofResidence (selectsource-5)],
		[ClientType (selectbasic-26)],
		[Tradingaccount (selectsource-31)], --[AccountStatus (selectsource-9)],
		'N'
	FROM CQBTempDB.export.Tb_FormData_1410 Client  
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON Client.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)];

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #ClientMaster);

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
		ISNULL(RecordType,'') + ',' + ISNULL(ClientCode,'') + ',' + ISNULL(UniqueClientCode,'') + ',' + ISNULL(ClientParentCode,'') + ',' + ISNULL(ClientName1,'') + ',' + ISNULL(ClientName2,'') + ',' + 
		ISNULL(ClientName3,'') + ',' + ISNULL(ClientCountry,'') + ',' + ISNULL(ClientType,'') + ',' + ISNULL(ClientStatus,'') + ',' + ISNULL(NetAgreementFlag,'')
	FROM #ClientMaster;

	DROP TABLE #Header
	DROP TABLE #ClientMaster

END