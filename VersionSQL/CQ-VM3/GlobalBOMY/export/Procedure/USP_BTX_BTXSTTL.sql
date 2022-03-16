/****** Object:  Procedure [export].[USP_BTX_BTXSTTL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXSTTL]
(
	@idteProcessDate DATETIME
)
AS
/*
STOCK TRADING LIMIT
EXEC [export].[USP_BTX_BTXSTTL] '2020-06-01'
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') , CONVERT(VARCHAR(8),@idteProcessDate,108) ,'','BTXSTTL','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,ExchCode				CHAR(10)
		,StockCode				CHAR(8)
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
		,ExchCode			
		,StockCode			
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
		1,
		I.HomeExchCd,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST([NetLimit (textinput-47)] AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST([NetLimit (textinput-47)] AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(0 AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		'1',
		'',
		'T'
	FROM CQBTempDB.export.Tb_FormData_1345 Product
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON Product.[CounterShortName (textinput-3)] = I.ShortName
	WHERE InstrumentCd LIKE '%.XKLS%';
	
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
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') ,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),'','T'); 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + ExchCode + StockCode + BuyLimit + SellLimit + NetLimit + TotalLimit + BuyTopup + SellTopup + NetTopup + TotalTopup + BuyPrevOrderAmt
		+ SellPrevOrderAmt + NetPrevOrderAmt + TotalPrevOrderAmt + LimitCheckFlag + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END