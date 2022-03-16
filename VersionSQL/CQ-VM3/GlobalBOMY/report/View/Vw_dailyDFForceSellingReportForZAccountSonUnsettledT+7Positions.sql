/****** Object:  View [report].[Vw_dailyDFForceSellingReportForZAccountSonUnsettledT+7Positions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[VW_DAILYDFFORCESELLINGREPORTFORZACCOUNTSONUNSETTLEDT+7POSITIONS]

AS
SELECT
ISNULL([BranchCode (textinput-42)],'') AS BRHID,
ISNULL(ACCOUNT.[DealerCode (selectsource-21)],'') As DelarCode,
ISNULL(TC.AcctNo,'') AS AccountNo,
ISNULL(CUSTOMER.[CustomerName (textinput-3)],'') AS AccountName,
ISNULL(TC.ContractDate,'') AS TRXDate,
ISNULL(TC.ContractNo,'') AS ContractNumber,
TC.TradedQty AS BALQTY,
ISNULL(TI.InstrumentCD,'') AS CounterCode,
ISNULL(TI.FullName,'') AS CounterName,
TC.TradedPrice AS PRICE,
(NetAmountSetl + AccruedInterestAmountSetl) AS OSAMT,
TCC.CashBalance AS TrustMoneyAvailable,
ISNULL(CAST(TC.TradeDate AS DATE),'') AS ToDate,
[GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TC.ContractDate,7,NULL) AS T7T10,
DATEDIFF(DAY,TC.TradeDate,[GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TC.ContractDate,7,NULL)) AS AgingDay
FROM [GlobalBOLocal].[transmanagement].[Tb_TransactionsSettledUnpaid] TC
INNER JOIN [CQBTempDB].[export].Tb_FormData_1409 ACCOUNT ON TC.AcctNo = ACCOUNT.[AccountNumber (textinput-5)]
INNER JOIN [CQBTEMPDB].[EXPORT].TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)]= CUSTOMER.[CustomerID (textinput-1)]
INNER JOIN [GlobalBO].[setup].tb_instrument TI ON TC.InstrumentId = TI.InstrumentId
INNER JOIN [CQBTempDB].[export].Tb_FormData_1377 DLR ON ACCOUNT.[DealerCode (selectsource-21)] = DLR.[DealerCode (textinput-35)]
INNER JOIN [CQBTempDB].[export].Tb_FormData_1374 B ON DLR.[BranchID (selectsource-1)] = B.[BranchID (textinput-1)]
LEFT JOIN [GLOBALBORPT].[valuation].Tb_CashRPValuationCollateralRpt TCC ON TC.AcctNo = TCC.AcctNo
WHERE [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TC.ContractDate,7,NULL) = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');



--SELECT * FROM [report].[VW_DAILYDFFORCESELLINGREPORTFORZACCOUNTSONUNSETTLEDT+7POSITIONS]

--DROP VIEW [report].[LIST OF CLIENTS OS PURCHASES BY REMISIER T1]