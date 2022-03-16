/****** Object:  Procedure [export].[USP_BTX_BTXCSHR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCSHR]
(
	@idteProcessDate DATE
)
AS
-- EXEC [export].[USP_BTX_BTXCSHR] '2021-09-12'
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
	VALUES ('H',REPLACE(@idteProcessDate,'-',''),CONVERT(VARCHAR(8),GETDATE(),108),'','BTXEF','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,ClientCode				CHAR(15)
		,BFETradingCode			CHAR(15)
		,ExchCode				CHAR(10)
		,StockCode				CHAR(20)
		,StockShortName			CHAR(20)
		--,FreeQty				DECIMAL(24,4)
		--,PurchaseQty			DECIMAL(24,9)
		--,SalesQty				DECIMAL(24,9)
		,FreeQty				CHAR(13)
		,PurchaseQty			CHAR(13)
		,SalesQty				CHAR(13)
		,Filler					CHAR(10)
		,LastPosition			CHAR(1)
	);
	
	INSERT INTO #Detail
	(
		 RecordType		
		,BranchCode		
		,ClientCode		
		,BFETradingCode	
		,ExchCode		
		,StockCode		
		,StockShortName	
		,FreeQty		
		,PurchaseQty	
		,SalesQty		
		,Filler			
		,LastPosition	
	)
	SELECT 
		1,
		Acct.BranchId,
		A.AcctNo,
		A.AcctNo,
		I.HomeExchCd,
		I.InstrumentCd,
		I.ShortName,
		Balance,
		Borrowed,
		Lent,
		'',
		'T'
	FROM 
		GlobalBO.setup.Tb_Instrument	I
	INNER JOIN CQBTempDB.export.Tb_FormData_1345 Product 
		ON I.ShortName = Product.[CounterShortName (textinput-3)]
	INNER JOIN GlobalBO.holdings.Tb_CustodyAssets A 
		ON I.InstrumentId = A.InstrumentId
	INNER JOIN GlobalBO.setup.Tb_Account AS Acct 
		ON Acct.AcctNo = A.AcctNo;
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
	VALUES(0,@Count,REPLACE(@idteProcessDate,'-',''),@Count,'','T'); 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + BranchCode + ClientCode + BFETradingCode + ExchCode + StockCode + StockShortName + FreeQty + PurchaseQty + SalesQty + Filler + LastPosition
		--+ CAST(FreeQty AS VARCHAR(15)) + CAST(PurchaseQty AS VARCHAR(15)) + CAST(SalesQty AS VARCHAR(15)) + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END