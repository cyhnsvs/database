/****** Object:  View [report].[ClientsOSPurchaseByRemisierT2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[ClientsOSPurchaseByRemisierT2] AS
SELECT Top 100  
AcctNo AS [AccountNo],
D.[CustomerName (textinput-3)] AS [AccountName],
A.TradeDate AS [Trans.Date],
A.InstrumentId AS [ProdCode],
A.InstrumentName AS [ProductName],
ContractNo AS [TrxRef],
TradedQty AS Quantity,
TradedPrice AS [TradePrice],
NetAmountSetl AS [TransactionAmount_RM],
SetlDate AS [DueDate],
'0' AS Age
FROM GlobalBORpt.contracts.Tb_ContractOutstandingRpt  A
LEFT JOIN CQBTempDB.export.Tb_FormData_1409 C
ON C.[AccountNumber (textinput-5)] =A.AcctNo
INNER JOIN CQBTempDB.export.Tb_FormData_1410 D
ON D.[CustomerID (textinput-1)] =C.[CustomerID (selectsource-1)]
WHERE TransType='TRBUY'
AND [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](A.ContractDate ,2,NULL) = A.SetlDate;
  