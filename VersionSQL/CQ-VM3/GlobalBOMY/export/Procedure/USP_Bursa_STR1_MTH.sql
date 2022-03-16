/****** Object:  Procedure [export].[USP_Bursa_STR1_MTH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_STR1_MTH]
(
	@idteProcessDate DATE
)
AS
/*
Description : SECURITIES TURNOVER BY INVESTOR CATEGORY. TRADING VOLUME BY ONMARKET and DIRECT BUSINESS TRANSACTIONS (DBT) TO BURSA
Test Input	: EXEC [export].[USP_Bursa_STR1_MTH] '2020-06-01'
*/
BEGIN
	
	DECLARE @dteMonthStart DATE 
	SET @dteMonthStart = (SELECT DATEADD(month, DATEDIFF(month, 0, @idteProcessDate), 0)) 
	
	-- Header Record
	CREATE TABLE #Header
	(
		RecordType		VARCHAR(1),
		ReportingDate	VARCHAR(10),
		RecordCount		VARCHAR(10)
	);

	-- Data Record
	CREATE TABLE #Detail
	(
		RecordType			VARCHAR(1),
		POCode				VARCHAR(6),
		PositionDate		VARCHAR(10),
		TransType			VARCHAR(3),
		InvestorCategory	VARCHAR(3),
		TradeType			VARCHAR(2),
		Volume				DECIMAL(15,0),
		YTDVolume			DECIMAL(15,0),
		[Value]				DECIMAL(15,2),
		YTDValue			DECIMAL(15,2)

	);
	INSERT INTO #Detail
	(
		 RecordType		
		,POCode			
		,PositionDate	
		,TransType		
		,InvestorCategory
		,TradeType		
		,Volume			
		,YTDVolume		
		,[Value]			
		,YTDValue													
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		CASE WHEN Facility = 'D' THEN 'DBT' ELSE 'MKT' END,
		CASE WHEN [ClientType (selectbasic-26)] = 'I' AND [BumiputraStatus (multipleradiosinline-1)] = 'Y' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'IB'
			 WHEN [ClientType (selectbasic-26)] = 'I' AND [BumiputraStatus (multipleradiosinline-1)] = 'N' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'INB'
			 WHEN [ClientType (selectbasic-26)] = 'I' AND [CountryOfResidence (selectsource-5)] <> 'MY' THEN 'IFR'
			 WHEN [ParentGroup (selectsource-3)] = 'B' THEN 'INT'
			 WHEN [ParentGroup (selectsource-3)] = 'I' THEN 'INS'
			 WHEN [ParentGroup (selectsource-3)] IN ('P','V','H') THEN 'PO'
			 WHEN [ParentGroup (selectsource-3)] IN ('F','G') THEN 'OTH'
			 ELSE ''
		END, 
		CASE WHEN TransType = 'TRBUY' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'LP'
			 WHEN TransType = 'TRBUY' AND [CountryOfResidence (selectsource-5)] <> 'MY' THEN 'FP'
			 WHEN TransType = 'TRSELL' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'LS'
			 WHEN TransType = 'TRSELL' AND [CountryOfResidence (selectsource-5)] <> 'MY' THEN 'FS'
		END,
		SUM(TradedQty),
		SUM(TradedQty),
		SUM(NetAmountSetl),
		SUM(NetAmountSetl)
	FROM GlobalBO.contracts.Tb_ContractOutstanding CO
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON CO.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON CO.AcctNo = Account.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE CO.ContractDate BETWEEN @dteMonthStart AND  @idteProcessDate AND I.ListedExchCd = 'XKLS'
	GROUP BY AcctNo,TransType,[ClientType (selectbasic-26)],[BumiputraStatus (multipleradiosinline-1)],[CountryOfResidence (selectsource-5)],Facility,[ParentGroup (selectsource-3)]
	UNION
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		CASE WHEN Facility = 'D' THEN 'DBT' ELSE 'MKT' END,
		CASE WHEN [ClientType (selectbasic-26)] = 'I' AND [BumiputraStatus (multipleradiosinline-1)] = 'Y' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'IB'
			 WHEN [ClientType (selectbasic-26)] = 'I' AND [BumiputraStatus (multipleradiosinline-1)] = 'N' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'INB'
			 WHEN [ClientType (selectbasic-26)] = 'I' AND [CountryOfResidence (selectsource-5)] <> 'MY' THEN 'IFR'
			 WHEN [ParentGroup (selectsource-3)] = 'B' THEN 'INT'
			 WHEN [ParentGroup (selectsource-3)] = 'I' THEN 'INS'
			 WHEN [ParentGroup (selectsource-3)] IN ('P','V','H') THEN 'PO'
			 WHEN [ParentGroup (selectsource-3)] IN ('F','G') THEN 'OTH'
			 ELSE ''
		END, 
		CASE WHEN TransType = 'TRBUY' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'LP'
			 WHEN TransType = 'TRBUY' AND [CountryOfResidence (selectsource-5)] <> 'MY' THEN 'FP'
			 WHEN TransType = 'TRSELL' AND [CountryOfResidence (selectsource-5)] = 'MY' THEN 'LS'
			 WHEN TransType = 'TRSELL' AND [CountryOfResidence (selectsource-5)] <> 'MY' THEN 'FS'
		END,
		SUM(TradedQty),
		SUM(TradedQty),
		SUM(NetAmountSetl),
		SUM(NetAmountSetl)
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled CO	
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON CO.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON CO.AcctNo = Account.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE CO.ContractDate BETWEEN @dteMonthStart AND  @idteProcessDate AND CO.TransType IN ('TRBUY','TRSELL') AND I.ListedExchCd = 'XKLS'
	GROUP BY AcctNo,TransType,[ClientType (selectbasic-26)],[BumiputraStatus (multipleradiosinline-1)],[CountryOfResidence (selectsource-5)],Facility,[ParentGroup (selectsource-3)];


	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);

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
		+ ',' + POCode			
		+ ',' + PositionDate	
		+ ',' + TransType		
		+ ',' + InvestorCategory
		+ ',' + TradeType		
		+ ',' + CAST(Volume	AS VARCHAR)		
		+ ',' + CAST(YTDVolume	AS VARCHAR)
		+ ',' + CAST([Value]	AS VARCHAR)	
		+ ',' + CAST(YTDValue	AS VARCHAR)
	FROM #Detail

	DROP TABLE #Header;
	DROP TABLE #Detail;

END