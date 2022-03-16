/****** Object:  Procedure [export].[USP_CQTrader_B2BDealerLmt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_CQTrader_B2BDealerLmt]
(
	@idteProcessDate DATE
)
AS
/*
B2B Dealer Limit
EXEC [export].[USP_CQTrader_B2BDealerLmt] '2020-06-01'
*/
BEGIN
	
	-- BATCH DETAILS
	CREATE TABLE #DealerLimit
	(
		 B2BADealerID			CHAR(5)
		,BuyLimit				DECIMAL(19,4)
		,SellLimit				DECIMAL(19,4)
		,BypassLimitCheck		CHAR(1)
	)

	INSERT INTO #DealerLimit
	(
		 B2BADealerID		
		,BuyLimit		
		,SellLimit		
		,BypassLimitCheck						
	)
	SELECT 
		[BFEDealerCode (textinput-26)],
		CASE WHEN [MaxBuyLimit (textinput-7)] = '' THEN '0' ELSE [MaxBuyLimit (textinput-7)] END,
		CASE WHEN [MaxSellLimit (textinput-8)] = '' THEN '0'  ELSE [MaxSellLimit (textinput-8)] END,
		'1'
	FROM 
		CQBTempDB.export.tb_formdata_1377 Dealer 
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1379 DealerMarket ON Dealer.[DealerCode (textinput-35)] = DealerMarket.[DealerCode (selectsource-14)]
	 
		
	-- RESULT SET
	SELECT 
		B2BADealerID + RIGHT(REPLICATE('0',21) + CAST(BuyLimit AS VARCHAR),21) + RIGHT(REPLICATE('0',21) + CAST(SellLimit AS VARCHAR),21) + BypassLimitCheck
	FROM 
		#DealerLimit

END