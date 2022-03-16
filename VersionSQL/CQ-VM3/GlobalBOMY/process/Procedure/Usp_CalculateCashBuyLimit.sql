/****** Object:  Procedure [process].[Usp_CalculateCashBuyLimit]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_CalculateCashBuyLimit]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_CalculateCashBuyLimit]
Created By        : Nishanth Chowdhary
Created Date      : 06/10/2017
Last Updated Date : 
Description       : this sp is used to import the accounts from ClientData on a daily basis
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_CalculateCashBuyLimit] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY

	begin tran
    	
		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate') --'2018-04-02';
		--DECLARE @dteBusinessDateMinus1 DATE = report.Udf_PrevWorkingDate(@dteBusinessDate);
		DECLARE @dteBusinessDateMinus1 DATE = (SELECT * FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@dteBusinessDate))
		--DECLARE @dteBusinessDateMinus2 DATE = (SELECT * FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@dteBusinessDateMinus1))
		--SELECT @dteBusinessDateMinus1;

		--DECLARE @decBLRate decimal(24,9) = (SELECT Rate FROM [GlobalBO].[setup].[Tb_Tier] 
		--									WHERE TierGroupId = (SELECT TierGroupId FROM [GlobalBO].[setup].[Tb_TierGroup]
		--														 WHERE TierCategory='Margin' AND Remarks='CashAcct-BuyLimit-20%'));

		DECLARE @decCashUpfrontLimitPercentage decimal(24,9) = GlobalBO.setup.Udf_FetchGlobalValue (1, 'CashUpfrontLimitPercentage');
		DECLARE @decCashUpfrontMinAmount decimal(24,9) = GlobalBO.setup.Udf_FetchGlobalValue (1, 'CashUpfrontMinAmount');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		); 
		
		--DROP TABLE #CashCollateral;
		CREATE TABLE #CashCollateral
		(
			BusinessDate date,
			AcctNo VARCHAR(30),
			AcctServiceType VARCHAR(20),
			ParentGroup VARCHAR(30),
			CashMultiplier decimal(24,9) DEFAULT (1),
			CollMultiplier decimal(24,9) DEFAULT (1),
			--CollateralType int DEFAULT (0),
			ApprovedLimit decimal(24,9) DEFAULT (0),
			AvailableCleanLimit decimal(24,9) DEFAULT (0),
			CashBalance decimal(24,9) DEFAULT (0),
			PendingCashBalance decimal(24,9) DEFAULT (0),
			TotalCashBalance decimal(24,9) DEFAULT (0),
			DrPurchase decimal(24,9) DEFAULT (0),
			DrContraLoss decimal(24,9) DEFAULT (0),
			DrSetoffLoss decimal(24,9) DEFAULT (0),
			DrInterest decimal(24,9) DEFAULT (0),
			DrNonTrade decimal(24,9) DEFAULT (0),
			DrOverduePurchase decimal(24,9) DEFAULT (0),
			DrUnrealizedLoss decimal(24,9) DEFAULT (0),
			TotalDebit decimal(24,9) DEFAULT (0),
			CrSales decimal(24,9) DEFAULT (0),
			CrSalesT1 decimal(24,9) DEFAULT (0),
			CrContraGain decimal(24,9) DEFAULT (0),
			CrSetoffGain decimal(24,9) DEFAULT (0),
			CrInterest decimal(24,9) DEFAULT (0),
			CrNonTrade decimal(24,9) DEFAULT (0),
			TotalCredit decimal(24,9) DEFAULT (0),
			NetCreditDebit decimal(24,9) DEFAULT (0),
			NetOSBalance decimal(24,9) DEFAULT (0),
			CappedMktValue decimal(24,9) DEFAULT (0),
			CapBuyLimit decimal(24,9) NULL,
			CalBuyLimit decimal(24,9) NULL,
			RealBuyLimit decimal(24,9) NULL
		);

		DECLARE @CashBalanceLookup INT = (select LookUpCategoryId from GlobalBO.setup.Tb_LookUpMapMaster WHERE LookUpColumnKey='CashBalanceFlag')
		DECLARE @FundSourceId INT = (SELECT FundSourceId FROM Globalbo.setup.Tb_FundSource WHERE FundSourceCd='Cash');
		
		--ARCHIVE YESTERDAY BUY LIMIT
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Archive CashBuyLimit');

		--INSERT INTO CashBuyLimit_Archive
		--	([BusinessDate],[AcctNo],[CollateralType],[ApprovedLimit],CashBalance,AdvanceWithdrawal,[Balance],[MktValue]
  --          ,[WHTaxJuristic],[OtherCollateral],[ART],[ARTMinus1],[APT],[ATSFeeT]
		--	,[APTMinus1],[ATSFeeTMinus1],[NETAR],[NETAP],[CapBuyLimit],[CalBuyLimit],[CalBuyLimitBeforeATS],[RealBuyLimit]
		--	,[OverBuyLimit],[APOver],[APToATS],[APToATSMinus1],[ARToATS],[ARToATSMinus1],[WHTaxJuristic1],[APToCashBalance],[ArchiveDate])
		--SELECT [BusinessDate],[AcctNo],[CollateralType],[ApprovedLimit],CashBalance,AdvanceWithdrawal,[Balance],[MktValue]
  --          ,[WHTaxJuristic],[OtherCollateral],[ART],[ARTMinus1],[APT],[ATSFeeT]
		--	,[APTMinus1],[ATSFeeTMinus1],[NETAR],[NETAP],[CapBuyLimit],[CalBuyLimit],[CalBuyLimitBeforeATS],[RealBuyLimit]
		--	,[OverBuyLimit],[APOver],[APToATS],[APToATSMinus1],[ARToATS],[ARToATSMinus1],[WHTaxJuristic1],[APToCashBalance], GETDATE() 
		--FROM CashBuyLimit;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Archive CashBuyLimit');

		TRUNCATE TABLE CashApprovedLimit;
				
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into #CashCollateral');

		INSERT INTO #CashCollateral (BusinessDate, AcctNo, AcctServiceType, ParentGroup, CashBalance)
		select @dteBusinessDate, A.AcctNo, A.ServiceType, AC.[ParentGroup (selectsource-3)], ISNULL(Balance,0)
		FROM GlobalBO.setup.Tb_Account AS A
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS AC
		ON A.AcctNo = AC.[AccountNumber (textinput-5)]
		LEFT JOIN 
			(SELECT AcctNo, @FundSourceId AS FundSourceId, SUM(Balance) AS Balance
			 FROM GlobalBO.holdings.Tb_Cash
			 GROUP BY AcctNo) AS C
		ON A.AcctNo = C.AcctNo
		WHERE A.AcctCategory='CL' AND A.AcctStatus = 'AA' 
		AND (C.FundSourceId = @FundSourceId OR C.FundSourceId IS NULL);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into #CashCollateral');
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Buy Limit Computation');
		
		--DECLARE @CreditLineLookup INT = (select LookUpCategoryId from GlobalBO.setup.Tb_LookUpMapMaster WHERE LookUpColumnKey='CreditLine')
		
		UPDATE CC
		SET ApprovedLimit = CAST(ISNULL(NULLIF(REPLACE(AF.[ApproveTradingLimit (textinput-54)],',',''),''),0.0) AS DECIMAL (24,9)),
			AvailableCleanLimit = CAST(ISNULL(NULLIF(REPLACE(AF.[AvailableCleanLineLimit (textinput-59)],',',''),''),0.0) AS DECIMAL (24,9)),
			CollMultiplier = ISNULL(NULLIF(AF.[MultiplierforNonShare (textinput-58)],''),1),
			CashMultiplier = ISNULL(NULLIF(AF.[MultiplierforCashDeposit (textinput-56)],''),1)
		FROM #CashCollateral AS CC
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS AF
		ON CC.AcctNo = AF.[AccountNumber (textinput-5)];
		
		--SELECT ISNULL(NULLIF(AF.[ApproveTradingLimit (textinput-54)],''),0.0),
		--	ISNULL(NULLIF(AF.[AvailableCleanLineLimit (textinput-59)],''),0.0),
		--	ISNULL(NULLIF(AF.[MultiplierforNonShare (textinput-58)],''),1),
		--	ISNULL(NULLIF(AF.[MultiplierforCashDeposit (textinput-56)],''),1), *
		--FROM #CashCollateral AS CC
		--INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS AF
		--ON CC.AcctNo = AF.[AccountNumber (textinput-5)]
		--where ISNUMERIC(AF.[AvailableCleanLineLimit (textinput-59)]) = 0

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Account Limits & Multipliers Updated');

		--Pending Cash Balance
		UPDATE CC
		SET PendingCashBalance = 0
		from #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, @FundSourceId AS FundSourceId, SUM(Balance) AS Balance
			 FROM GlobalBO.holdings.Tb_ReceivablePayableCash
			 GROUP BY AcctNo) AS C
		ON CC.AcctNo = C.AcctNo;

		--Purchase
		UPDATE CC
		SET DrPurchase = NetAmountSetl
		from #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, SUM(NetAmountSetl - ABS(ISNULL(PaymentMade,0))*-1) AS NetAmountSetl 
			 FROM GlobalBO.contracts.Tb_ContractOutstanding AS C
			 LEFT JOIN 
				(SELECT ContractNo, SUM(PaymentMade) AS PaymentMade
				 FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid 
				 WHERE TransType='TRBUY'
				 GROUP BY ContractNo
				 ) AS TP
			 ON C.ContractNo = TP.ContractNo
			 WHERE TransType='TRBUY' and ContractStatus='O'  --AND TradeDate <= @dteBusinessDate
			 GROUP BY AcctNo) AS CO
		ON CC.AcctNo = CO.AcctNo;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - TRBUY Updated');

		--NEGATIVE SALES CASE (CLIENT SOLD BUT NET BROKERAGE > NET GROSS AMOUNT -> CLIENT NEEDS TO PAY (NEGATIVE NET AMOUNT))
		UPDATE CC
		SET DrPurchase += NetAmountSetl
		from #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, SUM(NetAmountSetl-ABS(ISNULL(PaymentMade,0))*-1) AS NetAmountSetl 
			 FROM GlobalBO.contracts.Tb_ContractOutstanding AS C
			 LEFT JOIN 
				(SELECT ContractNo, SUM(PaymentMade) AS PaymentMade
				 FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid 
				 WHERE TransType='TRSELL'
				 GROUP BY ContractNo
				 ) AS TP
			 ON C.ContractNo = TP.ContractNo
			 WHERE TransType='TRSELL' and ContractStatus='O' --AND TradeDate <= @dteBusinessDate
			 GROUP BY AcctNo
			 HAVING SUM(NetAmountSetl) < 0) AS CO
		ON CC.AcctNo = CO.AcctNo;
		
		--OVERDUE
		UPDATE CC
		SET DrOverduePurchase = NetAmountSetl
		from #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, ABS(SUM(Balance))*-1 AS NetAmountSetl 
			 FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid
			 WHERE TransType='TRBUY' and ContractStatus='O' --AND TradeDate <= @dteBusinessDate
			 GROUP BY AcctNo) AS CO
		ON CC.AcctNo = CO.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - TRBUY Overdue Updated');

		--OS Debit Interest
		UPDATE CC
		SET DrInterest = T.AccruedInterestAmountSetl
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(AccruedInterestAmountSetl) AS AccruedInterestAmountSetl 
					FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid
					WHERE SetlCurrCd = 'MYR' AND AccruedInterestAmountSetl <> 0
					GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Accrued Interest on OS Trans Updated');

		UPDATE CC
		SET DrPurchase += DrOverduePurchase
		from #CashCollateral AS CC

		--select * from #CashCollateral where AcctNo='012200209'

		--Contra Loss
		UPDATE CC
		SET DrContraLoss = T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(Amount+TaxAmount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND TransType='CHLS' AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - CHLS Updated');

		--Setoff Loss
		UPDATE CC
		SET DrSetoffLoss = T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(Amount+TaxAmount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND TransType='SCHLS' AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - SCHLS Updated');

		--Debit Interest
		UPDATE CC
		SET DrInterest += T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(Amount+TaxAmount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND TransType='CHAO' AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - CHAO Updated');

		UPDATE CC
		SET DrNonTrade = T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(T.Amount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   INNER JOIN GlobalBO.setup.Tb_TransactionType AS TT
				   ON T.TransType = TT.TransType
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND LedgerCrDr = 'Dr' AND T.TransType NOT IN ('TRBUY','CHLS','SCHLS','CHAO') AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Other Non Trade Trans Dr Updated');

		UPDATE CC
		SET DrNonTrade += CO.NetAmountSetl
		FROM #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, SUM(Balance) AS NetAmountSetl 
			 FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid AS U
			 INNER JOIN GlobalBO.setup.Tb_TransactionType AS TT
			 ON U.TransType = TT.TransType
			 WHERE TT.LedgerCrDr='Dr' AND U.TransType NOT IN ('TRBUY') and ContractStatus='O' --AND TradeDate <= @dteBusinessDate
			 GROUP BY AcctNo) AS CO
		ON CC.AcctNo = CO.AcctNo;
		
		UPDATE CC
		SET DrUnrealizedLoss = NetAmountSetl
		from #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, SUM(TradedQty*TradedPrice - TradedQty*CP.ClosingPrice) AS NetAmountSetl 
			 FROM GlobalBO.contracts.Tb_ContractOutstanding AS C
			 INNER JOIN GlobalBO.setup.Tb_ClosingPrice AS CP
			 ON C.InstrumentId = CP.InstrumentId AND CP.BusinessDate = @dteBusinessDateMinus1
			 WHERE TransType='TRBUY' and ContractStatus='O' AND CP.ClosingPrice < C.TradedPrice
			 GROUP BY AcctNo) AS CO
		ON CC.AcctNo = CO.AcctNo;

		--Sales
		UPDATE CC
		SET CrSales = NetAmountSetl
		from #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, SUM(NetAmountSetl-ISNULL(PaymentMade,0)) AS NetAmountSetl 
			 FROM GlobalBO.contracts.Tb_ContractOutstanding AS C
			 LEFT JOIN 
				(SELECT ContractNo, SUM(PaymentMade) AS PaymentMade
				 FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid 
				 WHERE TransType='TRSELL'
				 GROUP BY ContractNo
				 ) AS TP
			 ON C.ContractNo = TP.ContractNo
			 WHERE TransType='TRSELL' and ContractStatus='O'  --AND TradeDate <= @dteBusinessDate
			 GROUP BY AcctNo
			 HAVING SUM(NetAmountSetl) > 0) AS CO
		ON CC.AcctNo = CO.AcctNo;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - TRSELL Updated');

		--Sales
		UPDATE CC
		SET CrSalesT1 = NetAmountSetl
		from #CashCollateral AS CC
		INNER JOIN 
			(SELECT AcctNo, SUM(NetAmountSetl-ISNULL(PaymentMade,0)) AS NetAmountSetl 
			 FROM GlobalBO.contracts.Tb_ContractOutstanding AS C
			 LEFT JOIN 
				(SELECT ContractNo, SUM(PaymentMade) AS PaymentMade
				 FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid 
				 WHERE TransType='TRSELL'
				 GROUP BY ContractNo
				 ) AS TP
			 ON C.ContractNo = TP.ContractNo
			 WHERE TransType='TRSELL' and ContractStatus='O' AND TradeDate = @dteBusinessDateMinus1
			 GROUP BY AcctNo
			 HAVING SUM(NetAmountSetl) > 0) AS CO
		ON CC.AcctNo = CO.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - TRSELL T1 Updated');

		--Contra Gain
		UPDATE CC
		SET CrContraGain = T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(Amount+TaxAmount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND TransType='CHGN' AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - CHGN Updated');

		--Setoff Gain
		UPDATE CC
		SET CrSetoffGain = T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(Amount+TaxAmount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND TransType='SCHGN' AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - SCHGN Updated');

		--Credit Interest
		UPDATE CC
		SET CrInterest = T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(Amount+TaxAmount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND TransType='CHAI' AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - CHAI Updated');

		UPDATE CC
		SET CrNonTrade = T.Amount
		FROM #CashCollateral AS CC
		INNER JOIN (SELECT AcctNo, SUM(T.Amount) AS Amount 
				   FROM GlobalBO.transmanagement.Tb_Transactions AS T
				   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
				   ON T.RecordId = TA.ReferenceID
				   INNER JOIN GlobalBO.setup.Tb_TransactionType AS TT
				   ON T.TransType = TT.TransType
				   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND LedgerCrDr = 'Cr' AND T.TransType NOT IN ('TRSELL','CHGN','SOGN','CHAI') AND SetlDate > @dteBusinessDate
				   GROUP BY AcctNo) AS T
		ON CC.AcctNo = T.AcctNo;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Other Non Trade Trans Cr Updated');

		UPDATE CC
		SET CappedMktValue = ISNULL(FBalanceMktValue,0)
		FROM #CashCollateral AS CC
		LEFT JOIN 
			(SELECT AcctNo, SUM(Collateral) AS FBalanceMktValue
			 FROM GlobalBO.[holdings].[Tb_CustodyAssetsRPCollateral]
			 --FROM GlobalBORpt.valuation.Tb_CustodyAssetsRPValuationCollateralRpt
			 WHERE BusinessDate = @dteBusinessDate --InstrumentTradedCurrCd = 'THB' AND 
			 --AND FundSourceId IN (SELECT FundSourceId FROM GlobalBO.setup.Tb_FundSource WHERE FundSourceCd IN ('02','04','08','12','SBLNTL'))
			 GROUP BY AcctNo) AS CV
		ON CC.AcctNo = CV.AcctNo;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - CappedMktValue Updated');
		
		UPDATE #CashCollateral
		SET TotalCashBalance = (CashBalance + PendingCashBalance);

		UPDATE #CashCollateral
		SET TotalDebit = DrPurchase + DrContraLoss + DrSetoffLoss + DrInterest + DrNonTrade,
			TotalCredit = CrSales + CrContraGain + CrSetoffGain + CrInterest + CrNonTrade;

		UPDATE #CashCollateral
		SET NetCreditDebit = TotalDebit + TotalCredit;
		
		UPDATE #CashCollateral
		SET NetOSBalance = TotalCashBalance + NetCreditDebit;

		-- CASE A
		UPDATE #CashCollateral
		SET CalBuyLimit = ROUND((NetOSBalance * @decCashUpfrontLimitPercentage/100) - @decCashUpfrontMinAmount,2)
		WHERE ParentGroup IN ('C','J');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - C & J Accounts Limit Updated');

		-- CASE B
		UPDATE #CashCollateral
		SET CalBuyLimit = ApprovedLimit --+ NetOSBalance
		WHERE ParentGroup IN ('A');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - A Accounts Limit Updated');

		-- CASE C
		UPDATE #CashCollateral
		SET CalBuyLimit = (TotalCashBalance * CashMultiplier) + (CappedMktValue * CollMultiplier) + CrSales + DrPurchase + ((NetCreditDebit - (CrSales + DrPurchase)) * CashMultiplier) + DrUnrealizedLoss
		WHERE ParentGroup IN ('U');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - U Accounts Limit Updated');

		--UPDATE #CashCollateral
		--SET CalBuyLimit = (TotalCashBalance * CashMultiplier) + (CappedMktValue * CollMultiplier) + NetCreditDebit + CrContraGain + DrContraLoss + AvailableCleanLimit
		--WHERE ParentGroup IN ('U');

		-- CASE E
		--UPDATE #CashCollateral
		--SET CalBuyLimit = ROUND(((CashBalance + DrPurchase + CrSalesT1) * @decCashUpfrontLimitPercentage/100) - @decCashUpfrontMinAmount,2)
		--WHERE ParentGroup IN ('W');
		UPDATE #CashCollateral
		SET CalBuyLimit = ROUND(CashBalance,2)
		WHERE ParentGroup IN ('W');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - W Accounts Limit Updated');

		--CASE F
		UPDATE #CashCollateral
		SET CalBuyLimit = ROUND(ApprovedLimit + DrPurchase + CrSales,2) --+ DrOverduePurchase
		WHERE AcctServiceType IN ('V');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - V Accounts Limit Updated');

		UPDATE #CashCollateral
		SET RealBuyLimit = CASE WHEN ApprovedLimit < CalBuyLimit THEN ApprovedLimit ELSE CalBuyLimit END
				
		UPDATE #CashCollateral
		SET RealBuyLimit = 0
		WHERE RealBuyLimit < 0;

		--UPDATE #CashCollateral
		--SET NETAR = CASE WHEN ART - APT - WHTaxJuristic > 0 THEN ART - APT - WHTaxJuristic ELSE 0 END
		--WHERE CollateralType IN (2,3,4);

		--UPDATE #CashCollateral
		--SET CalBuyLimit = (((Balance + OtherCollateral) + (CASE WHEN MktValue-NETAR < 0 THEN 0 ELSE MktValue-NETAR END)) / @decBLRate) - NETAR
		--WHERE CollateralType = 2;

		--UPDATE #CashCollateral
		--SET NETAP = (CASE WHEN APT - ART + WHTaxJuristic > 0 THEN APT - ART + WHTaxJuristic ELSE 0 END) + 
		--			(CASE WHEN APTMinus1 - ARTMinus1 + WHTaxJuristic1 > 0 THEN APTMinus1 - ARTMinus1 + WHTaxJuristic1 ELSE 0 END)
		--WHERE CollateralType IN (2,3,4);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Buy Limit Computation');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into CashBuyLimit');

		--INSERT FROM TEMP TABLE TO PHYSICAL TABLE
		INSERT INTO CashApprovedLimit
			([BusinessDate],[AcctNo],[AcctServiceType],[ParentGroup],[CashMultiplier],[CollMultiplier]
			,[ApprovedLimit],[AvailableCleanLimit],[CashBalance],[PendingCashBalance],[TotalCashBalance]
			,[DrPurchase],[DrContraLoss],[DrSetoffLoss],[DrInterest],[DrNonTrade],[DrOverduePurchase],[TotalDebit]
			,[CrSales],[CrSalesT1],[CrContraGain],[CrSetoffGain],[CrInterest],[CrNonTrade],[TotalCredit]
			,[NetCreditDebit],[NetOSBalance],[CappedMktValue],[CapBuyLimit],[CalBuyLimit],[RealBuyLimit])
		SELECT [BusinessDate],[AcctNo],[AcctServiceType],[ParentGroup],[CashMultiplier],[CollMultiplier]
			,[ApprovedLimit],[AvailableCleanLimit],[CashBalance],[PendingCashBalance],[TotalCashBalance]
			,[DrPurchase],[DrContraLoss],[DrSetoffLoss],[DrInterest],[DrNonTrade],[DrOverduePurchase],[TotalDebit]
			,[CrSales],[CrSalesT1],[CrContraGain],[CrSetoffGain],[CrInterest],[CrNonTrade],[TotalCredit]
			,[NetCreditDebit],[NetOSBalance],[CappedMktValue],[CapBuyLimit],[CalBuyLimit],[RealBuyLimit]
		FROM #CashCollateral;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into CashBuyLimit');
		
		EXEC [process].[Usp_CalculateMarginCallReport] 1, @ostrReturnMessage;
		IF (ISNULL(@ostrReturnMessage,'') <> '')
			SELECT 1 --RAISERROR();

		DROP TABLE #CashCollateral;

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_CalculateCashBuyLimit', '', [MessageLog] 
		from @logs;

		commit tran;

    END TRY
    BEGIN CATCH

	if @@TRANCOUNT > 0
		rollback tran;
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);

		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_CalculateCashBuyLimit: Failed'

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_CalculateCashBuyLimit', '', [MessageLog] 
		from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		      		
		EXEC [master].[dbo].DBA_SendEmail   
		@istrMailTo             = @strEmailTo,
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = @strEmailSubj, 
		@istrimportance         = 'high', 
		@istrfrom_address       = @strEmailFrom, 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 

        
    END CATCH
	SET NOCOUNT OFF;
END