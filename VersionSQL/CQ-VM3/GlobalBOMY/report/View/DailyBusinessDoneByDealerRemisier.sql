/****** Object:  View [report].[DailyBusinessDoneByDealerRemisier]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[DailyBusinessDoneByDealerRemisier] AS
SELECT
ContractNo AS [ContractNo_TaxInvoiceNo],
AcctNo AS [AccountNo],
D.[CustomerName (textinput-3)] AS [Account Name],
A.InstrumentId AS [ProdCode],
A.InstrumentName AS [ProductName],
TradedPrice As [Price],
TradedQty As [Quantity],
GrossAmountTrade AS [GrossAmount],
ClientBrokerageTrade AS [Brokerage_GST_Brkg],
ClientBrokerageTradeTax AS [C/Stamp],
NetAmountTrade AS [NetAmount],
TradedCurrCd FROM GlobalBO.contracts.Tb_ContractOutstanding  A
LEFT JOIN CQBTempDB.export.Tb_FormData_1409 C
ON C.[AccountNumber (textinput-5)] =A.AcctNo
INNER JOIN CQBTempDB.export.Tb_FormData_1410 D
ON D.[CustomerID (textinput-1)] =C.[CustomerID (selectsource-1)]