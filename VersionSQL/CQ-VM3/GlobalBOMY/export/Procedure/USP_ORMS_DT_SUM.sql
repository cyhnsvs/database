/****** Object:  Procedure [export].[USP_ORMS_DT_SUM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_DT_SUM]
(
	@idteProcessDate DATE
)
AS
--EXEC [export].[USP_ORMS_DT_SUM] '2021-07-30'
BEGIN

	--declare @idteProcessDate date = '2021-07-30'

	SELECT *
	INTO #DTAccounts
	FROM GlobalBO.setup.Tb_Account
	WHERE ServiceType IN ('CD1','CD2','CD3','CE1','CE2','CE3');

	SELECT 
		AcctNo, 
		DC, 
		SUM(NetAmountSetl) AS NetAmountSetl 
	INTO #OSTransactions
	FROM (
		SELECT 
			CO.AcctNo, 
			CASE 
				WHEN (CO.NetAmountSetl - ISNULL(TP.PaymentMade,0)) < 0 
				THEN 'D' 
				ELSE 'C' 
			END AS DC, 
			SUM(CO.NetAmountSetl - ISNULL(TP.PaymentMade,0)) AS NetAmountSetl
		FROM GlobalBO.Contracts.Tb_ContractOutstanding AS CO
		INNER JOIN #DTAccounts AS DT
			ON CO.AcctNo = DT.AcctNo
		LEFT JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid AS TP
			ON CO.ContractNo = TP.ContractNo AND CO.ContractPartNo = TP.ContractPartNo AND CO.ContractAmendNo = TP.ContractAmendNo
		GROUP BY CO.AcctNo, CASE WHEN (CO.NetAmountSetl - ISNULL(TP.PaymentMade,0)) < 0 THEN 'D' ELSE 'C' END
		UNION
		SELECT 
			CO.AcctNo, 
			CASE 
				WHEN (CO.NetAmountSetl - ISNULL(TP.PaymentMade,0)) < 0 
				THEN 'D' 
				ELSE 'C' 
			END AS DC, 
			SUM(CO.NetAmountSetl - ISNULL(TP.PaymentMade,0)) AS NetAmountSetl
		FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid AS CO
		INNER JOIN #DTAccounts AS DT
			ON CO.AcctNo = DT.AcctNo
		LEFT JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid AS TP
			ON CO.ContractNo = TP.ContractNo AND CO.ContractPartNo = TP.ContractPartNo AND CO.ContractAmendNo = TP.ContractAmendNo
		GROUP BY CO.AcctNo, CASE WHEN (CO.NetAmountSetl - ISNULL(TP.PaymentMade,0)) < 0 THEN 'D' ELSE 'C' END
		UNION
		SELECT 
			CO.AcctNo, 
			CASE 
				WHEN (CO.Amount - ISNULL(TP.PaymentMade,0)) < 0 
				THEN 'D' 
				ELSE 'C' 
			END AS DC, 
			SUM(CO.Amount - ISNULL(TP.PaymentMade,0)) AS NetAmountSetl
		FROM GlobalBO.transmanagement.Tb_Transactions AS CO
		INNER JOIN #DTAccounts AS DT
			ON CO.AcctNo = DT.AcctNo
		LEFT JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid AS TP
			ON CO.TransNo = TP.ContractNo
		GROUP BY CO.AcctNo, CASE WHEN (CO.Amount - ISNULL(TP.PaymentMade,0)) < 0 THEN 'D' ELSE 'C' END
	) AS C
	GROUP BY AcctNo, DC;

	CREATE TABLE #AccountSummary
	(
		RecordType	varchar(1),
		DealerCode	Varchar(10),
		TradingAccountNumber Varchar(10),
		AccountName Varchar(60),
		Address1 Varchar(60),
		Address2 Varchar(60),
		Address3 Varchar(60),
		Address4 Varchar(60),
		Address5 Varchar(60),
		EmailAddress Varchar(50),
		TradeStyle varchar(1),
		Trust Decimal(15,2),
		OSCR Decimal(15,2),
		OSDR Decimal(15,2),
		CurAppDt Date,
		NomineeName varchar(60),
		DateAcouuntOpened Date,
		AccountGroupCode varchar(10)
	);

	INSERT INTO #AccountSummary
	(
		RecordType,
		DealerCode,
		TradingAccountNumber,
		AccountName,
		Address1,
		Address2,
		Address3,
		Address4,
		Address5,
		EmailAddress,
		TradeStyle,
		Trust,
		OSCR,
		OSDR,
		CurAppDt,
		NomineeName,
		DateAcouuntOpened,
		AccountGroupCode 	
	)
	SELECT 
		1,
		TF1409.[DealerCode (selectsource-21)],
		TF1409.[AccountNumber (textinput-5)],
		TF1410.[CustomerName (textinput-3)],
		TF1410.[Address1 (textinput-35)],
		TF1410.[Address2 (textinput-36)],
		TF1410.[Address3 (textinput-37)],
		TF1410.[State (textinput-39)],
		TF1410.[Country (selectsource-24)],
		TF1410.[Email (textinput-58)],
		case 
			when TF1409.[AccountGroup (selectsource-2)] ='CD1'
			then 'A'
			when TF1409.[AccountGroup (selectsource-2)] ='CD2'
			then 'M'
			when TF1409.[AccountGroup (selectsource-2)] ='CD3'
			then 'C'
		ELSE ''
		End,
		ISNULL(TC.Balance,0),
		ISNULL(OSC.NetAmountSetl,0) AS Credit,
		ISNULL(OSD.NetAmountSetl,0) AS Debit,
		@idteProcessDate,
		TF1409.[NomineesName1 (selectsource-20)],
		TF1409.[DateofTradingAccountOpened (dateinput-20)],
		TF1409.[AccountGroup (selectsource-2)]

	FROM #DTAccounts AS DT
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 TF1409
		ON DT.AcctNo = TF1409.[AccountNumber (textinput-5)]
	INNER JOIN CQbTempDB.export.Tb_FormData_1410 TF1410 
		ON TF1410.[CustomerID (textinput-1)] = TF1409.[CustomerID (selectsource-1)]
	LEFT JOIN GlobalBO.holdings.Tb_Cash TC 
		ON TC.AcctNo = TF1409.[AccountNumber (textinput-5)]
	LEFT JOIN #OSTransactions OSC 
		ON OSC.AcctNo = TF1409.[AccountNumber (textinput-5)] AND OSC.DC = 'C'
	LEFT JOIN #OSTransactions OSD 
		ON OSD.AcctNo = TF1409.[AccountNumber (textinput-5)] AND OSD.DC = 'D';

	-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #AccountSummary);

	DECLARE @TotalNetAmount DECIMAL(15,2)
	SET @TotalNetAmount = (SELECT SUM(Trust) FROM #AccountSummary);

	CREATE TABLE #AccountSummaryControl
	(
		RecordType  varchar(10),
		CurrentApplicateDate Date,
		TotalRecord int,
		TotalTrust Decimal(15,2)
	);

	INSERT INTO #AccountSummaryControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord,
		TotalTrust
	)
	VALUES (0,@idteProcessDate,@Count,@TotalNetAmount);

	-- TRANSACTION RECORD - RESULT SET	

	SELECT 
		RecordType + '|' + DealerCode + '|' +  TradingAccountNumber + '|' +  AccountName + '|' +  Address1 + '|'  + 
		Address2 + '|' +  Address3 + '|' + Address4 + '|' + Address5 + '|' + EmailAddress + '|' + TradeStyle + '|' + 
		CAST(Trust as VARCHAR) + '|' + CAST(OSCR AS VARCHAR) +'|'+CAST(OSDR AS VARCHAR) +'|'+ CONVERT(varchar,CurAppDt,120) +'|'+ NomineeName +'|'+ 
		CONVERT(varchar,DateAcouuntOpened,120) +'|'+ AccountGroupCode
	FROM  #AccountSummary

	UNION ALL

	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' + CONVERT(varchar,CurrentApplicateDate,120)  +  '|' + CONVERT(varchar,TotalRecord) + '|' +CAST(TotalTrust AS VARCHAR) 
	FROM #AccountSummaryControl

	DROP TABLE #DTAccounts;
	DROP TABLE #OSTransactions;
	DROP TABLE #AccountSummary;
	DROP TABLE #AccountSummaryControl;

END