/****** Object:  Procedure [export].[USP_FRA_CHK]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_CHK]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(   
		Headerrecord char(1)
		,FileName char(15)
		,TypeofProcess char(3)
		,AppDate DATE
		,AppTime DATETIME
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(   
			Headerrecord
			,FileName
			,TypeofProcess
			,AppDate
			,AppTime
			)	 	
			select 
			'C'  
			,'FileName'  
			,'M01'  
			,getdate()
			,getdate()
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		 END

 	-- RESULT SET
	 SELECT    
	 Headerrecord
	 + FileName
	 + TypeofProcess
	 + FORMAT (AppDate ,'dd-MM-yyyy' )
	 + FORMAT (AppTime ,'hh:mm:ss' )
     from #Detail
 	DROP TABLE #Detail 
END