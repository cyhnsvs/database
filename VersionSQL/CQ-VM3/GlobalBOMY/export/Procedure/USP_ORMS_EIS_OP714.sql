/****** Object:  Procedure [export].[USP_ORMS_EIS_OP714]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_OP714]
(
	@idteProcessDate DATE
)
AS
/*
Outstanding Contra Loss
EXEC [export].[USP_ORMS_EIS_OP714] '2020-06-01'
*/
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType			VARCHAR(1)	
		,BranchCode			VARCHAR(2)
		,DealerCode			VARCHAR(4)
		,DealerName			VARCHAR(50)		
		,TradingAcctNo		VARCHAR(10)
		,ClientName			VARCHAR(50)
		,StockCode			VARCHAR(6)
		,StockShortName		VARCHAR(12)
		,TrxRefNo			VARCHAR(13)
		,TrxDate			VARCHAR(10)
		,DueDate			VARCHAR(10)
		,PurchasePrice		DECIMAL(8,5)
		,ClosingPrice		DECIMAL(8,5)
		,BalanceQty			DECIMAL(9,0)
		,BalanceAmount		DECIMAL(13,2)
		,ContraLossAmount	DECIMAL(13,2)

	)
	INSERT INTO #Detail
	(
		 RecordType		
		,BranchCode		
		,DealerCode		
		,DealerName		
		,TradingAcctNo	
		,ClientName		
		,StockCode		
		,StockShortName	
		,TrxRefNo		
		,TrxDate		
		,DueDate		
		,PurchasePrice	
		,ClosingPrice	
		,BalanceQty		
		,BalanceAmount	
		,ContraLossAmount						
	)
	SELECT
		1,
		Branch.[BranchCode (textinput-42)],
		Dealer.[DealerCode (textinput-35)],
		Dealer.[Name (textinput-3)],
		T.AcctNo,
		[CustomerName (textinput-3)],
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		I.ShortName,
		T.TransNo,
		CONVERT(VARCHAR,T.TransDate,103),
		CONVERT(VARCHAR,T.SetlDate,103),
		T.TradedPrice,
		ClosingPrice,
		TradedQty,
		Amount,
		Contra.GainLoss
	FROM GlobalBO.transmanagement.Tb_Transactions T
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON T.AcctNo = Account.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)]
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON T.InstrumentId = I.InstrumentId
	INNER JOIN GlobalBO.setup.Tb_ClosingPrice C 
		ON T.InstrumentId = C.InstrumentID
	INNER JOIN GlobalBOLocal.RPS.ContraTransactions_Temp Contra  
		ON Contra.CloseOutRef = T.TransNo
	WHERE
		I.InstrumentCd LIKE '%.XKLS%' AND T.TransDate = @idteProcessDate AND T.TransType = 'CHLS'


	-- BATCH TRAILER	
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)

	DECLARE @TotalQty INT
	SET @TotalQty = (SELECT SUM(BalanceQty) FROm #Detail)

	CREATE TABLE #Trailer
	(
		 RecordType				CHAR(1)
		,BatchDate				CHAR(10)
		,TotalRecord			INT
		,TotalQty				INT
	)
	INSERT INTO #Trailer
	(
		 RecordType				
		,BatchDate	
		,TotalRecord
		,TotalQty							
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count,@TotalQty)

	-- RESULT SET
	SELECT 
		 RecordType		
		 + '|' + BranchCode		
		 + '|' + DealerCode		
		 + '|' + DealerName		
		 + '|' + TradingAcctNo	
		 + '|' + ClientName		
		 + '|' + StockCode		
		 + '|' + StockShortName	
		 + '|' + TrxRefNo		
		 + '|' + TrxDate		
		 + '|' + DueDate		
		 + '|' + CAST(PurchasePrice	AS VARCHAR)
		 + '|' + CAST(ClosingPrice AS VARCHAR)
		 + '|' + CAST(BalanceQty AS VARCHAR)		
		 + '|' + CAST(BalanceAmount AS VARCHAR)	
		 + '|' + CAST(ContraLossAmount AS VARCHAR)
	FROM
		#Detail
	UNION ALL
	SELECT 
		RecordType + '|' + BatchDate + '|' + CAST(TotalRecord AS VARCHAR) 
	FROM 
		#Trailer

	DROP TABLE #Detail
	DROP TABLE #Trailer
END