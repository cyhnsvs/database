/****** Object:  View [report].[BRKTIEP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[BRKTIEP]
AS
SELECT
ISNULL(TC.ContractDate,'') AS TRSDATE,
ISNULL(TC.SetlDate,'') AS DUEDATE,
ISNULL(TC.AcctNo,'') AS ACCTNUMBER,
ISNULL(TI.InstrumentCD,'') AS PRODUCTCODE,
ISNULL(TI.FullName,'') AS PRODUCTNAME,
ISNULL(TC.ContractNo,'') AS TRSNUMBER,
ISNULL(TC.TradedQty,'') AS TRSQUANTITY,
ISNULL(TC.GrossAmountSetl,'') AS GROSSAMOUNT,
ISNULL(TC.BrokerageIncomeSetl,'') AS BROKERAGEAMOUNT,
'' AS STAMPDUTY,-- NEEDCLARIFICATION
'' AS CLEARINGAMOUNT,
TC.NetAmountSetl AS TRSAMOUNT,
'' AS FINANCECODE

FROM [GlobalBORpt].[contracts].Tb_ContractOutStandingRpt TC
INNER JOIN [CQBTempDB].[export].Tb_FormData_1409 ACCOUNT ON TC.AcctNo = ACCOUNT.[AccountNumber (textinput-5)]
INNER JOIN [CQBTEMPDB].[EXPORT].TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)]= CUSTOMER.[CustomerID (textinput-1)]
INNER JOIN [GlobalBO].[setup].tb_instrument TI ON TC.InstrumentId = TI.InstrumentId