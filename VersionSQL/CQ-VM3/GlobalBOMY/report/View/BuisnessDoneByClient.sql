/****** Object:  View [report].[BuisnessDoneByClient]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[BuisnessDoneByClient] AS     
SELECT 

 [TRXDT]             = CAST(CO.SetlDate AS DATE),  
 [ACCTNO]            = CO.AcctNo,
 [ACCTFNAME]         = C.[CustomerName (textinput-3)],  
 [PRODCD]            = CO.InstrumentId,  
 [ABRNAME]           = CO.InstrumentName,
 [TRDPRICE]          = CAST(CO.TradedPrice AS DECIMAL(24,6)),
 [QTY]               = CAST(CO.TradedQty AS DECIMAL(24,0)),
 [TRXCD]             = CASE WHEN (CO.TransType  = 'TRBUY') THEN 'TP' ELSE 'TS' END 



FROM   
 [GlobalBO].[contracts].[Tb_ContractOutstanding] CO  
 LEFT JOIN CQBTempDB.export.Tb_FormData_1409 ACC /*Account Info (updated)*/
 ON  CO.AcctNo = ACC.[AccountNumber (textinput-5)]

 LEFT JOIN CQBTempDB.export.Tb_FormData_1410 AS C
 ON ACC.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]

 LEFT JOIN CQBTempDB.export.Tb_FormData_1345 PR
 ON PR.[CounterShortName (textinput-3)]  = CO.InstrumentName
 WHERE CO.SetlDate = (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')) AND PR.[DisclosureofDealingtoSCTOM (multiplecheckboxes-2)] = 'D'

 UNION

 SELECT 

 [TRXDT]             = CAST(TS.SetlDate AS DATE),  
 [ACCTNO]            = TS.AcctNo,
 [ACCTFNAME]         = C.[CustomerName (textinput-3)],  
 [PRODCD]            = TS.InstrumentId,  
 [ABRNAME]           = TS.[InstrumentName],
 [TRDPRICE]          = CAST(TS.TradedPrice AS DECIMAL(24,6)),
 [QTY]               = CAST(TS.TradedQty AS DECIMAL(24,0)),
 [TRXCD]             = CASE WHEN (TS.TransType  = 'TRBUY') THEN 'TP' ELSE 'TS' END 



FROM   
 [GlobalBO].[transmanagement].[Tb_TransactionsSettled] TS 
 LEFT JOIN CQBTempDB.export.Tb_FormData_1409 ACC /*Account Info (updated)*/
	ON  TS.AcctNo = ACC.[AccountNumber (textinput-5)]

 LEFT JOIN CQBTempDB.export.Tb_FormData_1410 AS C
	 ON ACC.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
 
 LEFT JOIN CQBTempDB.export.Tb_FormData_1345 PR
	ON PR.[CounterShortName (textinput-3)]  = TS.InstrumentName
 WHERE TS.SetlDate = (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'))  AND PR.[DisclosureofDealingtoSCTOM (multiplecheckboxes-2)] = 'D'