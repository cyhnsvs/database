/****** Object:  Procedure [export].[USP_SUNGARD_Account]    Committed by VersionSQL https://www.versionsql.com ******/

/*
[export].[USP_N2N_DepositoryMovement] '2/17/22'
*/
create  PROCEDURE [export].[USP_SUNGARD_Account]
 
AS

BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 Ucc varchar(30)  
		,AccountName   varchar(50)  
		,ExtAccid  varchar(40)  
		,Status	  varchar(1)   
	)

		while  @RecType<10
		BEGIN
	INSERT INTO #Detail
	(
		 Ucc 
		,AccountName 
		,ExtAccid
		,Status  
	)	 	

	SELECT  
		 'AP070298' + CAST(@RecType AS CHAR(1)) 
		, 'AP CAPITAL INVESTMENT LIMITED'
		,'AP070298' + CAST(@RecType AS CHAR(1))  
		,'D'		 
 	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
 END
	
	 

	-- RESULT SET
 
	SELECT   Ucc +'|'+
		 AccountName +'|'+
		 ExtAccid+'|'+
		 Status  

	FROM #Detail
 
  
   
	DROP TABLE #Detail 
END