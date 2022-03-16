/****** Object:  Procedure [export].[USP_Bursa_PRREQDV]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_PRREQDV]
(
	@idteProcessDate DATE
)
AS
/*
Description : PRR Data – Principal Trades – Equity Derivatives INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_PRREQDV] '2020-06-01'
*/
BEGIN
	
	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-3)]) 
	FROM CQBTempDB.export.Tb_FormData_3265
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
		SBCCode					VARCHAR(6),
		ReportingDate			VARCHAR(10),
		BranchCode				VARCHAR(6),
		DealerCode				VARCHAR(6),
		AccountType				VARCHAR(3),
		DerivativeISINCode		VARCHAR(12),
		EquityISINCode			VARCHAR(12),
		DerivativeInstrumentType	VARCHAR(2),
		StrikePrice				DECIMAL(9,3),
		ExpiryDate				VARCHAR(10),
		PositionType			VARCHAR(1),
		CurrencyCode			VARCHAR(3),
		ContractVolume			DECIMAL(10,0),
		ContractValue			DECIMAL(15,3),
		InitMarginAmount		DECIMAL(15,3),
		EQConvFlag				VARCHAR(1),
		EQConvRatioQty			VARCHAR(5),
		EQConvRatioPrice		VARCHAR(9)
	);

	INSERT INTO #Data
	(
		 RecordType				
		,SBCCode					
		,ReportingDate			
		,BranchCode				
		,DealerCode				
		,AccountType				
		,DerivativeISINCode		
		,EquityISINCode			
		,DerivativeInstrumentType
		,StrikePrice				
		,ExpiryDate				
		,PositionType			
		,CurrencyCode			
		,ContractVolume			
		,ContractValue			
		,InitMarginAmount		
		,EQConvFlag				
		,EQConvRatioQty			
		,EQConvRatioPrice		
	)
	SELECT
		 '1'
		,[SBCCode (textinput-1)]
		,CONVERT(VARCHAR,@idteProcessDate,103)
		,[BranchCode (textinput-2)]
		,[DealerCode (textinput-3)]
		,[AccountType (selectbasic-1)]	
		,[DerivativeISINCode (textinput-4)] 
		,[UnderlyingEquityISINCode (textinput-5)]
		,[DerivativeInstrumentType (selectbasic-2)]
		,[StrikePrice (textinput-6)]
		,CONVERT(VARCHAR,[ExpiryDate (dateinput-2)],103)
		,[PositionType (selectbasic-3)]
		,[CurrencyCode (textinput-7)]
		,[ContractVolume (textinput-8)]
		,[ContractValue (textinput-9)]
		,[InitialMarginAmount (textinput-10)]
		,[EquityConversionFlag (selectbasic-4)]
		,[EquityConversionRatioQuantity (textinput-12)]
		,[EquityConversionRatioPrice (textinput-13)]
	FROM CQBTempDB.export.Tb_FormData_3265
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
		+ ',' + SBCCode					
		+ ',' + ReportingDate			
		+ ',' + BranchCode				
		+ ',' + DealerCode				
		+ ',' + AccountType				
		+ ',' + DerivativeISINCode		
		+ ',' + EquityISINCode			
		+ ',' + DerivativeInstrumentType
		+ ',' + CAST(StrikePrice AS VARCHAR)				
		+ ',' + ExpiryDate				
		+ ',' + PositionType			
		+ ',' + CurrencyCode			
		+ ',' + CAST(ContractVolume AS VARCHAR)			
		+ ',' + CAST(ContractValue AS VARCHAR)			
		+ ',' + CAST(InitMarginAmount AS VARCHAR)		
		+ ',' + EQConvFlag				
		+ ',' + EQConvRatioQty			
		+ ',' + EQConvRatioPrice			
	FROM #Data

	DROP TABLE #Data;
	DROP TABLE #Header;

END