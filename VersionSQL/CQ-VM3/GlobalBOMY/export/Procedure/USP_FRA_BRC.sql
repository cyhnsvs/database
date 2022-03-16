/****** Object:  Procedure [export].[USP_FRA_BRC]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE  PROCEDURE [export].[USP_FRA_BRC]
 AS
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
	  Code  char(6)
	 ,Name  char(50)
 	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(
				 Code  
				,Name    
			)	 	

			SELECT  '07300'+  CAST(@RecType AS CHAR(1)) ,
					'KENANGA INVESTMENT BANK BERHAD (KL)  '  +  CAST(@RecType AS CHAR(1)) 
 	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
		END
 	-- RESULT SET
 	SELECT   Code  + 
			Name  
	FROM #Detail
   
	DROP TABLE #Detail 
END