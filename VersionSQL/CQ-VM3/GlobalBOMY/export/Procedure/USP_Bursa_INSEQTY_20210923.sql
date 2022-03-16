/****** Object:  Procedure [export].[USP_Bursa_INSEQTY_20210923]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_INSEQTY_20210923]
(
	@idteProcessDate DATE
)
AS
/*
Description : Instrument Master for Equities, Debts and Warrants INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_INSEQTY] '2020-06-01'
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
	CREATE TABLE #Data
	(
		RecordType				VARCHAR(1),
		ReportingDate			VARCHAR(10),
		SecurityCode			VARCHAR(12),
		ISINCode				VARCHAR(12),
		InstrumentName			VARCHAR(40),
		InstrumentType			VARCHAR(2),
		InstrumentSubType		VARCHAR(5),
		UnderlyingISIN			VARCHAR(12),
		ExpiryDate				VARCHAR(10),
		IssuerName				VARCHAR(60),
		IndexCode				VARCHAR(10),
		InstrumentStatus		VARCHAR(1),
		SuspensionStatus		VARCHAR(1),
		ParValue				NUMERIC(15,3),
		MTMPrice				NUMERIC(9,3),
		IssueSize				VARCHAR(12),
		ExchCode				VARCHAR(10),
		RecognisedFlag			VARCHAR(1)
	);

	INSERT INTO #Data
	(
		 RecordType			
		,ReportingDate		
		,SecurityCode		
		,ISINCode			
		,InstrumentName		
		,InstrumentType		
		,InstrumentSubType
		,UnderlyingISIN
		,ExpiryDate			
		,IssuerName			
		,IndexCode			
		,InstrumentStatus	
		,SuspensionStatus	
		,ParValue			
		,MTMPrice			
		,IssueSize			
		,ExchCode			
		,RecognisedFlag		
	)
	SELECT
		1,
		CONVERT(VARCHAR,@idteProcessDate,103),
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		ISINCd,
		ShortName,
		[ProductClass (selectsource-3)],
		'',
		ISINCd,
		CONVERT(VARCHAR,ExpiryDate,103),
		Issuer,
		[IndexCode (selectsource-7)],
		[Status],
		'',
		ParValue,
		C.ClosingPrice,
		IssuedShare,
		ExchCd,
		[CARFlag (selectbasic-1)]
	FROM 
		GlobalBO.setup.Tb_Instrument I
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1345 P ON I.InstrumentCd = P.[InstrumentCode (textinput-49)]
	INNER JOIN 
		GlobalBO.setup.Tb_ClosingPrice C ON I.InstrumentId = C.InstrumentId
	WHERE
		I.InstrumentCd LIKE '%.XKLS%' AND P.[SecuritiesType (selectsource-6)] IN ('W') -- Warrant

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Data);

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
		RecordType		
		+ ',' + ReportingDate	
		+ ',' + SecurityCode	
		+ ',' + ISINCode		
		+ ',' + InstrumentName	
		+ ',' + InstrumentType	
		+ ',' + InstrumentSubType
		+ ',' + ExpiryDate		
		+ ',' + IssuerName		
		+ ',' + IndexCode		
		+ ',' + InstrumentStatus
		+ ',' + SuspensionStatus
		+ ',' + CAST(ParValue AS VARCHAR)	
		+ ',' + CAST(MTMPrice AS VARCHAR)	
		+ ',' + IssueSize		
		+ ',' + ExchCode		
		+ ',' + RecognisedFlag		
	FROM #Data;

	DROP TABLE #Header;
	DROP TABLE #Data;
END