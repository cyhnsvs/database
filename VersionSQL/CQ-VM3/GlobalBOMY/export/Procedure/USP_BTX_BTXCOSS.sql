/****** Object:  Procedure [export].[USP_BTX_BTXCOSS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCOSS]
(
	@idteProcessDate DATETIME
)
AS
/* Outstanding Contra Summary
EXEC [export].[USP_BTX_BTXCOSS] '2020-06-01'
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
		,Filler3		 CHAR(204)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') , CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCOSS','','BOS','','T');
	
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
		,ContraAmount			DECIMAL(16,2)
		,ContraSetlAmt			DECIMAL(16,2)
		,ContraOSAmt			DECIMAL(16,2)
		,DueDate				CHAR(10)
		,PurchaseAmount			DECIMAL(16,2)
		,SoldAmount				DECIMAL(16,2)
		,ServiceCharge			DECIMAL(16,2)
		,Currency				CHAR(5)
		,InterestAmount			DECIMAL(16,2)
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
		 ,ContraAmount	
		 ,ContraSetlAmt	
		 ,ContraOSAmt	
		 ,DueDate		
		 ,PurchaseAmount	
		 ,SoldAmount		
		 ,ServiceCharge	
		 ,Currency		
		 ,InterestAmount	
		 ,Filler			
		 ,LastPosition				
	)
	-- OUTSTANDING CONTRA SUMMARY

	SELECT 
		1,
		A.BranchId,
		A.AcctNo,
		A.AcctNo,
		C.CloseOutRef,
		CONVERT(CHAR(10),C.CreatedOn,112),
		CASE WHEN T.TransType = 'CHGN'
			 THEN 'Gain'
			 ELSE 'Loss'
		END,
		ABS(SUM(C.ContraQty)),
		I.HomeExchCd,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		I.ShortName,
		SUM(C.ContraAmount),
		ABS(SUM(C.ContraAmount)) - ABS(Balance),
		ABS(Balance),
		CONVERT(CHAR(10),T.SetlDate,112),
		ABS(SUM(C.ContraAmount)),
		ABS(SUM(C.ContraAmount)) + GainLoss,
		C.ServiceCharge,
		C.ContraCurr,
		C.AccruedInterestAmountSetl,
		'',
		'T'
	FROM GlobalBOLocal.RPS.Tb_ContraTransaction C 
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnPaid T 
		ON C.CloseoutRef = T.CloseOutRef AND C.TransType = 'TRBUY'
	INNER JOIN GlobalBO.setup.Tb_Account A 
		On A.AcctNo = T.AcctNo
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON I.InstrumentId = T.InstrumentId
	WHERE T.TransType IN ('CHGN','CHLS') AND InstrumentCd LIKE '%.XKLS%' AND C.CreatedOn = @idteProcessDate
	GROUP BY A.BranchId,A.AcctNo,C.CloseOutRef,CreatedOn, T.TransType,HomeExchCd,InstrumentCd, ShortName,Balance,
		GainLoss, T.SetlDate, C.ServiceCharge,C.ContraCurr,C.AccruedInterestAmountSetl;
	
	-- BATCH TRAILER

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(217)
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
		RecordType + BranchCode + ClientCode + BFETradingCode + ContraNo + ContraDate + ContraType + ContraQty + ExchCode + StockCode + StockShortName + 
		CASE WHEN ContraAmount > 0 THEN RIGHT(REPLICATE('0',16) + CAST(ContraAmount AS VARCHAR),16) ELSE '-' + RIGHT(REPLICATE('0',15) + CAST(ContraAmount AS VARCHAR),15) END
		+ RIGHT(REPLICATE('0',16) + CAST(ContraSetlAmt AS VARCHAR),16)	+ RIGHT(REPLICATE('0',16) + CAST(ContraOSAmt AS VARCHAR),16) 
		+ DueDate + RIGHT(REPLICATE('0',16) + CAST(PurchaseAmount AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(SoldAmount AS VARCHAR),16) 
		+ RIGHT(REPLICATE('0',16) + CAST(ServiceCharge AS VARCHAR),16) + Currency + RIGHT(REPLICATE('0',16) + CAST(InterestAmount AS VARCHAR),16) + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END