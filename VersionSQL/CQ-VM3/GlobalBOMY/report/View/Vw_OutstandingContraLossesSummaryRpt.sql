/****** Object:  View [report].[Vw_OutstandingContraLossesSummaryRpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW report.vw_OutstandingContraLossesSummaryRpt AS 
SELECT 
[DealerCode (selectsource-21)] AS DelearCode,
TR.AcctNo AS AccountNo,
[CustomerName (textinput-3)] AS AccountName,
ISNULL(Amount,0) AS OutStandingContra,
(ISNULL(Balance,0)+ISNULL(MktValue,0)-ISNULL(Amount,0))AS COLLSURPLUS,
0 AS OutstandingPurchase,
0 AS OutstandingSales,
ISNULL(Balance,0) AS Trust,
ISNULL(MktValue,0) AS CollateralMM,
ISNULL(Collateral,0) AS CollateralCapped,
[ApprovedLimit (textinput-64)] AS ApprovedLimit
FROM GlobalBO.transmanagement.Tb_Transactions TR -- -- MktValue
LEFT JOIN CQBTempDB.export.Tb_FOrmData_1409 Acc ON Acc.[AccountNumber (textinput-5)] = TR.AcctNo --DealerCode (selectsource-21)]
LEFT JOIN CQBTempDB.export.Tb_FOrmData_1410 CUST ON CUST.[CustomerID (textinput-1)] = Acc.[CustomerID (selectsource-1)] -- [CustomerName (textinput-3)]
LEFT JOIN GlobalBO.holdings.Tb_Cash CA ON CA.AcctNo = TR.AcctNo -- Balance
LEFT JOIN GlobalBORpt.valuation.Tb_CustodyAssetsRPValuationCollateralRpt Custd ON TR.AcctNo = Custd.AcctNo -- Amount
WHERE TR.TransType='CHLS'