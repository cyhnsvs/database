/****** Object:  Procedure [export].[USP_FRA_CM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_CM]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	( 
		ExchangeCode CHAR(10)
		,HolidayDate Date
		,Description CHAR(8)
   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(      
			ExchangeCode
			,HolidayDate
			,Description
			)	 	
			select  '
			ExcCode'  
			,getdate()
			,'Desc'  
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
		SELECT     
		ExchangeCode
		+ FORMAT (HolidayDate ,'dd-MM-yyyy' )
		+ Description
		from #Detail
 		DROP TABLE #Detail 
END