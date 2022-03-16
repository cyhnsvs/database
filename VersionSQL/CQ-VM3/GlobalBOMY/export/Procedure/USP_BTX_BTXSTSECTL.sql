/****** Object:  Procedure [export].[USP_BTX_BTXSTSECTL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXSTSECTL]
(
	@idteProcessDate DATETIME
)
AS
/* 
Stock Sector Trading Limit INFO Export to BTX SubSystem
EXEC [export].[USP_BTX_BTXSTSECTL] '2020-06-01'
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
		,Filler3		 CHAR(169)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXSTSECTL','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,ExchangeCode			CHAR(10)
		,SectorName				CHAR(50)
		,SectorCode				CHAR(10)
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
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		 RecordType			
		,ExchangeCode	
		,SectorName
		,SectorCode	
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
		,Filler				
		,LastPosition		
	)
	SELECT 
		 0 
		,[ExchangeCode (selectsource-1)]
		,[StockSectorName (textinput-2)]
		,[StockSectorCode (textinput-1)]
		,RIGHT(REPLICATE('0',16)+CAST([BuyLimit (textinput-3)] AS VARCHAR(16)),16) 
		,RIGHT(REPLICATE('0',16)+CAST([SellLimit (textinput-4)] AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST([NetLimit (textinput-5)] AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST([TotalLimit (textinput-6)] AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST([BuyTopUp (textinput-7)] AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST([SellTopUp (textinput-8)] AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST([NetTopUp (textinput-9)] AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST([TotalTopUp (textinput-10)] AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST(0 AS VARCHAR(16)),16) 
		,RIGHT(REPLICATE('0',16)+CAST(0 AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST(0 AS VARCHAR(16)),16)  
		,RIGHT(REPLICATE('0',16)+CAST(0 AS VARCHAR(16)),16)  
		,[WithLimit (multipleradiosinline-1)]
		,'' 
		,'T'
	FROM CQBTempDB.export.Tb_FormData_3055 StockSector
	WHERE [StockSectorCode (textinput-1)] = 'XKLS';
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(182)
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
		RecordType + ExchangeCode + SectorName + SectorCode + BuyLimit + SellLimit + NetLimit + TotalLimit + BuyTopup + SellTopup + NetTopup + TotalTopup + BuyPrevOrderAmt
		+ SellPrevOrderAmt + NetPrevOrderAmt + TotalPrevOrderAmt + LimitCheckFlag  + Filler + LastPosition		
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END