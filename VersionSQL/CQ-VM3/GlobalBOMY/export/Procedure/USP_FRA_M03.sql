/****** Object:  Procedure [export].[USP_FRA_M03]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_M03]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	BranchCode char(6)
	,ClientCode CHAR(20)
	,MarginFacility CHAR(12)
	,MarginBalanceD Decimal(20,2)
	,MarginCashA Decimal(20,2)
	,MarginScripsB Decimal(20,2)
	,MarginPurchasesCapValue Decimal(20,2)
	,MarginRatio Decimal(8,2)
	,AppDate DATE
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(     
			BranchCode
			,ClientCode
			,MarginFacility
			,MarginBalanceD
			,MarginCashA
			,MarginScripsB
			,MarginPurchasesCapValue
			,MarginRatio
			,AppDate
			)	 	
			select  '07300'  +CAST(@RecType AS  CHAR(1))	 
			,'ClientCode'  
			,'MarginFac'  
			,1000
			,1000
			,1000
			,1000
			,1000
			,getdate()
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT  BranchCode
		+ClientCode
		+MarginFacility
		+ CAST(MarginBalanceD AS  CHAR(22))
		+ CAST(MarginCashA AS  CHAR(22))
		+ CAST(MarginScripsB AS  CHAR(22))
		+ CAST(MarginPurchasesCapValue AS  CHAR(22))
		+ CAST(MarginRatio AS  CHAR(10))
		+ FORMAT (AppDate ,'dd-MM-yyyy' )
     from #Detail
 	DROP TABLE #Detail 
END