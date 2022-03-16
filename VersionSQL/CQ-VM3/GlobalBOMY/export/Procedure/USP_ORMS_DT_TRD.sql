/****** Object:  Procedure [export].[USP_ORMS_DT_TRD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_DT_TRD]
(
	@idteProcessDate DATE
)
AS
--EXEC [export].[USP_ORMS_DT_TRD] '2020-07-30'
BEGIN

	--declare @idteProcessDate date = '2021-07-30'
	
	SELECT *
	INTO #DTAccounts
	FROM GlobalBO.setup.Tb_Account
	WHERE ServiceType IN ('CD1','CD2','CD3','CE1','CE2','CE3');

	CREATE TABLE #TradeMovement
	(
		RecordType VARCHAR(1),
		TradingAccountNumber Varchar(10),
		TrxRef Varchar(13),
		TrxRefSX Varchar(3),
		TrxRefVS Varchar(3),
		ATrxRef Varchar(13),
		ATrxRefSX Varchar(3),
		ATrxRefVS Varchar(3),
		CurAppDt DATE,
		TransDate DATE,
		StockCode Varchar(10),
		StockShortName Varchar(20),
		ClosingPrice DECIMAL(10,6),
		Quantity DECIMAL(9,0),
		Price DECIMAL(10,6),
		NetAmount DECIMAL(15,2),
		CancelIndicator Varchar(1),
		Interest DECIMAL(15,2),
		ChargeCode varchar(3)
	);

	-- TRANSACTIONSSETTLED
	INSERT INTO #TradeMovement
	(
		RecordType,
		TradingAccountNumber,
		TrxRef,
		TrxRefVS,
		TrxRefSX,
		ATrxRef,
		ATrxRefVS,
		ATrxRefSX,
		CurAppDt,
		TransDate,
		StockCode,
		StockShortName,
		ClosingPrice ,
		Quantity ,
		Price ,
		NetAmount ,
		CancelIndicator ,
		Interest ,
		ChargeCode
	)
	SELECT 
		1,
		TTS.AcctNo,
		ContractNo,
		CAST(ContractPartNo as varchar(50))+'/'+ContractAmendNo,
		'',
		'',
		'',
		'',
		@idteProcessDate,
		TradeDate,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		ShortName,
		ClosingPrice,
		TradedQty,
		TradedPrice,
		NetAmountSetl,
		'N' AS CancelIndicator, --(CASE WHEN TTS.ContractAmendNo=0 THEN 'N' WHEN TTS.ContractAmendNo!=0 THEN 'Y' END) AS CancelIndicator,	
		AccruedInterestAmountSetl,
		''
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled TTS
	INNER JOIN GlobalBO.setup.Tb_Instrument TI 
		ON TTS.InstrumentId = TI.InstrumentId
	INNER JOIN GlobalBO.setup.Tb_ClosingPrice TC 
		ON TTS.InstrumentId = TC.InstrumentId
	WHERE TI.InstrumentCd LIKE '%.XKLS%' AND LedgerDate=@idteProcessDate

   UNION

   -- CONTRACT OUTSTANDING

   SELECT
		1,
		TCS.AcctNo,
		ContractNo,
		CAST(ContractPartNo as varchar(50))+'/'+ContractAmendNo,
		'',
		'',
		'',
		'',
		@idteProcessDate,
		ContractDate,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		ShortName,
		ClosingPrice,
		TradedQty,
		TradedPrice,
		NetAmountSetl,
		'N' AS CancelIndicator, --(CASE WHEN TCS.ContractAmendNo=0 THEN 'N' WHEN TCS.ContractAmendNo!=0 THEN 'Y' END) AS CancelIndicator,	
		AccruedInterestAmountSetl,
		''
    FROM GlobalBO.contracts.Tb_ContractOutstanding TCS
	INNER JOIN GlobalBO.setup.Tb_Instrument TI 
		ON TCS.InstrumentId = TI.InstrumentId
	INNER JOIN GlobalBO.setup.Tb_ClosingPrice TC 
		ON TCS.InstrumentId = TC.InstrumentId
	WHERE TI.InstrumentCd LIKE '%.XKLS%' AND TradeDate=@idteProcessDate

-- CONTROL RECORD 

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #TradeMovement);

	Declare @TotalNetAmount DECIMAL(15,2);
	set @TotalNetAmount = (SELECT SUM(NetAmount) FROM #TradeMovement);

	CREATE TABLE #TradeMovementControl
	(
		RecordType  CHAR(1),
		CurrentApplicateDate DATE,
		TotalRecord int,
		TotalNetAmount DECIMAL(15,2)
	);

	INSERT INTO #TradeMovementControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord,
		TotalNetAmount
	)
	VALUES (0, @idteProcessDate, @Count, CASE WHEN @TotalNetAmount IS NULL THEN 0 ELSE @TotalNetAmount END)

	SELECT 
		RecordType + '|' + TradingAccountNumber + '|' +  TrxRef + '|' + CASE WHEN TrxRefVS=0 THEN '' ELSE CAST(TrxRefVS AS VARCHAR) END + '|' +  TrxRefSX + '|'  +  
		ATrxRef + '|' + CASE WHEN ATrxRefVS=0 THEN '' ELSE CAST(ATrxRefVS AS VARCHAR) END + '|' + ATrxRefSX + '|' + CONVERT(varchar,CurAppDt,120) + '|' + CONVERT(varchar,TransDate,120) + '|' + StockCode + '|' + StockShortName + '|' +
		CAST(ClosingPrice AS VARCHAR) + '|' + CAST(Quantity AS VARCHAR) + '|' + CAST(Price AS VARCHAR) + '|' + CAST(NetAmount AS VARCHAR) + '|' + CancelIndicator + '|' + CAST(Interest AS VARCHAR) + '|' + ChargeCode
	FROM #TradeMovement
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' + CONVERT(varchar,CurrentApplicateDate,120) +  '|' +  CAST(TotalRecord AS VARCHAR) + '|' + CAST(TotalNetAmount AS VARCHAR)
	FROM #TradeMovementControl;

  DROP TABLE #DTAccounts;
  DROP TABLE #TradeMovement;
  DROP TABLE #TradeMovementControl; 
	
END