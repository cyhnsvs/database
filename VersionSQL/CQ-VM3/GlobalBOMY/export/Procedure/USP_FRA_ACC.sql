/****** Object:  Procedure [export].[USP_FRA_ACC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_ACC]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	 BranchCode CHAR(10)
	,ClientCode CHAR(20)
	,CounterCode CHAR(10)
	,CeilingPrice Decimal(10,4)
	,CapRate Decimal(10,2)
	,ExposureRate Decimal(10,2)
	,CounterConcetrationPercent Decimal(10,2)
	,DateStart CHAR(10)
	,DateEnd CHAR(10)
   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(   
			BranchCode
			,ClientCode
			,CounterCode
			,CeilingPrice
			,CapRate
			,ExposureRate
			,CounterConcetrationPercent
			,DateStart
			,DateEnd
			 )	 	
			select   
			'BranchCode'  
			,'ClientCode'  
			,'CNTCode'  
			,1000
			,1000
			,1000
			,1000
			,'01022022'  
			,'01022022'   
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		 SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT     BranchCode
				+ClientCode
				+CounterCode
				+ CAST(CeilingPrice AS  CHAR(14))
				+ CAST(CapRate AS  CHAR(12))
				+ CAST(ExposureRate AS  CHAR(12))
				+ CAST(CounterConcetrationPercent AS  CHAR(12))
				+ RIGHT(REPLICATE('0',10)+CAST(CAST(CounterConcetrationPercent AS DECIMAL(7,2)) AS VARCHAR(10)),10) 
				+DateStart
				+DateEnd
	FROM #Detail
    
	DROP TABLE #Detail 
END