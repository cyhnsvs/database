/****** Object:  Procedure [export].[USP_FRA_IFMOFAGPR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFMOFAGPR]
(
	@idteProcessDate DATETIME
)
AS
/*
DEALER DETAILS 
EXEC [export].[USP_FRA_IFMOFAGPR] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 MRKTCD			CHAR(4)      
		,PRODCD			CHAR(10)     
		,ACCTGRPCD	    CHAR(8)      
		,KEYCD	        CHAR(10)     
		,APPMOFSH	    CHAR(6)      
		,CALCMTHD	    CHAR(1)      
		,BASEPRCCAP	    DECIMAL(10,6)
		,RELPRCCAP	    CHAR(6)      
		,PRICECAPRT	    CHAR(6)      
		,RELMOFSH	    CHAR(6)      
		,MAXHLDQTY	    CHAR(5)      
		,MAXHLDVAL	    CHAR(8)      
		,DTRTEFFECT	    CHAR(10)     
		,NPRICECPRT	    CHAR(6)      
		,NBASEPRCCP	    CHAR(6)      
		,NAPPMOFSH	    CHAR(6)      
		,NRELPRCCAP	    CHAR(6)      
		,NRELMOFSH	    CHAR(6)      
		,MKTPRICE	    CHAR(6)      
		,PRICECPRT1	    CHAR(6)      
		,CAPQTYRT	    CHAR(6)      
		,MAXCAPQTY	    CHAR(5)      
		,NMKTPRICE	    CHAR(6)      
		,NPRCCPRT1	    CHAR(6)      
		,DTQTEFFECT	    CHAR(10)     
		,NCAPQTYRT	    CHAR(6)      
		,NMAXCAPQTY	    CHAR(5)      
		,RATEIND	    CHAR(1)      
		,RTGRACE	    CHAR(2)      
		,QTYIND	        CHAR(1)      
		,QTYGRACE	    CHAR(2)      
		,USRCREATED	    CHAR(10)     
		,DTCREATED	    CHAR(10)     
		,TMCREATED	    CHAR(8)      
		,USRUPDATED	    CHAR(10)     
		,DTUPDATED	    CHAR(10)     
		,TMUPDATED	    CHAR(8)      
		,RCDSTAT	    CHAR(1)      
		,RCDVERSION	    CHAR(3)      
		,PGMLSTUPD	    CHAR(10)     
		,TRIGGERACT	    CHAR(1)      
		,PRCCAPDT	    CHAR(10)     
		,QTYCAPDT	    CHAR(10)     
		,DATE1	        CHAR(10)     
		,DATE2	        CHAR(10)     
		,DATE3	        CHAR(10)     	 
	)

	INSERT INTO #Details
	(
		 MRKTCD		
		,PRODCD		
		,ACCTGRPCD	
		,KEYCD	    
		,APPMOFSH	
		,CALCMTHD	
		,BASEPRCCAP	
		,RELPRCCAP	
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
		,PRCCAPDT	
		,QTYCAPDT	
		,DATE1	    
		,DATE2	    
		,DATE3	    
	)
	SELECT 
		  ''        			
		 ,SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd))--PRODCD	    
		 ,[AccountGroupCode (textinput-1)]--ACCTGRPCD	    
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
		 
	FROM  
		GlobalBO.[setup].[Tb_PriceCap] P
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON P.ProductAttributeValue = I.InstrumentId
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1437 AcctGrp ON AcctGrp.[AccountGroupCode (textinput-1)] = P.AcctAttributeValue
    WHERE 
		I.InstrumentCd LIKE '%.XKLS%' 
	AND 
		AcctAttributeCd='ServiceType' 
	AND 
		ProductAttributeCd='InstrumentId'
		
	-- RESULT SET
	SELECT 
		   MRKTCD + PRODCD + ACCTGRPCD + KEYCD + APPMOFSH + CALCMTHD +CAST(BASEPRCCAP AS CHAR(8)) + RELPRCCAP + PRICECAPRT + RELMOFSH + MAXHLDQTY + MAXHLDVAL + DTRTEFFECT	              
		+ NPRICECPRT + NBASEPRCCP + NAPPMOFSH + NRELPRCCAP + NRELMOFSH + MKTPRICE + PRICECPRT1 + CAPQTYRT + MAXCAPQTY + NMKTPRICE + NPRCCPRT1 + DTQTEFFECT	              
		+ NCAPQTYRT + NMAXCAPQTY + RATEIND + RTGRACE + QTYIND + QTYGRACE + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT 
		+ RCDVERSION + PGMLSTUPD + TRIGGERACT + PRCCAPDT + QTYCAPDT + DATE1 + DATE2 + DATE3	                  
   
	FROM 
		#Details

	DROP TABLE #Details
END