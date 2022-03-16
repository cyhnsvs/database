/****** Object:  Procedure [export].[USP_FRA_IFPRODUCT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFPRODUCT]
(
	@idteProcessDate DATETIME
)
AS
/*
PRODUCT DETAILS 
EXEC [export].[USP_FRA_IFPRODUCT] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 MRKTCD      CHAR(4)						
		,PRODCD      CHAR(10)       
		,PRODCD1     CHAR(10)       
		,SHRGRDCD    CHAR(2)        
		,REGISTRCD   CHAR(5)        
		,SECINCD     CHAR(15)       
		,PRODCLSCD   CHAR(5)        
		,BASISCD     CHAR(1)        
		,DESCRIPTN   CHAR(30)       
		,MRKTSYMB    CHAR(10)       
		,LOTSIZE     CHAR(3)        
		,DTBEGTRD    CHAR(10)       
		,DTENDTRD    CHAR(10)       
		,PRODSTAT    CHAR(1)        
		,DTSUSPND    CHAR(10)           
		--,PRICECAP    DECIMAL(10,6)  
		,PRICECAP    DECIMAL(10,6)  
		,CLOSEPRICE  DECIMAL(10,6)  
		,CLSPRCDT    CHAR(10)           
		,CDSSHARE    CHAR(1)        
		,CDSTRADDT   CHAR(10)       
		,DTSTARTCDS  CHAR(10)       
		,DTENDCDS    CHAR(10)       
		,SHORTSELL   CHAR(1)        
		,DTSTARTRBL  CHAR(10)       
		,DTENDRBL    CHAR(10)       
		,PHYQT       CHAR(5)        
		,CDSQT       CHAR(5)        
		,SHRHLDVAL   CHAR(8)        
		,SHRHLDCOST  CHAR(8)        
		,USRCREATED  CHAR(10)       
		,DTCREATED   CHAR(10)       
		,TMCREATED   CHAR(8)        
		,USRUPDATED  CHAR(10)       
		,DTUPDATED   CHAR(10)       
		,TMUPDATED   CHAR(8)        
		,RCDSTAT     CHAR(1)        
		,RCDVERSION  CHAR(3)        
		,PGMLSTUPD   CHAR(10)       
		,TRIGGERACT  CHAR(1)        
		,RBLCD       CHAR(1)        
		,ODDLOTIND   CHAR(1)        
		,CALLWARIND  CHAR(1)        
		,DTEXERASE   CHAR(10)       
		,DTMATURE    CHAR(10)           
		,PREMPRC     CHAR(6)        
		,EXERPRC     DECIMAL(10,6)  
		,ISSUER      CHAR(30)       
		,MAXPRCLCHK  CHAR(3)        
		,MINPRCLCHK  CHAR(3)        
		,MASANAME    CHAR(20)       
		,TEXT1       CHAR(10)       
		,TEXT2       CHAR(10)       
		,TEXT3       CHAR(10)       
		,AMOUNT1     CHAR(8)        
		,AMOUNT2     CHAR(8)        
		,ABRNAME     CHAR(20)       
		,REGISTRCHG  CHAR(3)        
		,REMARKCD    CHAR(4)        
		,BRKGCD      CHAR(2)        
		,SRVRTCDDS   CHAR(3)        
		,DTSTARTMRG  CHAR(10)       
		,DTENDMRG    CHAR(10)       
		,CONVFEEAMT  CHAR(8)        
		,DATE1       CHAR(10)       
		,DATE2       CHAR(10)       
		,DTRELISTED  CHAR(10)       
		,PROFITIND   CHAR(1)        
		,SUSPDREASN  CHAR(4)        
		,INTSUSPDRE  CHAR(4)        
		,DTINTSUSPD  CHAR(10)       
		,SRVRTCDCF   CHAR(3)        
		,SRVRTCDST   CHAR(3)        
		,SRVRTCDVT   CHAR(3)        
		,COMPDS      CHAR(1)        
		,COMPCF      CHAR(1)        
		,COMPST      CHAR(1)        
		,COMPVT      CHAR(1)        
		,CONVPRIC    CHAR(6)        
		,COUPONR     CHAR(5)        
		,PERIODTYPE  CHAR(1)        
		,CALCMTD     CHAR(1)        
		,CURRCODE    CHAR(3)        
	)

	INSERT INTO #Details
	(
		  MRKTCD     
		 ,PRODCD     
		 ,PRODCD1    
		 ,SHRGRDCD   
		 ,REGISTRCD  
		 ,SECINCD    
		 ,PRODCLSCD  
		 ,BASISCD    
		 ,DESCRIPTN  
		 ,MRKTSYMB   
		 ,LOTSIZE    
		 ,DTBEGTRD   
		 ,DTENDTRD   
		 ,PRODSTAT   
		 ,DTSUSPND   
		 ,PRICECAP   
		 ,CLOSEPRICE 
		 ,CLSPRCDT   
		 ,CDSSHARE   
		 ,CDSTRADDT  
		 ,DTSTARTCDS 
		 ,DTENDCDS   
		 ,SHORTSELL  
		 ,DTSTARTRBL 
		 ,DTENDRBL   
		 ,PHYQT      
		 ,CDSQT      
		 ,SHRHLDVAL  
		 ,SHRHLDCOST 
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
		 ,RBLCD      
		 ,ODDLOTIND  
		 ,CALLWARIND 
		 ,DTEXERASE  
		 ,DTMATURE   
		 ,PREMPRC    
		 ,EXERPRC    
		 ,ISSUER     
		 ,MAXPRCLCHK 
		 ,MINPRCLCHK 
		 ,MASANAME   
		 ,TEXT1      
		 ,TEXT2      
		 ,TEXT3      
		 ,AMOUNT1    
		 ,AMOUNT2    
		 ,ABRNAME    
		 ,REGISTRCHG 
		 ,REMARKCD   
		 ,BRKGCD     
		 ,SRVRTCDDS  
		 ,DTSTARTMRG 
		 ,DTENDMRG   
		 ,CONVFEEAMT 
		 ,DATE1      
		 ,DATE2      
		 ,DTRELISTED 
		 ,PROFITIND  
		 ,SUSPDREASN 
		 ,INTSUSPDRE 
		 ,DTINTSUSPD 
		 ,SRVRTCDCF  
		 ,SRVRTCDST  
		 ,SRVRTCDVT  
		 ,COMPDS     
		 ,COMPCF     
		 ,COMPST     
		 ,COMPVT     
		 ,CONVPRIC   
		 ,COUPONR    
		 ,PERIODTYPE 
		 ,CALCMTD    
		 ,CURRCODE    
	)
	SELECT 
		  [MarketCode (selectsource-11)] --MRKTCD   
		 ,SUBSTRING([InstrumentCode (textinput-49)],0,CHARINDEX('.',[InstrumentCode (textinput-49)]))--PRODCD      CHAR(10)  
		 ,''
		 ,[ShareGrade (selectsource-4)]--SHRGRDCD  
		 ,''
		 ,''
		 ,[ProductClass (selectsource-3)]--PRODCLSCD   
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,[Datesuspended (dateinput-8)]--DTSUSPND 
		 ,CAST(PriceCap AS DECIMAL(10, 6)) --PRICECAP  
		 ,CAST([Closingprice (textinput-18)] AS DECIMAL(10, 6)) --CLOSEPRICE 
		 ,[Closingpricedate (dateinput-10)]--CLSPRCDT 
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
		 ,[Maturitydate (dateinput-13)]--,DTMATURE  
		 ,''
		 ,CAST([Exerciseprice (textinput-45)] AS DECIMAL(10, 6)) --EXERPRC 
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,ShortName--ABRNAME 
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
	 FROM 
		CQBTempDB.export.Tb_FormData_1345 F
	 INNER JOIN 
		GlobalBO.setup.Tb_Instrument INS ON INS.InstrumentCd = F.[InstrumentCode (textinput-49)]
	 INNER JOIN 
		GlobalBO.setup.Tb_PriceCap_20200817 PRICE ON PRICE.InstrumentId = INS.InstrumentId
	
	-- RESULT SET
	SELECT 
		     MRKTCD + PRODCD + PRODCD1 + SHRGRDCD + REGISTRCD + SECINCD + PRODCLSCD + BASISCD + DESCRIPTN + MRKTSYMB + LOTSIZE + DTBEGTRD   
		   + DTENDTRD + PRODSTAT + DTSUSPND + CAST(PRICECAP AS CHAR(10)) + CAST(CLOSEPRICE AS CHAR(10)) + CLSPRCDT + CDSSHARE + CDSTRADDT + DTSTARTCDS + DTENDCDS + SHORTSELL  
		   + DTSTARTRBL + DTENDRBL + PHYQT + CDSQT + SHRHLDVAL + SHRHLDCOST + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED  
		   + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + RBLCD + ODDLOTIND + CALLWARIND + DTEXERASE +CAST(DTMATURE AS CHAR(10))+ PREMPRC    
		   +CAST(EXERPRC AS CHAR(10)) + ISSUER + MAXPRCLCHK + MINPRCLCHK + MASANAME + TEXT1 + TEXT2 + TEXT3 + AMOUNT1 + AMOUNT2 + CAST(ABRNAME AS CHAR(10)) + REGISTRCHG 
		   + REMARKCD + BRKGCD + SRVRTCDDS + DTSTARTMRG + DTENDMRG + CONVFEEAMT + DATE1 + DATE2 + DTRELISTED + PROFITIND + SUSPDREASN 
		   + INTSUSPDRE + DTINTSUSPD + SRVRTCDCF + SRVRTCDST + SRVRTCDVT + COMPDS + COMPCF + COMPST + COMPVT + CONVPRIC + COUPONR    
		   + PERIODTYPE + CALCMTD + CURRCODE    
	FROM 
		#Details

	DROP TABLE #Details
END