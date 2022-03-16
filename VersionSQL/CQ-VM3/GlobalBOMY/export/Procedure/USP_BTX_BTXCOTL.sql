/****** Object:  Procedure [export].[USP_BTX_BTXCOTL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCOTL]
(
	@idteProcessDate DATETIME
)
AS
/*
COMPANY TRADING LIMIT
EXEC [export].[USP_BTX_BTXCOTL] '2020-06-01'
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
		,Filler3		 CHAR(152)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'), CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCOTL','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,CompanyCode			CHAR(3)
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
		 ,CompanyCode		
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
		'012',
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
		'',
		'T'
	FROM CQBTempDB.export.Tb_FormData_1372 Company;
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(165)
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
		RecordType + CompanyCode+ BuyLimit + SellLimit + NetLimit + TotalLimit + BuyTopup + SellTopup + NetTopup + TotalTopup + BuyPrevOrderAmt
		+ SellPrevOrderAmt + NetPrevOrderAmt + TotalPrevOrderAmt + LimitCheckFlag +  Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END