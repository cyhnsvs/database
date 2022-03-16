/****** Object:  Procedure [export].[USP_ECOS_MACSEFRMS_OST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEFRMS_OST]
(
	@idteProcessDate DATE
)
AS
-- OFFLINE CLIENT - CLIENT OUTSTANDING 
-- EXEC [export].[USP_ECOS_MACSEFRMS_OST] '2020-06-01'
BEGIN
	CREATE TABLE #ClientOutstanding
	(
		RecordType			CHAR(1),
		BranchID			CHAR(3),
		ClientCode			CHAR(9),
		StockCode			CHAR(8),
		TransactionDate		CHAR(8),
		ContractNo			CHAR(13),
		TransType			CHAR(2),
		Quantity			DECIMAL(9,0),
		Price				DECIMAL(10,6),
		NetAmount			DECIMAL(13,2),
		DueDate				CHAR(8),
		IntFee				DECIMAL(9,2),
		OrgQty				DECIMAL(9,0),
		OrgTransAmount		DECIMAL(13,2),
		SettledQty			DECIMAL(9,0),
		SettledAmount		DECIMAL(13,2)
	)
	INSERT INTO #ClientOutstanding
	(
		 RecordType	
		,BranchID
		,ClientCode		
		,StockCode		
		,TransactionDate	
		,ContractNo		
		,TransType		
		,Quantity		
		,Price			
		,NetAmount		
		,DueDate			
		,IntFee			
		,OrgQty			
		,OrgTransAmount	
		,SettledQty		
		,SettledAmount	
	)
	SELECT 
		1,
		'001',
		CO.AcctNo,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		REPLACE(CONVERT(VARCHAR,CO.ContractDate, 105),'-',''),
		CASE WHEN CO.TransType = 'TRBUY'
		     THEN 'P ' + CO.ContractNo
			 WHEN CO.TransType = 'TRSELL'
		     THEN 'S ' + CO.ContractNo
			 WHEN CO.TransType = 'CHGN'
			 THEN 'CC'+ CO.ContractNo
			 WHEN CO.TransType = 'CHLS'
			 THEN 'CD'+ CO.ContractNo
			 ELSE CASE	WHEN CO.NetAmountSetl < 0
						THEN 'DR'+ CO.ContractNo
						ELSE  'CR'+ CO.ContractNo
				  END
		END,
		CASE WHEN CO.TransType IN ('TRBUY','TRSELL')
		     THEN 'CN'
			 WHEN CO.TransType IN ('CHGN','CHLS')
			 THEN 'CA'
			 ELSE CASE	WHEN CO.NetAmountSetl < 0
						THEN 'DR'
						ELSE  'CR'
				  END
		END,
		ISNULL(CO.TradedQty,0),
		ISNULL(CO.TradedPrice,0),
		ISNULL(CO.NetAmountSetl,0),
		REPLACE(CONVERT(VARCHAR,CO.SetlDate, 105),'-',''),
		ISNULL(CO.AccruedInterestAmountSetl,0),
		ISNULL(CO.TradedQty,0),
		ISNULL(CO.NetAmountSetl,0),
		ISNULL(CO.TradedQty,0) - ISNULL(RemainingQty,0),
		ISNULL(CO.NetAmountSetl,0) - ISNULL(Balance,0)
	FROM	
		GlobalBO.contracts.Tb_ContractOutstanding CO
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON CO.InstrumentId = I.InstrumentId
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  CO.AcctNo
	LEFT JOIN 
		[GlobalBOLocal].[transmanagement].[Tb_TransactionsSettledUnpaid] T ON CO.ContractNo = LEFT(T.ContractNo,10)
	WHERE
		(CHARINDEX('M+',[MRIndicator (multipleradiosinline-4)]) = 0 OR ISNULL([CDSNo (textinput-19)],'') = '')
	AND
		I.InstrumentCd LIKE '%.XKLS%' AND CO.ContractDate = @idteProcessDate
	UNION
	SELECT 
		1,
		'001',
		CO.AcctNo,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		REPLACE(CONVERT(VARCHAR,CO.TransDate, 105),'-',''),
		CASE WHEN CO.TransType = 'TRBUY'
		     THEN 'P ' + SUBSTRING(TransNo,6,LEN(TransNo))
			 WHEN CO.TransType = 'TRSELL'
		     THEN 'S ' + SUBSTRING(TransNo,6,LEN(TransNo))
			 WHEN CO.TransType = 'CHGN'
			 THEN 'CC'+ SUBSTRING(TransNo,6,LEN(TransNo))
			 WHEN CO.TransType = 'CHLS'
			 THEN 'CD'+ SUBSTRING(TransNo,6,LEN(TransNo))
			 ELSE CASE	WHEN Amount < 0
						THEN 'DR'+ SUBSTRING(TransNo,6,LEN(TransNo))
						ELSE  'CR'+ SUBSTRING(TransNo,6,LEN(TransNo))
				  END
		END,
		CASE WHEN CO.TransType IN ('TRBUY','TRSELL')
		     THEN 'CN'
			 WHEN CO.TransType IN ('CHGN','CHLS')
			 THEN 'CA'
			 ELSE CASE	WHEN Amount < 0
						THEN 'DR'
						ELSE  'CR'
				  END
		END,
		ISNULL(CO.TradedQty,0),
		ISNULL(CO.TradedPrice,0),
		ISNULL(Amount,0),
		REPLACE(CONVERT(VARCHAR,CO.SetlDate, 105),'-',''),
		ISNULL(Fee,0),
		ISNULL(CO.TradedQty,0),
		ISNULL(Amount,0),
		ISNULL(CO.TradedQty,0) - ISNULL(RemainingQty,0),
		ISNULL(Amount,0) - ISNULL(Balance,0)
	FROM	
		GlobalBO.transmanagement.Tb_Transactions CO
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON CO.InstrumentId = I.InstrumentId
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  CO.AcctNo
	LEFT JOIN 
		[GlobalBOLocal].[transmanagement].[Tb_TransactionsSettledUnpaid] T ON CO.TransNo = T.ContractNo
	WHERE
		(CHARINDEX('M+',[MRIndicator (multipleradiosinline-4)]) = 0 OR ISNULL([CDSNo (textinput-19)],'') = '')
	AND
		I.InstrumentCd LIKE '%.XKLS%' AND CO.TransDate = @idteProcessDate

		-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #ClientOutstanding)
	
	CREATE TABLE #ClientOutstandingControl
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	)
	INSERT INTO #ClientOutstandingControl
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate,105))

	-- TRANSACTION RECORD - RESULT SET
	SELECT 
		ISNULL(RecordType,'') + '|' + ISNULL(BranchID,'') + '|' + ISNULL(ClientCode,'') + '|' +  ISNULL(StockCode,'') + '|' +  ISNULL(TransactionDate,'') + '|' +  
		ISNULL(ContractNo,'') + '|' +  ISNULL(TransType,'') + '|' +  CONVERT(CHAR(9),Quantity) + '|' +  CONVERT(CHAR(10),Price)
		 + '|' +  CONVERT(CHAR(13),NetAmount)  + '|' +  ISNULL(DueDate,'') + '|' +  CONVERT(CHAR(9),IntFee) + '|' +  CONVERT(CHAR(9),OrgQty) + '|' +  CONVERT(CHAR(13),OrgTransAmount)
		 + '|' +  CONVERT(CHAR(9),SettledQty) + '|' +  CONVERT(CHAR(13),SettledAmount)
	FROM 
		#ClientOutstanding
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' +  RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + '|' + ProcessDate
	FROM
		#ClientOutstandingControl

	DROP TABLE #ClientOutstanding
	DROP TABLE #ClientOutstandingControl
END