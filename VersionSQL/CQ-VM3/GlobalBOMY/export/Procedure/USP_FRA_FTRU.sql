/****** Object:  Procedure [export].[USP_FRA_FTRU]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_FTRU]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	 BranchCode char(6)
	,ClientCode char(20)
	,CurrencyCode char(5)
	,ForeignAmount Decimal(15,2)
	,LocalAmount Decimal(15,2)
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(  
			BranchCode
			,ClientCode
			,CurrencyCode
			,ForeignAmount
			,LocalAmount
			)	 	
			select   'BrCode'  
			,'ClientCode'  
			,'USD'  
			,1000
			,1000
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT    BranchCode
		+ ClientCode
		+ CurrencyCode
		+ CAST(ForeignAmount AS  CHAR(17))
		+ CAST(LocalAmount AS  CHAR(17))
   from #Detail
    
	DROP TABLE #Detail 
END