/****** Object:  Procedure [export].[USP_SUNGARD_Security_Multi]    Committed by VersionSQL https://www.versionsql.com ******/

/*
[export].[USP_N2N_DepositoryMovement] '2/17/22'
*/
create  PROCEDURE [export].[USP_SUNGARD_Security_Multi]
 
AS

BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
	 EXTSECID varchar(20) 
	,EXCHGID varchar(4) 
	,SECNAME varchar(20) 
	,LOCAL varchar(20) 
	,ISIN varchar(20) 
	,SEDOL varchar(20) 
	,SECNAMEOdd varchar(20) 
	,RIC varchar(20) 
	,BLOOMBERG varchar(20) 
	,LOTSIZE varchar(18) 
 	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(
				 EXTSECID  
				,EXCHGID   
				,SECNAME  
				,LOCAL 
				,ISIN  
				,SEDOL  
				,SECNAMEOdd  
				,RIC  
				,BLOOMBERG  
				,LOTSIZE 
			)	 	

			SELECT  '01150000200'+  CAST(@RecType AS CHAR(1)) ,
			'SEML',
			'MYN0001',
			'0001',
			'MYQ0001OO006',
			'B02JPH6',
			'MYO0001',
			'SCTH.KL',
			'SCT',
			'100'
 	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
 END
	
	 

	-- RESULT SET
 
	SELECT   EXTSECID  +','+
				 EXCHGID   +','+
				 SECNAME  +','+
				 LOCAL +','+
				 ISIN  +','+
				 SEDOL  +','+
				 SECNAMEOdd  +','+
				 RIC  +','+
				 BLOOMBERG  +','+
				 LOTSIZE 

	FROM #Detail
 
  
   
	DROP TABLE #Detail 
END