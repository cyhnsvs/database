/****** Object:  Procedure [export].[USP_FRA_IFAGRMKTEX]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFAGRMKTEX]  
(  
 @idteProcessDate DATETIME  
)  
AS  
/*  
EXEC [export].[USP_FRA_IFAGRMKTEX] '2020-06-01'  
*/  
BEGIN  
   
 -- CASH BALANCE  
 CREATE TABLE #Detail  
 (  
	ACCTGRPCD   CHAR(6)  
	,MRKTCD    CHAR(4)  
	,INTRAIND   CHAR(1)  
	,INTRABRKG   CHAR(10)  
	,IND1    CHAR(1)  
	,IND2    CHAR(1)  
	,IND3    CHAR(1)  
	,IND4    CHAR(1)  
	,IND5    CHAR(1)  
	,RATE1    DECIMAL(5,2)  
	,RATE2    CHAR(3)  
	,RATE3    CHAR(3)  
	,RATE4    CHAR(3)  
	,RATE5    CHAR(3)  
	,TEXT1    CHAR(10)  
	,TEXT2    CHAR(10)  
	,TEXT3    CHAR(10)  
	,TEXT4    CHAR(10)  
	,TEXT5    CHAR(10)  
	,QUANTITY1   CHAR(5)  
	,QUANTITY2   CHAR(5)  
	,QUANTITY3   CHAR(5)  
	,QUANTITY4   CHAR(5)  
	,QUANTITY5   CHAR(5)  
	,AMOUNT1   CHAR(8)  
	,AMOUNT2   CHAR(8)  
	,AMOUNT3   CHAR(8)  
	,AMOUNT4   CHAR(8)  
	,AMOUNT5   CHAR(8)  
	,DATE1    CHAR(10)  
	,DATE2    CHAR(10)  
	,DATE3    CHAR(10)  
	,DATE4    CHAR(10)  
	,DATE5    CHAR(10)  
	,SHORTSIND   CHAR(1)  
	,ODDLOTIND   CHAR(1)  
	,DESGNIND   CHAR(1)  
	,PN4IND    CHAR(1)  
	,IMMEDIND   CHAR(1)  
	,CNPAIDIND   CHAR(1)  
	,SRVCHGIND   CHAR(1)  
	,PRTCTSTMT   CHAR(1)  
	,PRTCSSTMT   CHAR(1)  
	,SUSPTYPE   CHAR(1)  
	,SUSPCRIT1   CHAR(4)  
	,CTLOSSPER   CHAR(3)  
	,SUSPCRIT2   CHAR(4)  
	,CONTRALOSS   CHAR(8)  
	,GRACEPRD1   CHAR(2)  
	,GRCPRDTYP1   CHAR(1)  
	,SUSPCRIT3   CHAR(4)  
	,CONTRALOS1   CHAR(8)  
	,CONTRALOS2   CHAR(8)  
	,GRACEPRD2   CHAR(2)  
	,GRCPRDTYP2   CHAR(1)  
	,SUSPCRIT4   CHAR(4)  
	,CONTRALOS3   CHAR(8)  
	,GRACEPRD3   CHAR(2)  
	,GRCPRDTYP3   CHAR(1)  
	,USRCREATED   CHAR(10)  
	,DTCREATED   CHAR(10)  
	,TMCREATED   CHAR(8)  
	,USRUPDATED   CHAR(10)  
	,DTUPDATED   CHAR(10)  
	,TMUPDATED   CHAR(8)  
	,RCDSTAT   CHAR(1)  
	,RCDVERSION   CHAR(3)  
	,PGMLSTUPD   CHAR(10)  
	,TRIGGERACT   CHAR(1)  
	,CUFCSHMULT   CHAR(3)  
 )  
  
 INSERT INTO #Detail  
 (  
    ACCTGRPCD     
   ,MRKTCD      
   ,INTRAIND     
   ,INTRABRKG     
   ,IND1      
   ,IND2      
   ,IND3      
   ,IND4      
   ,IND5      
   ,RATE1      
   ,RATE2      
   ,RATE3      
   ,RATE4      
   ,RATE5      
   ,TEXT1      
   ,TEXT2      
   ,TEXT3      
   ,TEXT4      
   ,TEXT5      
   ,QUANTITY1     
   ,QUANTITY2     
   ,QUANTITY3     
   ,QUANTITY4     
   ,QUANTITY5     
   ,AMOUNT1     
   ,AMOUNT2     
   ,AMOUNT3     
   ,AMOUNT4     
   ,AMOUNT5     
   ,DATE1      
   ,DATE2      
   ,DATE3      
   ,DATE4      
   ,DATE5      
   ,SHORTSIND     
   ,ODDLOTIND     
   ,DESGNIND     
   ,PN4IND      
   ,IMMEDIND     
   ,CNPAIDIND     
   ,SRVCHGIND     
   ,PRTCTSTMT     
   ,PRTCSSTMT     
   ,SUSPTYPE     
   ,SUSPCRIT1     
   ,CTLOSSPER     
   ,SUSPCRIT2     
   ,CONTRALOSS     
   ,GRACEPRD1     
   ,GRCPRDTYP1     
   ,SUSPCRIT3     
   ,CONTRALOS1     
   ,CONTRALOS2     
   ,GRACEPRD2     
   ,GRCPRDTYP2     
   ,SUSPCRIT4     
   ,CONTRALOS3     
   ,GRACEPRD3     
   ,GRCPRDTYP3     
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
   ,CUFCSHMULT              
 )  
 SELECT   
	[AccountGroup (selectsource-2)]  
	,''  
	,''  
	,''  
	,''  
	,''  
	,''  
	,''  
	,''  
	,[MultiplierforCashDeposit (textinput-56)]--CAST([MultiplierforCashDeposit (textinput-56)] AS DECIMAL(15,2))--RATE1   
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
	,''  
	,''  
	,''  
	,''  
	,''  
 FROM   
	CQBTempDB.export.Tb_FormData_1409  
    
 -- RESULT SET  
 SELECT   
      ACCTGRPCD + MRKTCD + INTRAIND + INTRABRKG + IND1 + IND2 + IND3 + IND4 + IND5 + CAST(RATE1 AS CHAR(3)) + RATE2 + RATE3 + RATE4 + RATE5 + TEXT1 + TEXT2 + TEXT3 + TEXT4 + TEXT5      
      + QUANTITY1 + QUANTITY2 + QUANTITY3 + QUANTITY4 + QUANTITY5 + AMOUNT1 + AMOUNT2 + AMOUNT3 + AMOUNT4 + AMOUNT5 + DATE1 + DATE2 + DATE3 + DATE4 + DATE5 + SHORTSIND     
      + ODDLOTIND + DESGNIND + PN4IND + IMMEDIND + CNPAIDIND + SRVCHGIND + PRTCTSTMT + PRTCSSTMT + SUSPTYPE + SUSPCRIT1 + CTLOSSPER + SUSPCRIT2 + CONTRALOSS + GRACEPRD1     
      + GRCPRDTYP1 + SUSPCRIT3 + CONTRALOS1 + CONTRALOS2 + GRACEPRD2 + GRCPRDTYP2 + SUSPCRIT4 + CONTRALOS3 + GRACEPRD3 + GRCPRDTYP3 + USRCREATED + DTCREATED + TMCREATED     
      + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + CUFCSHMULT     
 FROM   
	#Detail
	
  DROP TABLE #Detail
END  
  
  