/****** Object:  Procedure [export].[USP_FRA_DMAMAP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_DMAMAP]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(    
	KIBBClientCode char(20)
	,SunGardClientCode char(20)
	,CDSNumber char(9)
   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(    
			 KIBBClientCode
			,SunGardClientCode
			,CDSNumber
			)		 	
			select  
			'KIBBClientCode'  
			,'SunGardClientCode'  
			,'CDSNumber'  
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT   
			KIBBClientCode
			+SunGardClientCode
			+CDSNumber
    from #Detail
 	DROP TABLE #Detail 
END