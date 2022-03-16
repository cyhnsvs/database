/****** Object:  Procedure [export].[USP_FRA_IFMOFPROD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFMOFPROD]
(
	@idteProcessDate DATETIME
)
AS
/*
DEALER DETAILS 
EXEC [export].[USP_FRA_IFMOFPROD] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		     MRKTCD	     CHAR(4)      
		    ,PRODCD	     CHAR(10)     
		    ,KEYCD	     CHAR(10)     
		    ,APPMOFSH	 CHAR(6)      
		    ,CALCMTHD	 CHAR(1)      
		    ,BASEPRCCAP	 DECIMAL(10,6)      
		    ,RELPRCCAP	 CHAR(6)      
		    ,USRCREATED	 CHAR(10)     
		    ,DTCREATED	 CHAR(10)     
		    ,TMCREATED	 CHAR(8)      
		    ,USRUPDATED	 CHAR(10)     
		    ,DTUPDATED	 CHAR(10)     
		    ,TMUPDATED	 CHAR(8)      
		    ,RCDSTAT	 CHAR(1)      
		    ,RCDVERSION	 CHAR(3)      
		    ,PGMLSTUPD	 CHAR(10)     
		    ,TRIGGERACT	 CHAR(1)      
		    ,PRICECAPRT	 CHAR(6)      
		    ,MAXHLDQTY	 CHAR(5)      
		    ,MAXHLDVAL	 CHAR(8)      
		    ,RELMOFSH	 CHAR(6)      
		    ,DTRTEFFECT	 CHAR(10)     
		    ,NPRICECPRT	 CHAR(6)      
		    ,NBASEPRCCP	 CHAR(6)      
		    ,NAPPMOFSH	 CHAR(6)      
		    ,NRELPRCCAP	 CHAR(6)      
		    ,NRELMOFSH	 CHAR(6)      
		    ,CACAPPRC	 CHAR(6)      
		    ,CACAPRT	 CHAR(6)      
		    ,MKTPRICE	 CHAR(6)      
		    ,PRICECPRT1	 DECIMAL(10,6)
		    ,CAPQTYRT	 CHAR(6)      
		    ,MAXCAPQTY	 CHAR(5)      
		    ,NMKTPRICE	 CHAR(6)      
		    ,NPRCCPRT1	 CHAR(6)      
		    ,DTQTEFFECT	 CHAR(10)     
		    ,NCAPQTYRT	 CHAR(6)      
		    ,NMAXCAPQTY	 CHAR(5)      
		    ,RATEIND	 CHAR(1)      
		    ,RTGRACE	 CHAR(2)      
		    ,QTYIND	     CHAR(1)      
		    ,QTYGRACE	 CHAR(2)      
		    ,PRCCAPDT	 CHAR(10)     
		    ,QTYCAPDT	 CHAR(10)     
		    ,DATE1	     CHAR(10)     
		    ,DATE2	     CHAR(10)     
		    ,DATE3	     CHAR(10)     
        	 
	)

	INSERT INTO #Details
	(
		 MRKTCD	    
		,PRODCD	    
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
		,MAXHLDQTY	
		,MAXHLDVAL	
		,RELMOFSH	
		,DTRTEFFECT	
		,NPRICECPRT	
		,NBASEPRCCP	
		,NAPPMOFSH	
		,NRELPRCCAP	
		,NRELMOFSH	
		,CACAPPRC	
		,CACAPRT	
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
		,PRCCAPDT	
		,QTYCAPDT	
		,DATE1	    
		,DATE2	    
		,DATE3	       
	)
	SELECT 
		 HomeExchCd--MRKTCD
		,SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd))--PRODCD
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
		,0--PRICECPRT1
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
		GlobalBO.setup.Tb_PriceCap P
	INNER JOIN
		GlobalBO.setup.Tb_Instrument I ON P.ProductAttributeValue = I.InstrumentId
	WHERE I.InstrumentCd LIKE '%.XKLS%' 
	AND 
		AcctAttributeCd='ANY' 
	AND 
		ProductAttributeCd='InstrumentId'
		
	-- RESULT SET
	SELECT 
		    MRKTCD +  PRODCD +  KEYCD +  APPMOFSH + CALCMTHD +  CAST(BASEPRCCAP AS CHAR) +  RELPRCCAP +  USRCREATED +  DTCREATED +  TMCREATED 
		 +  USRUPDATED +  DTUPDATED +  TMUPDATED +  RCDSTAT +  RCDVERSION +  PGMLSTUPD +  TRIGGERACT +  PRICECAPRT +  MAXHLDQTY 
		 +  MAXHLDVAL +  RELMOFSH +  DTRTEFFECT +  NPRICECPRT +  NBASEPRCCP +  NAPPMOFSH +  NRELPRCCAP +  NRELMOFSH +  CACAPPRC 
		 +  CACAPRT +  MKTPRICE + CAST(PRICECPRT1 AS CHAR) +  CAPQTYRT +  MAXCAPQTY +  NMKTPRICE +  NPRCCPRT1 +  DTQTEFFECT +  NCAPQTYRT 
		 +  NMAXCAPQTY +  RATEIND +  RTGRACE +  QTYIND +  QTYGRACE +  PRCCAPDT +  QTYCAPDT +  DATE1 +  DATE2 +  DATE3	    

	FROM 
		#Details

	DROP TABLE #Details
END