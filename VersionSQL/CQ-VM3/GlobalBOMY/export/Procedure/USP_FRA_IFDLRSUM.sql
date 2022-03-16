/****** Object:  Procedure [export].[USP_FRA_IFDLRSUM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFDLRSUM]
(
	@idteProcessDate DATETIME
)
AS
/*
ACCOUNT CASH BALANCE
EXEC [export].[USP_FRA_IFDLRSUM] '2020-06-01'
*/
BEGIN
	
	-- CASH BALANCE
	CREATE TABLE #Details
	(
		 BROKERCD    CHAR(5)
		,DLREAFID    CHAR(3)      
		,DEALERCD    CHAR(4)      
		,DLRDEPM     DECIMAL(6,2)  
		,DLRSHRM     DECIMAL(6,2)  
		,DLRCLTTM    CHAR(4)    
		,DLRNSHRM    DECIMAL(6,2)  
		,MILTP1      CHAR(4)    
		,MILTP2      CHAR(4)    
		,TEXT1       CHAR(10)     
		,TEXT2       CHAR(10)     
		,TEXT3       CHAR(10)     
		,USRCREATED  CHAR(10)     
		,DTCREATED   DATE         
		,TMCREATED   CHAR(8)      
		,USRUPDATED  CHAR(10)     
		,DTUPDATED   DATE         
		,TMUPDATED   CHAR(8)      
		,RCDSTAT     CHAR(1)      
		,RCDVERSION  CHAR(3)      
		,PGMLSTUPD   CHAR(10)     
		,TRIGGERACT  CHAR(1)      
		,DLRROLRATE  CHAR(3)      
		,DLRNETDEPM  CHAR(3)      
		,DLRCOMMULT  CHAR(3)      
		,DLROSPURM   CHAR(3)      
		,RMRGRDCD    CHAR(2)      
		,PRVNETDEPM  CHAR(3)      
		,PRVCSHDEPM  CHAR(3)      
		,PRVSHRM     CHAR(3)      
		,PRVCOMMULT  CHAR(3)      
		,PRVOSPURM   CHAR(3)      
		,PRVCLTTRM   CHAR(3)      
		,LSTROPAYDT  CHAR(10)     
		,PRVNSHRM    CHAR(3)      
		,BUMISTAT    CHAR(1)      
		,PROFTSHRCD  CHAR(3)      
		,BRKGSHRCD   CHAR(3)      
		,SRVOFFCD    CHAR(10)     
		,LMTMULTMTH  CHAR(1)      
		,LMTMULTP1   CHAR(3)      
		,LMTMULTP2   CHAR(3)      
		,LMTMULTP3   CHAR(3)      
		,MAXMULTVAL  CHAR(8)      

	)

	INSERT INTO #Details
	(
		  BROKERCD   
		 ,DLREAFID   
		 ,DEALERCD   
		 ,DLRDEPM    
		 ,DLRSHRM    
		 ,DLRCLTTM   
		 ,DLRNSHRM   
		 ,MILTP1     
		 ,MILTP2     
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
		 ,DLRROLRATE 
		 ,DLRNETDEPM 
		 ,DLRCOMMULT 
		 ,DLROSPURM  
		 ,RMRGRDCD   
		 ,PRVNETDEPM 
		 ,PRVCSHDEPM 
		 ,PRVSHRM    
		 ,PRVCOMMULT 
		 ,PRVOSPURM  
		 ,PRVCLTTRM  
		 ,LSTROPAYDT 
		 ,PRVNSHRM   
		 ,BUMISTAT   
		 ,PROFTSHRCD 
		 ,BRKGSHRCD  
		 ,SRVOFFCD   
		 ,LMTMULTMTH 
		 ,LMTMULTP1  
		 ,LMTMULTP2  
		 ,LMTMULTP3  
		 ,MAXMULTVAL 
		 
	)
	SELECT 
	
		 '001' -- BROKERCD	
		,'' 
		,[DealerCode (textinput-35)]--DEALERCD	
		,'Y'--DLRDEPM	
		,'Y'--DLRSHRM	
		,'' 
		,'Y'--DLRNSHRM	
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
		,[DealerGradeCode (selectsource-13)]--RMRGRDCD	
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
	FROM 
		CQBTempDB.export.Tb_FormData_1377 
	--INNER JOIN 
	--	GlobalBO.holdings.Tb_Cash cash ON Account.[AccountNumber (textinput-5)] =  Cash.AcctNo

		
	-- RESULT SET
	SELECT 
		 BROKERCD + DLREAFID + DEALERCD + DLRDEPM + DLRSHRM + DLRCLTTM + DLRNSHRM + MILTP1 + MILTP2 + TEXT1 + TEXT2      
		+TEXT3 + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD  
		+TRIGGERACT + DLRROLRATE + DLRNETDEPM + DLRCOMMULT + DLROSPURM + RMRGRDCD + PRVNETDEPM + PRVCSHDEPM + PRVSHRM    
		+PRVCOMMULT + PRVOSPURM + PRVCLTTRM + LSTROPAYDT + PRVNSHRM + BUMISTAT + PROFTSHRCD + BRKGSHRCD + SRVOFFCD   
		+LMTMULTMTH + LMTMULTP1 + LMTMULTP2 + LMTMULTP3 + MAXMULTVAL 
	FROM 
		#Details

	DROP TABLE #Details
END