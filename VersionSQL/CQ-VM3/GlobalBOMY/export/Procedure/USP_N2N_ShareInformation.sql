/****** Object:  Procedure [export].[USP_N2N_ShareInformation]    Committed by VersionSQL https://www.versionsql.com ******/

/*
[export].[USP_N2N_DepositoryMovement] '2/17/22'
*/
CREATE PROCEDURE [export].[USP_N2N_ShareInformation]
 
AS

BEGIN
	-- BATCH HEADER
 	CREATE TABLE #Header
	(
	RecordType CHAR(1),
	HeaderDate CHAR(14),
	Filler1 CHAR(3),
	InterfaceID CHAR(5),
	Filler2 CHAR(3),
	SystemID CHAR(4),
	Filler3 CHAR(48)
	)
	DECLARE @Filler3 char(48)=''

	INSERT INTO #Header
	( 
	RecordType,
	HeaderDate,
	Filler1,
	InterfaceID,
	Filler2,
	SystemID,
	Filler3  
	)
	VALUES ('H',FORMAT(CAST(GETDATE() AS DATETIME),'ddMMyyyyhhmmss'),'   ','n2nef','   ','BOS ',
	@Filler3
	)
 
                                          
 DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType		DECIMAL(1,0),
		 BranchCode		DECIMAL(3,0)
		,CDSNo			CHAR(15)
		,ExchangeCode	char(10)
		,StockCode		CHAR(10)
		,OpeningFreeQty	DECIMAL(13,0) 
		,OpeningPurchaseQty	DECIMAL(13,0) 
		,OpeningSalesQty	DECIMAL(13,0) 
	)

		WHILE  @RecType<10
		  BEGIN
			INSERT INTO #Detail
			(
				RecordType 
				,BranchCode 
				,CDSNo
				,ExchangeCode
				,StockCode
				,OpeningFreeQty
				,OpeningPurchaseQty
				,OpeningSalesQty 
			)	 	

			SELECT @RecType
				,'1'
				, '1235546'
				,'ABD' 
				,'AMZ'		 
				,15	 
				,22 
				,32  
		
	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END
	
	-- BATCH TRAILER

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)
	CREATE TABLE #Trailer
	(
		 RecordType		 CHAR(1)
		,TotNoRecord	 DECIMAL(6,0)
		,ProcessingDate	 char(8)
		,BatchNumber	 DECIMAL(6,0)
	)
	INSERT INTO #Trailer
	(
		 RecordType	
		,TotNoRecord	
		,ProcessingDate	
		,BatchNumber	
	)
	VALUES('0',RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13) ,
	FORMAT(CAST(GETDATE() AS DATETIME),'ddMMyyyy'),1
	) 

	-- RESULT SET
   SELECT CAST(RecordType AS CHAR(1))+
	HeaderDate+
	Filler1+
	InterfaceID +
	Filler2+
	SystemID+
	Filler3 
	from #Header     
	UNION ALL   
	SELECT   
 	 	CAST(RecordType AS CHAR(1))  
		+ CAST(BranchCode AS CHAR(3))
		+ CDSNo
		+ ExchangeCode
		+ StockCode
		+ CAST(OpeningFreeQty AS CHAR(13))
		+ CAST(OpeningPurchaseQty AS CHAR(13))
		+ CAST(OpeningSalesQty AS CHAR(13))
 	FROM #Detail
  	UNION ALL
	SELECT  RecordType	
			+ CAST(TotNoRecord AS CHAR(6))
			+ ProcessingDate	
			+ CAST(BatchNumber AS CHAR(6))
	FROM #Trailer 

	 DROP TABLE #Header
	 DROP TABLE #Detail
	 DROP TABLE #Trailer
END