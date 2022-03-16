/****** Object:  Procedure [export].[USP_FRA_TTM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_TTM]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	( 
	 Type CHAR(3)
	,Description CHAR(100)
  	)
 	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			( Type
			  ,Description
			)	 	
		select 'ADJ', 'Description'  
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END
  	-- RESULT SET
	 SELECT    Type
			+Description
	from #Detail
 	DROP TABLE #Detail 
END