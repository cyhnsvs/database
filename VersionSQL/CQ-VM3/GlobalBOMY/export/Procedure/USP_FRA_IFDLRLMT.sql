/****** Object:  Procedure [export].[USP_FRA_IFDLRLMT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFDLRLMT]  
(  
 @idteProcessDate DATETIME  
)  
AS  
/*  
DEALER INFO  
EXEC [export].[USP_FRA_IFDLRLMT]   '2020-06-01'  
*/  
BEGIN  

		 CREATE TABLE #Detail  
		 (  
			  BROKERCD   CHAR(5)   
			 ,DLREAFID   CHAR(3)
			 ,DEALERCD   CHAR(4)
			 ,CHKLIMIT   CHAR(1)
			 ,MAXBUYLIM  CHAR(8)
			 ,MAXSELLLIM CHAR(8)
			 ,MAXNETLIM  DECIMAL(15,2)
			 ,MAXTOTLIM  CHAR(8)
			 ,EXLMPER    CHAR(3)
			 ,CLRPRVORD  CHAR(1)
			 ,ACCESSSR   CHAR(1)
			 ,BUYSR      CHAR(1)
			 ,SELLSR     CHAR(1)
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
			 ,BUYOS      CHAR(8)
			 ,SELLOS     CHAR(8)
			 ,TOTALOS    CHAR(8)
			 ,NETOS      CHAR(8)
			 ,DLYBUYLIM  CHAR(8)
			 ,DLYSELLLIM CHAR(8)
			 ,DLYTOTLIM  CHAR(8)
			 ,DLYNETLIM  CHAR(8)
			 ,COMPANYID  CHAR(1)
			 ,BRANCHID   CHAR(4)
			 ,BFESERVER  CHAR(2)

		 )  
  
		INSERT INTO #Detail  
		(  
			BROKERCD   
			,DLREAFID  
			,DEALERCD  
			,CHKLIMIT  
			,MAXBUYLIM 
			,MAXSELLLIM
			,MAXNETLIM 
			,MAXTOTLIM 
			,EXLMPER   
			,CLRPRVORD 
			,ACCESSSR  
			,BUYSR     
			,SELLSR    
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
			,BUYOS     
			,SELLOS    
			,TOTALOS   
			,NETOS     
			,DLYBUYLIM 
			,DLYSELLLIM
			,DLYTOTLIM 
			,DLYNETLIM 
			,COMPANYID 
			,BRANCHID  
			,BFESERVER 
	)  
	SELECT 
		'001'
		,''
		,[DealerCode (textinput-35)]
		,''
		,''
		,''
		, CAST([MaxNetLimit (textinput-9)] AS DECIMAL(15,2)) 
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
		CQBTempDB.export.tb_formdata_1377 DELEAR
	INNER JOIN 
		CQBTempDB.export.tb_formdata_1379 D_Market ON D_Market.[DealerCode (selectsource-14)] = DELEAR.[DealerCode (textinput-35)]

 -- RESULT SET  
 
	 SELECT   
			 BROKERCD +DLREAFID +DEALERCD + CHKLIMIT + MAXBUYLIM + MAXSELLLIM + CAST(MAXNETLIM as CHAR(20))+MAXTOTLIM + EXLMPER + CLRPRVORD + ACCESSSR 
			 + BUYSR + SELLSR + USRCREATED + DTCREATED +TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD +TRIGGERACT 
			 + BUYOS + SELLOS + TOTALOS + NETOS + DLYBUYLIM + DLYSELLLIM + DLYTOTLIM +DLYNETLIM +COMPANYID + BRANCHID + BFESERVER
	 FROM   
		 #Detail 
		 
	DROP TABLE #Detail
END