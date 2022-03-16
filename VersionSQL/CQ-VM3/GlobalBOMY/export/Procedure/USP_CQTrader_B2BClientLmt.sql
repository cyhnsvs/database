/****** Object:  Procedure [export].[USP_CQTrader_B2BClientLmt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_CQTrader_B2BClientLmt]
(
	@idteProcessDate DATE
)
AS
/*
B2B CLIENT LIMIT 
EXEC [export].[USP_CQTrader_B2BClientLmt] '2020-06-01'
*/
BEGIN
	
	-- BATCH DETAILS
	CREATE TABLE #ClientLimit
	(
		 B2BAcctNo				CHAR(20)
		,BuyLimit				DECIMAL(19,4)
		,SellLimit				DECIMAL(19,4)
		,BypassLimitCheck		CHAR(1)
		,ReturnLimitCheck		CHAR(1)
		,DealerLimitCheck		CHAR(1)
	)

	INSERT INTO #ClientLimit
	(
		 B2BAcctNo		
		,BuyLimit		
		,SellLimit		
		,BypassLimitCheck
		,ReturnLimitCheck
		,DealerLimitCheck						
	)
	SELECT 
		[AccountNumber (textinput-5)],
		CASE 
			WHEN [MaxBuyLimit (textinput-68)] = '' 
			THEN 0 ELSE [MaxBuyLimit (textinput-68)] 
		END,
		CASE 
			WHEN [MaxSellLimit (textinput-69)] = '' 
			THEN 0 ELSE [MaxSellLimit (textinput-69)] 
		END,
		'1',
		'1',
		'1'
	FROM 
		CQBTempDB.export.tb_formdata_1409 Account 
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 Customer ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)] 
		
	-- RESULT SET
	SELECT 
		B2BAcctNo + RIGHT(REPLICATE('0',21) + CAST(BuyLimit AS VARCHAR),21) + RIGHT(REPLICATE('0',21) + CAST(SellLimit AS VARCHAR),21)  + BypassLimitCheck + ReturnLimitCheck + DealerLimitCheck 
	FROM 
		#ClientLimit
	
	DROP TABLE #ClientLimit
END