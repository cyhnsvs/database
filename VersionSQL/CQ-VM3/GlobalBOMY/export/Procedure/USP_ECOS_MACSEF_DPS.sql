/****** Object:  Procedure [export].[USP_ECOS_MACSEF_DPS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEF_DPS]
(
	@idteProcessDate AS DATE
)
AS
-- SETTLED CASH DEPOSIT TRANSACTIONS DETAILS(OF ONLINE CLIENTS) TO ECOS
--EXEC [export].[USP_ECOS_MACSEF_DPS] '2021-10-01'
BEGIN
	
	--select * from GlobalBOMY.import.Tb_ECOS_DepositInfo AS DS
	
	--DECLARE @KeyDayOfYear CHAR(3) = RIGHT('000'+CAST((SELECT KeyDayOfYear from GlobalBO.utilities.Tb_CalendarListing AS CL WHERE DateKey = @idteProcessDate) as varchar(20)),3);

	-- TEMP TABLE TO GET CASH DEPOSIT DETAILS
	CREATE TABLE #CashDeposit
	(
		RecordType		CHAR(1),
		DepositRefNo	CHAR(20),
		SeqNo			CHAR(15),
		BranchCode		CHAR(5),
		ClientCode		CHAR(15),
		[Status]		CHAR(1)
	);

	INSERT INTO #CashDeposit
	(
		 RecordType	
		,DepositRefNo		
		,SeqNo		
		,BranchCode	
		,ClientCode  
		,[Status]	
	)
	SELECT 
		1 AS RecordType,
		TS.TransNo AS DepositRefNo,
		DS.RefNo AS SeqNo, --TS.TransNo --SUBSTRING(DS.RefNo, 3, LEN(DS.RefNo))     LEFT(DS.RefNo,2) + @KeyDayOfYear + RIGHT(DS.RefNo,5)
		[CDSACOpenBranch (selectsource-4)] AS BranchCode,
		Account.[AccountNumber (textinput-5)] AS ClientCode,
		'' AS [Status]
	FROM 
		GlobalBO.transmanagement.Tb_Transactions AS TS
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
		ON TS.RecordId = TA.ReferenceID AND TA.AppLevel='3' AND TA.AppStatus='A'
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] =  TS.AcctNo
	INNER JOIN GlobalBOMY.import.Tb_ECOS_DepositInfo AS DS
		ON TS.AcctNo = DS.AccountNo AND TS.ReferenceNo = DS.ChequeNo AND TS.Tag1 = DS.RefNo
	--INNER JOIN GlobalBOLocal.RPS.Tb_ReceiptTransaction
	WHERE TS.TransType = 'CHDP' AND TS.TransDate = @idteProcessDate
	
	UNION

	-- REJECTED TRANSACTIONS
	SELECT
		1 AS RecordType,
		TS.TransNo AS DepositRefNo,
		DS.RefNo AS SeqNo,
		[CDSACOpenBranch (selectsource-4)] AS BranchCode,
		Account.[AccountNumber (textinput-5)] AS ClientCode,
		'F' AS [Status]
	FROM 
		GlobalBO.transmanagement.Tb_Transactions AS TS
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
		ON TS.RecordId = TA.ReferenceID AND TA.AppLevel='3' AND TA.AppStatus='R'
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] =  TS.AcctNo
	INNER JOIN GlobalBOMY.import.Tb_ECOS_DepositInfo AS DS
		ON TS.AcctNo = DS.AccountNo AND TS.ReferenceNo = DS.RefNo AND TS.Tag1 = DS.ChequeNo
	WHERE TS.TransType = 'CHDP' AND TS.TransDate = @idteProcessDate

	-- CONTROL RECORD 
	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(1) FROM #CashDeposit);
	
	CREATE TABLE #CashDepositControl
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	);

	INSERT INTO #CashDepositControl
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate,105));

	-- TRANSACTION RECORD - RESULT SET
	SELECT 
		RecordType + DepositRefNo + SeqNo + BranchCode + ClientCode + [Status] AS CashDeposit
		FROM #CashDeposit

	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType  + RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + ProcessDate
		FROM #CashDepositControl;

	DROP TABLE #CashDeposit;
	DROP TABLE #CashDepositControl;

END