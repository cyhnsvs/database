/****** Object:  View [report].[Vw_ListOfClientsOSPurchasesByRemisier]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[VW_LISTOFCLIENTSOSPURCHASESBYREMISIER]

AS
SELECT
TC.AcctNo AS AccountNo,
CUSTOMER.[CustomerName (textinput-3)] AS AccountName,
TC.ContractDate AS TransDate,
TI.InstrumentCD AS ProdCode,
TI.FullName AS ProductName,
TC.ContractNo AS TrxRef,
TC.TradedQty AS Quantity,
TC.TradedPrice AS TradePrice,
TC.NetAmountSetl AS TransactionAmount,
TC.SetlDate AS DueDate,
'0' AS Age

FROM [GlobalBO].[contracts].Tb_ContractOutStanding TC
INNER JOIN [CQBTempDB].[export].Tb_FormData_1409 ACCOUNT ON TC.AcctNo = ACCOUNT.[AccountNumber (textinput-5)]
INNER JOIN [CQBTEMPDB].[EXPORT].TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)]= CUSTOMER.[CustomerID (textinput-1)]
INNER JOIN [GlobalBO].[setup].tb_instrument TI ON TC.InstrumentId = TI.InstrumentId
WHERE [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TC.ContractDate,1,NULL) = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');



--SELECT * FROM [report].[LIST OF CLIENTS OS PURCHASES BY REMISIER T1]

--DROP VIEW [report].[LIST OF CLIENTS OS PURCHASES BY REMISIER T1]