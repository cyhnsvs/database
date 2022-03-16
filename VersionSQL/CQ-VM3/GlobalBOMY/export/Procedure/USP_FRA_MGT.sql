/****** Object:  Procedure [export].[USP_FRA_MGT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_MGT]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(	BranchCode char(50)
		,ClientCode char(50)
		,LimitRatio char(50)
		,MarginCallRatio char(50)
		,FroceSellRatio char(50)
		,AppDate DATE
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(   
			BranchCode
			,ClientCode
			,LimitRatio
			,MarginCallRatio
			,FroceSellRatio
			,AppDate
			)	 	
			select  'BranchCode'  
			,'ClientCode'  
			,'LimitRatio'  
			,'MarginCallRatio'  
			,'FroceSellRatio'  
			,getdate()
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT    BranchCode
		+ClientCode
		+LimitRatio
		+MarginCallRatio
		+FroceSellRatio
		+ FORMAT (AppDate ,'dd-MM-yyyy' )
   from #Detail
    
	DROP TABLE #Detail 
END