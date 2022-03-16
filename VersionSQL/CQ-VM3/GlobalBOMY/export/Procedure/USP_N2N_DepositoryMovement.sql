/****** Object:  Procedure [export].[USP_N2N_DepositoryMovement]    Committed by VersionSQL https://www.versionsql.com ******/

/*
[export].[USP_N2N_DepositoryMovement] '2/17/22'
*/
CREATE PROCEDURE [export].[USP_N2N_DepositoryMovement]
(
	@idteProcessDate DATETIME
)
AS

BEGIN
	-- BATCH HEADER
/*	CREATE TABLE #Header
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
	*/

 DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType			DECIMAL(1,0)
		,CDSNo				CHAR(9)
		,TransactionType	CHAR(2)
		,TransactionDate	DATETIME
		,ReferenceNo		CHAR(14)
		,StockCode			CHAR(6)
		,Quantity			DECIMAL(12,0)
		,TransactionDetail1	CHAR(15)
		,TransactionDetail2	CHAR(15)
		,Status 			CHAR(2)
		,BHBranch 			CHAR(3)
	)
		while  @RecType<10
		BEGIN
	INSERT INTO #Detail
	(
		RecordType 
		,CDSNo	 
		,TransactionType	 
		,TransactionDate 
		,ReferenceNo 
		,StockCode		 
		,Quantity	 
		,TransactionDetail1	 
		,TransactionDetail2	 
		,Status 	 
		,BHBranch 	 	)

	SELECT @RecType
		,'1234567'
		,'T'
		, getdate()
		,'1234567890' 
		,'ABC'		 
		,15	 
		,'TRDET1'	 
		,'TRDET2'	 
		,'S' 	 
		,'BH' 
		
	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
 END
	
	-- BATCH TRAILER
/*
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
		*/
	-- RESULT SET
	/*SELECT 
		Header + FileDate 
	FROM #Header
	UNION ALL*/ 
	SELECT   
	CAST(RecordType AS CHAR(1)) 
		+CDSNo	 
		+TransactionType	 
		+FORMAT (TransactionDate, 'ddMMyyyy')  
		+ReferenceNo 
		+StockCode		  
		+CAST(Quantity AS CHAR(12)) 
		+TransactionDetail1	 
		+TransactionDetail2	 
		+Status 	 
		+BHBranch 
		/*
		 Detail	+ BrokerBranchID + TradingAccount + SGTradingAccount + CDSBranch +
		 CAST(MaxBuyCreditLimit AS CHAR(10)) + CAST(MaxSellCreditLimit	AS CHAR(10))
		+CAST(MaxNetCreditLimit AS CHAR(10)) + CAST(MaxTotalCreditLimit AS CHAR(10)) + 
		CAST(CBMaxBuyCrLimit AS CHAR(10)) + CAST(CBMaxSellCrLimit AS CHAR(10)) 
		+ CAST(CBMaxNetCrLimit AS CHAR(10)) + CAST(CBMaxTotalCrLimit AS CHAR(10)) + ClientPercentage + CDPAccount 		*/
	FROM #Detail

/*	UNION ALL
	SELECT 
		 Trailer + CAST(TotNoRecord AS CHAR(10))
	FROM #Trailer*/

	--DROP TABLE #Header
	DROP TABLE #Detail
	--DROP TABLE #Trailer
END