/****** Object:  Procedure [export].[USP_BTX_BTXCURR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCURR]
(
	@idteProcessDate DATETIME
)
AS
/*
Currency   
EXEC [export].[USP_BTX_BTXCURR] '2020-06-01'
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
		,Filler3		 CHAR(1)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'), CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXEF','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,Currency				CHAR(5)
		,BuyRate				DECIMAL(20,8)
		,SellRate				DECIMAL(20,8)
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		 RecordType	
		,Currency	
		,BuyRate	
		,SellRate	
		,Filler		
		,LastPosition
		
	)
	SELECT 
		1,
		OtherCurrCd,
		BuyExchRate,
		SellExchRate,
		'',
		'T'
	FROM GlobalBO.setup.Tb_ExchangeRate
	WHERE BaseCurrCd = 'MYR';
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(14)
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
	VALUES(0,RIGHT(REPLICATE('0',13) + CAST(@Count AS VARCHAR),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),RIGHT(REPLICATE('0',13) + CAST(@Count AS VARCHAR),13),'','T'); 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + Currency + RIGHT(REPLICATE('0',20) + CAST(BuyRate AS VARCHAR) ,20) + RIGHT(REPLICATE('0',20) + CAST(SellRate AS VARCHAR) ,20) +  Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;
END