/****** Object:  Procedure [export].[USP_FRA_ESF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_ESF]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		ESF Decimal(20,2)
		,ESFPercentage Decimal(5,2)
		,KLCIFactor Decimal(5,2)
		,NONKLCIFactor Decimal(5,2)
  	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(    
			 ESF
			,ESFPercentage
			,KLCIFactor
			,NONKLCIFactor
			)	 	
			select 10
			,10
			,10
			,10
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT     CAST(ESF AS  CHAR(22))
			+ CAST(ESFPercentage AS  CHAR(7))
			+ CAST(KLCIFactor AS  CHAR(7))
			+ CAST(NONKLCIFactor AS  CHAR(7))
	from #Detail
    
	DROP TABLE #Detail 
END