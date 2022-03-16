/****** Object:  Procedure [export].[USP_FRA_ACTRC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_ACTRC]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(   
	BranchCode CHAR(10)
	,ClientCode CHAR(20)
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
			,CounterConcetrationPercent
			,DateStart
			,DateEnd
            )	 	
			select   
			'BranchCode'  
			,'ClientCode'    
			,1000
			,'01022022'  
			,'01022022'   
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
	    END

 	-- RESULT SET
	 SELECT  BranchCode
			+ ClientCode
			+ CAST(CounterConcetrationPercent AS  CHAR(12))
			+ DateStart
			+ DateEnd





 from #Detail


   
	DROP TABLE #Detail 
END