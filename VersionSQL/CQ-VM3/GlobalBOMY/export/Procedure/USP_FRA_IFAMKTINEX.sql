/****** Object:  Procedure [export].[USP_FRA_IFAMKTINEX]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFAMKTINEX]
(
	@idteProcessDate DATETIME
)
AS
/*
EXEC [export].[USP_FRA_IFAMKTINEX] '2020-06-01'
*/
BEGIN
	
	
	CREATE TABLE #Detail
	(
		 MRKTCD		   CHAR(4)
		,COMPANYID	   CHAR(1)
		,BRANCHID	   CHAR(4)
		,EAFID		   CHAR(3)
		,ACCTNO		   CHAR(10)--CHAR(14)
		,ACCTSBNO	   CHAR(4)
		,CONTRALOSS	   CHAR(8)
		,GRACEPRD	   CHAR(2)
		,GRCPRDTYPE	   CHAR(1)
		,SECCSHMULT	   DECIMAL(5,2)
		,SECSHRMULT	   CHAR(3)
		,SECNSHMULT	   CHAR(3)
		,INTRAIND	   CHAR(1)
		,INTRABRKG	   CHAR(10)
		,IND1		   CHAR(1)
		,IND2		   CHAR(1)
		,IND3		   CHAR(1)
		,IND4		   CHAR(1)
		,IND5		   CHAR(1)
		,RATE1		   CHAR(3)
		,RATE2		   CHAR(3)
		,RATE3		   CHAR(3)
		,RATE4		   CHAR(3)
		,RATE5		   CHAR(3)
		,TEXT1		   CHAR(10)
		,TEXT2		   CHAR(10)
		,TEXT3		   CHAR(10)
		,TEXT4		   CHAR(10)
		,TEXT5		   CHAR(10)
		,QUANTITY1	   CHAR(5)
		,QUANTITY2	   CHAR(5)
		,QUANTITY3	   CHAR(5)
		,QUANTITY4	   CHAR(5)
		,QUANTITY5	   CHAR(5)
		,AMOUNT1	   DECIMAL(15,2)
		,AMOUNT2	   CHAR(8)
		,AMOUNT3	   CHAR(8)
		,AMOUNT4	   CHAR(8)
		,AMOUNT5	   CHAR(8)
		,DATE1		   CHAR(10)
		,DATE2		   CHAR(10)
		,DATE3		   CHAR(10)
		,DATE4		   CHAR(10)
		,DATE5		   CHAR(10)
		,SHORTSIND	   CHAR(1)
		,ODDLOTIND	   CHAR(1)
		,DESGNIND	   CHAR(1)
		,PN4IND		   CHAR(1)
		,IMMEDIND	   CHAR(1)
		,CNPAIDIND	   CHAR(1)
		,SRVCHGIND	   CHAR(1)
		,PRTCTSTMT	   CHAR(1)
		,PRTCSSTMT	   CHAR(1)
		,SECUDUETS	   CHAR(1)
		,PORTFLIND	   CHAR(1)
		,ACCTSGNON	   CHAR(10)
		,ITRDINQDLR	   CHAR(10)
		,N2NCLTIND	   CHAR(1)
		,ONLNTYPE	   CHAR(1)
		,ONLNDATOPN	   CHAR(10)
		,ONLNDATCLO	   CHAR(10)
		,GKACDATOPN	   CHAR(10)
		,GKCLTCODE	   CHAR(10)
		,GKONLNREG	   CHAR(1)
		,GKCDPNUM	   CHAR(20)
		,LMTBYRATIO	   CHAR(1)
		,TRDLMRATIO	   CHAR(2)
		,GKTRDLIMIT	   CHAR(8)
		,YEARLIMIT	   CHAR(8)
		,CUMEXPOSR	   CHAR(8)
		,GKSTATUS	   CHAR(1)
		,GKREPNAM	   CHAR(60)
		,GKREPTEL1	   CHAR(15)
		,GKREPTEL2	   CHAR(15)
		,GKREPTEL3	   CHAR(15)
		,GKREPFAX1	   CHAR(15)
		,GKREPFAX2	   CHAR(15)
		,GKACDATATV	   CHAR(10)
		,GKBUYEXTRT	   CHAR(6)
		,GKSELEXTRT	   CHAR(6)
		,RDLRDTSTR	   CHAR(10)
		,RDLRDTEND	   CHAR(10)
		,USRCREATED	   CHAR(10)
		,DTCREATED	   CHAR(10)
		,TMCREATED	   CHAR(8)
		,USRUPDATED	   CHAR(10)
		,DTUPDATED	   CHAR(10)
		,TMUPDATED	   CHAR(8)
		,RCDSTAT	   CHAR(1)
		,RCDVERSION	   CHAR(3)
		,PGMLSTUPD	   CHAR(10)
		,TRIGGERACT	   CHAR(1)
		,CUFCSHMULT	   CHAR(3)
		,REBATECD	   CHAR(2)
		,CTSRVDAYS	   CHAR(10)
		,TPDAYS		   CHAR(2)
		,TPDAYTYPE	   CHAR(1)
		,TSDAYS		   CHAR(2)
		,TSDAYTYPE	   CHAR(1)
	)

	INSERT INTO #Detail
	(
		  MRKTCD		 
		 ,COMPANYID	 
		 ,BRANCHID	 
		 ,EAFID		 
		 ,ACCTNO		 
		 ,ACCTSBNO	 
		 ,CONTRALOSS	 
		 ,GRACEPRD	 
		 ,GRCPRDTYPE	 
		 ,SECCSHMULT	 
		 ,SECSHRMULT	 
		 ,SECNSHMULT	 
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
		 ,SECUDUETS	 
		 ,PORTFLIND	 
		 ,ACCTSGNON	 
		 ,ITRDINQDLR	 
		 ,N2NCLTIND	 
		 ,ONLNTYPE	 
		 ,ONLNDATOPN	 
		 ,ONLNDATCLO	 
		 ,GKACDATOPN	 
		 ,GKCLTCODE	 
		 ,GKONLNREG	 
		 ,GKCDPNUM	 
		 ,LMTBYRATIO	 
		 ,TRDLMRATIO	 
		 ,GKTRDLIMIT	 
		 ,YEARLIMIT	 
		 ,CUMEXPOSR	 
		 ,GKSTATUS	 
		 ,GKREPNAM	 
		 ,GKREPTEL1	 
		 ,GKREPTEL2	 
		 ,GKREPTEL3	 
		 ,GKREPFAX1	 
		 ,GKREPFAX2	 
		 ,GKACDATATV	 
		 ,GKBUYEXTRT	 
		 ,GKSELEXTRT	 
		 ,RDLRDTSTR	 
		 ,RDLRDTEND	 
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
		 ,REBATECD	 
		 ,CTSRVDAYS	 
		 ,TPDAYS		 
		 ,TPDAYTYPE	 
		 ,TSDAYS		 
		 ,TSDAYTYPE	 												
	)
	SELECT 
		 ''
		,''
		,''
		,''
		,[AccountNumber (textinput-5)]
		,''
		,''
		,''
		,''
		,CASE WHEN ISNULL([MultiplierforCashDeposit (textinput-56)],'') = '' 
			   THEN 0 
			   ELSE CAST([MultiplierforCashDeposit (textinput-56)] AS DECIMAL(5,2)) 
		 END 
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,CASE WHEN ISNULL([AvailableCleanLineLimit (textinput-59)],'') = '' 
			   THEN 0 
			   ELSE CAST([AvailableCleanLineLimit (textinput-59)] AS DECIMAL(15,2)) 
		 END
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
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
		    MRKTCD + COMPANYID + BRANCHID + EAFID + ACCTNO + ACCTSBNO + CONTRALOSS + GRACEPRD + GRCPRDTYPE + CAST(SECCSHMULT AS CHAR(3)) + SECSHRMULT + SECNSHMULT + INTRAIND + INTRABRKG	 
			+ IND1 + IND2 + IND3 + IND4	+ IND5 + RATE1 + RATE2 + RATE3 + RATE4 + RATE5 + TEXT1 + TEXT2 + TEXT3 + TEXT4 + TEXT5 + QUANTITY1 + QUANTITY2 + QUANTITY3 + QUANTITY4	 
			+ QUANTITY5 + CAST(AMOUNT1 AS CHAR(8)) + AMOUNT2 + AMOUNT3 + AMOUNT4	+ AMOUNT5 + DATE1 + DATE2 + DATE3 + DATE4 + DATE5 + SHORTSIND + ODDLOTIND + DESGNIND + PN4IND + IMMEDIND	 
			+ CNPAIDIND + SRVCHGIND	+ PRTCTSTMT + PRTCSSTMT + SECUDUETS + PORTFLIND + ACCTSGNON + ITRDINQDLR + N2NCLTIND + ONLNTYPE	+ ONLNDATOPN + ONLNDATCLO + GKACDATOPN	 
			+ GKCLTCODE + GKONLNREG	+ GKCDPNUM + LMTBYRATIO + TRDLMRATIO + GKTRDLIMIT + YEARLIMIT + CUMEXPOSR + GKSTATUS + GKREPNAM	 + GKREPTEL1 + GKREPTEL2 + GKREPTEL3	 
			+ GKREPFAX1 + GKREPFAX2 + GKACDATATV + GKBUYEXTRT + GKSELEXTRT + RDLRDTSTR + RDLRDTEND + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED	 
			+ RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT	+ CUFCSHMULT + REBATECD + CTSRVDAYS + TPDAYS + TPDAYTYPE + TSDAYS + TSDAYTYPE	 			
	FROM 
		#Detail

	DROP TABLE #Detail
END