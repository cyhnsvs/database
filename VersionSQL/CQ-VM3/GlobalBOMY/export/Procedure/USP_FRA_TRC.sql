/****** Object:  Procedure [export].[USP_FRA_TRC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_TRC]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(      
	 BranchCode char(6)
	,RemisierCode char(20)
	,CounterCode char(8)
	,Quantity char(10)
	,AmountInCapped Decimal(20,2)
	,AppDate date
    )

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(     
			BranchCode
			,RemisierCode
			,CounterCode
			,Quantity
			,AmountInCapped
			,AppDate
			)	 	
			select  '07300'  +CAST(@RecType AS  CHAR(1))	 
			,'RemisierCode'  
			,'CntrCode'  
			,'22'  
			,1000
			,getdate()
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT  BranchCode
			+ RemisierCode
			+ CounterCode
			+ Quantity
			+ CAST(AmountInCapped AS  CHAR(22))
			+ FORMAT (AppDate ,'dd-MM-yyyy' )
	from #Detail
     
	DROP TABLE #Detail 
END