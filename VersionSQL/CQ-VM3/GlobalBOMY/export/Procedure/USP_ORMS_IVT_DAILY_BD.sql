/****** Object:  Procedure [export].[USP_ORMS_IVT_DAILY_BD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_IVT_DAILY_BD]
(
	@idteProcessDate DATE
)
AS
/*
Daily Business Done 
EXEC [export].[USP_ORMS_IVT_DAILY_BD] '2020-06-01'
*/
BEGIN
		
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType		CHAR(1)
		,TradingDate	CHAR(10)
		,AccountNo		VARCHAR(10)
		,ContractNo		VARCHAR(13)
		,TransType		VARCHAR(1)
		,StockCode		VARCHAR(10)
		,UnitPrice		DECIMAL(8,5)
		,Quantity		DECIMAL(9,0)
		,NetAmount		DECIMAL(13,2)
	)
	
	INSERT INTO #Detail
	(
		  RecordType	
		 ,TradingDate
		 ,AccountNo	
		 ,ContractNo	
		 ,TransType	
		 ,StockCode	
		 ,UnitPrice	
		 ,Quantity	
		 ,NetAmount	
	)
	-- SETTLED CONTRACTS
	SELECT 
		1,
		C.ContractDate,
		Account.[AccountNumber (textinput-5)],
		ContractNo,
		CASE 
			WHEN TransType = 'TRBUY' 
			THEN 'P' 
			ELSE 'S' 
		END,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		TradedPrice,
		ABS(TradedQty),
		ABS(NetAmountSetl)
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON C.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = C.AcctNo
 	WHERE
		C.TransType IN ('TRBUY','TRSELL') AND I.InstrumentCd LIKE '%.XKLS%' 
	AND 
		C.ContractDate = @idteProcessDate AND Account.[ParentGroup (selectsource-3)] IN ('V','P')

	UNION
	-- UNSETTLED CONTRACTS
	SELECT 
		1,
		C.ContractDate,
		C.AcctNo,
		ContractNo,
		CASE 
			WHEN TransType = 'TRBUY' 
			THEN 'P' 
			ELSE 'S' 
		END,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		TradedPrice,
		ABS(TradedQty),
		ABS(NetAmountSetl)
	FROM GlobalBO.contracts.Tb_ContractOutstanding C
	--INNER JOIN 
		--GlobalBOMY.import.Tb_AccountNoMapping AM ON C.AcctNo = AM.OldAccountNo 
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON C.InstrumentId = I.InstrumentId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = C.AcctNo
	WHERE
		I.InstrumentCd LIKE '%.XKLS%' 
	AND 
		C.ContractDate = @idteProcessDate AND Account.[ParentGroup (selectsource-3)] IN ('V','P')

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
	VALUES(0,@idteProcessDate,@Count,@totalQty) 
		
	-- RESULT SET
	SELECT 
		 RecordType + '|' + TradingDate + '|' + AccountNo + '|' + ContractNo + '|' + TransType + '|' + StockCode + '|' + 
		 CAST(UnitPrice AS VARCHAR) + '|' + CAST(Quantity AS VARCHAR) + '|' + CAST(NetAmount AS VARCHAR)
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



        