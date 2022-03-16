/****** Object:  Procedure [export].[USP_ORMS_DT_OS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_DT_OS]
(
	@idteProcessDate DATE
)
AS
--EXEC [export].[USP_ORMS_DT_OS] '2020-07-30'
BEGIN

	SET NOCOUNT ON;
	
	--declare @idteProcessDate date = '2021-07-30'

	SELECT *
	INTO #DTAccounts
	FROM GlobalBO.setup.Tb_Account
	WHERE ServiceType IN ('CD1','CD2','CD3','CE1','CE2','CE3');

	CREATE TABLE #Outstanding
	(
		RecordType           varchar(1),
		TradingAccountNumber varchar(10),
		TrxRef				 varchar(13),
		TrxRefVS			 varchar(3),
		TrxRefSX			 varchar(3),
		TransDate			 date,
		DateDuePayment       date,
		Quantity             Decimal(9,0),
		Price                Decimal(10,6),
		NetAmount			 Decimal(15,2),
		Interest              Decimal(15,2),
		ChargeCode			 varchar(10)
	)

	--CONTRACTOUTSTANDING
	INSERT INTO #Outstanding (
		RecordType,
		TradingAccountNumber,
		TrxRef,
		TrxRefVS,
		TrxRefSX,
		TransDate,
		DateDuePayment,
		Quantity,
		Price,
		NetAmount,
		Interest,
		ChargeCode			 
	)
	SELECT 
		1,
		CO.AcctNo,
		CO.ContractNo,
		'',
		'',
		CONVERT(varchar,CO.ContractDate,120),
		CONVERT(varchar,CO.SetlDate,120),
		CO.TradedQty - ISNULL(TP.FreeQty,0) AS TradedQty,
		CO.TradedPrice,
		CO.NetAmountSetl - ISNULL(TP.PaymentMade,0) AS NetAmount,
		CO.AccruedInterestAmountSetl - ISNULL(TP.AccruedInterestAmountSetl,0) AS AccruedInterestAmountSetl,
		0
	FROM #DTAccounts AS DT
	INNER JOIN GlobalBO.contracts.Tb_ContractOutstanding CO
		ON DT.AcctNo = CO.AcctNo
	LEFT JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid AS TP
		ON CO.ContractNo = TP.ContractNo AND CO.ContractPartNo = TP.ContractPartNo AND CO.ContractAmendNo = TP.ContractAmendNo
	
	UNION

	SELECT 
		1,
		CO.AcctNo,
		CO.ContractNo,
		'',
		'',
		CONVERT(varchar,CO.ContractDate,120),
		CONVERT(varchar,CO.SetlDate,120),
		CO.TradedQty - ISNULL(TP.FreeQty,0) AS TradedQty,
		CO.TradedPrice,
		CO.NetAmountSetl - ISNULL(TP.PaymentMade,0) AS NetAmount,
		CO.AccruedInterestAmountSetl - ISNULL(TP.AccruedInterestAmountSetl,0) AS AccruedInterestAmountSetl,
		0
	FROM #DTAccounts AS DT
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionsSettled CO
		ON DT.AcctNo = CO.AcctNo
	LEFT JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid AS TP
		ON CO.ContractNo = TP.ContractNo AND CO.ContractPartNo = TP.ContractPartNo AND CO.ContractAmendNo = TP.ContractAmendNo
	WHERE CO.SetlDate >= @idteProcessDate AND CO.TransType IN ('TRBUY','TRSELL')

	--UNION
	
	----TRANSACTIONS
	--SELECT 
	--	1,
	--	TT.AcctNo,
	--	TransNo,
	--	0,
	--	'',
	--	CONVERT(varchar,TransDate,120),
	--	CONVERT(varchar,SetlDate,120),
	--	TradedQty,
	--	TradedPrice,
	--	Amount,
	--	0,
	--	0

	--FROM #DTAccounts AS DT
	--INNER JOIN GlobalBO.transmanagement.Tb_Transactions TT
	--ON DT.AcctNo = TT.AcctNo
	
	-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(1) FROM #Outstanding)

	DECLARE @TOTALNETAMOUNT DECIMAL(15,2)
	SET @TOTALNETAMOUNT  = (SELECT SUM(NetAmount) FROM #Outstanding)

	CREATE TABLE #OutstandingControl
	(
		RecordType  CHAR(1),
		CurrentApplicateDate DATE,
		TotalRecord INT,
		TotalNetAmount DECIMAL(15,2)
	)
	INSERT INTO #OutstandingControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord,
		TotalNetAmount
	)
	VALUES (0,@idteProcessDate,@Count,@TOTALNETAMOUNT);

	-- TRANSACTION RECORD - RESULT SET


	SELECT 
		RecordType + '|' + TradingAccountNumber + '|' +  TrxRef + '|' + CASE WHEN TrxRefVS=0 THEN '' ELSE CAST(TrxRefVS AS VARCHAR) END + '|' +  TrxRefSX + '|'  +  
		CONVERT(varchar,TransDate,120) + '|' +  CONVERT(varchar,DateDuePayment,120) + '|' + CAST(Quantity AS VARCHAR) + '|' + CAST(Price AS VARCHAR) + 
		'|' + CAST(NetAmount AS VARCHAR) + '|' + CAST(Interest AS VARCHAR) + '|' + ChargeCode + '|'
	FROM #Outstanding
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' + CONVERT(varchar,CurrentApplicateDate,120) +  '|' + CAST(TotalRecord AS VARCHAR)  + '|' + CAST(TotalNetAmount AS VARCHAR)
	FROM #OutstandingControl

	DROP TABLE #Outstanding
	DROP TABLE #OutstandingControl

END