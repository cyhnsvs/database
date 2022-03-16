/****** Object:  Procedure [export].[USP_FRA_IFDLRGRADE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFDLRGRADE]
(
	@idteProcessDate DATETIME
)
AS
/*
DEALER DETAILS 
EXEC [export].[USP_FRA_IFDLRGRADE] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 DLRGRDCD   CHAR(2)     
		,DESCRIPTN  CHAR(30)    
		,DLRNETDEPM CHAR(3)     
		,DLRCOMMULT DECIMAL(5,2)
		,DLROSPURM  CHAR(3)     
		,DLRCSHDEPM CHAR(3)     
		,DLRSHRM    CHAR(3)     
		,IND1       CHAR(1)     
		,IND2       CHAR(1)     
		,IND3       CHAR(1)     
		,RATE1      CHAR(3)     
		,RATE2      CHAR(3)     
		,RATE3      CHAR(3)     
		,QUANTITY1  CHAR(5)     
		,QUANTITY2  CHAR(5)     
		,QUANTITY3  CHAR(5)     
		,AMOUNT1    CHAR(8)     
		,AMOUNT2    CHAR(8)     
		,AMOUNT3    CHAR(8)     
		,TEXT1      CHAR(10)    
		,TEXT2      CHAR(10)    
		,TEXT3      CHAR(10)    
		,USRCREATED CHAR(10)    
		,DTCREATED  CHAR(10)    
		,TMCREATED  CHAR(8)     
		,USRUPDATED CHAR(10)    
		,DTUPDATED  CHAR(10)    
		,TMUPDATED  CHAR(8)     
		,RCDSTAT    CHAR(1)     
		,RCDVERSION CHAR(3)     
		,PGMLSTUPD  CHAR(10)    
		,TRIGGERACT CHAR(1)     
		,DLRNSHM    CHAR(3)     
		,LMTMULTMTH CHAR(1)     
		,LMTMULTP1  CHAR(3)     
		,LMTMULTP2  CHAR(3)     
		,LMTMULTP3  CHAR(3)     
		,MAXMULTVAL CHAR(8)     
	)

	INSERT INTO #Details
	(
		  DLRGRDCD   
		 ,DESCRIPTN  
		 ,DLRNETDEPM 
		 ,DLRCOMMULT 
		 ,DLROSPURM  
		 ,DLRCSHDEPM 
		 ,DLRSHRM    
		 ,IND1       
		 ,IND2       
		 ,IND3       
		 ,RATE1      
		 ,RATE2      
		 ,RATE3      
		 ,QUANTITY1  
		 ,QUANTITY2  
		 ,QUANTITY3  
		 ,AMOUNT1    
		 ,AMOUNT2    
		 ,AMOUNT3    
		 ,TEXT1      
		 ,TEXT2      
		 ,TEXT3      
		 ,USRCREATED 
		 ,DTCREATED  
		 ,TMCREATED  
		 ,USRUPDATED 
		 ,DTUPDATED  
		 ,TMUPDATED  
		 ,RCDSTAT    
		 ,RCDVERSION 
		 ,PGMLSTUPD  
		 ,TRIGGERACT 
		 ,DLRNSHM    
		 ,LMTMULTMTH 
		 ,LMTMULTP1  
		 ,LMTMULTP2  
		 ,LMTMULTP3  
		 ,MAXMULTVAL 
	)
	--SELECT 
	Values(
		  'Y'
		 ,''
		 ,''
		 ,'Y'
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		  )
	--FROM 
	--	CQBTempDB.export.Tb_FormData_1409 Account
	--INNER JOIN 
	--	GlobalBO.holdings.Tb_Cash cash ON Account.[AccountNumber (textinput-5)] =  Cash.AcctNo
			
	-- RESULT SET
	SELECT 
		 DLRGRDCD +DESCRIPTN +DLRNETDEPM +DLRCOMMULT +DLROSPURM +DLRCSHDEPM +DLRSHRM +IND1 +IND2 +IND3 +RATE1 + RATE2 +RATE3 
		 + QUANTITY1 + QUANTITY2 + QUANTITY3 +AMOUNT1 + AMOUNT2 + AMOUNT3 + TEXT1 + TEXT2 + TEXT3  + USRCREATED + DTCREATED 
		 + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + DLRNSHM 
		 + LMTMULTMTH + LMTMULTP1 + LMTMULTP2 + LMTMULTP3 + MAXMULTVAL
	FROM 
		#Details

	DROP TABLE #Details
END