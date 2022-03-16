/****** Object:  Procedure [export].[USP_SUNGARD_Client]    Committed by VersionSQL https://www.versionsql.com ******/

/*
[export].[USP_N2N_DepositoryMovement] '2/17/22'
*/
create  PROCEDURE [export].[USP_SUNGARD_Client]
 
AS

BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 EXTCLNID varchar(30)  
		,CLIENTNAME   varchar(50)  
		,STATUS  varchar(1)  
		,FIRMID	  varchar(30)   
	)

		while  @RecType<10
		BEGIN
	INSERT INTO #Detail
	(
		 EXTCLNID 
		,CLIENTNAME 
		,STATUS
		,FIRMID  
	)	 	

	SELECT  
		 'AP070298' + CAST(@RecType AS CHAR(1)) 
		, 'AP CAPITAL INVESTMENT LIMITED' 
		,'A','KIBB'	 
 	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
 END
	
	 

	-- RESULT SET
 
	SELECT   EXTCLNID +'|'+
		 CLIENTNAME +'|'+
		 STATUS+'|'+
		 FIRMID  

	FROM #Detail
 
  
   
	DROP TABLE #Detail 
END