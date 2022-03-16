/****** Object:  Procedure [export].[USP_ECOS_MACSEF_DBD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEF_DBD]
(
	@idteProcessDate DATE
)
-- DAILY BUSINESS DONE - ONLINE CLIENT
-- EXEC [export].[USP_ECOS_MACSEF_DBD] '2020-06-01'
AS
BEGIN
	CREATE TABLE #DBD
	(
		RecordType				CHAR(1),
		ClientCode				CHAR(9),
		TransType				CHAR(2),
		[P/S]					CHAR(1),
		TransPrefix				CHAR(1),
		TransNo					CHAR(6),
		TransSurfix				CHAR(1),
		TransVersion			CHAR(2),
		TransDate				CHAR(8),
		TransAmount				DECIMAL(13,2),
		TransQty				DECIMAL(9,0),
		[Cancel/Replace]		CHAR(1),
		CounterCode				CHAR(8),
		MatchedPrice			DECIMAL(10,6),
		RemisierCode			CHAR(4),
		NetAmount				DECIMAL(13,2),
		BrokerageAmount			DECIMAL(9,2),
		ContractStampAmt		DECIMAL(9,2),
		ClearingFee				DECIMAL(9,2),
		BrokerageServiceTax		DECIMAL(9,2),
		ClearingFeeServiceTax	DECIMAL(9,2)

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
		C.AcctNo,
		'CN',
		CASE 
			WHEN TransType = 'TRBUY' THEN 'P' ELSE 'S'
		END,
		LEFT(C.ContractNo,1),
		RIGHT(C.ContractNo,6),
		'',
		'',
		REPLACE(CONVERT(VARCHAR,ContractDate, 105),'-',''),
		ISNULL(ABS(NetAmountSetl),0),
		ISNULL(ABS(TradedQty),0),
		'',
		SUBSTRING(Product.[InstrumentCode (textinput-49)],0,CHARINDEX('.',Product.[InstrumentCode (textinput-49)])),
		ISNULL(ABS(TradedPrice),0),
		AcctExecutiveCd,
		ISNULL(ABS(NetAmountSetl),0),
		ISNULL(ABS(ClientBrokerageClientBased),0),
		ISNULL(ABS(B.FeeAmountSetl),0),
		ISNULL(ABS(A.FeeAmountSetl),0),
		ISNULL(ABS(ClientBrokerageClientBasedTax),0),
		ISNULL(ABS(A.FeeTaxSetl),0)
	FROM 
		GlobalBO.transmanagement.Tb_TransactionsSettled C
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
	WHERE
		C.TransType IN ('TRBUY','TRSELL') AND C.ContractDate = @idteProcessDate
	AND
		Product.[InstrumentCode (textinput-49)] LIKE '%.XKLS%'
	AND
		[MRIndicator (multipleradiosinline-4)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''

	UNION 

	-- OUTSTANDING  CONTRACTS
	SELECT
		1,
		C.AcctNo,
		'CN',
		CASE WHEN TransType = 'TRBUY'
		     THEN 'P'
			 ELSE 'S'
		END,
		LEFT(C.ContractNo,1),
		RIGHT(C.ContractNo,6),
		'',
		'',
		REPLACE(CONVERT(VARCHAR,ContractDate, 105),'-',''),
		ISNULL(ABS(NetAmountSetl),0),
		ISNULL(ABS(TradedQty),0),
		'',
		SUBSTRING(Product.[InstrumentCode (textinput-49)],0,CHARINDEX('.',Product.[InstrumentCode (textinput-49)])),
		ISNULL(ABS(TradedPrice),0),
		AcctExecutiveCd,
		ISNULL(ABS(NetAmountSetl),0),
		ISNULL(ABS(ClientBrokerageClientBased),0),
		ISNULL(ABS(B.FeeAmountSetl),0),
		ISNULL(ABS(A.FeeAmountSetl),0),
		ISNULL(ABS(ClientBrokerageClientBasedTax),0),
		ISNULL(ABS(A.FeeTaxSetl),0)
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
	WHERE
		C.TransType IN ('TRBUY','TRSELL') AND C.ContractDate = @idteProcessDate
	AND
		Product.[InstrumentCode (textinput-49)] LIKE '%.XKLS%'
	AND
		[MRIndicator (multipleradiosinline-4)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''

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
		ISNULL(RecordType,'') + '|' + 
		ISNULL(ClientCode,'') + '|' +  
		ISNULL(TransType,'') + '|' +  
		ISNULL([P/S],'') + '|' + 
		ISNULL(TransPrefix,'') + '|' +
		ISNULL(TransNo,'') + '|' + 
		ISNULL(TransSurfix,'') + '|' + 
		ISNULL(TransVersion,'') + '|' + 
		ISNULL(TransDate,'') + '|' + 
		RIGHT(REPLICATE('0',13) + TransAmount,13) +  '|' +
		RIGHT(REPLICATE('0',9) + TransQty,9) + '|' + 
		ISNULL([Cancel/Replace],'') + '|' + 
		ISNULL(CounterCode,'') + '|' + 
		RIGHT(REPLICATE('0',10) + MatchedPrice,10) + '|' + 
		ISNULL(RemisierCode,'') + '|' +
		RIGHT(REPLICATE('0',13) + NetAmount,13) + '|' + 
		RIGHT(REPLICATE('0',9) + BrokerageAmount,9) + '|' + 
		RIGHT(REPLICATE('0',9) + ContractStampAmt,9) + '|' +	
		RIGHT(REPLICATE('0',9) + ClearingFee,9) + '|' +  
		RIGHT(REPLICATE('0',9) + BrokerageServiceTax,9) + '|' + 
		RIGHT(REPLICATE('0',9) + ClearingFeeServiceTax,9)
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