/****** Object:  Procedure [export].[USP_ECOS_MACSEF_CMS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEF_CMS]
(
	@idteProcessDate DATE
)
AS
-- CASH MOVEMENT DETAILS OF ONLINE CLIENT TO ECOS
-- EXEC [export].[USP_ECOS_MACSEF_CMS] '2020-06-01'
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE,
			@idteNextBusinessDate AS DATE

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate))
	SET @idteNextBusinessDate = (SELECT NextBusinessDate FROM GlobalBO.global.Udf_GetNextBusinessDate(@idteProcessDate))
	-- CASH MOVEMENT
	CREATE TABLE #CashMovement
	(
		RecordType			CHAR(1),
		ClientCode			CHAR(9),
		TransactionDate		CHAR(8),
		TransactionDetails  CHAR(30),
		CashReceipt			DECIMAL(13,2),
		Debit				DECIMAL(13,2),
		Credit				DECIMAL(13,2),
		CashBalance			DECIMAL(13,2)
	)

	INSERT INTO #CashMovement
	(
		 RecordType			
		,ClientCode			
		,TransactionDate		
		,TransactionDetails  
		,CashReceipt			
		,Debit				
		,Credit				
		,CashBalance		
	)
	-- CONTRACTS
	--SELECT 
	--	1,
	--	[AccountNumber (textinput-5)],
	--	REPLACE(CONVERT(VARCHAR,C.ContractDate, 105),'-',''),
	--	CASE WHEN C.NetAmountSetl < 0
	--	     THEN 'DR' + C.ContractNo
	--		 ELSE 'CR' + C.ContractNo 
	--	END,
	--	0,
	--	CASE WHEN NetAmountSetl < 0
	--	     THEN NetAmountSetl
	--		 ELSE 0
	--	END,
	--	CASE WHEN NetAmountSetl > 0
	--	     THEN NetAmountSetl
	--		 ELSE 0
	--	END,
	--	0
	--FROM
	--	GlobalBO.contracts.Tb_Contract C
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1409 Account ON C.AcctNo = Account.[AccountNumber (textinput-5)]
	--WHERE
	--	[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	--UNION
	-- CASH BALANCE CARRY FORWARD 
	--SELECT 
	--	1,
	--	AM.NewAccountNo,
	--	REPLACE(CONVERT(VARCHAR,C.ContractDate, 105),'-',''),
	--	'BF' + CONVERT(VARCHAR,@idteNextBusinessDate, 105) + ' BROUGHT FORWARD',
	--	SUM(Cash.CashBalance + C.NetAmountSetl),
	--	0,
	--	0,
	--	0
	--FROM
	--	GlobalBO.contracts.Tb_Contract C
	--INNER JOIN 
	--	GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash ON Cash.AcctNo = C.AcctNo AND Cash.BusinessDate = @idtePreviousBusinessDate
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1409 Account ON C.AcctNo = Account.[AccountNumber (textinput-5)]
	--WHERE 
	--	[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	--GROUP BY
	--	AM.NewAccountNo,ContractDate,C.TransType
	--UNION
	-- UNSETTLED CONTRACTS
	--SELECT 
	--	1,
	--	C.AcctNo,
	--	REPLACE(CONVERT(VARCHAR,C.ContractDate, 105),'-',''),
	--	CASE WHEN NetAmountSetl < 0
	--	     THEN 'DR' + C.ContractNo
	--		 ELSE 'CR' + C.ContractNo 
	--	END,
	--	0,
	--	CASE WHEN NetAmountSetl < 0
	--	     THEN NetAmountSetl
	--		 ELSE 0
	--	END,
	--	CASE WHEN NetAmountSetl > 0
	--	     THEN NetAmountSetl
	--		 ELSE 0
	--	END,
	--	0
	--FROM
	--	GlobalBO.contracts.Tb_ContractOutStanding C
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1409 Account ON C.AcctNo = Account.[AccountNumber (textinput-5)]
	--WHERE 
	--	[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	--UNION
	-- CASH BALANCE CARRY FORWARD 
	--SELECT 
	--	1,
	--	C.AcctNo,
	--	REPLACE(CONVERT(VARCHAR,C.ContractDate, 105),'-',''),
	--	'CF' + CONVERT(VARCHAR,@idteNextBusinessDate, 105) + ' BROUGHT FORWARD',
	--	SUM(Cash.CashBalance + C.NetAmountSetl),
	--	0,
	--	0,
	--	0
	--FROM
	--	GlobalBO.contracts.Tb_ContractOutStanding C
	--INNER JOIN 
	--	GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash ON Cash.AcctNo = C.AcctNo AND Cash.BusinessDate = @idtePreviousBusinessDate
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1409 Account ON C.AcctNo = Account.[AccountNumber (textinput-5)]
	--WHERE 
	--	[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	--GROUP BY
	--	NewAccountNo,ContractDate,C.TransType

	--UNION

	-- CASH BALANCE BROUGHT FORWARD 
	SELECT 
		1,
		Cash.AcctNo,
		REPLACE(CONVERT(VARCHAR,@idteProcessDate, 105),'-',''),
		'BF' + CONVERT(VARCHAR,@idteProcessDate, 105) + ' BROUGHT FORWARD',
		SUM(Cash.CashBalanceBF),
		0,
		0,
		0
	FROM
		GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash 
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1409 Account ON Cash.AcctNo = Account.[AccountNumber (textinput-5)]
	WHERE 
		[MRIndicator (multipleradiosinline-4)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> '' AND ReportDate = @idteProcessDate
	GROUP BY
		Cash.AcctNo
	UNION
	-- SETTLED CONTRACTS
	SELECT 
		1,
		C.AcctNo,
		REPLACE(CONVERT(VARCHAR,C.ContractDate, 105),'-',''),
		CASE WHEN C.NetAmountSetl < 0
		     THEN 'DR' + C.ContractNo
			 ELSE 'CR' + C.ContractNo 
		END,
		0,
		CASE WHEN NetAmountSetl < 0
		     THEN NetAmountSetl
			 ELSE 0
		END,
		CASE WHEN NetAmountSetl > 0
		     THEN NetAmountSetl
			 ELSE 0
		END,
		0
	FROM
		GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1409 Account ON C.AcctNo = Account.[AccountNumber (textinput-5)]
	WHERE 
		[MRIndicator (multipleradiosinline-4)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	AND
		C.TransType IN ('TRBUY','TRSELL') AND C.LedgerDate = @idteProcessDate
	UNION

	-- SETTLED TRANSACTIONS
	SELECT 
		1,
		C.AcctNo,
		REPLACE(CONVERT(VARCHAR,C.ContractDate, 105),'-',''),
		CASE WHEN C.NetAmountSetl < 0
		     THEN 'DR' + C.ContractNo
			 ELSE 'CR' + C.ContractNo 
		END,
		0,
		CASE WHEN NetAmountSetl < 0
		     THEN NetAmountSetl
			 ELSE 0
		END,
		CASE WHEN NetAmountSetl > 0
		     THEN NetAmountSetl
			 ELSE 0
		END,
		0
	FROM
		GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1409 Account ON C.AcctNo = Account.[AccountNumber (textinput-5)]
	WHERE 
		[MRIndicator (multipleradiosinline-4)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	AND
		C.TransType NOT IN ('TRBUY','TRSELL') AND C.LedgerDate = @idteProcessDate

	-- CASH BALANCE CARRY FORWARD
	UNION
	SELECT 
		1,
		Cash.AcctNo,
		REPLACE(CONVERT(VARCHAR,@idteProcessDate, 105),'-',''),
		'CF' + CONVERT(VARCHAR,@idteProcessDate, 105) + ' CARRY FORWARD',
		0,
		0,
		0,
		SUM(CashBalanceBF) + SUM(T.NetAmountSetl)
	FROM
		GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash 
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1409 Account ON Cash.AcctNo = Account.[AccountNumber (textinput-5)]
	LEFT JOIN	
		GlobalBO.transmanagement.Tb_TransactionsSettled T ON Cash.AcctNo = T.AcctNo AND T.LedgerDate = @idteProcessDate
	WHERE 
		[MRIndicator (multipleradiosinline-4)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	GROUP BY 
		Cash.AcctNo

	-- TRANSACTIONS
	--SELECT 
	--	1,
	--	NewAccountNo,
	--	REPLACE(CONVERT(VARCHAR,C.TransDate, 105),'-',''),
	--	CASE WHEN Amount < 0
	--	     THEN 'DR' + C.TransNo
	--		 ELSE 'CR' + C.TransNo 
	--	END,
	--	0,
	--	CASE WHEN Amount < 0
	--	     THEN Amount
	--		 ELSE 0
	--	END,
	--	CASE WHEN Amount > 0
	--	     THEN Amount
	--		 ELSE 0
	--	END,
	--	0
	--FROM
	--	GlobalBO.transmanagement.Tb_Transactions C
	--INNER JOIN 
	--	GlobalBOMY.import.Tb_AccountNoMapping AM ON C.AcctNo = AM.OldAccountNo
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1409 Account ON AM.NewAccountNo = Account.[AccountNumber (textinput-5)]
	--WHERE 
	--	[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	--UNION
	---- CASH BALANCE CARRY FORWARD 
	--SELECT 
	--	1,
	--	NewAccountNo,
	--	REPLACE(CONVERT(VARCHAR,C.TransDate, 105),'-',''),
	--	'BF' + CONVERT(VARCHAR,@idteNextBusinessDate, 105) + ' BROUGHT FORWARD',
	--	SUM(Cash.CashBalance + C.Amount),
	--	0,
	--	0,
	--	0
	--FROM
	--	GlobalBO.transmanagement.Tb_Transactions C
	--INNER JOIN 
	--	GlobalBOMY.import.Tb_AccountNoMapping AM ON C.AcctNo = AM.OldAccountNo
	--INNER JOIN 
	--	GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash ON Cash.AcctNo = C.AcctNo AND Cash.BusinessDate = @idtePreviousBusinessDate
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1409 Account ON AM.NewAccountNo = Account.[AccountNumber (textinput-5)]
	--WHERE 
	--	[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	--GROUP BY
	--	NewAccountNo,TransDate,C.TransType

	-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #CashMovement)
	
	CREATE TABLE #CashMovementControl
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	)
	INSERT INTO #CashMovementControl
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate,105))

	-- TRANSACTION RECORD - RESULT SET
	SELECT 
		RecordType + '|' + ClientCode + '|' +  TransactionDate + '|' +  TransactionDetails + '|' +  CAST(CashReceipt AS CHAR(13)) + '|' +  CAST(Debit AS CHAR(13)) + '|' +  
		CAST(Credit AS CHAR(13)) + '|' +  CAST(CashBalance AS CHAR(13)) AS CashDeposit
	FROM 
		#CashMovement	
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' +  RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + '|' +  ProcessDate
	FROM
		#CashMovementControl
		
	DROP TABLE #CashMovement
	DROP TABLE #CashMovementControl

END