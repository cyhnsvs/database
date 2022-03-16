/****** Object:  Procedure [export].[USP_FRA_IFMOFACPR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFMOFACPR]
(
	@idteProcessDate DATETIME
)
AS
/*
DEALER DETAILS 
EXEC [export].[USP_FRA_IFMOFACPR] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 MRKTCD      CHAR(4)       
		,PRODCD      CHAR(10)      
		,COMPANYID   CHAR(1)       
		,BRANCHID    CHAR(4)       
		,EAFID       CHAR(3)       
		,ACCTNO      CHAR(10)      
		,ACCTSBNO    CHAR(4)       
		,KEYCD       CHAR(10)      
		,APPMOFSH    CHAR(6)       
		,CALCMTHD    CHAR(1)       
		,BASEPRCCAP  DECIMAL(10,6) 
		,RELPRCCAP   CHAR(6)       
		,USRCREATED  CHAR(6)       
		,DTCREATED   CHAR(10)      
		,TMCREATED   CHAR(8)       
		,USRUPDATED  CHAR(10)      
		,DTUPDATED   CHAR(10)      
		,TMUPDATED   CHAR(8)       
		,RCDSTAT     CHAR(1)       
		,RCDVERSION  CHAR(3)       
		,PGMLSTUPD   CHAR(10)      
		,TRIGGERACT  CHAR(1)       
		,PRICECAPRT  CHAR(6)       
		,RELMOFSH    CHAR(6)       
		,MAXHLDQTY   CHAR(5)       
		,MAXHLDVAL   CHAR(8)       
		,DTRTEFFECT  CHAR(10)      
		,NPRICECPRT  CHAR(6)       
		,NBASEPRCCP  CHAR(6)       
		,NAPPMOFSH   CHAR(6)       
		,NRELPRCCAP  CHAR(6)       
		,NRELMOFSH   CHAR(6)       
		,MKTPRICE    CHAR(6)       
		,PRICECPRT1  CHAR(6)       
		,CAPQTYRT    CHAR(6)       
		,MAXCAPQTY   CHAR(5)       
		,NMKTPRICE   CHAR(6)       
		,NPRCCPRT1   CHAR(6)       
		,DTQTEFFECT  CHAR(10)      
		,NCAPQTYRT   CHAR(6)       
		,NMAXCAPQTY  CHAR(5)       
		,RATEIND     CHAR(1)       
		,RTGRACE     CHAR(2)       
		,QTYIND      CHAR(1)       
		,QTYGRACE    CHAR(2)       
		,DTQTEFF1    CHAR(10)      
		,CAPQTYRT1   CHAR(6)       
		,MAXCAPQT1   CHAR(5)       
		,DTQTEFF2    CHAR(10)      
		,CAPQTYRT2   CHAR(6)       
		,MAXCAPQT2   CHAR(5)       
		,DTQTEFF3    CHAR(10)      
		,CAPQTYRT3   CHAR(6)       
		,MAXCAPQT3   CHAR(5)       
		,PRCCAPDT    CHAR(10)      
		,QTYCAPDT    CHAR(10)      
		,DATE1       CHAR(10)      
		,DATE2       CHAR(10)      
		,DATE3       CHAR(10)      
	)

	INSERT INTO #Details
	(
		  MRKTCD     
		 ,PRODCD     
		 ,COMPANYID  
		 ,BRANCHID   
		 ,EAFID      
		 ,ACCTNO     
		 ,ACCTSBNO   
		 ,KEYCD      
		 ,APPMOFSH   
		 ,CALCMTHD   
		 ,BASEPRCCAP 
		 ,RELPRCCAP  
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
		 ,PRICECAPRT 
		 ,RELMOFSH   
		 ,MAXHLDQTY  
		 ,MAXHLDVAL  
		 ,DTRTEFFECT 
		 ,NPRICECPRT 
		 ,NBASEPRCCP 
		 ,NAPPMOFSH  
		 ,NRELPRCCAP 
		 ,NRELMOFSH  
		 ,MKTPRICE   
		 ,PRICECPRT1 
		 ,CAPQTYRT   
		 ,MAXCAPQTY  
		 ,NMKTPRICE  
		 ,NPRCCPRT1  
		 ,DTQTEFFECT 
		 ,NCAPQTYRT  
		 ,NMAXCAPQTY 
		 ,RATEIND    
		 ,RTGRACE    
		 ,QTYIND     
		 ,QTYGRACE   
		 ,DTQTEFF1   
		 ,CAPQTYRT1  
		 ,MAXCAPQT1  
		 ,DTQTEFF2   
		 ,CAPQTYRT2  
		 ,MAXCAPQT2  
		 ,DTQTEFF3   
		 ,CAPQTYRT3  
		 ,MAXCAPQT3  
		 ,PRCCAPDT   
		 ,QTYCAPDT   
		 ,DATE1      
		 ,DATE2      
		 ,DATE3      
	)
	SELECT 
		  ''
		 ,SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd))  --PRODCD	
		 ,''
		 ,''
		 ,''
		 ,[AccountNumber (textinput-5)]--ACCTNO	
		 ,''
		 ,''
		 ,''
		 ,''
		 ,P.MaximumAmount--BASEPRCCAP	
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
		GlobalBO.[setup].[Tb_PriceCap] P
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON P.ProductAttributeValue = I.InstrumentId
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Acct ON Acct.[AccountNumber (textinput-5)] = P.AcctAttributeValue
	WHERE 
		I.InstrumentCd LIKE '%.XKLS%' 
	AND 
		AcctAttributeCd='AcctNo' 
	AND 
		ProductAttributeCd='InstrumentId'
		
	-- RESULT SET
	SELECT 
		     MRKTCD + PRODCD + COMPANYID + BRANCHID + EAFID + ACCTNO + ACCTSBNO + KEYCD + APPMOFSH + CALCMTHD + CAST(BASEPRCCAP AS CHAR)
		   + RELPRCCAP + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION 
		   + PGMLSTUPD + TRIGGERACT + PRICECAPRT + RELMOFSH + MAXHLDQTY + MAXHLDVAL + DTRTEFFECT + NPRICECPRT + NBASEPRCCP
		   + NAPPMOFSH + NRELPRCCAP + NRELMOFSH + MKTPRICE + PRICECPRT1 + CAPQTYRT + MAXCAPQTY + NMKTPRICE + NPRCCPRT1 
		   + DTQTEFFECT + NCAPQTYRT + NMAXCAPQTY + RATEIND + RTGRACE + QTYIND + QTYGRACE + DTQTEFF1 + CAPQTYRT1 + MAXCAPQT1 
		   + DTQTEFF2 + CAPQTYRT2 + MAXCAPQT2 + DTQTEFF3 + CAPQTYRT3 + MAXCAPQT3 + PRCCAPDT + QTYCAPDT + DATE1 + DATE2 + DATE3     
	FROM 
		#Details

	DROP TABLE #Details
END