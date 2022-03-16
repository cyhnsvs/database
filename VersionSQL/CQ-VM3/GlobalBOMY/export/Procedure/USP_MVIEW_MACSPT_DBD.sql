/****** Object:  Procedure [export].[USP_MVIEW_MACSPT_DBD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MVIEW_MACSPT_DBD]
(
	@idteProcessDate DATE
)
-- DAILY BUSINESS DONE - ONLINE CLIENT TO MVIEW SUB SYSTEM
-- EXEC [export].[USP_MVIEW_MACSPT_DBD] '2020-06-01'
AS
BEGIN
	CREATE TABLE #DBD
	(
		RecordType				CHAR(1),
		ClientCode				CHAR(6),
		TransType				CHAR(2),
		[P/S]					CHAR(1),
		TransPrefix				CHAR(1),
		TransNo					CHAR(6),
		TransSurfix				CHAR(1),
		TransVersion			CHAR(2),
		TransDate				CHAR(7),
		TransAmount				CHAR(13),
		TransQty				CHAR(9),
		[Cancel/Replace]		CHAR(1),
		CounterCode				CHAR(8),
		MatchedPrice			CHAR(10),
		RemisierCode			CHAR(3),
		NetAmount				CHAR(13),
		BrokerageAmount			CHAR(9),
		ContractStampAmt		CHAR(9),
		ClearingFee				CHAR(9),
		BrokerageServiceTax		CHAR(9),
		ClearingFeeServiceTax	CHAR(9)

	)
	INSERT INTO #DBD
	(
		 RecordType			
		,ClientCode			
		,TransType			
		,[P/S]				
		,TransPrefix			
		,TransNo				
		,TransSurfix			
		,TransVersion		
		,TransDate			
		,TransAmount			
		,TransQty			
		,[Cancel/Replace]	
		,CounterCode			
		,MatchedPrice		
		,RemisierCode		
		,NetAmount			
		,BrokerageAmount		
		,ContractStampAmt	
		,ClearingFee			
		,BrokerageServiceTax	
		,ClearingFeeServiceTax			
	)
	-- SETTLED CONTRACTS
	SELECT
		1,
		Account.[AccountNumber (textinput-5)],
		'CN',
		CASE WHEN TransType = 'TRBUY'
		     THEN 'P'
			 ELSE 'S'
		END,
		'',
		C.ContractNo,
		'',
		'',
		REPLACE(CONVERT(VARCHAR,ContractDate, 105),'-',''),
		CAST(RIGHT(REPLICATE('0',13) + CAST(CAST(ABS(NetAmountSetl) AS DECIMAL(13,2)) AS VARCHAR),13) AS CHAR(13)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(TradedQty) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		'',
		SUBSTRING(Product.[InstrumentCode (textinput-49)],0,CHARINDEX('.',Product.[InstrumentCode (textinput-49)])),
		CAST(RIGHT(REPLICATE('0',10) + CAST(CAST(ABS(TradedPrice) AS DECIMAL(9,6)) AS VARCHAR),10) AS CHAR(10)),
		AcctExecutiveCd,
		CAST(RIGHT(REPLICATE('0',13) + CAST(CAST(ABS(NetAmountSetl) AS DECIMAL(13,2)) AS VARCHAR),13) AS CHAR(13)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(ClientBrokerageClientBased) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(B.FeeAmountSetl) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(A.FeeAmountSetl) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(ClientBrokerageClientBasedTax) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(A.FeeTaxSetl) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9))
	FROM 
		GlobalBO.contracts.Tb_Contract C
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1345 Product ON Product.[CounterShortName (textinput-3)] = C.InstrumentName
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  C.AcctNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 Customer ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE
		C.TransType IN ('TRBUY','TRSELL') AND C.ContractDate = @idteProcessDate
	AND
		Product.[InstrumentCode (textinput-49)] LIKE '%.XKLS%'
	AND
		[OnlineSystemIndicator (multiplecheckboxesinline-2)] LIKE '%MV%' AND ISNULL([CDSNo (textinput-19)],'') <> ''

	UNION 

	-- OUTSTANDING  CONTRACTS
	SELECT
		1,
		Account.[AccountNumber (textinput-5)],
		'CN',
		CASE WHEN TransType = 'TRBUY'
		     THEN 'P'
			 ELSE 'S'
		END,
		'',
		C.ContractNo,
		'',
		'',
		REPLACE(CONVERT(VARCHAR,ContractDate, 105),'-',''),
		CAST(RIGHT(REPLICATE('0',13) + CAST(CAST(ABS(NetAmountSetl) AS DECIMAL(13,2)) AS VARCHAR),13) AS CHAR(13)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(TradedQty) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		'',
		SUBSTRING(Product.[InstrumentCode (textinput-49)],0,CHARINDEX('.',Product.[InstrumentCode (textinput-49)])),
		CAST(RIGHT(REPLICATE('0',10) + CAST(CAST(ABS(TradedPrice) AS DECIMAL(9,6)) AS VARCHAR),10) AS CHAR(10)),
		AcctExecutiveCd,
		CAST(RIGHT(REPLICATE('0',13) + CAST(CAST(ABS(NetAmountSetl) AS DECIMAL(13,2)) AS VARCHAR),13) AS CHAR(13)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(ClientBrokerageClientBased) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(B.FeeAmountSetl) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(A.FeeAmountSetl) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(ClientBrokerageClientBasedTax) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9)),
		CAST(RIGHT(REPLICATE('0',9) + CAST(CAST(ABS(A.FeeTaxSetl) AS DECIMAL(9,0)) AS VARCHAR),9) AS CHAR(9))
	FROM 
		GlobalBO.contracts.Tb_ContractOutstanding C
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1345 Product ON Product.[CounterShortName (textinput-3)] = C.InstrumentName
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  C.AcctNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 Customer ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE
		C.TransType IN ('TRBUY','TRSELL') AND C.ContractDate = @idteProcessDate
	AND
		Product.[InstrumentCode (textinput-49)] LIKE '%.XKLS%'
	AND
		[OnlineSystemIndicator (multiplecheckboxesinline-2)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''

		-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #DBD)
	
	CREATE TABLE #DBDControl
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	)
	INSERT INTO #DBDControl
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate, 105))

	-- TRANSACTION RECORD - RESULT SET
	SELECT 
		ISNULL(RecordType,'') + '|' + ISNULL(ClientCode,'') + '|' +  ISNULL(TransType,'') + '|' +  ISNULL([P/S],'') + '|' + ISNULL(TransPrefix,'') + '|' +
		ISNULL(TransNo,'') + '|' + ISNULL(TransSurfix,'') + '|' + ISNULL(TransVersion,'') + '|' + ISNULL(TransDate,'') + '|' + ISNULL(TransAmount,'')+ '|' +
		ISNULL(TransQty,'') + '|' + ISNULL([Cancel/Replace],'') + '|' + ISNULL(CounterCode,'') + '|' + ISNULL(MatchedPrice,'') + '|' + ISNULL(RemisierCode,'') + '|' +
		ISNULL(NetAmount,'') + '|' + ISNULL(BrokerageAmount,'') + '|' + ISNULL(ContractStampAmt,'') + '|' +	ISNULL(ClearingFee,'') + '|' +  
		ISNULL(BrokerageServiceTax,'') + '|' + ISNULL(ClearingFeeServiceTax,'')
	FROM 
		#DBD
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' +  RIGHT(REPLICATE('0',12) + RTRIM(RecordCount), 12) + '|' +  ProcessDate
	FROM
		#DBDControl

	DROP TABLE #DBD
	DROP TABLE #DBDControl
END