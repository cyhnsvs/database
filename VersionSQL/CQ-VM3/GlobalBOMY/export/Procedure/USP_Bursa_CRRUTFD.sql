/****** Object:  Procedure [export].[USP_Bursa_CRRUTFD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CRRUTFD]
(
	@idteProcessDate DATE
)
AS
/*
Description : UNSETTLED TRADES/ Free Delivery / Exceptional Instruments INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_CRRUTFD] '2020-06-01'
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
		SBCCode					VARCHAR(6),
		ReportingDate			VARCHAR(10),
		BranchCode				VARCHAR(6),
		DealerCode				VARCHAR(6),
		ClientCode				VARCHAR(12),
		ExposureType			VARCHAR(2),
		ISINCode				VARCHAR(12),
		TransRef				VARCHAR(20),
		ContractType			VARCHAR(1),
		TransType				VARCHAR(1),
		ContractDate			VARCHAR(10),
		SetlDate				VARCHAR(10),
		FreeDeliveryDate		VARCHAR(10),
		OrgVolume				NUMERIC(15,3),
		OrgValue				NUMERIC(15,3),
		OutStandingVol			NUMERIC(15,3),
		OutStandingVal			NUMERIC(15,3),
		CurrencyCode			VARCHAR(3),
		ProvisionType			VARCHAR(1),
		ProvisionValueMYR		NUMERIC(15,3)
	);
	INSERT INTO #Data
	(
		RecordType			
		,SBCCode				
		,ReportingDate		
		,BranchCode			
		,DealerCode			
		,ClientCode			
		,ExposureType		
		,ISINCode			
		,TransRef			
		,ContractType		
		,TransType			
		,ContractDate		
		,SetlDate			
		,FreeDeliveryDate	
		,OrgVolume			
		,OrgValue			
		,OutStandingVol		
		,OutStandingVal		
		,CurrencyCode		
		,ProvisionType		
		--,ProvisionValueMYR	
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		[CDSACOpenBranch (selectsource-4)],
		[DealerCode (selectsource-21)],
		C.AcctNo,
		'UT',
		ISINCd,
		ContractNo,
		'A',
		TransType,
		CONVERT(VARCHAR,ContractDate,103),
		CONVERT(VARCHAR,SetlDate,103),
		CASE
		WHEN (GlobalBO.[global].[Udf_GetNextBusDateByDaysExcludePH](C.ContractDate,2,NULL) = C.SetlDate) AND (C.TransType = 'TRBUY') THEN GlobalBO.[global].[Udf_GetNextBusDateByDaysExcludePH](C.ContractDate,2,NULL)
		WHEN (GlobalBO.[global].[Udf_GetNextBusDateByDaysExcludePH](C.ContractDate,2,NULL) = C.SetlDate) AND (C.TransType = 'TRSELL') THEN (SELECT * FROM GlobalBO.[global].[Udf_GetNextBusinessDate](C.ContractDate))
		WHEN (GlobalBO.[global].[Udf_GetNextBusDateByDaysExcludePH](C.ContractDate,1,NULL) = C.SetlDate) AND (C.TransType = 'TRBUY') THEN C.ContractDate
		WHEN (GlobalBO.[global].[Udf_GetNextBusDateByDaysExcludePH](C.ContractDate,1,NULL) = C.SetlDate) AND (C.TransType = 'TRSELL') THEN (SELECT * FROM GlobalBO.[global].[Udf_GetNextBusinessDate](C.ContractDate))
		END,
		TradedQty,
		NetAmountSetl,
		'0.000',
		'0.000',
		C.TradedCurrCd,
		'N'
		'0.000'
	FROM GlobalBO.contracts.Tb_ContractOutstanding C
	INNER JOIN CQBTempDB.export.tb_FormData_1409 A 
		ON C.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON C.InstrumentId = I.InstrumentId
	WHERE [ParentGroup (selectsource-3)] IN ('V','P','E');

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Data);

	INSERT INTO #Header
	(
		RecordType,
		ReportingDate,
		RecordCount
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count)

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
		 + ',' + ClientCode			
		 + ',' + ExposureType		
		 + ',' + ISINCode			
		 + ',' + TransRef			
		 + ',' + ContractType		
		 + ',' + TransType			
		 + ',' + ContractDate		
		 + ',' + SetlDate			
		 + ',' + FreeDeliveryDate	
		 + ',' + CAST(OrgVolume	AS VARCHAR)	
		 + ',' + CAST(OrgValue	AS VARCHAR)			
		 + ',' + CAST(OutStandingVol AS VARCHAR)		
		 + ',' + CAST(OutStandingVal AS VARCHAR)		
		 + ',' + CurrencyCode		
		 + ',' + ProvisionType		
		 + ',' + CAST(ProvisionValueMYR	AS VARCHAR)		 
	FROM #Data;

	DROP TABLE #Header;
	DROP TABLE #Data;

END