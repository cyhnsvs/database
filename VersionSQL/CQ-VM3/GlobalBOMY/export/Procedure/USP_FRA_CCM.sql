/****** Object:  Procedure [export].[USP_FRA_CCM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_CCM]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	 ExchangeCode CHAR(10)
	,CounterCode CHAR(10)
	,CeilingPrice Decimal(10,4)
	,CappingPrice Decimal(10,4)
	,ExpireDate DATE
	,AppDate DATE
   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(  
			ExchangeCode
			,CounterCode
			,CeilingPrice
			,CappingPrice
			,ExpireDate
			,AppDate
			)	 	
			select   
			'Bursa'  
			,'CntCode'  
			,1000
			,1000
			,getdate()
			,getdate()
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
		SELECT   +ExchangeCode
			+ CounterCode
			+ CAST(CeilingPrice AS  CHAR(14))
			+ CAST(CappingPrice AS  CHAR(14))
			+ FORMAT (ExpireDate ,'MM-dd-yyyy' )
			+ FORMAT (AppDate ,'MM-dd-yyyy' )
		from #Detail
 	DROP TABLE #Detail 
END