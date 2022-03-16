/****** Object:  Procedure [export].[USP_ORMS_EIS_CLTOS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_CLTOS]
(
	@idteProcessDate DATE
)
AS
/*
Client Outstanding
EXEC [export].[USP_ORMS_EIS_CLTOS] '2020-06-01'
*/
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType			VARCHAR(1)			
		,BranchCode			VARCHAR(2)
		--,DealerType			VARCHAR(1)
		,DealerCode			VARCHAR(4)
		,DealerName			VARCHAR(100)
		,AccountNo			VARCHAR(10)
		,ClientName			VARCHAR(300)
		,TradingDate		VARCHAR(10)
		,ContractNo			VARCHAR(10)
		,StockCode			VARCHAR(10)
		,StockShortName		VARCHAR(12)
		,UnitPrice			DECIMAL(8,5)
		,Quantity			DECIMAL(9,0)
		,BalanceAmount		DECIMAL(15,2)
		,DueDate			VARCHAR(10)
		,Interest			DECIMAL(15,2)
	)
	INSERT INTO #Detail
	(
		 RecordType		
		,BranchCode		
		--,DealerType		
		,DealerCode		
		,DealerName		
		,AccountNo		
		,ClientName		
		,TradingDate	
		,ContractNo		
		,StockCode		
		,StockShortName	
		,UnitPrice		
		,Quantity		
		,BalanceAmount	
		,DueDate		
		,Interest		
	)
	SELECT 
		1,
		Branch.[BranchCode (textinput-42)],
		--Customer.[ClientType (selectbasic-26)],
		Account.[DealerCode (selectsource-21)],
		Dealer.[Name (textinput-3)],
		[AccountNumber (textinput-5)],
		[CustomerName (textinput-3)],
		CONVERT(VARCHAR,C.ContractDate,103),
		C.ContractNo,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		I.ShortName,
		TradedPrice,
		TradedQty,
		NetAmountSetl,
		CONVERT(VARCHAR,C.SetlDate,103),
		AccruedInterestAmountSetl
	FROM GlobalBO.contracts.Tb_ContractOutstanding	C
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON C.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = C.AcctNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)]
 	WHERE
		I.InstrumentCd LIKE '%.XKLS%'  AND C.ContractDate = @idteProcessDate 

	UNION
	SELECT 
		1,
		Branch.[BranchCode (textinput-42)],
		--Customer.[ClientType (selectbasic-26)],
		Account.[DealerCode (selectsource-21)],
		Dealer.[Name (textinput-3)],
		[AccountNumber (textinput-5)],
		[CustomerName (textinput-3)],
		CONVERT(VARCHAR,C.TransDate,103),
		RIGHT(TransNo,10),
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		I.ShortName,
		TradedPrice,
		TradedQty,
		Amount,
		CONVERT(VARCHAR,C.SetlDate,103),
		0
	FROM GlobalBO.transmanagement.Tb_Transactions	C
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON C.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = C.AcctNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)]
 	WHERE
		I.InstrumentCd LIKE '%.XKLS%' AND C.TransDate = @idteProcessDate 


	-- BATCH TRAILER	
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)

	DECLARE @totalQty INT
	SET @totalQty = (SELECT SUM(Quantity) FROM #Detail)

	CREATE TABLE #Trailer
	(
		 RecordType				CHAR(1)
		,CurrentApplicateDate	CHAR(10)
		,TotalRecord			INT
		,TotalQty				INT
	)
	INSERT INTO #Trailer
	(
		 RecordType				
		,CurrentApplicateDate	
		,TotalRecord				
		,TotalQty			
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count,@totalQty)

	-- RESULT SET
	SELECT 
		  RecordType + '|' + BranchCode + '|' + DealerCode + '|' + DealerName + '|' + AccountNo + '|' + ClientName + '|' + TradingDate + '|' + ContractNo + '|' + 
		  StockCode + '|' + StockShortName + '|' + CAST(UnitPrice AS VARCHAR) + '|' + CAST(Quantity AS VARCHAR) + '|' + CAST(BalanceAmount AS VARCHAR) + '|' + 
		  DueDate + '|' + CAST(Interest AS VARCHAR)
	FROM 
		#Detail
	UNION ALL
	SELECT 
		RecordType + '|' + CurrentApplicateDate + '|' + CAST(TotalRecord AS VARCHAR) + '|' + CAST(TotalQty AS VARCHAR)
	FROM 
		#Trailer

	DROP TABLE #Detail
	DROP TABLE #Trailer
END