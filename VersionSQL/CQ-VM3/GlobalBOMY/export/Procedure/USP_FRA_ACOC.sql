/****** Object:  Procedure [export].[USP_FRA_ACOC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_ACOC]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(    
	 BranchCode CHAR(10)
	,RemisierCode CHAR(20)
	,ClientCode CHAR(10)
	,CounterConcetrationPercent Decimal(10,2)
   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(    
			BranchCode
			,RemisierCode
			,ClientCode
			,CounterConcetrationPercent
			)	 	
			select  'BrCode'  
			,'RemisierCode'  
			,'ClntCode'  
			,1000
 	     ---FROM CQBTempDB.export.tb_formdata_xxxx

		   SET @RecType=@RecType+1
		END

 	-- RESULT SET
		SELECT   BranchCode
				+ RemisierCode
				+ ClientCode
				+ CAST(CounterConcetrationPercent AS  CHAR(12))
		from #Detail

 	   DROP TABLE #Detail 
END