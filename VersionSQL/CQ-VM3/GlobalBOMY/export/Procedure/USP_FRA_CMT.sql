/****** Object:  Procedure [export].[USP_FRA_CMT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_CMT]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	 CounterCode CHAR(10)
	,MarginCeilingPrice1 Decimal(10,4)
	,MarginCapRate1 Decimal(10,2)
	,MarginReason1 CHAR(100)
	,MarginCeilingPrice2 Decimal(10,4)
	,MarginCapRate2 Decimal(10,2)
	,MarginReason2 CHAR(100)
	,MarginCeilingPrice3 Decimal(10,4)
	,MarginCapRate3 Decimal(10,2)
	,MarginReason3 CHAR(100)
	,ConcentrationExclusion CHAR(10)
   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(  
			CounterCode
			,MarginCeilingPrice1
			,MarginCapRate1
			,MarginReason1
			,MarginCeilingPrice2
			,MarginCapRate2
			,MarginReason2
			,MarginCeilingPrice3
			,MarginCapRate3
			,MarginReason3
			,ConcentrationExclusion
			)	 	
			select   
			'CntCode'  
			,1000
			,1000
			,'MarginReason1'  
			,1000
			,1000
			,'MarginReason2'  
			,1000
			,1000
			,'MarginReason3'  
			,'CntExcl'  
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		 END

 	-- RESULT SET
	 SELECT   
		CounterCode
		+ CAST(MarginCeilingPrice1 AS  CHAR(14))
		+ CAST(MarginCapRate1 AS  CHAR(12))
		+ MarginReason1
		+ CAST(MarginCeilingPrice2 AS  CHAR(14))
		+ CAST(MarginCapRate2 AS  CHAR(12))
		+ MarginReason2
		+ CAST(MarginCeilingPrice3 AS  CHAR(14))
		+ CAST(MarginCapRate3 AS  CHAR(12))
		+ MarginReason3
		+ ConcentrationExclusion
	 from #Detail
    
	DROP TABLE #Detail 
END