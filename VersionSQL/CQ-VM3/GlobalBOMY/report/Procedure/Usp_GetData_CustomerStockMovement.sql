/****** Object:  Procedure [report].[Usp_GetData_CustomerStockMovement]    Committed by VersionSQL https://www.versionsql.com ******/

-- data need to separate by branch which pending on 
CREATE PROCEDURE [report].[Usp_GetData_CustomerStockMovement]
	@FromDate date, 
	@ToDate date, 
	@BranchCode varchar(128) = NULL,
	@InstrumentCd varchar(128) = NULL,
	@AcctNo varchar(128) = NULL
AS
/*********************************************************************************** 

Name              : [report].Usp_GetData_CustomerStockMovement
Created By        : Porawat Chimcherdsin (Art)
Created Date      : 11/06/2017
Last Updated Date : 
Description       : Get data for ""

Table(s) Used     : 

Modification History :
	ModifiedBy :	Project UIN:		ModifiedDate :              Reason :
    Porawat(Art)	GBO-CQTH00001 		11/06/2018					Created
    Porawat(Art)						18/06/2018					Add logic to put balance + unavailable balance
PARAMETERS *************** REVIEW LATER ****************

Used By : Report
EXEC [report].[Usp_GetData_CustomerStockMovement] '2020-03-02', '2020-03-02', NULL, NULL, '09271-1'
************************************************************************************/
BEGIN

	-- For test
	--DECLARE @FromDate date = '20190227'
	--DECLARE @ToDate date = '20190227'
	--DECLARE @BranchCode varchar(128) = NULL
	--DECLARE @AcctNo varchar(128) = NULL
	--DECLARE @InstrumentCd varchar(128) = NULL
	DECLARE @dteBusinessDate DATE;

	SELECT @dteBusinessDate=PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@FromDate); 
	 
	-- BrokerName
	DECLARE @BrokerName varchar(128)
	SELECT @BrokerName = (SELECT TOP 1 CompanyName FROM GlobalBO.global.Tb_CompanyMaster WHERE CompanyId = 88)

	IF OBJECT_ID('tempdb.dbo.#stockbf', 'U') IS NOT NULL
	  DROP TABLE #stockbf;
	IF OBJECT_ID('tempdb.dbo.#movement', 'U') IS NOT NULL
	  DROP TABLE #movement;

	-- Retrive StockBalance B/F
	CREATE TABLE #stockbf (
		AcctNo varchar(128),
		FundSourceId varchar(128),
		InstrumentCd varchar(128),
		Balance decimal(24,9)
	);

	INSERT INTO #stockbf
	SELECT
		AcctNo,
		FundSourceId,
		InstrumentCd,
		SUM(Balance)
	FROM (
		SELECT
		ca.AcctNo,
		ca.FundSourceId,
		inst.InstrumentCd,
		ca.CustodyAssetsBalance Balance
		FROM GlobalBORpt.valuation.Tb_CustodyAssetsRPValuationCollateralRpt ca
		INNER JOIN GlobalBO.setup.Tb_Instrument inst
		ON inst.InstrumentId = ca.InstrumentId AND ca.CompanyId = inst.CompanyId
		WHERE ca.ReportDate = @dteBusinessDate
	)t
	where-- t.InstrumentCd=@InstrumentCd and t.AcctNo=@AcctNo
	 (ISNULL(@AcctNo,'') = '' OR t.AcctNo = @AcctNo)
	AND (ISNULL(@InstrumentCd,'') = '' OR t.InstrumentCd = @InstrumentCd)
	GROUP BY AcctNo,FundSourceId,InstrumentCd;
	 
	 --select * from #stockbf
	
	-- Movement
	CREATE TABLE #movement (
		InstrumentCd varchar(128),
		AcctNo varchar(128),
		Name varchar(256),
		FundSourceId varchar(128),
		FundSourceDesc varchar(128),
		BusinessDate date,
		ContractNo varchar(128),
		TransType varchar(128),
		TransTypeDesc varchar(128),
		TradedPrice decimal(24,9),
		BuyQty decimal(24,9),
		SellQty decimal(24,9),
		NetAmount decimal(24,9),
		Remark varchar(512),
		Tag2 varchar(512)
	);

	INSERT INTO #movement
	SELECT DISTINCT 
		inst.InstrumentCd,
		m.AcctNo,
		ad.ChequeName,
		m.FundSourceId,
		fs.FundSourceDesc,
		m.SetlDate,
		m.ContractNo,
		m.TransType,
		tt.TransTypeDesc,
		m.TradedPrice,
		CASE 
			--WHEN m.TransType IN('TRBUY','INTI') THEN ABS(m.TradedQty)
			WHEN m.TradedQty>0 THEN ABS(m.TradedQty)
			ELSE CAST(0.00 as decimal(24,9))
		END as BuyQty,
		CASE 
			--WHEN m.TransType IN('TRSELL','INTO') THEN ABS(m.TradedQty)
			WHEN m.TradedQty<0 THEN ABS(m.TradedQty)
			ELSE CAST(0.00 as decimal(24,9))
		END as SellQty,
		ABS(m.NetAmountTrade) as NetAmount,
		m.Remark,
		m.Tag2 
	FROM (
		select 
			con.TradeDate,
			con.SetlDate,
			con.AcctNo,
			con.FundSourceId,
			con.InstrumentId,
			con.ContractNo,
			con.TransType,
			con.TradedPrice,
			con.TradedQty,
			con.NetAmountTrade,
			'' as Remark,
			Tag2 
		from GlobalBO.contracts.Tb_ContractOutstanding con
		WHERE con.SetlDate BETWEEN @FromDate AND @ToDate --AND con.TransType IN ('TRBUY','TRSELL') 
		and ContractStatus='O' AND CompanyId=88
		UNION ALL
		SELECT
			t.TransDate,
			t.SetlDate,
			t.AcctNo,
			t.FundSourceId,
			t.InstrumentId,
			t.TransNo,
			t.TransType,
			t.TradedPrice,
			t.TradedQty,
			t.Amount,
			'' as Remark,
			Tag2 
		--FROM GBORPT.GlobalBORpt.transmanagement.Tb_TransactionsRpt t
		FROM GlobalBO.transmanagement.Tb_Transactions t
		WHERE t.SetlDate BETWEEN @FromDate AND @ToDate AND CompanyId=88 --AND t.TransType IN ('INTI','INTO')
		UNION ALL
		SELECT
			ts.TradeDate,
			ts.SetlDate,
			ts.AcctNo,
			ts.FundSourceId,
			ts.InstrumentId,
			ts.ContractNo,
			ts.TransType,
			ts.TradedPrice,
			ts.TradedQty,
			ts.NetAmountTrade,
			'' as Remark,
			Tag2 
		FROM GlobalBO.transmanagement.Tb_TransactionsSettled ts
		WHERE ts.SetlDate BETWEEN @FromDate AND @ToDate AND CompanyId=88 --AND ts.TransType IN ('TRBUY','TRSELL','INTI','INTO') --and ContractStatus='O' 
	)m
	INNER JOIN GlobalBO.setup.Tb_Instrument inst
	ON inst.InstrumentId = m.InstrumentId
	INNER JOIN GlobalBO.setup.Tb_Account ad
	ON ad.AcctNo = m.AcctNo AND inst.CompanyId = ad.CompanyId
	INNER JOIN GlobalBO.setup.Tb_FundSource fs
	ON fs.FundSourceId = m.FundSourceId AND inst.CompanyId = fs.CompanyId
	INNER JOIN GlobalBO.setup.Tb_TransactionType tt
	ON tt.TransType = m.TransType --AND inst.CompanyId = tt.CompanyId
	WHERE (ISNULL(@AcctNo,'') = '' OR m.AcctNo = @AcctNo)
	AND (ISNULL(@BranchCode,'') = '' OR ad.BranchId = @BranchCode)
	AND (ISNULL(@InstrumentCd,'') = '' OR inst.InstrumentCd = @InstrumentCd)
	AND inst.CompanyId = 88;

	--select * from #movement
	--where FundSourceId = 25

	-- Show only movement
	SELECT distinct
		@BrokerName as BrokerName,
		m.InstrumentCd,
		m.AcctNo,
		m.Name,
		m.FundSourceId,
		m.FundSourceDesc,
		m.BusinessDate,
		m.ContractNo,
		m.TransType,
		m.TransTypeDesc,
		m.TradedPrice,
		m.BuyQty,
		m.SellQty,
		m.NetAmount,
		ISNULL(s.Balance, CAST(0.00 as decimal(24,9))) as BalanceBF,
		ISNULL(s.Balance, CAST(0.00 as decimal(24,9)))+SUM(m.BuyQty - m.SellQty) OVER (PARTITION BY m.AcctNo, m.InstrumentCd, m.FundSourceId ORDER BY BusinessDate,Tag2 ,ContractNo ROWS UNBOUNDED PRECEDING) AS CumulativeTotal,
		m.Remark,
		Tag2
	FROM #movement m
	LEFT JOIN #stockbf s
	ON s.AcctNo = m.AcctNo
	AND s.FundSourceId = m.FundSourceId
	AND s.InstrumentCd = m.InstrumentCd
	ORDER BY m.InstrumentCd, m.AcctNo, m.FundSourceDesc, m.BusinessDate, Tag2 , m.ContractNo

END