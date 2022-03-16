/****** Object:  Procedure [export].[USP_N2N_lobcrlimit]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_N2N_lobcrlimit]
(
	@idteProcessDate DATETIME
)
AS
/*

EXEC [export].[USP_N2N_CRLIMIT] '2020-06-01'
*/
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 Header		     CHAR(1)
		,FileDate 		 CHAR(8)
		
	)
	INSERT INTO #Header
	(
		 Header		
		,FileDate 	
		
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'))
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 Detail					CHAR(1)
		,BrokerBranchID			CHAR(5)
		,TradingAccount			CHAR(20)
		,SGTradingAccount		CHAR(20)
		,CDSBranch				CHAR(5)
		,MaxBuyCreditLimit		DECIMAL(21,0)
		,MaxSellCreditLimit		DECIMAL(21,0)
		,MaxNetCreditLimit		DECIMAL(21,0)
		,MaxTotalCreditLimit	DECIMAL(21,0)
		,CBMaxBuyCrLimit 		DECIMAL(21,0)
		,CBMaxSellCrLimit 		DECIMAL(21,0)
		,CBMaxNetCrLimit 		DECIMAL(21,0)
		,CBMaxTotalCrLimit 		DECIMAL(21,0)
		,ClientPercentage 		CHAR(1)
		,CDPAccount 			CHAR(20)
	)

	INSERT INTO #Detail
	(
		 Detail					
		,BrokerBranchID			
		,TradingAccount			
		,SGTradingAccount		
		,CDSBranch				
		,MaxBuyCreditLimit		
		,MaxSellCreditLimit		
		,MaxNetCreditLimit		
		,MaxTotalCreditLimit	
		,CBMaxBuyCrLimit 		
		,CBMaxSellCrLimit 		
		,CBMaxNetCrLimit 		
		,CBMaxTotalCrLimit 		
		,ClientPercentage 		
		,CDPAccount 			
	)
	SELECT 
		 'D'
		,'001'
		,[AccountNumber (textinput-5)]
		,''
		,[CDSACOpenBranch (selectsource-4)]
		,[MaxBuyLimit (textinput-68)]
		,[MaxNetLimit (textinput-70)]
		,[MaxSellLimit (textinput-69)]
		,0
		,0
		,0
		,0
		,0
		,''
		,''
	FROM CQBTempDB.export.tb_formdata_1409
	
	-- BATCH TRAILER

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)
	CREATE TABLE #Trailer
	(
		 Trailer		 CHAR(1)
		,TotNoRecord	 DECIMAL(8,0)
	)
	INSERT INTO #Trailer
	(
		 Trailer	
		,TotNoRecord	
	)
	VALUES('',RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13)) 
		
	-- RESULT SET
	SELECT 
		Header + FileDate 
	FROM #Header
	UNION ALL
	SELECT 
		 Detail	+ BrokerBranchID + TradingAccount + SGTradingAccount + CDSBranch +CAST(MaxBuyCreditLimit AS CHAR(10)) + CAST(MaxSellCreditLimit	AS CHAR(10))
		+CAST(MaxNetCreditLimit AS CHAR(10)) + CAST(MaxTotalCreditLimit AS CHAR(10)) + CAST(CBMaxBuyCrLimit AS CHAR(10)) + CAST(CBMaxSellCrLimit AS CHAR(10)) 
		+ CAST(CBMaxNetCrLimit AS CHAR(10)) + CAST(CBMaxTotalCrLimit AS CHAR(10)) + ClientPercentage + CDPAccount 		
	FROM #Detail
	UNION ALL
	SELECT 
		 Trailer + CAST(TotNoRecord AS CHAR(10))
	FROM #Trailer

	DROP TABLE #Header
	DROP TABLE #Detail
	DROP TABLE #Trailer
END