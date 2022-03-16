/****** Object:  Procedure [export].[USP_FRA_REL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_REL]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(  
	ClientCode char(20)
	,RelatedNRIC char(30)
	,RelationShip char(50)
	,RelatedClientCode char(20)
    	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(  ClientCode
				,RelatedNRIC
				,RelationShip
				,RelatedClientCode
			)	 	
			select   'MGNN009063'  
			,'RelatedNRIC'  
			,'RelationShip'  
			,'RelatedClientCode'  
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT    ClientCode
			+RelatedNRIC
			+RelationShip
			+RelatedClientCode
     from #Detail
    
	DROP TABLE #Detail 
END