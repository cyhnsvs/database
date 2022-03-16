/****** Object:  Procedure [report].[Usp_RptCustodyAssestBalance]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_RptCustodyAssestBalance] (
	@istrAccNo VARCHAR(20)=NULL,
	@istrInstrumetCd varchar(50)=NULL,
	@idteReportDate DATE,
	@iIntFundSource varchar(50)='ALL',
	@istrCustTypeFront varchar(50)='ALL',
	@istrCustomerType varchar(100) = NULL,
	@istrTypeofInvestor varchar(100) = NULL
	)
AS
--EXEC [report].[Usp_RptCustodyAssestBalance] '', '4715.XKLS', '2020-06-01', 'ALL', 'ALL'
--EXEC [report].[Usp_RptCustodyAssestBalance] '35882-1', 'BTS', '2019-10-08', 'ALL', 'ALL'
--EXEC [report].[Usp_RptCustodyAssestBalance] '10383-1', NULL, '2020-05-25', 'ALL', 'ALL', NULL, NULL
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @dteBusinessDate DATE, @dtePrevBusinessDate DATE;
	SET @dteBusinessDate = (SELECT DateValue FROM GlobalBO.setup.Tb_Date WHERE CompanyId = 1)
	SELECT @dtePrevBusinessDate = PreviousBusinessDate FROM GlobalBO.[global].[Udf_GetPreviousBusinessDate](@dteBusinessDate);
	--SELECT @dtePrevBusinessDate = '2020-03-18';
	
	SET @istrAccNo =NULLIF(@istrAccNo ,'');
	set @istrInstrumetCd=NULLIF(@istrInstrumetCd ,'');

	IF(@istrCustomerType = '0')
		SET @istrCustomerType = NULL
	IF(@istrTypeofInvestor = '0')
		SET @istrTypeofInvestor = NULL

	CREATE TABLE #res
	(
		BusinessDate date,
		AcctNo varchar(7),
		InstrumentId bigint,
		ChequeName varchar(200),
		FundSourceDesc varchar(50),
		FundSourceId bigint,
		InstrCode varchar(50),
		InstrName varchar(200),
		SettledBalance decimal(24,9),
		UnavailableBalance decimal(24,9),
		TotTradedQty decimal(24,9),
		RPBalance decimal(24,9),
		TotTradedQty1 decimal(24,9),
		TotTradedQty2 decimal(24,9),
		FinalBalance decimal(24,9),
		T date,
		ClosingPrice decimal(24,9),
		T1 date,
		Cost decimal(24,9),
		MarketValue decimal(24,9),
		T2 date,
		CostAmount decimal(24,9),
		CertNo varchar(100),
		CertName varchar(250),
		CertQty decimal(24,9),
		CertCount bigint
	)

	CREATE TABLE #certs
	(
		BusinessDate date,
		AcctNo varchar(7),
		InstrumentId bigint,
		FundSourceId bigint,
		TotalofCertQty decimal(24,9)
	)

	--SELECT CustomerNo, CustomerType, TypeofInvestor
	--INTO #tmpAcct
	--FROM
	--(
	--	SELECT 
	--		[Customerno (textinput-47)] as CustomerNo,
	--		[CustomerType (multipleradios-7)] as CustomerType,
	--		[TypeofInvestor (multipleradios-8)] as TypeofInvestor 
	--	FROM form.Tb_ExportFormData_199

	--	UNION

	--	SELECT
	--		[Customerno (textinput-40)] as CustomerNo,
	--		[CustomerType (multipleradios-0)] as CustomerType,
	--		[TypeofInvestor (multipleradios-2)] as TypeofInvestor 
	--	FROM form.Tb_ExportFormData_385
	--) AS Z

	IF(@idteReportDate < @dtePrevBusinessDate)
	BEGIN

		INSERT INTO #res (
			BusinessDate, AcctNo, InstrumentId, ChequeName, FundSourceDesc, FundSourceId, InstrCode, InstrName, SettledBalance, UnavailableBalance, TotTradedQty, RPBalance,
			TotTradedQty1, TotTradedQty2, FinalBalance, T, ClosingPrice, T1, Cost, MarketValue, T2, CostAmount, CertNo, CertName, CertQty, CertCount
		)
		SELECT 
			C.BusinessDate, C.AcctNo, C.InstrumentId, C.ChequeName, C.FundSourceDesc, C.FundSourceId, C.InstrCode, C.InstrName, C.SettledBalance, C.UnavailableBalance, C.TotTradedQty, C.RPBalance,
			C.TotTradedQty1, C.TotTradedQty2, C.FinalBalance, C.T, C.ClosingPrice, C.T1, C.Cost, C.MarketValue, C.T2, C.CostAmount,'','',0, 
			ROW_NUMBER() OVER(Partition by C.AcctNo, C.InstrumentId, C.FundSourceId ORDER BY C.InstrCode,C.AcctNo) AS CertCount
		FROM report.Tb_CustodyAssetsBalance_Archive AS C
		--LEFT JOIN form.Tb_ExportFormData_106 AS CI
		--ON LEFT(C.AcctNo,5) = CI.[Customerno (textinput-119)]
		--LEFT JOIN dbo.Tb_CustodyAssets_Certificates_Archive as certs
		--ON certs.AcctNo = C.AcctNo AND certs.BusinessDate = C.BusinessDate AND certs.InstrumentId = C.InstrumentId and certs.FundSourceId = C.FundSourceId
		--INNER JOIN #tmpAcct as acct
		--ON acct.CustomerNo = LEFT(C.AcctNo,5)
		WHERE C.BusinessDate = @idteReportDate
		AND C.AcctNo=ISNULL(@istrAccNo,C.AcctNo) and InstrCode=ISNULL(@istrInstrumetCd,InstrCode)
		AND (@iIntFundSource='ALL' OR C.FundSourceId IN (SELECT value FROM STRING_SPLIT(@iIntFundSource, ',')))
		--AND (CI.[Customerno (textinput-119)] IS NULL OR @istrCustTypeFront = 'ALL' OR [CustomerTypeCodeforFront (selectsource-2)] IN (SELECT value FROM string_split(@istrCustTypeFront,',')))
		--AND acct.CustomerType = ISNULL(@istrCustomerType, acct.CustomerType)
		--AND acct.TypeofInvestor = ISNULL(@istrTypeofInvestor, acct.TypeofInvestor)
		order by InstrCode,AcctNo;
		

		INSERT INTO #certs (
			BusinessDate, AcctNo, InstrumentId, FundSourceId, TotalofCertQty 
		)
		SELECT BusinessDate, AcctNo, InstrumentId, FundSourceId, SUM(CertQty) as TotalofCertQty 
		FROM #res 
		WHERE CertNo IS NOT NULL
		group by BusinessDate, AcctNo, InstrumentId, FundSourceId

		UPDATE A
			SET A.CertNo = NULL, A.CertName = NULL, A.CertQty = NULL
		FROM #res as A
		INNER JOIN #certs as B
		ON A.BusinessDate = B.BusinessDate AND A.AcctNo = B.AcctNo AND A.InstrumentId = B.InstrumentId AND A.FundSourceId = B.FundSourceId
		WHERE A.FinalBalance <> B.TotalofCertQty 
		AND A.CertCount = 1;

		DELETE A
		FROM #res as A
		INNER JOIN #certs as B
		ON A.BusinessDate = B.BusinessDate AND A.AcctNo = B.AcctNo AND A.InstrumentId = B.InstrumentId AND A.FundSourceId = B.FundSourceId
		WHERE A.FinalBalance <> B.TotalofCertQty 
		AND A.CertCount <> 1;

		SELECT
			BusinessDate, AcctNo, InstrumentId, ChequeName, FundSourceDesc, FundSourceId, InstrCode, InstrName, 
			CASE WHEN CertCount = 1 THEN SettledBalance ELSE NULL END AS SettledBalance, 
			CASE WHEN CertCount = 1 THEN UnavailableBalance ELSE NULL END AS UnavailableBalance, 
			CASE WHEN CertCount = 1 THEN TotTradedQty ELSE NULL END AS TotTradedQty, 
			CASE WHEN CertCount = 1 THEN RPBalance ELSE NULL END AS RPBalance,
			CASE WHEN CertCount = 1 THEN TotTradedQty1 ELSE NULL END AS TotTradedQty1, 
			CASE WHEN CertCount = 1 THEN TotTradedQty2 ELSE NULL END AS TotTradedQty2, 
			CASE WHEN CertCount = 1 THEN FinalBalance ELSE NULL END AS FinalBalance, T, 
			CASE WHEN CertCount = 1 THEN ClosingPrice ELSE NULL END AS ClosingPrice, T1, 
			CASE WHEN CertCount = 1 THEN Cost ELSE NULL END AS Cost, 
			CASE WHEN CertCount = 1 THEN MarketValue ELSE NULL END AS MarketValue, T2, 
			CASE WHEN CertCount = 1 THEN CostAmount ELSE NULL END AS CostAmount, 
			CertNo, CertName, CertQty, CertCount
		FROM #res
		ORDER BY AcctNo, InstrCode, FundSourceDesc;
	END
	ELSE IF(@idteReportDate = @dtePrevBusinessDate)
	BEGIN

		INSERT INTO #res (
			BusinessDate, AcctNo, InstrumentId, ChequeName, FundSourceDesc, FundSourceId, InstrCode, InstrName, SettledBalance, UnavailableBalance, TotTradedQty, RPBalance,
			TotTradedQty1, TotTradedQty2, FinalBalance, T, ClosingPrice, T1, Cost, MarketValue, T2, CostAmount, CertNo, CertName, CertQty, CertCount
		)
		SELECT
			C.BusinessDate, C.AcctNo, C.InstrumentId, C.ChequeName, C.FundSourceDesc, C.FundSourceId, C.InstrCode, C.InstrName, C.SettledBalance, C.UnavailableBalance, C.TotTradedQty, C.RPBalance,
			C.TotTradedQty1, C.TotTradedQty2, C.FinalBalance, C.T, C.ClosingPrice, C.T1, C.Cost, C.MarketValue, C.T2, C.CostAmount,'','',0, 
			ROW_NUMBER() OVER(Partition by C.AcctNo, C.InstrumentId, C.FundSourceId ORDER BY C.InstrCode,C.AcctNo) AS CertCount
		FROM report.Tb_CustodyAssetsBalance AS C
		--LEFT JOIN form.Tb_ExportFormData_106 AS CI
		--ON LEFT(C.AcctNo,5) = CI.[Customerno (textinput-119)]
		--LEFT JOIN dbo.Tb_CustodyAssets_Certificates as certs
		--ON certs.AcctNo = C.AcctNo AND certs.BusinessDate = C.BusinessDate AND certs.InstrumentId = C.InstrumentId and certs.FundSourceId = C.FundSourceId
		--INNER JOIN #tmpAcct as acct
		--ON acct.CustomerNo = LEFT(C.AcctNo,5)
		WHERE C.BusinessDate = @idteReportDate
		AND C.AcctNo=ISNULL(@istrAccNo,C.AcctNo) and InstrCode=ISNULL(@istrInstrumetCd,InstrCode)
		AND (@iIntFundSource='ALL' OR C.FundSourceId IN (SELECT value FROM STRING_SPLIT(@iIntFundSource, ',')))
		--AND (CI.[Customerno (textinput-119)] IS NULL OR @istrCustTypeFront = 'ALL' OR [CustomerTypeCodeforFront (selectsource-2)] IN (SELECT value FROM string_split(@istrCustTypeFront,',')))
		--AND acct.CustomerType = ISNULL(@istrCustomerType, acct.CustomerType)
		--AND acct.TypeofInvestor = ISNULL(@istrTypeofInvestor, acct.TypeofInvestor)
		order by InstrCode,AcctNo;

		INSERT INTO #certs (
			BusinessDate, AcctNo, InstrumentId, FundSourceId, TotalofCertQty 
		)
		SELECT BusinessDate, AcctNo, InstrumentId, FundSourceId, SUM(CertQty) as TotalofCertQty 
		FROM #res 
		WHERE CertNo IS NOT NULL
		group by BusinessDate, AcctNo, InstrumentId, FundSourceId

		UPDATE A
			SET A.CertNo = NULL, A.CertName = NULL, A.CertQty = NULL
		FROM #res as A
		INNER JOIN #certs as B
		ON A.BusinessDate = B.BusinessDate AND A.AcctNo = B.AcctNo AND A.InstrumentId = B.InstrumentId AND A.FundSourceId = B.FundSourceId
		WHERE A.FinalBalance <> B.TotalofCertQty 
		AND A.CertCount = 1;

		DELETE A
		FROM #res as A
		INNER JOIN #certs as B
		ON A.BusinessDate = B.BusinessDate AND A.AcctNo = B.AcctNo AND A.InstrumentId = B.InstrumentId AND A.FundSourceId = B.FundSourceId
		WHERE A.FinalBalance <> B.TotalofCertQty 
		AND A.CertCount <> 1;

		SELECT
			BusinessDate, AcctNo, InstrumentId, ChequeName, FundSourceDesc, FundSourceId, InstrCode, InstrName, 
			CASE WHEN CertCount = 1 THEN SettledBalance ELSE NULL END AS SettledBalance, 
			CASE WHEN CertCount = 1 THEN UnavailableBalance ELSE NULL END AS UnavailableBalance, 
			CASE WHEN CertCount = 1 THEN TotTradedQty ELSE NULL END AS TotTradedQty, 
			CASE WHEN CertCount = 1 THEN RPBalance ELSE NULL END AS RPBalance,
			CASE WHEN CertCount = 1 THEN TotTradedQty1 ELSE NULL END AS TotTradedQty1, 
			CASE WHEN CertCount = 1 THEN TotTradedQty2 ELSE NULL END AS TotTradedQty2, 
			CASE WHEN CertCount = 1 THEN FinalBalance ELSE NULL END AS FinalBalance, T, 
			CASE WHEN CertCount = 1 THEN ClosingPrice ELSE NULL END AS ClosingPrice, T1, 
			CASE WHEN CertCount = 1 THEN Cost ELSE NULL END AS Cost, 
			CASE WHEN CertCount = 1 THEN MarketValue ELSE NULL END AS MarketValue, T2, 
			CASE WHEN CertCount = 1 THEN CostAmount ELSE NULL END AS CostAmount, 
			CertNo, CertName, CertQty, CertCount
		FROM #res
		ORDER BY AcctNo, InstrCode, FundSourceDesc;
	END
	ELSE
	BEGIN
		--@iIntFundSource =NULLIF(@istrAccNo ,'')

		CREATE TABLE #TEMP (
			[CompanyId] [bigint] NOT NULL,
			[ProductId] [bigint] NULL,
			[InstrumentId] [bigint] NULL,
			[FundSourceId] [bigint] NULL,
			[AcctNo] [varchar](20) NOT NULL,
			[CustodianAcctNo] [varchar](20) NULL,
			[SetlDate] date NULL,
			[TotTradedqty] [decimal](38, 9) NULL,
			--[TotTradedqty2] [decimal](38, 9) NULL,
			--[TotTradedqty3] [decimal](38, 9) NULL
		) 

		insert INTO #TEMP (CompanyId,ProductId,InstrumentId,FundSourceId,AcctNo,CustodianAcctNo,SetlDate,TotTradedqty)
		select * FROM (
		select CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo, SetlDate, SUM(Tradedqty) TotTradedqty 
		from GlobalBO.contracts.Tb_ContractOutstanding 
		where AcctNo<>CustodianAcctNo and ContractStatus='O' 
		group by CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo, SetlDate
		) A
		--WHERE AcctNo='70202-7' 

		--select InstrumentId,SetlDate, SUM(TotTradedqty1) from #TEMP 
		-- group by InstrumentId,SetlDate

		DECLARE @T Date,@T1 Date,@T2 Date;

		SELECT 
		@T = CASE WHEN rownumber = 1 THEN SetlDate ELSE null END 
		FROM (
		  SELECT ROW_NUMBER() OVER (ORDER BY SetlDate ASC) AS rownumber, SetlDate
		  FROM (select distinct SetlDate from #TEMP) a
		) AS foo
		WHERE rownumber = 1 
		SELECT 
		@T1 = CASE WHEN rownumber = 2 THEN SetlDate ELSE null END
		FROM (
		  SELECT ROW_NUMBER() OVER (ORDER BY SetlDate ASC) AS rownumber, SetlDate
		  FROM (select distinct SetlDate from #TEMP) a
		) AS foo
		WHERE rownumber = 2
		SELECT 
		@T2 = CASE WHEN rownumber = 3 THEN SetlDate ELSE null END 
		FROM (
		  SELECT ROW_NUMBER() OVER (ORDER BY SetlDate ASC) AS rownumber, SetlDate
		  FROM (select distinct SetlDate from #TEMP) a
		) AS foo
		WHERE rownumber = 3;

		insert INTO #TEMP (CompanyId,ProductId,InstrumentId,FundSourceId,AcctNo,CustodianAcctNo,SetlDate,TotTradedqty)
		select T.CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo, SetlDate, SUM(Tradedqty) TotTradedqty 
		from GlobalBO.transmanagement.Tb_Transactions AS T
		INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
		ON T.RecordId = TA.ReferenceID
		where AcctNo<>CustodianAcctNo AND TA.AppLevel = '3' AND TA.AppStatus <> 'R' --AND T.SetlDate IN (@T,@T1,@T2)
		group by T.CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo, SetlDate

		insert INTO #TEMP (CompanyId,ProductId,InstrumentId,FundSourceId,AcctNo,CustodianAcctNo,SetlDate,TotTradedqty)
		select CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo, DeliveryDate, SUM(Tradedqty) TotTradedqty
		from GlobalBO.transmanagement.Tb_TransactionsSettled
		where AcctNo<>CustodianAcctNo AND TransType IN ('TRBUY','TRSELL') AND AcctNo LIKE '%-6' AND DeliveryDate IN (@T,@T1,@T2)
		group by CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo, DeliveryDate;
		
		--select * from #TEMP 
		--where acctno='04523-1';
		--select @T ,@T1 ,@T2

		--SELECT AcctNo,InstrumentId,FundSourceId, ABS(ROUND(SUM(Amount)/SUM(TradedQty),4)) AS Cost
		--INTO #FIFO
		--FROM FIFOByLot
		--GROUP BY AcctNo,InstrumentId,FundSourceId
		--HAVING SUM(TradedQty) <> 0;

		select SB.*, @T AS T, @T1 AS T1, @T2 AS T2, 0 AS Cost, SB.FinalBalance * 1 AS CostAmount, ISNULL(CP.ClosingPrice,0) AS ClosingPrice, SB.FinalBalance * ISNULL(CP.ClosingPrice,0) AS MarketValue from 
		(
			select  C.AcctNo,I.InstrumentId, Acc.ChequeName,F.FundSourceId, F.FundSourceDesc,I.InstrumentCd InstrCode,I.FullName InstrName, 
					ISNULL(C.Balance,0) as 'SettledBalance', ISNULL(UnavailableBalance,0) UnavailableBalance, --'' RPType, --ISNULL(RP.RPType,'-') RPType, 
					ISNULL(RP.Balance,0) as RP_Balance , ISNULL(TotTradedqty,0) TotTradedqty ,ISNULL(TotTradedqty1,0) TotTradedqty1,
					ISNULL(TotTradedqty2,0) TotTradedqty2, --ISNULL(C.Balance,0) + ISNULL(TotTradedqty,0) + ISNULL(TotTradedqty1,0) + ISNULL(TotTradedqty2,0) FinalBalance --ISNULL(FinalBalance,0) FinalBalance
					ISNULL(C.Balance,0) + ISNULL(C.UnavailableBalance,0) + ISNULL(RP.Balance,0) FinalBalance
			from GlobalBO.holdings.Tb_CustodyAssets C
			LEFT OUTER JOIN (SELECT CompanyId, AcctNo, ProductId, CustodianAcctNo, InstrumentId, FundSourceId, SUM(Balance) as Balance
							 FROM GlobalBO.holdings.Tb_ReceivablePayableCustodian 
							 GROUP BY CompanyId, AcctNo, ProductId, CustodianAcctNo, InstrumentId, FundSourceId
							 HAVING SUM(Balance) <> 0.0) RP 
			ON C.InstrumentId = RP.InstrumentId and C.CompanyId = RP.CompanyId AND C.AcctNo = RP.AcctNo and C.FundSourceId = RP.FundSourceId 
				and C.CustodianAcctNo = RP.CustodianAcctNo and C.ProductId = RP.ProductId
			left join (select CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo,
							  SUM(CASE WHEN SetlDate = @T then TotTradedqty else 0 end) TotTradedqty,
							  SUM(CASE WHEN SetlDate = @T1 then TotTradedqty else 0 end) TotTradedqty1,
							  SUM(CASE WHEN @T2 IS NOT NULL AND SetlDate >= @T2 then TotTradedqty 
									   WHEN @T2 IS NULL AND SetlDate > @T1 then TotTradedqty else 0 end) TotTradedqty2 
					   from #TEMP
					   group by CompanyId, ProductId, InstrumentId,FundSourceId,AcctNo,CustodianAcctNo) A 
			on C.InstrumentId=A.InstrumentId and C.CompanyId=A.CompanyId AND C.AcctNo=A.AcctNo and C.FundSourceId=A.FundSourceId 
				and C.CustodianAcctNo=A.CustodianAcctNo and C.ProductId=A.ProductId
			Inner join GlobalBO.setup.Tb_FundSource F 
			on C.FundSourceId=F.FundSourceId and C.CompanyId=F.CompanyId
			Inner join GlobalBO.setup.Tb_Instrument I 
			on C.InstrumentId=I.InstrumentId and C.CompanyId=I.CompanyId
			Inner join GlobalBO.setup.Tb_Account Acc 
			on C.AcctNo=Acc.AcctNo and C.CompanyId=Acc.CompanyId
			where C.AcctNo=ISNULL(@istrAccNo,C.AcctNo) and I.InstrumentCd=ISNULL(@istrInstrumetCd,I.InstrumentCd) --(ISNULL(C.FinalBalance,0) <> 0) AND 
			AND C.AcctNo <> C.CustodianAcctNo
			AND (ISNULL(C.Balance,0) <> 0 OR ISNULL(RP.Balance,0) <> 0 OR ISNULL(C.UnavailableBalance,0) <> 0)
			and (@iIntFundSource='ALL' OR F.FundSourceId IN (SELECT value FROM STRING_SPLIT(@iIntFundSource, ',')))
			--and (ISNULL(TotTradedqty,0) <> 0 OR ISNULL(TotTradedqty1,0) <> 0  OR ISNULL(TotTradedqty2,0) <> 0)

			UNION ALL

			select  RP.AcctNo,I.InstrumentId, Acc.ChequeName,F.FundSourceId,F.FundSourceDesc,I.InstrumentCd InstrCode,I.FullName InstrName, 
					ISNULL(C.Balance,0) as 'SettledBalance', ISNULL(UnavailableBalance,0) UnavailableBalance, --'' RPType, --ISNULL(RP.RPType,'-') RPType, 
					ISNULL(RP.Balance,0) as RP_Balance , ISNULL(TotTradedqty,0) TotTradedqty ,ISNULL(TotTradedqty1,0) TotTradedqty1,
					ISNULL(TotTradedqty2,0) TotTradedqty2, --ISNULL(C.Balance,0) + ISNULL(TotTradedqty,0) + ISNULL(TotTradedqty1,0) + ISNULL(TotTradedqty2,0) FinalBalance --ISNULL(FinalBalance,0) FinalBalance
					ISNULL(C.Balance,0) + ISNULL(C.UnavailableBalance,0) + ISNULL(RP.Balance,0) FinalBalance
			from (
				SELECT CompanyId, AcctNo, ProductId, CustodianAcctNo, InstrumentId, FundSourceId, SUM(Balance) as Balance
				FROM GlobalBO.holdings.Tb_ReceivablePayableCustodian 
				GROUP BY CompanyId, AcctNo, ProductId, CustodianAcctNo, InstrumentId, FundSourceId) RP
			LEFT JOIN GlobalBO.holdings.tb_custodyassets C
			ON C.InstrumentId = RP.InstrumentId and C.CompanyId = RP.CompanyId AND C.AcctNo = RP.AcctNo and C.FundSourceId = RP.FundSourceId 
				and C.CustodianAcctNo = RP.CustodianAcctNo and C.ProductId = RP.ProductId
			left join (select CompanyId, ProductId, InstrumentId, FundSourceId, AcctNo, CustodianAcctNo,
								SUM(CASE WHEN SetlDate = @T then TotTradedqty else 0 end) TotTradedqty,
								SUM(CASE WHEN SetlDate = @T1 then TotTradedqty else 0 end) TotTradedqty1,
								SUM(CASE WHEN @T2 IS NOT NULL AND SetlDate >= @T2 then TotTradedqty 
									     WHEN @T2 IS NULL AND SetlDate > @T1 then TotTradedqty else 0 end) TotTradedqty2 
						from #TEMP
						group by CompanyId, ProductId, InstrumentId,FundSourceId,AcctNo,CustodianAcctNo) A 
			on RP.InstrumentId=A.InstrumentId and RP.CompanyId=A.CompanyId AND RP.AcctNo=A.AcctNo and RP.FundSourceId=A.FundSourceId 
				and RP.CustodianAcctNo=A.CustodianAcctNo and RP.ProductId=A.ProductId
			Inner join GlobalBO.setup.Tb_FundSource F 
			on RP.FundSourceId=F.FundSourceId and RP.CompanyId=F.CompanyId
			Inner join GlobalBO.setup.Tb_Instrument I 
			on RP.InstrumentId=I.InstrumentId and RP.CompanyId=I.CompanyId
			Inner join GlobalBO.setup.Tb_Account Acc 
			on RP.AcctNo=Acc.AcctNo and RP.CompanyId=Acc.CompanyId
			WHERE RP.AcctNo=ISNULL(@istrAccNo,RP.AcctNo) and I.InstrumentCd=ISNULL(@istrInstrumetCd,I.InstrumentCd) 
			and (@iIntFundSource='ALL' OR F.FundSourceId IN (SELECT value FROM STRING_SPLIT(@iIntFundSource, ','))) AND C.AcctNo IS NULL
			AND RP.AcctNo <> RP.CustodianAcctNo
			and (ISNULL(TotTradedqty,0) <> 0 OR ISNULL(TotTradedqty1,0) <> 0  OR ISNULL(TotTradedqty2,0) <> 0)
			) as SB
		LEFT JOIN GlobalBO.setup.Tb_ClosingPrice AS CP
		ON SB.InstrumentId = CP.InstrumentId AND CP.BusinessDate = @idteReportDate
		--LEFT JOIN #FIFO AS F
		--ON SB.AcctNo = F.AcctNo AND SB.InstrumentId = F.InstrumentId AND SB.FundSourceId = F.FundSourceId
		--LEFT JOIN form.Tb_ExportFormData_106 AS CI
		--ON LEFT(SB.AcctNo,5) = CI.[Customerno (textinput-119)]
		--WHERE (CP.BusinessDate IS NULL OR )
		--WHERE CI.[Customerno (textinput-119)] IS NULL OR @istrCustTypeFront = 'ALL' OR [CustomerTypeCodeforFront (selectsource-2)] IN (SELECT value FROM string_split(@istrCustTypeFront,','))
		order by AcctNo, InstrCode, FundSourceDesc
		--order by C.AcctNo, RP.AcctNo, C.InstrumentId, RP.InstrumentId, C.FundSourceId, RP.FundSourceId;

		--select * from GlobalBO.holdings.tb_custodyassets C where C.AcctNo='22505-1' and InstrumentId=30897
		----select * from GlobalBO.setup.Tb_Instrument I where InstrumentCd='JAS'
		--select * from GlobalBO.holdings.Tb_ReceivablePayableCustodian C where C.AcctNo='22505-1' and InstrumentId=30897

		drop table #TEMP;
	END
	SET NOCOUNT OFF;
END