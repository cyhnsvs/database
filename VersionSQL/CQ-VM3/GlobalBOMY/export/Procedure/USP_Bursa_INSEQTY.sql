/****** Object:  Procedure [export].[USP_Bursa_INSEQTY]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_INSEQTY]
(
	@idteProcessDate DATE
)
AS
/*
Description : Instrument Master for Equities, Debts and Warrants INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_INSEQTY] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-3)]) 
	FROM CQBTempDB.export.Tb_FormData_3384
	WHERE CAST([ReportDate (dateinput-3)] as date) <= @idteProcessDate;

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
		[SecurityCode (textinput-1)],
		[ISINCode (textinput-2)],
		[InstrumentName (textinput-3)],
		[InstrumentType (selectbasic-1)],
		[InstrumentSubType (selectbasic-2)],
		[UnderlyingInstrumentISIN (textinput-5)],
		[ExpiryMaturityDate (dateinput-2)],
		[IssuerName (textinput-6)],
		[IndexCode (selectbasic-3)],
		[InstrumentStatus (selectbasic-4)],
		[SuspensionStatus (selectbasic-5)],
		[ParValue (textinput-7)],
		[MTMPrice (textinput-8)],
		[IssueSize (textinput-9)],
		[ExchangeCode (selectbasic-6)],
		[RecognisedFlag (selectbasic-7)]
	FROM CQBTempDB.export.Tb_FormData_3384
	WHERE [ReportDate (dateinput-3)] = @ReportDate;

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