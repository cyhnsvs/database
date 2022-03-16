/****** Object:  Procedure [export].[USP_ECOS_MACSEF_DPS_20211014]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEF_DPS_20211014]
(
	@idteProcessDate AS DATE
)
AS
-- SETTLED CASH DEPOSIT TRANSACTIONS DETAILS(OF ONLINE CLIENTS) TO ECOS
--EXEC [export].[USP_ECOS_MACSEF_DPS] '2019-10-23'
BEGIN
	-- TEMP TABLE TO GET CASH DEPOSIT DETAILS
	CREATE TABLE #CashDeposit
	(
		RecordType	CHAR(1),
		RefNo		CHAR(20),
		SeqNo		VARCHAR(15),
		BranchCode	CHAR(5),
		ClientCode  CHAR(15),
		[Status]	CHAR(1)
	)

	INSERT INTO #CashDeposit
	(
		 RecordType	
		,RefNo		
		,SeqNo		
		,BranchCode	
		,ClientCode  
		,[Status]	
	)
	SELECT
		1										AS RecordType,
		RIGHT(ContractNo,10)					AS RefNo,
		''	AS SeqNo,
		[CDSACOpenBranch (selectsource-4)]		AS BranchCode,
		Account.[AccountNumber (textinput-5)]	AS ClientCode,
		'U'										AS [Status]
	FROM 
		GlobalBO.transmanagement.Tb_TransactionsSettled AS TS
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  TS.AcctNo
	WHERE
		TS.TransType = 'CHDP' AND TS.ContractDate = @idteProcessDate
	AND
		--[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND 
		ISNULL([CDSNo (textinput-19)],'') <> ''

	UNION
	-- REJECTED TRANSACTIONS
	SELECT
		1										AS RecordType,
		RIGHT(TransNo,10)						AS RefNo,
		''	AS SeqNo,
		[CDSACOpenBranch (selectsource-4)]		AS BranchCode,
		Account.[AccountNumber (textinput-5)]	AS ClientCode,
		'R'										AS [Status]
	FROM 
		[GlobalBO].[transmanagement].[Tb_TransactionsRejected] AS TR
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] =  TR.AcctNo
	WHERE
		TR.TransType = 'CHDP' AND TR.TransDate = @idteProcessDate
	AND
		--[OnlineSystemIndicator (multiplecheckboxesinline-1)] LIKE '%M+%' AND 
		ISNULL([CDSNo (textinput-19)],'') <> ''


	-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #CashDeposit)
	
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
		RecordType + RefNo + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS CHAR(15)) + BranchCode + ClientCode + [Status] AS CashDeposit
	FROM 
		#CashDeposit
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType  + RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + ProcessDate
	FROM
		#CashDepositControl

END