/****** Object:  Procedure [export].[USP_AB_MAL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_AB_MAL]
(
	@idteProcessDate DATE
)
AS
-- EXEC [export].[USP_AB_MAL] '2020-06-01'
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType					CHAR(1)
		,BrokerCode					CHAR(6)
		,TransType					CHAR(1)
		,ContractNo					CHAR(15)
		,TRSBroker					CHAR(4)
		,ContractDate				CHAR(6)
		,TRSNumber					CHAR(5)
		,Price						DECIMAL(11,6)
		,Qty						DECIMAL(10,0)
		,StockCode					CHAR(8)
		,CDSAcctNo					CHAR(20)
		,ClientBrokerage			DECIMAL(11,2)
		,FinanceBrokerage			DECIMAL(11,2)
		,ClearFee					DECIMAL(11,2)
		,ContractStamp				DECIMAL(11,2)
		,StampDuty					DECIMAL(11,2)
		,OtherAmount				DECIMAL(11,2)
		,CurrencyCode				CHAR(1)
		,GSTOnBrokerage				DECIMAL(11,2)
		,GSTOnClearingFee			DECIMAL(11,2)
	)
	INSERT INTO #Detail
	( 
		 RecordType			
		,BrokerCode			
		,TransType			
		,ContractNo			
		,TRSBroker			
		,ContractDate		
		,TRSNumber			
		,Price				
		,Qty				
		,StockCode			
		,CDSAcctNo			
		,ClientBrokerage	
		,FinanceBrokerage	
		,ClearFee			
		,ContractStamp		
		,StampDuty			
		,OtherAmount		
		,CurrencyCode		
		,GSTOnBrokerage		
		,GSTOnClearingFee				
	)
	SELECT 
		'C',
		BrokerInfo.[BrokerCode (textinput-1)],
		CASE WHEN C.TransType = 'TRBUY'
			 THEN 'P'
			 ELSE 'S'
		END,
		C.ContractNo,
		'',
		REPLACE(CONVERT(CHAR(8), CONVERT(DATETIME,ContractDate), 3), '/', ''),
		C.ContractNo,
		TradedPrice,
		TradedQty,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		Acct.[CDSNo (textinput-19)],
		ClientBrokerageSetl,
		ClientBrokerageSetl,
		A.FeeAmountSetl,
		B.FeeAmountSetl,
		B.FeeAmountSetl,
		0,
		CASE WHEN C.TradedCurrCd = 'MYR'
			 THEN 'L'
			 ELSE 'F'
		END,
		ClientBrokerageSetlTax,
		A.FeeTaxSetl
	FROM GlobalBO.contracts.Tb_ContractOutstanding C
	INNER JOIN CQBTempDB.export.Tb_FormData_2795 BrokerInfo 
		ON BrokerInfo.[StockExchange (selectsource-2)] = C.ExchCd
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON C.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Acct 
		ON C.AcctNo = Acct.[AccountNumber (textinput-5)]	
	LEFT JOIN (SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN (SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	WHERE
		InstrumentCd LIKE '%.XKLS%'  AND C.ContractDate = @idteProcessDate
	UNION
	SELECT 
		'C',
		BrokerInfo.[BrokerCode (textinput-1)],
		CASE WHEN C.TransType = 'TRBUY'
			 THEN 'P'
			 ELSE 'S'
		END,
		C.ContractNo,
		'',
		REPLACE(CONVERT(CHAR(8), CONVERT(DATETIME,ContractDate), 3), '/', ''),
		C.ContractNo,
		TradedPrice,
		TradedQty,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		Acct.[CDSNo (textinput-19)],
		ClientBrokerageSetl,
		ClientBrokerageSetl,
		A.FeeAmountSetl,
		B.FeeAmountSetl,
		B.FeeAmountSetl,
		0,
		CASE WHEN C.TradedCurrCd = 'MYR'
			 THEN 'L'
			 ELSE 'F'
		END,
		ClientBrokerageSetlTax,
		A.FeeTaxSetl
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN CQBTempDB.export.Tb_FormData_2795 BrokerInfo
		ON BrokerInfo.[StockExchange (selectsource-2)] = C.ExchCd
	INNER JOIN GlobalBO.setup.Tb_Instrument I
		ON C.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Acct 
		ON C.AcctNo = Acct.[AccountNumber (textinput-5)]	
	LEFT JOIN (SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN (SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	WHERE
		InstrumentCd LIKE '%.XKLS%'  AND C.ContractDate = @idteProcessDate AND C.TransType IN ('TRBUY','TRSELL')
	-- BATCH TRAILER

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)

	CREATE TABLE #Trailer
	(
		 RowType			CHAR(1)
		,BrokerCode			CHAR(6)
		,[Date]				CHAR(8)
		,TotalRecord		CHAR(10)
	)
	INSERT INTO #Trailer
	(
		 RowType		
		,BrokerCode		
		,[Date]			
		,TotalRecord	
	)
	VALUES ('T','', REPLACE(CONVERT(CHAR(10), CONVERT(DATETIME,@idteProcessDate), 103), '/', ''),RIGHT(REPLICATE('0',10) + CAST(@Count AS VARCHAR),10))

	-- RESULT SET
	SELECT 
		RecordType + BrokerCode + TransType + ContractNo + TRSBroker + ContractDate + TRSNumber + RIGHT(REPLICATE('0',11) + CAST(Price AS VARCHAR),11) + RIGHT(REPLICATE('0',10) + CAST(Qty AS VARCHAR),10) + 
		StockCode + CDSAcctNo + RIGHT(REPLICATE('0',11) + CAST(ClientBrokerage AS VARCHAR),11) + RIGHT(REPLICATE('0',11) + CAST(FinanceBrokerage AS VARCHAR),11) + 
		RIGHT(REPLICATE('0',11) + CAST(ClearFee AS VARCHAR),11) + RIGHT(REPLICATE('0',11) + CAST(ContractStamp AS VARCHAR),11) + RIGHT(REPLICATE('0',11) + CAST(StampDuty AS VARCHAR),11) +
		RIGHT(REPLICATE('0',11) + CAST(OtherAmount AS VARCHAR),11) + CurrencyCode + RIGHT(REPLICATE('0',11) + CAST(GSTOnBrokerage AS VARCHAR),11) + RIGHT(REPLICATE('0',11) + CAST(GSTOnClearingFee AS VARCHAR),11) 
	FROM 
		#Detail
	UNION ALL
	SELECT 
		RowType + BrokerCode + [Date] + TotalRecord
	FROM 
		#Trailer

	DROP TABLE #Detail
	DROP TABLE #Trailer
END