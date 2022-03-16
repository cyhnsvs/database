/****** Object:  Procedure [export].[USP_FRA_IFOSTRADE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFOSTRADE]  
(  
 @idteProcessDate DATETIME  
)  
AS  
/*  
DEALER INFO  
EXEC [export].[USP_FRA_IFOSTRADE]   '2020-06-01'  
*/  
BEGIN  

		 CREATE TABLE #Detail  
		 (  
			    OSTRADEKEY   CHAR(6)
			   ,COMPANYID    CHAR(1)
			   ,BRANCHID     CHAR(4)   	
			   ,EAFID        CHAR(3)
			   ,ACCTNO       CHAR(10)  	
			   ,ACCTSBNO     CHAR(4)
			   ,CUSTKEY      CHAR(10)
			   ,CURRCODE     CHAR(3)
			   ,SUBACCTTYP   CHAR(2)
			   ,MRKTCD       CHAR(4)   	
			   ,PRODCD       CHAR(10)  	
			   ,PRODCD1      CHAR(10)
			   ,BROKERCD     CHAR(5)
			   ,DLREAFID     CHAR(3)
			   ,DEALERCD     CHAR(4)   	
			   ,TRADEACKEY   CHAR(6)
			   ,ALCOMPANY    CHAR(1)
			   ,ALBRANCH     CHAR(4)
			   ,ALEAFID      CHAR(3)
			   ,ALACCTNO     CHAR(10)
			   ,ALACCTSBNO   CHAR(4)
			   ,INTTRXID     CHAR(6)
			   ,TRXCD        CHAR(2)  		
			   ,TRXSUBCD     CHAR(1)  		
			   ,TRXREFNO     CHAR(10)  	
			   ,TRXREFSX     CHAR(3)
			   ,TRXREFVS     CHAR(2)
			   ,TRXDT        CHAR(10)
			   ,TRDPRICE     DECIMAL(10,6)
			   ,TRXQTY       DECIMAL(9,0) 
			   ,TRXAMT       CHAR(8)
			   ,TRXAMTL      CHAR(8)
			   ,TRXEXRT      CHAR(5)   
			   ,BALQTY       DECIMAL(9,0) 
			   ,BALAMT       DECIMAL(15,2)
			   ,BALAMTL      CHAR(8)
			   ,PENDQTY      CHAR(5)
			   ,PENDAMT      CHAR(8)
			   ,PENDAMTL     CHAR(8)
			   ,PENDCTRQTY   CHAR(5)
			   ,PENDCTRAMT   CHAR(8)
			   ,FOREXGNLS    CHAR(8)
			   ,CURMTDINT    CHAR(8)
			   ,ACCRINTPD    CHAR(8)
			   ,DTINTCOMP    CHAR(10)
			   ,DTDUEDLV     CHAR(10)
			   ,RELDOCNO     CHAR(15)
			   ,FREEOFPAYM   CHAR(1)
			   ,LSTVSNO      CHAR(2)
			   ,MRKTTRADE    CHAR(1)
			   ,SCRIPLESS    CHAR(1)
			   ,BRKGBAL      CHAR(5)
			   ,DOCSTMBAL    CHAR(5)
			   ,CLRFEEBAL    CHAR(5)
			   ,SALETAXBAL   CHAR(5)
			   ,OTHCHGBAL    CHAR(5)
			   ,VATBAL       CHAR(5)
			   ,COMMBAL      CHAR(8)
			   ,BRKGAMT      DECIMAL(9,2) 
			   ,CLRFEEAMT    DECIMAL(9,2) 
			   ,DOCSTMAMT    CHAR(5)
			   ,SALESTAX     CHAR(5)
			   ,OTHCHG       CHAR(5)
			   ,VATAMT       CHAR(5)
			   ,COMMAMT      CHAR(8)
			   ,SBLTRXRATE   CHAR(5)
			   ,ODDLOTIND    CHAR(1)
			   ,CDSNUMBER    CHAR(20) 		
			   ,INTMETHOD    CHAR(1)
			   ,ONHOLD       CHAR(1)
			   ,USRUPDATED   CHAR(10)
			   ,DTUPDATED    CHAR(10)
			   ,TMUPDATED    CHAR(8)
			   ,RCDSTAT      CHAR(1)
			   ,RCDVERSION   CHAR(3)
			   ,PGMLSTUPD    CHAR(10)
			   ,TRIGGERACT   CHAR(1)
			   ,CAKEY        CHAR(6)
			   ,CADTLKEY     CHAR(6)
			   ,AMOUNT1      CHAR(8)
			   ,AMOUNT2      CHAR(8)
			   ,AMOUNT3      CHAR(8)
			   ,QUANTITY1    CHAR(5)
			   ,QUANTITY2    CHAR(5)
			   ,QUANTITY3    CHAR(5)
			   ,RCDKEY1      CHAR(6)
			   ,RCDKEY2      CHAR(6)
			   ,RCDKEY3      CHAR(6)
			   ,STKDIVIND    CHAR(1)
			   ,CSHDIVIND    CHAR(1)
			   ,RGTISSIND    CHAR(1)
			   ,SHORTSELL    CHAR(1)
			   ,CALLWARIND   CHAR(1)
			   ,ORGTRXDT     CHAR(10)
			   ,ENTITLRGT    CHAR(1)
			   ,PRCTYPE      CHAR(1)
			   ,RBLCD        CHAR(1)
			   ,NEXTRODATE   CHAR(10)
			   ,ISLSECIND    CHAR(1)
			   ,MRKTTRDREF   CHAR(15)
			   ,DTDUEPAY     CHAR(10)		
			   ,ACCTTYPECD   CHAR(2)
			   ,ACCTGRPCD    CHAR(5)
			   ,REMARKCD     CHAR(4)
			   ,REMARKCD1    CHAR(4)
			   ,REMARKCD2    CHAR(4)
			   ,FINANCEIND   CHAR(1)
			   ,CHRGCD       CHAR(3) 		
			   ,FINANCEDT    CHAR(10)
			   ,TRXCOMPANY   CHAR(1)
			   ,TRXBRANCH    CHAR(4)
			   ,TRXEAFID     CHAR(3)
			   ,DLRBEAR      CHAR(1)
			   ,DLRBEARDT    CHAR(10)
			   ,CMPBEARAMT   CHAR(8)
			   ,DLRBEARAMT   CHAR(8)
			   ,DTLSTSETT    CHAR(10)
			   ,AMTLSTSETT   CHAR(8)
			   ,SETTTRXCD    CHAR(2)
			   ,DOCREF1      CHAR(20)
			   ,DOCREF2      CHAR(20)
			   ,SWIFTREF     CHAR(20)
			   ,ACNTRAPRTY   CHAR(8)
			   ,ASETOFPRTY   CHAR(8)
			   ,LSTRODATE    CHAR(10)
			   ,CURMTDCOM    CHAR(8)
			   ,CURMTDHND    CHAR(8)
			   ,MCDREFNO     CHAR(30)
			   ,LSTSETTQTY   CHAR(5)
			   ,RELEASEDT    CHAR(10)
			   ,INTRTCD      CHAR(3)
			   ,CURMTDINTD   CHAR(8)
			   ,ACCRINTPDD   CHAR(8)
			   ,AMOUNT4      CHAR(8)
			   ,AMOUNT5      CHAR(8)
			   ,QUANTITY4    CHAR(5)
			   ,QUANTITY5    CHAR(5)
			   ,DATE1        CHAR(10)
			   ,DATE2        CHAR(10)
			   ,DATE3        CHAR(10)
			   ,DATE4        CHAR(10)
			   ,TEXT1        CHAR(10)
			   ,TEXT2        CHAR(10)
			   ,TEXT3        CHAR(10)
			   ,TEXT4        CHAR(10)
			   ,DLVQTY       CHAR(5)
			   ,PENDCTRAML   CHAR(8)
			   ,PENDDLVQTY   CHAR(5)
			   ,HLDQTY       CHAR(5)
			   ,HLDAMT       CHAR(8)
			   ,REINSTATED   CHAR(1)
			   ,REINSTAMT    CHAR(8)
			   ,REINSTQTY    CHAR(5)
			   ,REINSTDATE   CHAR(10)
			   ,PARACGRPCD   CHAR(5)

		 )  
  
		INSERT INTO #Detail  
		(  
			OSTRADEKEY
			,COMPANYID 
			,BRANCHID  
			,EAFID     
			,ACCTNO    
			,ACCTSBNO  
			,CUSTKEY   
			,CURRCODE  
			,SUBACCTTYP
			,MRKTCD    
			,PRODCD    
			,PRODCD1   
			,BROKERCD  
			,DLREAFID  
			,DEALERCD  
			,TRADEACKEY
			,ALCOMPANY 
			,ALBRANCH  
			,ALEAFID   
			,ALACCTNO  
			,ALACCTSBNO
			,INTTRXID  
			,TRXCD     
			,TRXSUBCD  
			,TRXREFNO  
			,TRXREFSX  
			,TRXREFVS  
			,TRXDT     
			,TRDPRICE  
			,TRXQTY    
			,TRXAMT    
			,TRXAMTL   
			,TRXEXRT   
			,BALQTY    
			,BALAMT    
			,BALAMTL   
			,PENDQTY   
			,PENDAMT   
			,PENDAMTL  
			,PENDCTRQTY
			,PENDCTRAMT
			,FOREXGNLS 
			,CURMTDINT 
			,ACCRINTPD 
			,DTINTCOMP 
			,DTDUEDLV  
			,RELDOCNO  
			,FREEOFPAYM
			,LSTVSNO   
			,MRKTTRADE 
			,SCRIPLESS 
			,BRKGBAL   
			,DOCSTMBAL 
			,CLRFEEBAL 
			,SALETAXBAL
			,OTHCHGBAL 
			,VATBAL    
			,COMMBAL   
			,BRKGAMT   
			,CLRFEEAMT 
			,DOCSTMAMT 
			,SALESTAX  
			,OTHCHG    
			,VATAMT    
			,COMMAMT   
			,SBLTRXRATE
			,ODDLOTIND 
			,CDSNUMBER 
			,INTMETHOD 
			,ONHOLD    
			,USRUPDATED
			,DTUPDATED 
			,TMUPDATED 
			,RCDSTAT   
			,RCDVERSION
			,PGMLSTUPD 
			,TRIGGERACT
			,CAKEY     
			,CADTLKEY  
			,AMOUNT1   
			,AMOUNT2   
			,AMOUNT3   
			,QUANTITY1 
			,QUANTITY2 
			,QUANTITY3 
			,RCDKEY1   
			,RCDKEY2   
			,RCDKEY3   
			,STKDIVIND 
			,CSHDIVIND 
			,RGTISSIND 
			,SHORTSELL 
			,CALLWARIND
			,ORGTRXDT  
			,ENTITLRGT 
			,PRCTYPE   
			,RBLCD     
			,NEXTRODATE
			,ISLSECIND 
			,MRKTTRDREF
			,DTDUEPAY  
			,ACCTTYPECD
			,ACCTGRPCD 
			,REMARKCD  
			,REMARKCD1 
			,REMARKCD2 
			,FINANCEIND
			,CHRGCD    
			,FINANCEDT 
			,TRXCOMPANY
			,TRXBRANCH 
			,TRXEAFID  
			,DLRBEAR   
			,DLRBEARDT 
			,CMPBEARAMT
			,DLRBEARAMT
			,DTLSTSETT 
			,AMTLSTSETT
			,SETTTRXCD 
			,DOCREF1   
			,DOCREF2   
			,SWIFTREF  
			,ACNTRAPRTY
			,ASETOFPRTY
			,LSTRODATE 
			,CURMTDCOM 
			,CURMTDHND 
			,MCDREFNO  
			,LSTSETTQTY
			,RELEASEDT 
			,INTRTCD   
			,CURMTDINTD
			,ACCRINTPDD
			,AMOUNT4   
			,AMOUNT5   
			,QUANTITY4 
			,QUANTITY5 
			,DATE1     
			,DATE2     
			,DATE3     
			,DATE4     
			,TEXT1     
			,TEXT2     
			,TEXT3     
			,TEXT4     
			,DLVQTY    
			,PENDCTRAML
			,PENDDLVQTY
			,HLDQTY    
			,HLDAMT    
			,REINSTATED
			,REINSTAMT 
			,REINSTQTY 
			,REINSTDATE
			,PARACGRPCD
	)  
	SELECT 
		''
		,''
		,[CDSACOpenBranch (selectsource-4)] --BRANCHID	
		,''
		,CON.AcctNo  --ACCTNO	
		,''
		,''
		,''
		,''
		,HomeExchCd  --MRKTCD	
		,SUBSTRING(INS.InstrumentCd,0,CHARINDEX('.',INS.InstrumentCd))  --PRODCD	
		,''
		,''
		,''
		,[DealerCode (selectsource-21)] -- DEALERCD	
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,LEFT(TRAUNPAID.ContractNo, (PATINDEX('%[0-9]%', TRAUNPAID.ContractNo) - 1)) --TRXCD	
		,CON.Facility -- TRXSUBCD	
		,CON.ContractNo  --TRXREFNO	
		,''
		,''
		,''
		,CON.TradedPrice --TRDPRICE	
		,CON.TradedQty -- TRXQTY	
		,''
		,''
		,''
		,(CON.TradedQty - TRAUNPAID.RemainingQty)BALQTY --BALQTY	
		,(CON.NetAmountSetl - TRAUNPAID.Balance)BALAMT --BALAMT	
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,CON.ClientBrokerageSetl --BRKGAMT	
		,A.FeeTaxSetl --CLRFEEAMT	
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,[CDSNo (textinput-19)] --CDSNUMBER	
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,CON.SetlDate --DTDUEPAY	
		,''
		,''
		,''
		,''
		,''
		,''
		,'Y' --CHRGCD	
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
	 
	FROM GlobalBO.Contracts.Tb_ContractOutstanding CON
	 LEFT JOIN   
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF  
			INNER JOIN    
				GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'  
		) AS A ON A.ContractNo =  CON.ContractNo  
	INNER JOIN 
		CQBTempDB.export.tb_formdata_1409 BRANCH ON BRANCH.[AccountNumber (textinput-5)] = CON.AcctNo
	INNER JOIN 
		GlobalBO.setup.Tb_instrument INS ON INS.InstrumentId = CON.InstrumentId
	INNER JOIN 
		GlobalBOLocal.transmanagement.Tb_transactionsSettledUnPaid TRAUNPAID ON TRAUNPAID.ContractNo = CON.ContractNo  
	WHERE INS.InstrumentCd LIKE '%.XKLS%' 
 -- RESULT SET  
 
	 SELECT   
			   OSTRADEKEY + COMPANYID + BRANCHID + ACCTNO + ACCTSBNO + CUSTKEY + CURRCODE + SUBACCTTYP 
			 + MRKTCD + PRODCD + PRODCD1 + BROKERCD + DLREAFID + DEALERCD + TRADEACKEY + ALCOMPANY  
			 + ALBRANCH + ALEAFID + ALACCTNO + ALACCTSBNO + INTTRXID + TRXCD + TRXSUBCD + TRXREFNO   
			 + TRXREFSX + TRXREFVS + TRXDT + TRDPRICE + TRXQTY + TRXAMT + TRXAMTL + TRXEXRT + BALQTY     
			 + BALAMT + BALAMTL + PENDQTY  + PENDAMT + PENDAMTL + PENDCTRQTY + PENDCTRAMT + FOREXGNLS  
			 + CURMTDINT + ACCRINTPD + DTINTCOMP + DTDUEDLV + RELDOCNO + FREEOFPAYM + LSTVSNO + MRKTTRADE  
			 + SCRIPLESS + BRKGBAL + DOCSTMBAL + CLRFEEBAL + SALETAXBAL + OTHCHGBAL + VATBAL + COMMBAL    
			 + BRKGAMT + CLRFEEAMT + DOCSTMAMT + SALESTAX + OTHCHG + VATAMT + COMMAMT + SBLTRXRATE 
			 + ODDLOTIND + CDSNUMBER + INTMETHOD + ONHOLD + USRUPDATED + DTUPDATED + TMUPDATED  
			 + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + CAKEY + CADTLKEY + AMOUNT1 + AMOUNT2    
			 + AMOUNT3 + QUANTITY1 + QUANTITY2 + QUANTITY3 + RCDKEY1 + RCDKEY2 + RCDKEY3 + STKDIVIND  
			 + CSHDIVIND + RGTISSIND + SHORTSELL + CALLWARIND + ORGTRXDT + ENTITLRGT + PRCTYPE    
			 + RBLCD + NEXTRODATE + ISLSECIND + MRKTTRDREF + DTDUEPAY + ACCTTYPECD + ACCTGRPCD  
			 + REMARKCD + REMARKCD1 + REMARKCD2 + FINANCEIND + CHRGCD + FINANCEDT + TRXCOMPANY 
			 + TRXBRANCH + TRXEAFID + DLRBEAR + DLRBEARDT + CMPBEARAMT + DLRBEARAMT + DTLSTSETT  
			 + AMTLSTSETT + SETTTRXCD + DOCREF1 + DOCREF2 + SWIFTREF + ACNTRAPRTY + ASETOFPRTY 
			 + LSTRODATE + CURMTDCOM + CURMTDHND + MCDREFNO + LSTSETTQTY + RELEASEDT + INTRTCD    
			 + CURMTDINTD + ACCRINTPDD + AMOUNT4 + AMOUNT5 + QUANTITY4 + QUANTITY5 + DATE1 + DATE2      
			 + DATE3 + DATE4 + TEXT1 + TEXT2 + TEXT3 + TEXT4 + DLVQTY + PENDCTRAML + PENDDLVQTY 
			 + HLDQTY + HLDAMT + REINSTATED + REINSTAMT + REINSTQTY + REINSTDATE + PARACGRPCD 
	 FROM   
		 #Detail  
	DROP TABLE #Detail
END