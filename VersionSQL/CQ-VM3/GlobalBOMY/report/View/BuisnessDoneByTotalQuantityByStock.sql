/****** Object:  View [report].[BuisnessDoneByTotalQuantityByStock]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[BuisnessDoneByTotalQuantityByStock] AS     
SELECT 
 [TRXDT],               
 [PRODCD],           
 [ABRNAME],                   
 SUM([QTY]) AS QTY,           
 CASE WHEN ([TRXCD]  = 'TRBUY') THEN 'TP' ELSE 'TS' END AS [TRXCD]

FROM

	(SELECT 

	 [TRXDT]             = CAST(CO.SetlDate AS DATE),   
	 [PRODCD]            = CO.InstrumentId,  
	 [ABRNAME]           = CO.InstrumentName,
	 [QTY]               = CAST(CO.TradedQty AS DECIMAL(24,0)),
	 [TRXCD]             = CO.TransType

	FROM   
	 [GlobalBO].[contracts].[Tb_ContractOutstanding] CO  

	 LEFT JOIN CQBTempDB.export.Tb_FormData_1345 PR
	 ON PR.[CounterShortName (textinput-3)]  = CO.InstrumentName

	 WHERE CO.SetlDate = (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')) AND PR.[DisclosureofDealingtoSCTOM (multiplecheckboxes-2)] = 'D'

	 UNION

	 SELECT 

	 [TRXDT]             = CAST(TS.SetlDate AS DATE),   
	 [PRODCD]            = TS.InstrumentId,  
	 [ABRNAME]           = TS.[InstrumentName],
	 [QTY]               = CAST(TS.TradedQty AS DECIMAL(24,0)),
	 [TRXCD]             = TS.TransType

	FROM   
	 [GlobalBO].[transmanagement].[Tb_TransactionsSettled] TS 

	 LEFT JOIN CQBTempDB.export.Tb_FormData_1345 PR
		ON PR.[CounterShortName (textinput-3)]  = TS.InstrumentName

	 WHERE TS.SetlDate = (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'))  AND PR.[DisclosureofDealingtoSCTOM (multiplecheckboxes-2)] = 'D'
	 ) AS T

 GROUP BY T.TRXCD,T.PRODCD,T.ABRNAME,T.TRXDT