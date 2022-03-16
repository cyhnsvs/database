/****** Object:  Procedure [export].[USP_Bursa_BROKERAGE_QTR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_BROKERAGE_QTR]
(
	@idteProcessDate DATE
)
AS
/*
Description : BROKERAGE INFO TO BURSA   
Test Input	: EXEC [export].[USP_Bursa_BROKERAGE_QTR] '2020-06-01'
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
	CREATE TABLE #Detail
	(
		RecordType			VARCHAR(1),
		POCode				VARCHAR(6),
		PositionDate		VARCHAR(10),
		RevenueType			VARCHAR(3),
		BrokerageType		VARCHAR(3),
		ClientType			VARCHAR(3),
		RevenueValue		DECIMAL(15,2)

	);
	INSERT INTO #Detail
	(
		 RecordType		
		,POCode			
		,PositionDate	
		,RevenueType		
		,BrokerageType		
		,ClientType		
		,RevenueValue									
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		'EGR', -- Other type categorization is pending 
		CASE WHEN Channel = 'Online' THEN 'OL' ELSE 'OFF' END,
		[ClientType (selectbasic-26)],
		SUM(ClientBrokerageSetl)
	FROM GlobalBO.contracts.Tb_ContractOutstanding CO 
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON CO.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C 
		ON C.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)]
	GROUP BY AcctNo,[ClientType (selectbasic-26)], Channel

	UNION 
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		'EGR', -- Other type categorization is pending 
		CASE WHEN Channel = 'Online' THEN 'OL' ELSE 'OFF' END,
		[ClientType (selectbasic-26)],
		SUM(CommissionClientBased)
	FROM GlobalBO.transmanagement.Tb_Transactions T 
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON T.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C 
		ON C.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)]
	GROUP BY AcctNo,[ClientType (selectbasic-26)], Channel

	UNION 
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		'EGR', -- Other type categorization is pending 
		CASE WHEN Channel = 'Online' THEN 'OL' ELSE 'OFF' END,
		[ClientType (selectbasic-26)],
		SUM(ClientBrokerageSetl)
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled T 
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON T.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C 
		ON C.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)]
	GROUP BY AcctNo,[ClientType (selectbasic-26)], Channel;


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
	FROM 
		#Header
	UNION ALL
	SELECT 
		RecordType + ',' + POCode + ',' + PositionDate + ',' + RevenueType + ',' + BrokerageType  + ',' + ClientType + ',' + CAST(RevenueValue AS VARCHAR)
	FROM 
		#Detail;

	DROP TABLE #Header;
	DROP TABLE #Detail;

END