/****** Object:  Procedure [export].[USP_AB_BusinessDone_Alliance]    Committed by VersionSQL https://www.versionsql.com ******/

--EXEC [export].[USP_AB_BusinessDone_Alliance] '2020-02-01'

CREATE PROCEDURE [export].[USP_AB_BusinessDone_Alliance]
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
	INSERT INTO #ReportTitle VALUES ('EXTERNAL MARGIN CLIENT TRADE - ALLIANCE BANK')

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
		Column13	CHAR(14),
	)
	INSERT INTO #Header VALUES ('Trx Number', 'Trx Date', 'Sett. Date', 'A/C Number', 'Stock Code',
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
		FORMAT(TradeDate, 'dd-MM-yyyy'),
		FORMAT(SetlDate, 'dd-MM-yyyy'),
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
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON C.InstrumentId = I.InstrumentId
	LEFT JOIN (SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN (SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	WHERE 
		ContractDate = @idteProcessDate AND InstrumentCd LIKE '%.XKLS%'

	CREATE TABLE #Trailer
	(
		 TotalRecord		CHAR(20)
		,TotalPurchase		CHAR(30)
		,TotalSellAmt		CHAR(30)
		,EndOfTrailer		CHAR(40)
	)

	DECLARE @TRADENO CHAR(30)= (SELECT COUNT(TradeNo) FROM #Detail WHERE NetAmount<0);
	DECLARE @DEBITAMT CHAR(30)= (SELECT SUM(ISNULL(ABS(NetAmount),0)) FROM #Detail WHERE NetAmount<0);
	DECLARE @CREDITAMT CHAR(30)= (SELECT SUM(ISNULL(ABS(NetAmount),0)) FROM #Detail WHERE NetAmount>0);

	INSERT INTO #Trailer
	(
	 TotalRecord	
	,TotalPurchase	
	,TotalSellAmt	
	,EndOfTrailer	
	)
	VALUES
	(
	 @TRADENO
	,@DEBITAMT
	,@CREDITAMT
	,'** End Of Record **'
	);

	-- RESULT SET
	SELECT 
		ReportTitle FROM #ReportTitle
	UNION ALL
	SELECT
		Column1 + Column2 + Column3 + Column4 + Column5 + Column6 + Column7 + Column8 + Column9 + Column10 + Column11 + Column12 + Column13
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

	SELECT TotalRecord	+ ISNULL(TotalPurchase,'')  + ISNULL(TotalSellAmt,'') + EndOfTrailer FROM #Trailer

	DROP TABLE #Detail
	DROP TABLE #ReportTitle
	DROP TABLE #Trailer
	DROP TABLE #Header
END