/****** Object:  Procedure [export].[USP_ECOS_MACSEF_CWD_20211015]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEF_CWD_20211015]
(
	@idteProcessDate AS DATE
)
AS
-- SETTLED CASH WITHDRAW TRANSACTIONS
--EXEC [export].[USP_ECOS_MACSEF_CWD] '2021-04-12'
BEGIN
	-- TEMP TABLE TO GET CASH WITHDRAW DETAILS
	CREATE TABLE #CashWithdraw
	(
		RecordType	CHAR(1),
		RefNo		CHAR(20),
		BranchCode	CHAR(5),
		ClientCode  CHAR(15),
		[Status]	CHAR(1),
		ReceiptNo	CHAR(30),
		Remarks		CHAR(120)
	)

	INSERT INTO #CashWithdraw
	(
		 RecordType	
		,RefNo		
		,BranchCode	
		,ClientCode  
		,[Status]	
		,ReceiptNo
		,Remarks
	)
	SELECT
		1										AS RecordType,
		ContractNo								AS RefNo,
		[CDSACOpenBranch (selectsource-4)]		AS BranchCode,
		Account.[AccountNumber (textinput-5)]	AS ClientCode,
		'U'										AS [Status],
		CAST(TS.ContractNo AS VARCHAR)		AS ReceiptNo,
		Account.[Remarks (textinput-72)]        AS Remarks
	FROM 
		GlobalBO.transmanagement.Tb_TransactionsSettled AS TS
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  TS.AcctNo
	WHERE
		TS.TransType = 'CHWD' AND TS.ContractDate = @idteProcessDate
	AND
		--[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND 
		ISNULL([CDSNo (textinput-19)],'') <> ''

	UNION 
	-- UNSETTLED TRANSACTIONS
	SELECT
		1										AS RecordType,
		TransNo									AS RefNo,
		[CDSACOpenBranch (selectsource-4)]		AS BranchCode,
		Account.[AccountNumber (textinput-5)]	AS ClientCode,
		'U'										AS [Status],
		T.TransNo							    AS ReceiptNo,
		Account.[Remarks (textinput-72)]        AS Remarks
	FROM 
		GlobalBO.transmanagement.Tb_Transactions AS T
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  T.AcctNo
	WHERE
		T.TransType = 'CHWD' AND T.TransDate = @idteProcessDate
	AND
		--[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND 
		ISNULL([CDSNo (textinput-19)],'') <> ''

	UNION
	-- REJECTED TRANSACTIONS
	SELECT
		1										AS RecordType,
		TransNo									AS RefNo,
		[CDSACOpenBranch (selectsource-4)]		AS BranchCode,
		Account.[AccountNumber (textinput-5)]	AS ClientCode,
		'R'										AS [Status],
		TR.TransNo								AS ReceiptNo,
		Account.[Remarks (textinput-72)]        AS Remarks
	FROM 
		[GlobalBO].[transmanagement].[Tb_TransactionsRejected] AS TR
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  TR.AcctNo
	WHERE
		TR.TransType = 'CHWD' AND TR.TransDate = @idteProcessDate
	AND
		--[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND 
		ISNULL([CDSNo (textinput-19)],'') <> ''

	-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #CashWithdraw)
	
	CREATE TABLE #CashDepositControl
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	)
	INSERT INTO #CashDepositControl
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate,105))

	-- TRANSACTION RECORD - RESULT SET
	SELECT 
		RecordType + RefNo + BranchCode + ClientCode + [Status] + ReceiptNo + Remarks  AS CashDeposit
	FROM 
		#CashWithdraw
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType  + RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + ProcessDate
	FROM
		#CashDepositControl

END