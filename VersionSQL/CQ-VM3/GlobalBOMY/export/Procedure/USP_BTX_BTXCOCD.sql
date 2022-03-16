/****** Object:  Procedure [export].[USP_BTX_BTXCOCD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCOCD]
(
	@idteProcessDate DATETIME
)
AS
/* Contra Details
EXEC [export].[USP_BTX_BTXCOCD] '2020-06-01'
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
		,Filler3		 CHAR(183)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') , CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCOCD','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,ClientCode				CHAR(15)
		,BFETradingCode			CHAR(9)
		,ContraNo				CHAR(30)
		,ContraDate				CHAR(10)
		,ContraType				CHAR(1)
		,ContraQty				CHAR(13)
		,ExchCode				CHAR(10)
		,StockCode				CHAR(10)
		,StockShortName			CHAR(20)
		,ContractNo				CHAR(30)
		,ContractType			CHAR(1)
		,ContractDate			CHAR(10)
		,ContractQty			DECIMAL(13,0)
		,ContractAmount			DECIMAL(16,2)
		,GainLoss				DECIMAL(16,2)
		,Price					DECIMAL(20,8)
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		  RecordType		
		 ,BranchCode		
		 ,ClientCode		
		 ,BFETradingCode	
		 ,ContraNo		
		 ,ContraDate		
		 ,ContraType		
		 ,ContraQty		
		 ,ExchCode		
		 ,StockCode		
		 ,StockShortName	
		 ,ContractNo		
		 ,ContractType	
		 ,ContractDate	
		 ,ContractQty	
		 ,ContractAmount	
		 ,GainLoss		
		 ,Price			
		 ,Filler			
		 ,LastPosition			
	)
	SELECT 
		1,
		'001',
		T.AcctNo,
		T.AcctNo,
		T.CloseOutRef,
		CONVERT(CHAR(8),T.CreatedDate,112),
		CASE WHEN U.TransType = 'CHGN'
		     THEN 'G'
			 WHEN U.TransType  = 'CHLS'
			 THEN 'L'
		END,
		Contra.ContraQty,
		T.ExchCd,
		SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		I.ShortName,
		T.ContractNo,
		CASE WHEN T.TransType = 'TRBUY'
			 THEN 'P'
			 WHEN T.TransType = 'TRSELL'
			 THEN 'S'
		END,
		CONVERT(CHAR(8),T.ContractDate,112),
		T.TradedQty,
		T.NetAmountSetl,
		Contra.GainLoss,
		Contra.TradedPrice,
		'',
		'T'
	FROM GlobalBOLocal.RPS.Tb_ContraTransaction	Contra
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid T 
		ON Contra.TransReference LIKE '%' +T.ContractNo+'%'
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid U 
		ON T.CloseOutRef = U.ContractNo
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON T.InstrumentId =  I.InstrumentId	
	WHERE I.InstrumentCd LIKE '%.XKLS%' AND Contra.CreatedOn = @idteProcessDate;					
		
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(196)
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
	VALUES(0,@Count,FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),@Count,'','T'); 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		   RecordType		
		 + BranchCode		
		 + ClientCode		
		 + BFETradingCode	
		 + ContraNo		
		 + ContraDate		
		 + ContraType		
		 + ContraQty		
		 + ExchCode		
		 + StockCode		
		 + StockShortName	
		 + ContractNo		
		 + ContractType	
		 + ContractDate	
		 + RIGHT(REPLICATE('0',13) + CAST(ContractQty AS VARCHAR),13)
		 + RIGHT(REPLICATE('0',16) + CAST(ContractAmount AS VARCHAR),16)
		 + CASE WHEN GainLoss > 0 THEN RIGHT(REPLICATE('0',16) + CAST(GainLoss AS VARCHAR),16) ELSE '-' + RIGHT(REPLICATE('0',15) + CAST(GainLoss AS VARCHAR),15) END	
		 + RIGHT(REPLICATE('0',16) + CAST(Price AS VARCHAR),20)		
		 + Filler			
		 + LastPosition	
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + RIGHT(REPLICATE('0',13) + RTRIM(TrailerCount),13) +	ProcessingDate + RIGHT(REPLICATE('0',13) + RTRIM(HASHTotal),13) + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END