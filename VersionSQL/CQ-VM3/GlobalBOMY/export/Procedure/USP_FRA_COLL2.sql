/****** Object:  Procedure [export].[USP_FRA_COLL2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_COLL2]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(     
		 BranchCode CHAR(6)
		,ClientCode CHAR(20)
		,KLSECode CHAR(8)
		,Quantity Decimal(10,0)
		,AppDate DATE
     )

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(     
			BranchCode
			,ClientCode
			,KLSECode
			,Quantity
			,AppDate
			)	 	
			select  
			'07300'  + CAST(@RecType AS  CHAR(1))	 
			,'ClientCode'  
			,'KLSECode'  
			,1000
			,getdate()
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT   BranchCode
			+ClientCode
			+KLSECode
			+ CAST(Quantity AS  CHAR(10))
			+ FORMAT (AppDate ,'dd-MM-yyyy' )
     from #Detail
 	DROP TABLE #Detail 
END