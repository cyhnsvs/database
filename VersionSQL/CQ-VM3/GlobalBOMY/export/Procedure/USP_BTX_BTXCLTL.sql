/****** Object:  Procedure [export].[USP_BTX_BTXCLTL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCLTL]
(
	@idteProcessDate DATETIME
)
AS
/*
CLIENT TRADING LIMIT
EXEC [export].[USP_BTX_BTXCLTL] '2020-06-01'
*/
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(16)
		,Filler1		 CHAR(3)
		,InterfaceID	 CHAR(10)
		,Filler2		 CHAR(3)
		,SystemID		 CHAR(15)
		,Filler3		 CHAR(350)
		,LastPosition	 CHAR(1)
	);
	INSERT INTO #Header
	(
		 RecordType	
		,HeaderDate	
		,Filler1	
		,InterfaceID
		,Filler2	
		,SystemID	
		,Filler3	
		,LastPosition
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') + CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCLTL','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,ClientCode				CHAR(15)
		,TradingAccount			CHAR(9)
		,BuyLimit				CHAR(16)
		,SellLimit				CHAR(16)
		,NetLimit				CHAR(16)
		,TotalLimit				CHAR(16)
		,BuyTopup				CHAR(16)
		,SellTopup				CHAR(16)
		,NetTopup				CHAR(16)
		,TotalTopup				CHAR(16)
		,BuyPrevOrderAmt		CHAR(16)
		,SellPrevOrderAmt		CHAR(16)
		,NetPrevOrderAmt		CHAR(16)
		,TotalPrevOrderAmt		CHAR(16)
		,AdditionalLimit		CHAR(13)
		,MarginOSAmt			CHAR(16)
		,MarginEqAmt			CHAR(16)
		,LimitCheckFlag			CHAR(1)
		,ShareCheckFlag			CHAR(1)
		,DealerAuthorityShareFlag	CHAR(1)
		,FSTLimit				CHAR(16)
		,OrderEntry				CHAR(13)
		,Modality				CHAR(1)
		,TradeControl			CHAR(13)
		,TradeStatus			CHAR(1)
		,Remarks				CHAR(50)
		,TrustAccountBalance	CHAR(16)
		,Filler					CHAR(20)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		 RecordType				
		,BranchCode	
		,ClientCode
		,TradingAccount			
		,BuyLimit				
		,SellLimit				
		,NetLimit				
		,TotalLimit				
		,BuyTopup				
		,SellTopup				
		,NetTopup				
		,TotalTopup				
		,BuyPrevOrderAmt		
		,SellPrevOrderAmt		
		,NetPrevOrderAmt		
		,TotalPrevOrderAmt		
		,AdditionalLimit		
		,MarginOSAmt			
		,MarginEqAmt			
		,LimitCheckFlag			
		,ShareCheckFlag			
		,DealerAuthorityShareFlag
		,FSTLimit				
		,OrderEntry				
		,Modality				
		,TradeControl			
		,TradeStatus			
		,Remarks				
		,TrustAccountBalance	
		,Filler					
		,LastPosition						
	)
	SELECT 
		1,
		A.BranchId,
		[AccountNumber (textinput-5)],
		[AccountNumber (textinput-5)],
		RIGHT(REPLICATE('0',16)+CAST(CAST(ISNULL(CASE WHEN [MaxBuyLimit (textinput-68)] = '' THEN NULL ELSE [MaxBuyLimit (textinput-68)] END,0.00) AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(ISNULL(CASE WHEN [MaxSellLimit (textinput-69)] = '' THEN NULL ELSE [MaxSellLimit (textinput-69)] END,0.00) AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(ISNULL(CASE WHEN [MaxNetLimit (textinput-70)] = '' THEN NULL ELSE [MaxNetLimit (textinput-70)] END,0.00) AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(ISNULL(CASE WHEN [MaxNetLimit (textinput-70)] = '' THEN NULL ELSE [MaxNetLimit (textinput-70)] END,0.00) AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',13),
		REPLICATE('0',16),
		REPLICATE('0',16),
		1,
		1,
		'',
		REPLICATE('0',16),
		'',--[ShortSellInd (selectsource-19)],
		1,
		127 + CASE WHEN [LEAP (multipleradiosinline-36)] = 'Y' THEN 256 ELSE 0 END + CASE WHEN [ETFLI (multipleradiosinline-20)] = 'Y' THEN 1024 ELSE 0 END,
		/*
		Trade Control : default all accounts eiligle to trade the following
		1-Closed End Fund
		2-Warrant/TSR
		8-Loan Stock
		16-Loan Notes
		32-ETF Bond
		64-ETF Equity
		*/
		[Tradingaccount (selectsource-31)],--[AccountStatus (selectsource-9)],
		[Remarks (textinput-72)],
		RIGHT(REPLICATE('0',16)+CAST(CAST(C.Balance AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		'',
		'T'
	FROM CQBTempDB.export.Tb_FormData_1409 Account
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Customer.[CustomerID (textinput-1)] = Account.[CustomerID (selectsource-1)]
	INNER JOIN GlobalBO.setup.Tb_Account A 
		ON Account.[AccountNumber (textinput-5)] = A.AcctNo
	INNER JOIN GlobalBO.holdings.Tb_Cash C 
		ON A.AcctNo = C.AcctNo;
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(363)
		,LastPosition		CHAR(1)
	);
	INSERT INTO #Trailer
	(
		 RecordType		
		,TrailerCount	
		,ProcessingDate	
		,HASHTotal		
		,Filler			
		,LastPosition	
	)
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') ,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),'','T');
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + BranchCode + ClientCode + TradingAccount + BuyLimit + SellLimit + NetLimit + TotalLimit + BuyTopup + SellTopup + NetTopup + TotalTopup + BuyPrevOrderAmt
		+ SellPrevOrderAmt + NetPrevOrderAmt + TotalPrevOrderAmt + AdditionalLimit + MarginOSAmt + MarginEqAmt + LimitCheckFlag + ShareCheckFlag + DealerAuthorityShareFlag
		+ FSTLimit + OrderEntry + Modality + TradeControl + TradeStatus + Remarks + TrustAccountBalance +  Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END