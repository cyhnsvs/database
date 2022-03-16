/****** Object:  Procedure [export].[USP_Bursa_STR2_MTH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_STR2_MTH]
(
	@idteProcessDate DATE
)
AS
/*
Description : SECURITIES TURNOVER BY INVESTOR CATEGORY. TOTAL VOLUME AND VALUE OF FOREIGN TRANSACTIONS BY COUNTRY OF ORIGIN TO BURSA
Test Input	: EXEC [export].[USP_Bursa_STR2_MTH] '2020-06-01'
*/
BEGIN
	
	DECLARE @dteMonthStart DATE;
	SET @dteMonthStart = (SELECT DATEADD(month, DATEDIFF(month, 0, @idteProcessDate), 0)); 

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
		CountryOfOrigin		VARCHAR(3),
		InvestorCategory	VARCHAR(3),
		Volume				DECIMAL(15,0),
		[Value]				DECIMAL(15,2)

	);
	INSERT INTO #Detail
	(
		 RecordType		
		,POCode			
		,PositionDate	
		,CountryOfOrigin		
		,InvestorCategory	
		,Volume		
		,[Value]													
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		[CountryOfResidence (selectsource-5)],
		CASE WHEN [ClientType (selectbasic-26)] = 'I' THEN 'IND'
			 WHEN [ParentGroup (selectsource-3)] = 'B' THEN 'INT'
			 WHEN [ParentGroup (selectsource-3)] = 'I' THEN 'INS'
			 WHEN [ParentGroup (selectsource-3)] IN ('P','V','H') THEN 'PO'
			 WHEN [ParentGroup (selectsource-3)] IN ('F','G') THEN 'OTH'
			 ELSE ''
		END,
		SUM(TradedQty),
		SUM(NetAmountSetl)
	FROM GlobalBO.contracts.Tb_ContractOutstanding CO
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON CO.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON CO.AcctNo = Account.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE CO.ContractDate BETWEEN @dteMonthStart AND  @idteProcessDate AND I.ListedExchCd <> 'XKLS'
	GROUP BY [CountryOfResidence (selectsource-5)],[ClientType (selectbasic-26)],[ParentGroup (selectsource-3)]
	UNION
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		[CountryOfResidence (selectsource-5)],
		CASE WHEN [ClientType (selectbasic-26)] = 'I' THEN 'IND'
			 WHEN [ParentGroup (selectsource-3)] = 'B' THEN 'INT'
			 WHEN [ParentGroup (selectsource-3)] = 'I' THEN 'INS'
			 WHEN [ParentGroup (selectsource-3)] IN ('P','V','H') THEN 'PO'
			 WHEN [ParentGroup (selectsource-3)] IN ('F','G') THEN 'OTH'
			 ELSE ''
		END,
		SUM(TradedQty),
		SUM(NetAmountSetl)
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled CO
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON CO.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON CO.AcctNo = Account.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE CO.ContractDate BETWEEN @dteMonthStart AND  @idteProcessDate AND CO.TransType IN ('TRBUY','TRSELL') AND I.ListedExchCd <> 'XKLS'
	GROUP BY [CountryOfResidence (selectsource-5)],[ClientType (selectbasic-26)],[ParentGroup (selectsource-3)];


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
		+ ',' + CountryOfOrigin		
		+ ',' + InvestorCategory		
		+ ',' + CAST(Volume	 AS VARCHAR)	
		+ ',' + CAST([Value] AS VARCHAR)
	FROM #Detail;

	DROP TABLE #Header;
	DROP TABLE #Detail;

END