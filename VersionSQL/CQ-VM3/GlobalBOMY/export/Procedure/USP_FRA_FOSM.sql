/****** Object:  Procedure [export].[USP_FRA_FOSM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_FOSM]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	KIBBStockCode char(8)
	,ForeignStockCode char(10)
	,ForeignStockName char(60)
	,ForeignMarketCode char(2)
	,ForeignExchangeCode char(4)
	,ForeignClosingPrice Decimal(18,4)
	,ISIN char(20)
	,ProcessDate date
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(   
			 KIBBStockCode
			,ForeignStockCode
			,ForeignStockName
			,ForeignMarketCode
			,ForeignExchangeCode
			,ForeignClosingPrice
			,ISIN
			,ProcessDate
			)	 	
			select  
			'KIBBSC'  
			,'FnStCode'  
			,'FnStockName'  
			,'FC'  
			,'FExC'  
			,1000
			,'ISIN'  
			,getdate()
     	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT   KIBBStockCode
			+ ForeignStockCode
			+ ForeignStockName
			+ ForeignMarketCode
			+ ForeignExchangeCode
			+ CAST(ForeignClosingPrice AS  CHAR(22))
			+ ISIN
			+ FORMAT (ProcessDate ,'dd-MM-yyyy' )
     from #Detail


   
	DROP TABLE #Detail 
END