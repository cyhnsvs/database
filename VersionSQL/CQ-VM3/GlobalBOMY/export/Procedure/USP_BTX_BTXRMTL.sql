/****** Object:  Procedure [export].[USP_BTX_BTXRMTL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXRMTL]
(
	@idteProcessDate DATETIME
)
AS
/*
REMISIER TRADING LIMIT
EXEC [export].[USP_BTX_BTXRMTL] '2020-06-01'
*/
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(8)
		,HeaderTime		 CHAR(8)
		,Filler1		 CHAR(3)
		,InterfaceID	 CHAR(10)
		,Filler2		 CHAR(3)
		,SystemID		 CHAR(15)
		,Filler3		 CHAR(392)
		,LastPosition	 CHAR(1)
	);
	INSERT INTO #Header
	(
		 RecordType	
		,HeaderDate	
		,HeaderTime	
		,Filler1	
		,InterfaceID
		,Filler2	
		,SystemID	
		,Filler3	
		,LastPosition
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') , CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXRMTL','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,DealerBFEID			CHAR(13)
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
		,LimitCheckFlag			CHAR(1)
		,ExceedLimit			CHAR(16)
		,TradeStatus			CHAR(13)
		,BUYTransLimit			CHAR(16)
		,SellTransLimit			CHAR(16)
		,BuyLotLimit			CHAR(13)
		,SellLotLimit			CHAR(13)
		,BuyBidLimit			CHAR(13)
		,SellBidLimit			CHAR(13)
		,OrderType				CHAR(13)
		,OrderModality			CHAR(13)
		,TradeControl			CHAR(13)
		,DBTOverride			CHAR(1)
		,TDayAmendment			CHAR(1)
		,Remarks				CHAR(50)
		,LoginID				CHAR(16)
		,Filler					CHAR(10)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		 RecordType			
		,BranchCode			
		,DealerBFEID		
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
		,LimitCheckFlag		
		,ExceedLimit		
		,TradeStatus		
		,BUYTransLimit		
		,SellTransLimit		
		,BuyLotLimit		
		,SellLotLimit		
		,BuyBidLimit		
		,SellBidLimit		
		,OrderType
		,OrderModality
		,TradeControl		
		,DBTOverride		
		,TDayAmendment		
		,Remarks			
		,LoginID			
		,Filler				
		,LastPosition			
	)
	SELECT 
		1,
		CASE WHEN ISNULL(Dealer.[BranchID (selectsource-1)],'') <> '' THEN Dealer.[BranchID (selectsource-1)] ELSE '001' END,
		[BFEDealerCode (textinput-26)],
		RIGHT(REPLICATE('0',16)+CAST(CAST([MaxBuyLimit (textinput-7)] AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST([MaxSellLimit (textinput-8)] AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST([MaxNetLimit (textinput-9)] AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST([MaxNetLimit (textinput-9)] AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',16),
		'1',
		REPLICATE('0',16),
		[Status (selectsource-12)],
		REPLICATE('0',16),
		REPLICATE('0',16),
		REPLICATE('0',13),
		REPLICATE('0',13),
		REPLICATE('0',13),
		REPLICATE('0',13),
		[ShortSellInd (selectsource-17)],
		'',
		'',
		0,
		'',
		[Remarks (textinput-11)],
		[BFEDealerCode (textinput-26)],
		'', -- Filler
		'T'
	FROM CQBTempDB.export.Tb_FormData_1377 Dealer
	INNER JOIN CQBTempDB.export.Tb_FormData_1379 DealerMarket 
		ON Dealer.[DealerCode (textinput-35)] = DealerMarket.[DealerCode (selectsource-14)];

	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(405)
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
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),'','T'); 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + BranchCode + DealerBFEID + BuyLimit + SellLimit + NetLimit + TotalLimit + BuyTopup + SellTopup + NetTopup + TotalTopup + BuyPrevOrderAmt
		+ SellPrevOrderAmt + NetPrevOrderAmt + TotalPrevOrderAmt + LimitCheckFlag + ExceedLimit + TradeStatus + BUYTransLimit + SellTransLimit + BuyLotLimit + SellLotLimit
		+ BuyBidLimit + SellBidLimit + OrderType + OrderModality + TradeControl + DBTOverride + TDayAmendment + Remarks + LoginID + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END