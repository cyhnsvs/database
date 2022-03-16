/****** Object:  Procedure [export].[USP_BTX_BTXBRTL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXBRTL]
(
	@idteProcessDate DATETIME
)
AS
/* 
Branch Trading Limit INFO Export to BTX SubSystem
EXEC [export].[USP_BTX_BTXBRTL] '2020-06-01'
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
		,Filler3		 CHAR(172)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXBRTL','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,CompanyCode			CHAR(3)
		,BranchCode				CHAR(4)
		,BuyLimit				DECIMAL(16,2)
		,SellLimit				DECIMAL(16,2)
		,NetLimit				DECIMAL(16,2)
		,TotalLimit				DECIMAL(16,2)
		,BuyTopup				DECIMAL(16,2)
		,SellTopup				DECIMAL(16,2)
		,NetTopup				DECIMAL(16,2)
		,TotalTopup				DECIMAL(16,2)
		,BuyPrevOrderAmt		DECIMAL(16,2)
		,SellPrevOrderAmt		DECIMAL(16,2)
		,NetPrevOrderAmt		DECIMAL(16,2)
		,TotalPrevOrderAmt		DECIMAL(16,2)
		,LimitCheckFlag			CHAR(1)
		,ExceedLimit			DECIMAL(16,2)
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		 RecordType			
		,CompanyCode		
		,BranchCode			
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
		,Filler				
		,LastPosition		
	)
	SELECT 
		 0 
		,RIGHT(REPLICATE('0',3)+CAST(1 AS VARCHAR(3)),3) 
		,[BranchID (textinput-1)]  
		,CAST(ISNULL(CASE WHEN ISNULL([MaxBuyLimit (textinput-39)],'') = '' THEN NULL ELSE [MaxBuyLimit (textinput-39)] END,0.00) AS DECIMAL(16,2))
		,CAST(ISNULL(CASE WHEN ISNULL([MaxSellLimit (textinput-40)],'') = '' THEN NULL ELSE [MaxSellLimit (textinput-40)] END,0.00) AS DECIMAL(16,2))
		,CAST(ISNULL(CASE WHEN ISNULL([MaxNetLimit (textinput-41)],'') = '' THEN NULL ELSE [MaxNetLimit (textinput-41)] END,0.00) AS DECIMAL(16,2)) 
		,CAST(ISNULL(CASE WHEN ISNULL([MaxNetLimit (textinput-41)],'') = '' THEN NULL ELSE [MaxNetLimit (textinput-41)] END,0.00) AS DECIMAL(16,2)) 
		,CAST(0 AS DECIMAL(16,2)) 
		,CAST(0 AS DECIMAL(16,2)) 
		,CAST(0 AS DECIMAL(16,2)) 
		,CAST(0 AS DECIMAL(16,2)) 
		,CAST(0 AS DECIMAL(16,2))
		,CAST(0 AS DECIMAL(16,2)) 
		,CAST(0 AS DECIMAL(16,2))  
		,CAST(0 AS DECIMAL(16,2))  
		,'0' 
		,CAST(0 AS DECIMAL(16,2))  
		,'' 
		,'T'
	FROM CQBTempDB.export.Tb_FormData_1374 Branch;
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(185)
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
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),'','T') ;
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + CompanyCode + BranchCode + RIGHT(REPLICATE('0',16) + CAST(BuyLimit AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(SellLimit AS VARCHAR),16) 
		+ RIGHT(REPLICATE('0',16) + CAST(NetLimit AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(TotalLimit AS VARCHAR),16) 
		+ RIGHT(REPLICATE('0',16) + CAST(BuyTopup AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(SellTopup AS VARCHAR),16) 
		+ RIGHT(REPLICATE('0',16) + CAST(NetTopup AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(TotalTopup AS VARCHAR),16) 
		+ RIGHT(REPLICATE('0',16) + CAST(BuyPrevOrderAmt AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(SellPrevOrderAmt AS VARCHAR),16) 
		+ RIGHT(REPLICATE('0',16) + CAST(NetPrevOrderAmt AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(TotalPrevOrderAmt AS VARCHAR),16) 
		+ LimitCheckFlag + RIGHT(REPLICATE('0',16) + CAST(ExceedLimit AS VARCHAR),16) + Filler + LastPosition		
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;
END