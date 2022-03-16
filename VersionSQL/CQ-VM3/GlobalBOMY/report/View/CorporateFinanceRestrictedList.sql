/****** Object:  View [report].[CorporateFinanceRestrictedList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[CorporateFinanceRestrictedList] AS     
SELECT 
	
 [ACCTGRPCD]		 = ACC.[AccountGroup (selectsource-2)],
 [PARACGRPCD]		 = ACC.[ParentGroup (selectsource-3)],
 [DEALERCODE]		 = ACC.[DealerCode (selectsource-21)], 
 [CLTNO]			 = ACC.[CustomerID (selectsource-1)],
 [ACCTNO]			 = CO.AcctNo,
 [MRKTCODE]	     = CO.ExchCd,
 [STOCKCODE]		 = CO.InstrumentId,
 [ABRNAME]           = CO.InstrumentName,
 [TRXCD]             = CASE WHEN (CO.TransType  = 'TRBUY') THEN 'TP' ELSE 'TS' END,
 [TRXREF]           = CO.ContractNo,
 [TRXDATE]          = CAST(CO.SetlDate AS DATE),
 [TRXQTY]            = CAST(CO.TradedQty AS DECIMAL(24,0)),
 [GROSSAMOUNT]      = CAST(CO.GrossAmountSetl AS DECIMAL(24,2)),
 [BROKERAGEAMOUNT]  = CAST(CO.ClientBrokerageSetl AS DECIMAL(24,2)),
 [CLRFEEAMOUNT]     = CAST(CO.ExchFeeSetl AS DECIMAL(24,2))

FROM   
 [GlobalBO].[contracts].[Tb_ContractOutstanding] CO  
 LEFT JOIN CQBTempDB.export.Tb_FormData_1409 ACC /*Account Info (updated)*/
 ON  CO.AcctNo = ACC.[AccountNumber (textinput-5)]

 LEFT JOIN CQBTempDB.export.Tb_FormData_1410 AS C
 ON ACC.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]

 LEFT JOIN CQBTempDB.export.Tb_FormData_1345 PR
 ON PR.[CounterShortName (textinput-3)]  = CO.InstrumentName
 WHERE CO.SetlDate = (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')) AND PR.[RestrictedList (multiplecheckboxes-1)] = 'R'

 UNION

 SELECT 
 	
 [ACCTGRPCD]		 = ACC.[AccountGroup (selectsource-2)],
 [PARACGRPCD]		 = ACC.[ParentGroup (selectsource-3)],
 [DEALERCODE]		 = ACC.[DealerCode (selectsource-21)], 
 [CLTNO]			 = ACC.[CustomerID (selectsource-1)],
 [ACCTNO]			 = TS.AcctNo,
 [MRKT CODE]	     = TS.ExchCd,
 [STOCK  CODE]		 = TS.InstrumentId,
 [ABRNAME]           = TS.InstrumentName,
 [TRXCD]             = CASE WHEN (TS.TransType  = 'TRBUY') THEN 'TP' ELSE 'TS' END,
 [TRX REF]           = TS.ContractNo,
 [TRX DATE]          = CAST(TS.SetlDate AS DATE),
 [TRXQTY]            = CAST(TS.TradedQty AS DECIMAL(24,0)),
 [GROSS AMOUNT]      = CAST(TS.GrossAmountSetl AS DECIMAL(24,2)),
 [BROKERAGE AMOUNT]  = CAST(TS.ClientBrokerageSetl AS DECIMAL(24,2)),
 [CLRFEE AMOUNT]     = CAST(TS.ExchFeeSetl AS DECIMAL(24,2))

FROM   
 [GlobalBO].[transmanagement].[Tb_TransactionsSettled] TS 
 LEFT JOIN CQBTempDB.export.Tb_FormData_1409 ACC /*Account Info (updated)*/
	ON  TS.AcctNo = ACC.[AccountNumber (textinput-5)]

 LEFT JOIN CQBTempDB.export.Tb_FormData_1410 AS C
	 ON ACC.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
 
 LEFT JOIN CQBTempDB.export.Tb_FormData_1345 PR
	ON PR.[CounterShortName (textinput-3)]  = TS.InstrumentName
 WHERE TS.SetlDate = (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'))  AND PR.[RestrictedList (multiplecheckboxes-1)] = 'R'