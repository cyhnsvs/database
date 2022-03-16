/****** Object:  Procedure [export].[USP_FRA_M01]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_M01]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	BranchCode char(6)
	,ClientCode char(20)
	,CounterCode char(8)
	,MarginScripsBQty char(12)
	,MarginPurchasesCapCQty char(12)
	,Price Decimal(8,2)
	,CostValueofMarginScripsB Decimal(25,2)
	,CostValueofPurchasesCapC Decimal(25,2)
	,SuspensionIndicator char(1)
	,SuspensionDate date
	,ExclusionIndicator char(1)
	,AppDate date
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(     
			BranchCode
			,ClientCode
			,CounterCode
			,MarginScripsBQty
			,MarginPurchasesCapCQty
			,Price
			,CostValueofMarginScripsB
			,CostValueofPurchasesCapC
			,SuspensionIndicator
			,SuspensionDate
			,ExclusionIndicator
			,AppDate
			)	 	
			select  '07300'  +CAST(@RecType AS  CHAR(1))	 
			,'ClientCode'  
			,'CntCode'  
			,'MSBQty'  
			,'MPGCQty'  
			,1000
			,1000
			,1000
			,'A'  
			,getdate()
			,'0'  
			,getdate()
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
		SELECT   BranchCode
		+ ClientCode
		+ CounterCode
		+ MarginScripsBQty
		+ MarginPurchasesCapCQty
		+ CAST(Price AS  CHAR(10))
		+ CAST(CostValueofMarginScripsB AS  CHAR(27))
		+ CAST(CostValueofPurchasesCapC AS  CHAR(27))
		+ SuspensionIndicator
		+ FORMAT (SuspensionDate ,'dd-MM-yyyy' )
		+ ExclusionIndicator
		+ FORMAT (AppDate ,'dd-MM-yyyy' )
		from #Detail

 	   DROP TABLE #Detail 
END