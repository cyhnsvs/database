/****** Object:  Procedure [report].[Usp_GetData_DailySummaryTrading]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_GetData_DailySummaryTrading]
	@TradeDateFrom date,
	@TradeDateTo date,
	@BranchCode varchar(128) = NULL,
	@AcctNo varchar(128) = NULL,
	@Channel varchar(128) = NULL,
	@InstrumentCode varchar(128) = NULL,
	@CustGroup varchar(128) = NULL,
	@TradeType VARCHAR(100) = 'ALL'
AS
/*********************************************************************************** 

Name              : [report].[Usp_GetData_DailySummaryTrading]
Created By        : Porawat(Art)
Created Date      : 29/03/2018	
Last Updated Date : 
Description       : Get data for ""

Table(s) Used     : 

Modification History :
	ModifiedBy :	Project UIN:	ModifiedDate :	Reason :
	Porawat(Art)	29/03/2018						Created
	Porawat(Art)	17/06/2018						Change map to AcctDetail, report.Tb_ContractOutstanding
	Anita			GBOTH 5.0						Added Trade Type
    
PARAMETERS *************** REVIEW LATER ****************

Used By : Report Investigation for Daily Trading
EXEC [report].[Usp_GetData_DailySummaryTrading] '2020-05-28', '2020-05-28', NULL, 'ALL', 'ALL', NULL, NULL, 'SELL,BUY,SBL SHORT SELL,SBL BUY COVER'
EXEC [report].[Usp_GetData_DailySummaryTrading] '2020-03-20',NULL, NULL, NULL, NULL, NULL, '19', NULL, NULL, NULL, 'SELL,BUY,SBL SHORT SELL,SBL BUY COVER'
************************************************************************************/
BEGIN

	DECLARE 
	@v_TradeDateFrom date,
	@v_TradeDateTo date,
	@v_BranchCode varchar(128) = NULL,
	@v_AcctNo varchar(128) = NULL,
	@v_Channel varchar(128) = NULL,
	@v_InstrumentCode varchar(128) = NULL,
	@v_CustGroup varchar(128) = NULL,
	@v_TradeType varchar(100) = NULL;

	IF @BranchCode = 'NULL'
		SET @v_BranchCode = NULL;
	ELSE
		SET @v_BranchCode = @BranchCode;

	IF @AcctNo = 'NULL'
		SET @v_AcctNo = NULL;
	ELSE
		SET @v_AcctNo = @AcctNo;

	IF @Channel = 'NULL'
		SET @v_Channel = NULL;
	ELSE
		SET @v_Channel = @Channel;

	IF @InstrumentCode = 'NULL'
		SET @v_InstrumentCode = NULL;
	ELSE
		SET @v_InstrumentCode = @InstrumentCode;

	IF @CustGroup = 'NULL'
		SET @v_CustGroup = NULL;
	ELSE
		SET @v_CustGroup = @CustGroup;

	
	SET @v_TradeType	  = @TradeType;
	
	SET @v_TradeType = CASE WHEN @v_TradeType = 'SELL, BUY, SBL SHORT SELL, SBL BUY COVER' THEN 'ALL' ELSE @v_TradeType END;
	

	declare @BrokerName VARCHAR(128);
	declare @SBLFundSource VARCHAR(10) = (SELECT FundSourceId FROM GlobalBO.setup.Tb_FundSource WHERE FundSourceCd = 'SBLT');

	-- BrokerName
	SELECT @BrokerName = (SELECT TOP 1 CompanyName FROM GlobalBO.global.Tb_CompanyMaster WHERE CompanyId = 1);

	SELECT
		AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
		ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo,SubContractNo,RowNum
	INTO #tmpContractOutstanding
	FROM
	(
		select AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName,TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
		ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo,SubContractNo, 
		ROW_NUMBER() over (partition by ContractNo, ContractPartNo,ContractAmendNo order by Reportdate desc , ContractAmendNo desc) AS RowNum
		from  GlobalBORpt.contracts.Tb_ContractOutstandingRpt
		WHERE CPartyInd != 'Y' and ContractStatus='O' AND TradeDate BETWEEN @TradeDateFrom AND @TradeDateTo
		AND (ISNULL(@v_AcctNo, '') = '' OR AcctNo = @v_AcctNo)
		and (ISNULL(@v_Channel,'') = '' OR Channel = @v_Channel)
		and (ISNULL(@v_InstrumentCode,'') = '' OR InstrumentCd = @v_InstrumentCode)
	) as Z
	WHERE Z.RowNum = 1;

	select
		AcctNo,TradeDate, Channel, InstrumentCd,InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
		ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo
	INTO #Contracts
	from(
		select 
			AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo,
			ROW_NUMBER() over (partition by ContractNo, ContractPartNo,ContractAmendNo order by ContractAmendNo desc) AS RowNum
		from ( 
			select
				AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
				ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo
			from #tmpContractOutstanding as c

			union all

			select
				AcctNo,TradeDate, Channel, I.InstrumentCd, InstrumentName, TransType, FundSourceId, c.Tag1, ContractNo, TradedQty, TradedPrice,c.TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
				ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo
			from  GlobalBORpt.transmanagement.Tb_TransactionsSettled as c
			inner join GlobalBO.setup.Tb_Instrument I ON C.InstrumentId = I.InstrumentId 
			WHERE TransType IN ('TRBUY','TRSELL') AND CPartyInd != 'Y' and ContractStatus='O' AND TradeDate BETWEEN @TradeDateFrom AND @TradeDateTo
			AND (ISNULL(@v_AcctNo, '') = '' OR AcctNo = @v_AcctNo)
			and (ISNULL(@v_Channel,'') = '' OR Channel = @v_Channel)
			and (ISNULL(@v_InstrumentCode,'') = '' OR I.InstrumentCd = @v_InstrumentCode)
		)con
	)t
	where t.RowNum = 1;
	
	--select count(1) from #Contracts;

	--Get Branch as of report date
	--SELECT AD.*, M.[TeamID (textinput-3)] AS MktTeamID, M.[MarketingID (textinput-0)] AS MktID, M.[MarketingThaiName (textinput-2)] AS MktName, M.[SectionCode (textinput-10)] as SectionCode
	--INTO #AcctDetail
	--FROM (
	--	SELECT ad.*, CASE WHEN ad.IsJuristic = 'N' THEN ISNULL(HI.SelectBranch,ad.BranchCode) 
	--					  ELSE ISNULL(HC.SelectBranch,ad.BranchCode) END AS SelectBranch,
	--		   CASE WHEN ad.IsJuristic = 'N' THEN ISNULL(MI.MarketingFullID,ad.AEFullCode) 
	--				ELSE ISNULL(MC.MarketingFullID,ad.AEFullCode) END AS MarketingFullID
	--	FROM GlobalBOTH.report.AcctDetail (nolock) ad
	--	LEFT JOIN
	--		(SELECT FH.Key1Value AS CustCode, FH.Value AS SelectBranch
	--			FROM form.Tb_FormDataHistory AS FH
	--			INNER JOIN (SELECT Key1Value, MAX(EffectiveDate) AS MaxEffDate 
	--						FROM form.Tb_FormDataHistory AS A
	--						INNER JOIN #Contracts AS B
	--						ON A.Key1Value = LEFT(B.AcctNo,5)
	--						WHERE FormId=199 AND FieldName='[SelectBranch (selectsource-3)]' AND EffectiveDate <= B.TradeDate
	--						--WHERE FormId=199 AND FieldName='[SelectBranch (selectsource-3)]' AND EffectiveDate <= @v_TradeDate
	--						GROUP BY Key1Value) AS M
	--			ON FH.Key1Value = M.Key1Value AND FH.EffectiveDate = M.MaxEffDate
	--			WHERE FormId=199 AND FieldName='[SelectBranch (selectsource-3)]'
	--			) AS HI
	--	ON ad.CustNo = HI.CustCode
	--	LEFT JOIN 
	--		(SELECT FH.Key1Value AS CustCode, FH.Value AS SelectBranch
	--			FROM form.Tb_FormDataHistory AS FH
	--			INNER JOIN (SELECT Key1Value, MAX(EffectiveDate) AS MaxEffDate 
	--						FROM form.Tb_FormDataHistory AS A
	--						INNER JOIN #Contracts AS B
	--						ON A.Key1Value = LEFT(B.AcctNo,5)
	--						WHERE FormId=385 AND FieldName='[SelectBranch (selectsource-0)]' AND EffectiveDate <= B.TradeDate
	--						--WHERE FormId=199 AND FieldName='[SelectBranch (selectsource-3)]' AND EffectiveDate <= @v_TradeDate
	--						GROUP BY Key1Value) AS M
	--			ON FH.Key1Value = M.Key1Value AND FH.EffectiveDate = M.MaxEffDate
	--			WHERE FormId=385 AND FieldName='[SelectBranch (selectsource-0)]'
	--			) AS HC
	--	ON ad.CustNo = HC.CustCode
	--	LEFT JOIN (
	--				SELECT FH.Key1Value AS CustCode, FH.Value AS MarketingFullID
	--				FROM form.Tb_FormDataHistory AS FH
	--				INNER JOIN (
	--					SELECT Key1Value, MAX(EffectiveDate) AS MaxEffDate 
	--					FROM form.Tb_FormDataHistory AS F
	--					INNER JOIN #Contracts AS B
	--						ON F.Key1Value = LEFT(B.AcctNo,5)
	--					WHERE FormId=199 AND FieldName='[MarketingFullID (textinput-137)]' AND CAST(EffectiveDate as date) <= B.TradeDate
	--					AND F.BusinessDate <= B.TradeDate
	--					--WHERE FormId=199 AND FieldName='[MarketingFullID (textinput-137)]' AND CAST(EffectiveDate as date) <= @v_TradeDate
	--					--AND F.BusinessDate <= @v_TradeDate
	--					GROUP BY Key1Value) AS M
	--				ON FH.Key1Value = M.Key1Value AND FH.EffectiveDate = M.MaxEffDate
	--				WHERE FormId=199 AND FieldName='[MarketingFullID (textinput-137)]'
	--			) AS MI
	--	ON ad.CustNo = MI.CustCode
	--	LEFT JOIN (
	--				SELECT FH.Key1Value AS CustCode, FH.Value AS MarketingFullID
	--				FROM form.Tb_FormDataHistory AS FH
	--				INNER JOIN (
	--					SELECT Key1Value, MAX(EffectiveDate) AS MaxEffDate 
	--					FROM form.Tb_FormDataHistory AS F
	--					INNER JOIN #Contracts AS B
	--						ON F.Key1Value = LEFT(B.AcctNo,5)
	--					WHERE FormId=385 AND FieldName='[MarketingFullID (textinput-50)]' AND CAST(EffectiveDate as date) <= B.TradeDate
	--					AND F.BusinessDate <= B.TradeDate
	--					--WHERE FormId=385 AND FieldName='[MarketingFullID (textinput-50)]' AND CAST(EffectiveDate as date) <= @v_TradeDate
	--					--AND F.BusinessDate <= @v_TradeDate
	--					GROUP BY Key1Value) AS M
	--				ON FH.Key1Value = M.Key1Value AND FH.EffectiveDate = M.MaxEffDate
	--				WHERE FormId=385 AND FieldName='[MarketingFullID (textinput-50)]'
	--			) AS MC
	--	ON ad.CustNo = MC.CustCode
	--	--where ad.AcctNo = isnull(@v_AcctNo,ad.AcctNo)
	--	where (ISNULL(@v_AcctNoFrom,ad.AcctNo) = ad.AcctNo OR ad.AcctNo BETWEEN @v_AcctNoFrom AND @v_AcctNoTo)
	--) AS AD
	--LEFT JOIN form.Tb_ExportFormData_674 AS M
	--ON AD.MarketingFullID = M.[SBAUserID (textinput-5)] AND [IsActive (textinput-17)] = 'Y';

	SELECT 
		Cust.ReportDate, acct.[AccountNumber (textinput-5)] as AcctNo, 
		Cust.[CustomerName (textinput-3)] as CustName, 
		cust.[ClientType (selectbasic-26)] as CustType,
		Branch.[BranchCode (textinput-42)] as BranchCode,
		Acct.[AccountGroup (selectsource-2)] as CustGroup
	INTO #AcctDetail
	FROM GlobalBORpt.form.Tb_FormData_1410 as Cust
	INNER JOIN GlobalBORpt.form.Tb_FormData_1409 AS Acct
	ON Cust.[CustomerID (textinput-1)] = Acct.[CustomerID (selectsource-1)]
	AND Cust.ReportDate = Acct.ReportDate
	INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as Dealer
	ON Dealer.[DealerCode (textinput-35)] = Acct.[DealerCode (selectsource-21)]
	AND Dealer.ReportDate = Acct.ReportDate
	INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as Branch
	ON Branch.[BranchID (textinput-1)] = Dealer.[BranchID (selectsource-1)]
	AND Branch.ReportDate = Dealer.ReportDate
	WHERE Cust.ReportDate BETWEEN @TradeDateFrom and @TradeDateTo
	
	select
		ContractNo,
		AcctNo,
		[Name] as AcctName,
		InstrumentCd,
		InstrumentName,
		TradeDate,
		@BrokerName as BrokerName,
		TradedPrice,
		TradedQty,
		GrossAmountTrade as GrossAmount,
		ClientBrokerageTrade as Brokerage,
		CAST(0 as decimal(24,2)) as cstamp,
		CAST(0 as decimal(24,2)) as cfees,
		NetAmountTrade as NetAmount,
		TradedCurrCd,
		CASE WHEN TransType = 'TRSELL' AND FundSourceId = @SBLFundSource THEN 'Y'
			 WHEN TransType = 'TRBUY' AND FundSourceId = @SBLFundSource THEN 'N' 
		ELSE '-' END AS CR,
		CustType,
		BranchCode,
		CustGroup,
		ContractPartNo,
		ContractAmendNo
	INTO #raw
	FROM (
		SELECT 
			con.AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo,
			ad.CustName as [Name], ad.CustType, ad.BranchCode, ad.CustGroup
		FROM #Contracts as con 
		LEFT JOIN #AcctDetail ad
		ON ad.AcctNo = con.AcctNo AND ad.ReportDate = con.TradeDate
		where con.TradeDate BETWEEN @TradeDateFrom AND @TradeDateTo
		AND (ISNULL(@v_AcctNo, '') = '' OR con.AcctNo = @v_AcctNo)
		and (ISNULL(@v_Channel,'') = '' OR Channel = @v_Channel)
		and (ISNULL(@v_InstrumentCode,'') = '' OR InstrumentCd = @v_InstrumentCode)
		AND (@v_TradeType = 'ALL' OR (EXISTS (SELECT 1 FROM STRING_SPLIT(@v_TradeType, ',') WHERE value = 'SELL') AND TransType = 'TRSELL' AND FundSourceId <> @SBLFundSource))

		UNION ALL 

		SELECT
			con.AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo,
			ad.CustName as [Name], ad.CustType, ad.BranchCode, ad.CustGroup
		FROM #Contracts as con 
		LEFT JOIN #AcctDetail ad
		ON ad.AcctNo = con.AcctNo
		where con.TradeDate BETWEEN @TradeDateFrom AND @TradeDateTo
		AND (ISNULL(@v_AcctNo, '') = '' OR con.AcctNo = @v_AcctNo)
		and (ISNULL(@v_Channel,'') = '' OR con.Channel = @v_Channel)
		and (ISNULL(@v_InstrumentCode,'') = '' OR con.InstrumentCd = @v_InstrumentCode)
		AND (@v_TradeType = 'ALL' OR (EXISTS (SELECT 1 FROM STRING_SPLIT(@v_TradeType, ',') WHERE value = 'BUY') AND TransType = 'TRBUY' AND FundSourceId <> @SBLFundSource))

		UNION ALL 

		SELECT
			con.AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo,
			ad.CustName as [Name], ad.CustType, ad.BranchCode, ad.CustGroup
		FROM #Contracts as con 
		LEFT JOIN #AcctDetail ad
		ON ad.AcctNo = con.AcctNo
		where con.TradeDate BETWEEN @TradeDateFrom AND @TradeDateTo
		AND (ISNULL(@v_AcctNo, '') = '' OR con.AcctNo = @v_AcctNo)
		and (ISNULL(@v_Channel,'') = '' OR con.Channel = @v_Channel)
		and (ISNULL(@v_InstrumentCode,'') = '' OR con.InstrumentCd = @v_InstrumentCode)
		AND (@v_TradeType = 'ALL' OR (EXISTS (SELECT 1 FROM STRING_SPLIT(@v_TradeType, ',') WHERE value = 'SBL SHORT SELL') AND TransType = 'TRSELL' AND FundSourceId = @SBLFundSource))

		UNION ALL 

		SELECT
			con.AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo,
			ad.CustName as [Name], ad.CustType, ad.BranchCode, ad.CustGroup
		FROM #Contracts as con 
		LEFT JOIN #AcctDetail ad
		ON ad.AcctNo = con.AcctNo
		where con.TradeDate BETWEEN @TradeDateFrom AND @TradeDateTo
		AND (ISNULL(@v_AcctNo, '') = '' OR con.AcctNo = @v_AcctNo)
		and (ISNULL(@v_Channel,'') = '' OR con.Channel = @v_Channel)
		and (ISNULL(@v_InstrumentCode,'') = '' OR con.InstrumentCd = @v_InstrumentCode)
		AND (@v_TradeType = 'ALL' OR (EXISTS (SELECT 1 FROM STRING_SPLIT(@v_TradeType, ',') WHERE value = 'SBL BUY COVER') AND TransType = 'TRBUY' AND FundSourceId = @SBLFundSource))
	) AS C
	ORDER BY AcctNo, ContractNo, SubContractNo;

	UPDATE a
	SET a.cstamp = cf.FeeAmountSetl
	FROM #raw as a
	INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails as cf
	ON cf.ContractNo = a.ContractNo AND cf.ContractPartNo = a.ContractPartNo AND cf.ContractAmendNo = a.ContractAmendNo
	INNER JOIN GlobalBO.setup.Tb_TransactionFee as tf
	ON tf.FeeId = cf.FeeId AND tf.FeeDesc = 'Contract Stamp Fee'

	UPDATE a
	SET a.cfees = cf.FeeAmountSetl
	FROM #raw as a
	INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails as cf
	ON cf.ContractNo = a.ContractNo AND cf.ContractPartNo = a.ContractPartNo AND cf.ContractAmendNo = a.ContractAmendNo
	INNER JOIN GlobalBO.setup.Tb_TransactionFee as tf
	ON tf.FeeId = cf.FeeId AND tf.FeeDesc = 'Clearing Fee'

	SELECT
	*
	FROM #raw
	WHERE (ISNULL(@v_BranchCode,'') = '' OR BranchCode = @v_BranchCode)
	AND (ISNULL(@v_CustGroup,'') = '' OR CustGroup = @v_CustGroup)
	ORDER BY TradeDate;

	DROP TABLE #raw;
	DROP TABLE #Contracts;

END