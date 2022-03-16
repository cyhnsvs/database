/****** Object:  Procedure [export].[USP_ORMS_EIS_DAILYCTJRN]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_DAILYCTJRN]
(
	@idteProcessDate DATE
)
AS
/*
Contra History Details
EXEC [export].[USP_ORMS_EIS_DAILYCTJRN] '2020-06-01'
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
		,TrxDate			VARCHAR(10)
		,TrxRefNo			VARCHAR(13)
		,Qty				DECIMAL(9,0)
		,ContraAmount		DECIMAL(13,2)
		,GainLoss			VARCHAR(1)

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
		,TrxDate		
		,TrxRefNo		
		,Qty			
		,ContraAmount	
		,GainLoss								
	)
	SELECT 
			1,
			Branch.[BranchCode (textinput-42)],    
			Account.[DealerCode (selectsource-21)],  
			Dealer.[Name (textinput-3)],  
			[AccountNumber (textinput-5)],  
			[CustomerName (textinput-3)], 
			SUBSTRING(InstrumentCode,0,CHARINDEX('.',InstrumentCode)),
			ShortName,
			CONVERT(VARCHAR,TradeDate,103),
			CloseOutRef,
			ContraQty,
			ContraAmount,
			CASE WHEN GainLoss > 0 
			     THEN 'G'
				 ELSE 'L'
			END
		FROM [RPS].[ContraTransactions_Temp] C
		INNER JOIN GlobalBO.setup.Tb_Instrument I 
			ON C.InstrumentCode = I.InstrumentCd
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
			ON Account.[AccountNumber (textinput-5)] = C.AcctNo  
		INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
			ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]  
		INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
			ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]  
		INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
			ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)] 
		WHERE 
			ISNULL(C.IsReversed,0) = 0 AND C.TransType ='TRBUY' AND C.CloseoutRef IS NOT NULL AND ContraCurr IS NOT NULL  		
		GROUP BY
			C.CloseoutRef ,InstrumentCode,  GainLoss , ServiceCharge ,Transno , TransDate , ContraCurr, C.CreatedBy , CreatedOn, C.BusinessDate ,C.SetlDate,ContractInd


	-- BATCH TRAILER	
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)

	DECLARE @TotalQty INT
	SET @TotalQty = (SELECT SUM(Qty) FROm #Detail)

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