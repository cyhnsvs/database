/****** Object:  Procedure [export].[USP_HL_BusinessDone_HLB]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_HL_BusinessDone_HLB]
(
	@idteProcessDate DATE
)
AS
BEGIN
	-- Report Title
	CREATE TABLE #ReportTitle
	(
		ReportTitle CHAR(100)
	)
	INSERT INTO #ReportTitle VALUES ('EXTERNAL MARGIN CLIENT TRADE - HONG LEONG BANK')

	-- HEADER DETAIL
	CREATE TABLE #Header
	(
		Column1 CHAR(14),
		Column2	CHAR(11),
		Column3	CHAR(11),
		Column4	CHAR(12),
		Column5	CHAR(10),
		Column6	CHAR(11),
		Column7	CHAR(11),
		Column8	CHAR(14),
		Column9	CHAR(14),
		Column10	CHAR(14),
		Column11	CHAR(14),
		Column12	CHAR(14),
		Column13	CHAR(14)
	)
	INSERT INTO #Header VALUES ('Trx Number', 'Trx Date', 'Sett. Date' + 'A/C Number', 'Stock Code',
								RIGHT(REPLICATE(' ',11) + 'Price',11),
								RIGHT(REPLICATE(' ',11) + 'Quantity',11),
								RIGHT(REPLICATE(' ',14) + 'Brokerage',14),
								RIGHT(REPLICATE(' ',14) + 'ST Brokerage',14),
								RIGHT(REPLICATE(' ',14) + 'Clr Fee',14),
								RIGHT(REPLICATE(' ',14) + 'ST Clr Fee',14),
								RIGHT(REPLICATE(' ',14) + 'Stamp Duty',14),
								RIGHT(REPLICATE(' ',14) + 'Net Amount',14)
								)
	 
	-- DETAIL
	CREATE TABLE #Detail
	(
		 TradeNo			CHAR(14)
		,TradeDate			CHAR(11)
		,SetlDate			CHAR(11)
		,AcctNo				CHAR(12)
		,StockCode			CHAR(8)
		,Price				DECIMAL(24,6)
		,Quantity			DECIMAL(24,0)
		,Brokerage			DECIMAL(24,2)
		,STBrokerage		DECIMAL(24,2)
		,ClearingFee		DECIMAL(24,2)
		,STClearingFee		DECIMAL(24,2)
		,StampDuty			DECIMAL(24,2)
		,NetAmount			DECIMAL(24,2)
	)
	INSERT INTO #Detail
	(
		 TradeNo		
		,TradeDate	
		,SetlDate	
		,AcctNo			
		,StockCode		
		,Price			
		,Quantity		
		,Brokerage		
		,STBrokerage	
		,ClearingFee	
		,STClearingFee	
		,StampDuty		
		,NetAmount						
	)
	SELECT 
		C.ContractNo,
		FORMAT(TradeDate, 'dd/MM/yyyy'),
		FORMAT(SetlDate, 'dd/MM/yyyy'),
		C.AcctNo,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		TradedPrice,
		TradedQty,
		ClientBrokerageSetl,
		ClientBrokerageSetlTax,
		A.FeeAmountSetl,
		A.FeeTaxSetl,
		B.FeeAmountSetl,
		NetAmountSetl
	FROM 
		GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON C.InstrumentId = I.InstrumentId
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON C.AcctNo = Account.[AccountNumber (textinput-5)]
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	WHERE 
		ContractDate = @idteProcessDate AND InstrumentCd LIKE '%.XKLS%'
	AND
		Account.[AccountGroup (selectsource-2)] IN ('M','G')
		

	-- TRAILER

	DECLARE @count INT
	SET @count = (SELECT COUNT(*) FROM #Detail)

	DECLARE @totalDebitAmt DECIMAL(24,2)
	SET @totalDebitAmt = (SELECT SUM(ABS(NetAmount)) FROM #Detail WHERE NetAmount < 0 )

	DECLARE @totalCreditAmt DECIMAL(24,2)
	SET @totalCreditAmt = (SELECT SUM(ABS(NetAmount)) FROM #Detail WHERE NetAmount > 0 )

	CREATE TABLE #Trailer
	(
		 TotalRecord		CHAR(20)
		,TotalDebitAmt	CHAR(30)
		,TotalCreditAmt		CHAR(30)
		,EndOfTrailer		CHAR(40)
	)
	INSERT INTO #Trailer
	(
		 TotalRecord		
		,TotalDebitAmt	
		,TotalCreditAmt		
		,EndOfTrailer		
	)
	VALUES (@count,@totalDebitAmt,@totalCreditAmt,'*** End of Report *** ') 
		

	-- RESULT SET
	SELECT 
		ReportTitle FROM #ReportTitle
	UNION ALL
	SELECT
		Column1 + Column2 + Column3 + Column4 + Column5 + Column6 + Column7 + Column8 + Column9 + Column10 + Column11 + Column12
	FROM 
		#Header
	UNION ALL
	SELECT
		TradeNo
		+ TradeDate
		+ SetlDate
		+ AcctNo
		+ StockCode
		+ RIGHT(REPLICATE(' ',11) + CAST(Price AS VARCHAR),11)
		+ RIGHT(REPLICATE(' ',11) + CAST(Quantity AS VARCHAR),11)
		+ RIGHT(REPLICATE(' ',14) + CAST(Brokerage AS VARCHAR),14)
		+ RIGHT(REPLICATE(' ',14) + CAST(STBrokerage AS VARCHAR),14)
		+ RIGHT(REPLICATE(' ',14) + CAST(ClearingFee AS VARCHAR),14)
		+ RIGHT(REPLICATE(' ',14) + CAST(STClearingFee AS VARCHAR),14)
		+ RIGHT(REPLICATE(' ',14) + CAST(StampDuty AS VARCHAR),14)
		+ RIGHT(REPLICATE(' ',14) + CAST(NetAmount AS VARCHAR),14)
	FROM 
		#Detail
	UNION ALL
	SELECT 
		 TotalRecord + TotalDebitAmt + TotalCreditAmt + EndOfTrailer
	
	DROP TABLE #ReportTitle
	DROP TABLE #Detail
	DROP TABLE #Header
	DROP TABLE #Trailer
END