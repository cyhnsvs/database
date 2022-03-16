/****** Object:  Procedure [export].[USP_FRA_IFRSKPRDAC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFRSKPRDAC]
(
	@idteProcessDate DATETIME
)
AS
/*
PRODUCT DETAILS 
EXEC [export].[USP_FRA_IFRSKPRDAC] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 MRKTCD	     CHAR(4)
		,PRODCD	     CHAR(10)
		,COMPANYID	 CHAR(1)
		,BRANCHID	 CHAR(4)
		,EAFID	     CHAR(3)
		,ACCTNO	     CHAR(10)
		,ACCTSBNO	 CHAR(4)
		,SHRQTY	     CHAR(6)
		,SHRQTYMG	 CHAR(6)
		,SHRQTYNM	 CHAR(6)
		,POSTQTY	 CHAR(6)
		,POSTQTYMG	 CHAR(6)
		,POSTQTYNM	 CHAR(6)
		,POSTAMT	 CHAR(8)
		,POSTAMTMG	 CHAR(8)
		,POSTAMTNM	 CHAR(8)
		,SOSTQTY	 CHAR(6)
		,SOSTQTYMG	 CHAR(6)
		,SOSTQTYNM	 CHAR(6)
		,SOSTAMT	 CHAR(8)
		,SOSTAMTMG	 CHAR(8)
		,SOSTAMTNM	 CHAR(8)
		,PORDQTY	 CHAR(6)
		,PORDQTYMG	 CHAR(6)
		,PORDQTYNM	 CHAR(6)
		,PORDAMT	 CHAR(8)
		,PORDAMTMG	 CHAR(8)
		,PORDAMTNM	 CHAR(8)
		,SORDQTY	 CHAR(6)
		,SORDQTYMG	 CHAR(6)
		,SORDQTYNM	 CHAR(6)
		,SORDAMT	 CHAR(8)
		,SORDAMTMG	 CHAR(8)
		,SORDAMTNM	 CHAR(8)
		,PTRDQTY	 CHAR(6)
		,PTRDQTYMG	 CHAR(6)
		,PTRDQTYNM	 CHAR(6)
		,PTRDAMT	 CHAR(8)
		,PTRDAMTMG	 CHAR(8)
		,PTRDAMTNM	 CHAR(8)
		,STRDQTY	 CHAR(6)
		,STRDQTYMG	 CHAR(6)
		,STRDQTYNM	 CHAR(6)
		,STRDAMT	 CHAR(8)
		,STRDAMTMG	 CHAR(8)
		,STRDAMTNM	 CHAR(8)
		,CUSTKEY	 CHAR(10)
		,ACCTGRPCD	 CHAR(5)
		,ACCTTYPECD	 CHAR(2)
		,PARACGRPCD	 CHAR(5)
		,USRCREATED	 CHAR(10)
		,DTCREATED	 CHAR(10)
		,TMCREATED	 CHAR(8)
		,USRUPDATED	 CHAR(10)
		,DTUPDATED	 CHAR(10)
		,TMUPDATED	 CHAR(8)
		,PGMLSTUPD	 CHAR(10)
		,RCDSTAT	 CHAR(1)
		,RCDVERSION	 CHAR(3)
		,TRIGGERACT	 CHAR(1)
		,ENTITLQTY	 CHAR(5)
		,CAPPRC	     DECIMAL(10,6)
		,CACAPPRC	 CHAR(6)
		,CURRPRC	 CHAR(6)
		,CAPQTY	     CHAR(5)
		,VALQTY	     CHAR(5)
		,VALENTITL	 CHAR(5)
		,SHRMKTVAL	 CHAR(8)
		,SHRMGNVAL	 CHAR(8)
		,SECSHRMULT	 CHAR(3)
		,SHRMGNMULT	 CHAR(8)
		,PENDQTY	 CHAR(5)
		,THRDFQTY	 CHAR(5)
		,THRDTQTY	 CHAR(5)      
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
		 ,SHRQTY	   
		 ,SHRQTYMG	
		 ,SHRQTYNM	
		 ,POSTQTY	
		 ,POSTQTYMG	
		 ,POSTQTYNM	
		 ,POSTAMT	
		 ,POSTAMTMG	
		 ,POSTAMTNM	
		 ,SOSTQTY	
		 ,SOSTQTYMG	
		 ,SOSTQTYNM	
		 ,SOSTAMT	
		 ,SOSTAMTMG	
		 ,SOSTAMTNM	
		 ,PORDQTY	
		 ,PORDQTYMG	
		 ,PORDQTYNM	
		 ,PORDAMT	
		 ,PORDAMTMG	
		 ,PORDAMTNM	
		 ,SORDQTY	
		 ,SORDQTYMG	
		 ,SORDQTYNM	
		 ,SORDAMT	
		 ,SORDAMTMG	
		 ,SORDAMTNM	
		 ,PTRDQTY	
		 ,PTRDQTYMG	
		 ,PTRDQTYNM	
		 ,PTRDAMT	
		 ,PTRDAMTMG	
		 ,PTRDAMTNM	
		 ,STRDQTY	
		 ,STRDQTYMG	
		 ,STRDQTYNM	
		 ,STRDAMT	
		 ,STRDAMTMG	
		 ,STRDAMTNM	
		 ,CUSTKEY	
		 ,ACCTGRPCD	
		 ,ACCTTYPECD
		 ,PARACGRPCD
		 ,USRCREATED
		 ,DTCREATED	
		 ,TMCREATED	
		 ,USRUPDATED
		 ,DTUPDATED	
		 ,TMUPDATED	
		 ,PGMLSTUPD	
		 ,RCDSTAT	
		 ,RCDVERSION
		 ,TRIGGERACT
		 ,ENTITLQTY	
		 ,CAPPRC	   
		 ,CACAPPRC	
		 ,CURRPRC	
		 ,CAPQTY	   
		 ,VALQTY	   
		 ,VALENTITL	
		 ,SHRMKTVAL	
		 ,SHRMGNVAL	
		 ,SECSHRMULT
		 ,SHRMGNMULT
		 ,PENDQTY	
		 ,THRDFQTY	
		 ,THRDTQTY	    
	)
	SELECT 
		 ''     			
		 ,SUBSTRING(INS.InstrumentCd,0,CHARINDEX('.',INS.InstrumentCd)) --PRODCD    
		 ,''     		
		 ,''     		
		 ,''     		
		 ,CON.AcctNo--ACCTNO    
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
		 ,''     		
		 ,''     		
		 ,''     		
		 ,''     		
		 ,''     		
		 ,''     		
		 ,''     		
		 ,PRICE.PriceCap --CAPPRC   
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
		GlobalBO.Contracts.Tb_ContractOutstanding CON
	 INNER JOIN 
		CQBTempDB.export.tb_formdata_1409 BRANCH ON BRANCH.[AccountNumber (textinput-5)] = CON.AcctNo
	 INNER JOIN 
		GlobalBO.setup.Tb_instrument INS ON INS.InstrumentId = CON.InstrumentId
	 INNER JOIN 
		GlobalBO.setup.Tb_PriceCap_20200817 PRICE ON PRICE.InstrumentId = INS.InstrumentId
	 WHERE INS.InstrumentCd LIKE '%.XKLS%' 
	
	-- RESULT SET
	SELECT 
		    MRKTCD + PRODCD + COMPANYID + BRANCHID + EAFID + ACCTNO + ACCTSBNO + SHRQTY + SHRQTYMG + SHRQTYNM + POSTQTY + POSTQTYMG + POSTQTYNM 
			+ POSTAMT + POSTAMTMG + POSTAMTNM + SOSTQTY + SOSTQTYMG + SOSTQTYNM + SOSTAMT + SOSTAMTMG + SOSTAMTNM + PORDQTY + PORDQTYMG + PORDQTYNM 
			+ PORDAMT + PORDAMTMG + PORDAMTNM + SORDQTY + SORDQTYMG + SORDQTYNM + SORDAMT + SORDAMTMG + SORDAMTNM + PTRDQTY + PTRDQTYMG + PTRDQTYNM 
			+ PTRDAMT + PTRDAMTMG + PTRDAMTNM + STRDQTY + STRDQTYMG + STRDQTYNM + STRDAMT + STRDAMTMG + STRDAMTNM + CUSTKEY + ACCTGRPCD + ACCTTYPECD 
			+ PARACGRPCD + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + PGMLSTUPD + RCDSTAT + RCDVERSION + TRIGGERACT 
			+ ENTITLQTY + CAPPRC + CACAPPRC + CURRPRC + CAPQTY + VALQTY + VALENTITL + SHRMKTVAL + SHRMGNVAL + SECSHRMULT + SHRMGNMULT + PENDQTY 
			+ THRDFQTY + THRDTQTY	

	FROM 
		#Details

	DROP TABLE #Details
END