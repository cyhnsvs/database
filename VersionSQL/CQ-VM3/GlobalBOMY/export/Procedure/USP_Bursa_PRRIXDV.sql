/****** Object:  Procedure [export].[USP_Bursa_PRRIXDV]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_PRRIXDV]
(
	@idteProcessDate DATE
)
AS
/*
Description : PRR Data – Principal Trades – Index Derivatives INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_PRRIXDV] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-4)]) 
	FROM CQBTempDB.export.Tb_FormData_3175
	WHERE CAST([ReportDate (dateinput-4)] as date) <= @idteProcessDate;

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
		SBCCode					VARCHAR(6),
		ReportingDate			VARCHAR(10),
		BranchCode				VARCHAR(6),
		DealerCode				VARCHAR(6),
		AccountType				VARCHAR(3),
		ISINCode				VARCHAR(12),
		InstrumentType			VARCHAR(2),
		StrikePrice				NUMERIC(9,3),
		ExpiryDate				VARCHAR(10),
		PositionType			VARCHAR(1),
		CurrencyCode			VARCHAR(3),
		ContractVolume			VARCHAR(10),
		ContractValue			NUMERIC(15,3),
		PRRMethod				VARCHAR(3)
	);
	
	INSERT INTO #Data
	(
		 RecordType		
		,SBCCode			
		,ReportingDate	
		,BranchCode		
		,DealerCode		
		,AccountType		
		,ISINCode		
		,InstrumentType		
		,StrikePrice		
		,ExpiryDate			
		,PositionType		
		,CurrencyCode	
		,ContractVolume	
		,ContractValue	
		,PRRMethod											
	)
	SELECT 
		 1
		,[SBCCode (textinput-1)]
		,CONVERT(VARCHAR,@idteProcessDate,103)
		,[BranchCode (textinput-2)]
		,[DealerCode (textinput-3)]
		,[AccountType (selectbasic-1)]	
		,[ISINCode (textinput-4)]
		,[DerivativeInstrumentType (selectbasic-2)]
		,[StrikePrice (textinput-5)]
		,[ExpiryDate (dateinput-3)]
		,[PositionType (selectbasic-3)]
		,[CurrencyCode (textinput-6)]
		,[ContractVolume (textinput-7)]
		,[ContractValue (textinput-8)]
		,[PRRMethod (textinput-9)]		
	FROM CQBTempDB.export.tb_formdata_3175
	WHERE [ReportDate (dateinput-4)] = @ReportDate;

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
		+ ',' + SBCCode			
		+ ',' + ReportingDate	
		+ ',' + BranchCode		
		+ ',' + DealerCode		
		+ ',' + AccountType		
		+ ',' + ISINCode		
		+ ',' + InstrumentType	
		+ ',' + CAST(StrikePrice AS VARCHAR)		
		+ ',' + ExpiryDate		
		+ ',' + PositionType	
		+ ',' + CurrencyCode	
		+ ',' + ContractVolume	
		+ ',' + CAST(ContractValue AS VARCHAR)
		+ ',' + PRRMethod		
	FROM #Data;

	DROP TABLE #Data;
	DROP TABLE #Header;

END