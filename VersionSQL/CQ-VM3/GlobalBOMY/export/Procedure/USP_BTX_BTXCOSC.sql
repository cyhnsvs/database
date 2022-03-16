/****** Object:  Procedure [export].[USP_BTX_BTXCOSC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCOSC]
(
	@idteProcessDate DATETIME
)
AS
/*
Client Account Outstanding Position
EXEC [export].[USP_BTX_BTXCOSC] '2020-06-01'
*/
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(16)
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
		,Filler1	
		,InterfaceID
		,Filler2	
		,SystemID	
		,Filler3	
		,LastPosition
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') + CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCOSC','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,ClientCode				CHAR(15)
		,BFETradingCode			CHAR(9)
		,ContractNo				CHAR(30)
		,TransDate				CHAR(10)
		,TransType				CHAR(1)
		,ExchCode				CHAR(10)
		,StockCode				CHAR(8)
		,StockShortName			CHAR(20)
		,Qty					CHAR(13)
		,Price					CHAR(20)
		,NetAmount				CHAR(16)
		,DueDate				CHAR(10)
		,IntCharge				CHAR(16)
		,IntPaid				CHAR(16)
		,BrokerageRate			CHAR(20)
		,Brokerage				CHAR(16)
		,StampDuty				CHAR(16)
		,ClearingFee			CHAR(16)
		,Currency				CHAR(5)
		,ServiceCharge			CHAR(16)
		,SettledAmt				CHAR(16)
		,SettledQty				CHAR(13)
		,OSAmt					CHAR(16)
		,OSQty					CHAR(13)
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);
	
	INSERT INTO #Detail
	(
		 RecordType			
		,BranchCode			
		,ClientCode			
		,BFETradingCode		
		,ContractNo			
		,TransDate			
		,TransType			
		,ExchCode			
		,StockCode			
		,StockShortName		
		,Qty				
		,Price				
		,NetAmount			
		,DueDate			
		,IntCharge			
		,IntPaid			
		,BrokerageRate		
		,Brokerage			
		,StampDuty			
		,ClearingFee		
		,Currency			
		,ServiceCharge		
		,SettledAmt			
		,SettledQty			
		,OSAmt				
		,OSQty				
		,Filler				
		,LastPosition			
	)
	-- OUTSTANDING CONTRACT
	SELECT 
		1,
		Acct.BranchId,
		C.AcctNo,
		C.AcctNo,
		C.ContractNo,
		CONVERT(CHAR(10),C.ContractDate,112),
		CASE WHEN C.TransType = 'TRBUY'
		     THEN 'P'
			 ELSE 'S'
		END,
		I.HomeExchCd,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		I.ShortName,
		C.TradedQty,
		C.TradedPrice,
		C.NetAmountSetl,
		CONVERT(CHAR(10),C.SetlDate,112),
		C.AccruedInterestAmountSetl,
		T.AccruedInterestAmountSetl,
		Tier.Rate,
		C.ClientBrokerageSetl,
		B.FeeAmountSetl,
		A.FeeAmountSetl,
		C.TradedCurrCd,
		C.ChargesSetl,
		C.NetAmountSetl - T.Balance,
		C.TradedQty - RemainingQty,
		T.Balance,
		RemainingQty,
		'',
		'T'
	FROM GlobalBO.contracts.Tb_ContractOutstanding	C
	INNER JOIN GlobalBO.setup.Tb_Account Acct 
		ON Acct.AcctNo = C.AcctNo
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON I.InstrumentId = C.InstrumentId
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid T 
		ON C.AcctNo = T.AcctNo
	LEFT JOIN GlobalBO.contracts.Tb_Contract C1 
		ON C.ContractNO = C1.ContractNo 
	LEFT JOIN GlobalBO.setup.Tb_BrokerageGroup BR 
		ON C1.BrokerageGroupId = BR.BrokerageGroupId
	LEFT JOIN GlobalBO.setup.Tb_Tier Tier 
		ON BR.TierGroupId = Tier.TierGroupId
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	WHERE C.TransType IN ('TRBUY','TRSELL') AND I.InstrumentCd LIKE '%.XKLS%' AND C.ContractDate = @idteProcessDate;

	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(315)
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
		RecordType + HeaderDate + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + BranchCode + ClientCode + BFETradingCode + ExchCode + StockCode + StockShortName + Qty + Price + NetAmount + DueDate + IntCharge + IntPaid
		+ BrokerageRate + Brokerage + StampDuty + ClearingFee + Currency + ServiceCharge + SettledAmt + SettledQty + OSAmt + OSQty + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END