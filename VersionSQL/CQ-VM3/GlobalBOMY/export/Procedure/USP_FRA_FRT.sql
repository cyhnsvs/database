/****** Object:  Procedure [export].[USP_FRA_FRT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_FRT]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(   
	CurrencyCode CHAR(5)
	,BuyRate Decimal(20,4)
	,SellRate Decimal(20,4)
	,AppDate CHAR(10)
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(   
			CurrencyCode
			,BuyRate
			,SellRate
			,AppDate
			)	 	
			select
			'USD'  
			,1000
			,1000
			,'24022022'  
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		  SET @RecType=@RecType+1
       END

 	-- RESULT SET
	 SELECT    CurrencyCode
		+ CAST(BuyRate AS  CHAR(24))
		+ CAST(SellRate AS  CHAR(24))
		+ AppDate
     from #Detail
 	DROP TABLE #Detail 
END