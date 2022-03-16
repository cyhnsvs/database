/****** Object:  View [report].[Vw_OSPurchaseGainsExceeding_5]    Committed by VersionSQL https://www.versionsql.com ******/

--select * from [report].[VW_OSPURCHASEGAINSEXCEEDING_5]

CREATE VIEW [report].[VW_OSPURCHASEGAINSEXCEEDING_5]
AS
SELECT 

ISNULL([BranchCode (textinput-42)],'') AS BRHID,
ISNULL(DLR.[Name (textinput-3)],'') AS DelarName,
ISNULL(DLR.[DealerCode (textinput-35)],'') AS DelarCode,
ISNULL(TC.AcctNo,'') AS AccountNo,
ISNULL(CUSTOMER.[CustomerName (textinput-3)],'') AS AccountName,
ISNULL(TI.InstrumentCD,'') AS StockCode,
ISNULL(TI.FullName,'') AS StockName,
ISNULL(TC.ContractDate,'') AS TRXDate,
TCP.ClosingPrice AS ClosingPrice,
TC.TradedPrice AS PurchasePrice,
((TCP.ClosingPrice - TC.TradedPrice)/TC.TradedPrice)*100 AS GainPercentage,
TC.TradedQty AS BalanceQuantity,
TC.TradedPrice AS BalanceAmount,
((TCP.ClosingPrice - TC.TradedPrice) * TC.TradedQty)  AS MarkToMrktGain
FROM [GlobalBO].[contracts].Tb_ContractOutStanding TC
INNER JOIN [CQBTempDB].[export].Tb_FormData_1409 ACCOUNT ON TC.AcctNo = ACCOUNT.[AccountNumber (textinput-5)]
INNER JOIN [CQBTEMPDB].[EXPORT].TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)]= CUSTOMER.[CustomerID (textinput-1)]
INNER JOIN [GlobalBO].[setup].tb_instrument TI ON TC.InstrumentId = TI.InstrumentId
INNER JOIN [CQBTempDB].[export].Tb_FormData_1377 DLR ON ACCOUNT.[DealerCode (selectsource-21)] = DLR.[DealerCode (textinput-35)]
INNER JOIN [CQBTempDB].[export].Tb_FormData_1374 B ON DLR.[BranchID (selectsource-1)] = B.[BranchID (textinput-1)]
Left JOIN [GLOBALBORPT].[archive].[Tb_ClosingPrice] TCP ON TC.InstrumentId = TCP.InstrumentId