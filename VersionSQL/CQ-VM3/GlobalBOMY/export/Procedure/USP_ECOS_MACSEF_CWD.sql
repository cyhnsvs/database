/****** Object:  Procedure [export].[USP_ECOS_MACSEF_CWD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEF_CWD]
(
	@idteProcessDate AS DATE
)
AS
-- SETTLED CASH WITHDRAW TRANSACTIONS
--EXEC [export].[USP_ECOS_MACSEF_CWD] '2021-10-01'
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
	);

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
		1 AS RecordType,
		WS.RequestNo AS RefNo,
		[CDSACOpenBranch (selectsource-4)] AS BranchCode,
		Account.[AccountNumber (textinput-5)] AS ClientCode,
		'P' AS [Status],
		TS.TransNo AS ReceiptNo,
		'' AS Remarks
	FROM 
		GlobalBO.transmanagement.Tb_Transactions AS TS
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
		ON TS.RecordId = TA.ReferenceID AND TA.AppLevel='3' AND TA.AppStatus='A'
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] =  TS.AcctNo
	INNER JOIN GlobalBOMY.import.Tb_ECOS_WithdrawalInfo AS WS
		ON TS.AcctNo = WS.ClientCode AND TS.ReferenceNo = WS.RequestNo AND TS.Tag1 = WS.RequestNo
	WHERE TS.TransType = 'CHWD' AND TS.TransDate = @idteProcessDate
	
	UNION

	-- REJECTED TRANSACTIONS
	SELECT
		1 AS RecordType,
		WS.RequestNo AS RefNo,
		[CDSACOpenBranch (selectsource-4)] AS BranchCode,
		Account.[AccountNumber (textinput-5)] AS ClientCode,
		'R' AS [Status],
		TS.TransNo AS ReceiptNo,
		ISNULL(NULLIF(WS.Remarks,''),'User Rejected manually') AS Remarks
	FROM 
		GlobalBO.transmanagement.Tb_Transactions AS TS
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
		ON TS.RecordId = TA.ReferenceID AND TA.AppLevel='3' AND TA.AppStatus='R'
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] =  TS.AcctNo
	INNER JOIN GlobalBOMY.import.Tb_ECOS_WithdrawalInfo AS WS
		ON TS.AcctNo = WS.ClientCode AND TS.ReferenceNo = WS.RequestNo AND TS.Tag1 = WS.RequestNo
	WHERE TS.TransType = 'CHWD' AND TS.TransDate = @idteProcessDate

	UNION
	
	-- REJECTED TRANSACTIONS
	SELECT
		1 AS RecordType,
		WS.RequestNo AS RefNo,
		ISNULL([CDSACOpenBranch (selectsource-4)],'') AS BranchCode,
		ISNULL(Account.[AccountNumber (textinput-5)],'') AS ClientCode,
		'R' AS [Status],
		'' AS ReceiptNo,
		WS.Remarks AS Remarks
	FROM 
		GlobalBOMY.import.Tb_ECOS_WithdrawalInfo AS WS
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] =  WS.ClientCode
	WHERE WS.Status = 'R' AND CONVERT(DATE,LEFT(WS.RequestDate,10),105) = @idteProcessDate

	-- CONTROL RECORD 
	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(1) FROM #CashWithdraw);
	
	CREATE TABLE #CashWithdrawControl
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	);

	INSERT INTO #CashWithdrawControl
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate,105));

	-- TRANSACTION RECORD - RESULT SET
	SELECT 
		RecordType + RefNo + BranchCode + ClientCode + [Status] + ReceiptNo + Remarks  AS CashDeposit
	FROM #CashWithdraw
		UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType  + RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + ProcessDate
	FROM #CashWithdrawControl;

	DROP TABLE #CashWithdraw
	DROP TABLE #CashWithdrawControl

END