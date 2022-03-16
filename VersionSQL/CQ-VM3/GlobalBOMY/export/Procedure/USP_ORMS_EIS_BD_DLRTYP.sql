/****** Object:  Procedure [export].[USP_ORMS_EIS_BD_DLRTYP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_BD_DLRTYP]
(
	@idteProcessDate DATE
)
AS
/*
Daily Business Done 
EXEC [export].[USP_ORMS_EIS_BD_DLRTYP] '2020-06-01'
*/
BEGIN
		
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType			VARCHAR(1)
		,TradingDate		VARCHAR(10)
		,BranchCode			VARCHAR(10)
		,DealerCode			VARCHAR(4)
		--,DealerType			VARCHAR(1)
		,AccountNo			VARCHAR(10)
		,ClientName			VARCHAR(300)
		,CDSNo				VARCHAR(9)
		,ContractNo			VARCHAR(13)
		,TransType			VARCHAR(2)
		,StockCode			VARCHAR(10)
		,StockShortName		VARCHAR(12)
		,UnitPrice			DECIMAL(8,5)
		,Quantity			DECIMAL(9,0)
		,GrossAmount		DECIMAL(13,2)
		,TotalBrokerageAmt	DECIMAL(9,2)
		,RemisierBrokerage	DECIMAL(9,2)
		,CompanyBrokerage	DECIMAL(9,2)
		,StampDuty			DECIMAL(5,2)
		,ClearingFee		DECIMAL(6,2)
		,NetAmount			DECIMAL(13,2)
		,Currency			VARCHAR(3)
		,IntraDayInd		VARCHAR(1)
		,TradingSource		VARCHAR(1)
		,Channel			VARCHAR(1)
		,BatchMode			VARCHAR(1)
		--,ParentGroup		VARCHAR(10)
		--,AccountGroup		VARCHAR(10)
		--,eTrading			VARCHAR(1)
		--,eContract			VARCHAR(10)
		--,CurrentApplicantDate VARCHAR(10)
		,AcctType			VARCHAR(1)
	)
	
	INSERT INTO #Detail
	(
		  RecordType			
		 ,TradingDate		
		 ,BranchCode			
		 ,DealerCode			
		 --,DealerType			
		 ,AccountNo			
		 ,ClientName			
		 ,CDSNo				
		 ,ContractNo			
		 ,TransType			
		 ,StockCode			
		 ,StockShortName		
		 ,UnitPrice			
		 ,Quantity			
		 ,GrossAmount		
		 ,TotalBrokerageAmt	
		 ,RemisierBrokerage	
		 ,CompanyBrokerage	
		 ,StampDuty			
		 ,ClearingFee		
		 ,NetAmount			
		 ,Currency			
		 ,IntraDayInd		
		 ,TradingSource		
		 ,Channel			
		 ,BatchMode			
		 --,ParentGroup		
		 --,AccountGroup		
		 --,eTrading			
		 --,eContract			
		 --,CurrentApplicantDate
		 ,AcctType
	)
	-- SETTLED CONTRACTS
	SELECT 
		1,
		CONVERT(VARCHAR,C.ContractDate,103),
		Branch.[BranchCode (textinput-42)],
		Account.[DealerCode (selectsource-21)],
		--Customer.[ClientType (selectbasic-26)],
		[AccountNumber (textinput-5)],
		[CustomerName (textinput-3)],
		[CDSNo (textinput-19)],
		C.ContractNo,
		CASE 
			WHEN TransType = 'TRBUY' 
			THEN 'TP' 
			ELSE 'TS' 
		END,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		I.ShortName,
		TradedPrice,
		ABS(TradedQty),
		ABS(GrossAmountTrade),
		ClientBrokerageSetl + ClientBrokerageCompanyBased, -- Remisier + Company Brokerage
		ClientBrokerageSetl, -- Remisier Brokerage
		ClientBrokerageCompanyBased, -- Company Brokerage 
		0, -- Stamp Duty
		0, -- Clearing Fee
		C.NetAmountSetl,
		C.TradedCurrCd,
		Account.[IntraDayInd (selectbasic-12)],
		CASE WHEN Account.[ParentGroup (selectsource-3)] IN ('V','P') 
			 THEN 'I' 
			 ELSE (CASE WHEN C.Channel = 'Online' THEN 'O' ELSE 'F' END) 
		END,
		CASE 
			WHEN C.Channel = 'Online' 
			THEN 'O' 
			ELSE 'F' 
		END,
		CASE 
			WHEN C.ContractAmendNo = 0 
			THEN 'N' 
			ELSE 'A' 
		END, -- Batch Code
		--Account.[ParentGroup (selectsource-3)],
		--Account.[AccountGroup (selectsource-2)],
		--CASE WHEN C.Channel = 'Online' THEN 'Y' ELSE 'N' END,
		--CASE WHEN C.Channel = 'Online' THEN 'Y' ELSE 'N' END,
		--@idteProcessDate
		[AccountType (selectsource-7)]
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled C
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
		C.TransType IN ('TRBUY','TRSELL') AND I.InstrumentCd LIKE '%.XKLS%' 
	AND 
		C.ContractDate = @idteProcessDate

	UNION
	-- UNSETTLED CONTRACTS
	SELECT 
		1,
		CONVERT(VARCHAR,C.ContractDate,103),
		Branch.[BranchCode (textinput-42)],
		Account.[DealerCode (selectsource-21)],
		--Customer.[ClientType (selectbasic-26)],
		[AccountNumber (textinput-5)],
		[CustomerName (textinput-3)],
		[CDSNo (textinput-19)],
		C.ContractNo,
		CASE 
			WHEN TransType = 'TRBUY' 
			THEN 'TP' 
			ELSE 'TS' 
		END,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		I.ShortName,
		TradedPrice,
		ABS(TradedQty),
		ABS(GrossAmountTrade),
		ClientBrokerageSetl + ClientBrokerageCompanyBased, -- Remisier + Company Brokerage
		ClientBrokerageSetl, -- Remisier Brokerage
		ClientBrokerageCompanyBased, -- Company Brokerage 
		0, -- Stamp Duty
		0, -- Clearing Fee
		C.NetAmountSetl,
		C.TradedCurrCd,
		Account.[IntraDayInd (selectbasic-12)],
		CASE WHEN Account.[ParentGroup (selectsource-3)] IN ('V','P') 
			 THEN 'I' 
			 ELSE (CASE WHEN C.Channel = 'Online' THEN 'O' ELSE 'F' END) 
		END,
		CASE 
			WHEN C.Channel = 'Online' 
			THEN 'O' 
			ELSE 'F' 
		END,
		CASE 
			WHEN C.ContractAmendNo = 0 
			THEN 'N' 
			ELSE 'A' 
		END, -- Batch Code
		--Account.[ParentGroup (selectsource-3)],
		--Account.[AccountGroup (selectsource-2)],
		--CASE WHEN C.Channel = 'Online' THEN 'Y' ELSE 'N' END,
		--CASE WHEN C.Channel = 'Online' THEN 'Y' ELSE 'N' END,
		--@idteProcessDate
		[AccountType (selectsource-7)]
	FROM GlobalBO.contracts.Tb_ContractOutstanding C
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
		C.TransType IN ('TRBUY','TRSELL') AND I.InstrumentCd LIKE '%.XKLS%' 
	AND 
		C.ContractDate = @idteProcessDate 

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
		  RecordType + '|' + TradingDate + '|' + BranchCode + '|' + DealerCode + '|' + --DealerType + '|' + 
		  AccountNo + '|' + ClientName + '|' + CDSNo + '|' + ContractNo + '|' + 
		  TransType	+ '|' + StockCode + '|' + StockShortName + '|' + CAST(UnitPrice AS VARCHAR) + '|' + CAST(Quantity AS VARCHAR) + '|' + CAST(GrossAmount AS VARCHAR) + '|' + 
		  CAST(TotalBrokerageAmt AS VARCHAR) + '|' + CAST(RemisierBrokerage AS VARCHAR) + '|' + CAST(CompanyBrokerage AS VARCHAR) + '|' + CAST(StampDuty AS VARCHAR) + '|' + 
		  CAST(ClearingFee AS VARCHAR) + '|' + CAST(NetAmount AS VARCHAR) + '|' + Currency + '|' + IntraDayInd + '|' + TradingSource + '|' + Channel + '|' + BatchMode + '|' + AcctType
		  --ParentGroup + '|' + AccountGroup + '|' + eTrading + '|' + eContract + '|' + CurrentApplicantDate
		  
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



        