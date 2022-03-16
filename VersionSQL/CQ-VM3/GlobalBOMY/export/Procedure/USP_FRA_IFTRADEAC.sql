/****** Object:  Procedure [export].[USP_FRA_IFTRADEAC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFTRADEAC]
(
	@idteProcessDate DATETIME
)
AS
/*
WATCH LIST DETAILS 
EXEC [export].[USP_FRA_IFTRADEAC] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 TRADEACKEY       CHAR(6)       
		,COMPANYID        CHAR(1)       
		,BRANCHID         CHAR(4)       
		,EAFID            CHAR(3)       
		,ACCTNO           CHAR(10)      
		,ACCTSBNO         CHAR(4)       
		,CURRCODE         CHAR(3)       
		,SUBACCTTYP       CHAR(2)       
		,TRXCD            CHAR(3)       
		,MRKTCD           CHAR(4)       
		,PRODCD           CHAR(10)      
		,BRKGCD           CHAR(2)       
		,BROKERCD         CHAR(5)       
		,DLREAFID         CHAR(3)       
		,DEALERCD         CHAR(4)       
		,ORGCOMPANY       CHAR(1)       
		,ORGBRANCH        CHAR(4)       
		,ORGEAFID         CHAR(3)       
		,ORGCURR          CHAR(3)       
		,ALCOMPANY        CHAR(1)       
		,ALBRANCH         CHAR(4)       
		,ALEAFID          CHAR(3)       
		,ALACCTNO         CHAR(10)      
		,ALACCTSBNO       CHAR(4)       
		,BASISCD          CHAR(1)       
		,CANCELTNR        CHAR(4)       
		,CHRGCD           CHAR(3)       
		,INTTRXID         CHAR(6)       
		,TRXSUBCD         CHAR(1)       
		,TRXREFNO         CHAR(14)      
		,TRXREFSX         CHAR(3)       
		,TRXREFVS         CHAR(2)       
		,TRXDT            CHAR(10)      
		,TRXVLDT          CHAR(10)      
		,INTORDNO         CHAR(10)      
		,TRDORDNO         CHAR(10)      
		,TRDPRICE         DECIMAL(10,6) 
		,TRXQTY           DECIMAL(9,0)  
		,TRXAMT           DECIMAL(15,2) 
		,TRXAMTL          CHAR(8)       
		,TRXEXRT          CHAR(5)       
		,ORGTRXDT         CHAR(10)      
		,ORGTRDPRC        CHAR(6)       
		,ORGTRXAMT        CHAR(8)       
		,ORGEXRT          CHAR(5)       
		,DTDUEDLV         CHAR(10)      
		,FREEOFPAYM       CHAR(1)       
		,ULTTRDPTY        CHAR(10)      
		,FOREXGNLS        CHAR(8)       
		,MRKTTRADE        CHAR(1)       
		,CANCELIND        CHAR(1)       
		,SCRIPLESS        CHAR(1)       
		,OSTRADEKEY       CHAR(6)       
		,APPCOMPANY       CHAR(4)       
		,APPBRANCH        CHAR(1)       
		,APPEAFID         CHAR(3)       
		,APPTXCD          CHAR(2)       
		,APPTXSUB         CHAR(1)       
		,APPTXREF         CHAR(10)      
		,APPTXREFSX       CHAR(3)       
		,APPTXREFVS       CHAR(2)       
		,APPBFAMT         CHAR(8)       
		,APPBFQTY         CHAR(5)       
		,APPEXRT          CHAR(5)       
		,APPTXDT          CHAR(10)      
		,APPDUEDT         CHAR(10)      
		,BRKGAMT          DECIMAL(9,2)  
		,CLRFEEAMT        DECIMAL(9,2)  
		,DOCSTMAMT        DECIMAL(9,2)  
		,SALESTAX         CHAR(5)       
		,OTHCHG           CHAR(5)       
		,VATAMT           CHAR(5)       
		,RBTAMT           CHAR(8)       
		,COMMAMT          CHAR(8)       
		,ACCRINTPD        CHAR(8)       
		,BNKCOMMAMT       CHAR(5)       
		,BNKCOMMPD        CHAR(5)       
		,CURAPPDT         CHAR(10)      
		,FINPD            CHAR(2)       
		,FINYR            CHAR(3)       
		,PARTICULAR       CHAR(50)      
		,RELDOCNO         CHAR(15)      
		,SHORTSELL        CHAR(1)       
		,CHEQUECD         CHAR(1)       
		,SETTMODECD       CHAR(2)       
		,SETTCURR         CHAR(3)       
		,SETTAMT          CHAR(8)       
		,SETTEXRT         CHAR(5)       
		,SETTBANK         CHAR(50)      
		,SETTREF          CHAR(15)      
		,CHEQUEDT         CHAR(10)      
		,BANKCD           CHAR(4)       
		,BANKBRANCH       CHAR(10)      
		,CBCOMPANY        CHAR(1)       
		,CBBRANCH         CHAR(4)       
		,CASHBKID         CHAR(3)       
		,CBTRXKEY         CHAR(6)       
		,REJECTIONR       CHAR(4)       
		,BANKINREF        CHAR(10)      
		,CDSNUMBER        CHAR(20)      
		,ODDLOTIND        CHAR(1)       
		,INTMETHOD        CHAR(1)       
		,LOANPRD          CHAR(3)       
		,SBLTRXRATE       CHAR(5)       
		,SRVRTCDDS        CHAR(3)       
		,SRVRTCDCF        CHAR(3)       
		,SRVRTCDST        CHAR(3)       
		,SRVRTCDVT        CHAR(3)       
		,USRENTERED       CHAR(10)      
		,DTENTERED        CHAR(10)      
		,TMENTERED        CHAR(8)       
		,USRCHECKED       CHAR(10)      
		,DTCHECKED        CHAR(10)      
		,TMCHECKED        CHAR(8)       
		,USRAPPROVE       CHAR(10)      
		,DTAPPROVED       CHAR(10)      
		,TMAPPROVED       CHAR(8)       
		,USRPOSTED        CHAR(10)      
		,DTPOSTED         CHAR(10)      
		,TMPOSTED         CHAR(8)       
		,RCDSTAT          CHAR(1)       
		,RCDVERSION       CHAR(3)       
		,PGMLSTUPD        CHAR(10)      
		,TRIGGERACT       CHAR(1)       
		,WRKSTN           CHAR(10)      
		,CHKRACTION       CHAR(1)       
		,APPSTATUS        CHAR(1)       
		,CAKEY            CHAR(6)       
		,CADTLKEY         CHAR(6)       
		,AMOUNT1          CHAR(8)       
		,AMOUNT2          CHAR(8)       
		,AMOUNT3          CHAR(8)       
		,DATE1            CHAR(10)      
		,DATE2            CHAR(10)      
		,QUANTITY1        CHAR(5)       
		,QUANTITY2        CHAR(5)       
		,QUANTITY3        CHAR(5)       
		,RCDKEY1          CHAR(6)       
		,RCDKEY2          CHAR(6)       
		,RCDKEY3          CHAR(6)       
		,CALLWARIND       CHAR(1)       
		,ORGBRKGAMT       CHAR(5)       
		,ORGCLRFAMT       CHAR(5)       
		,ORGDOCSAMT       CHAR(5)       
		,STKDIVIND        CHAR(1)       
		,CSHDIVIND        CHAR(1)       
		,RGTISSIND        CHAR(1)       
		,ENTITLRGT        CHAR(1)       
		,PRCTYPE          CHAR(1)       
		,DTDUEPAY         CHAR(10)      
		,ISLSECIND        CHAR(1)       
		,MRKTTRDREF       CHAR(15)      
		,ACCTTYPECD       CHAR(2)       
		,ACCTGRPCD        CHAR(5)       
		,REMARKCD         CHAR(4)       
		,TRXCOMPANY       CHAR(1)       
		,TRXBRANCH        CHAR(4)       
		,TRXEAFID         CHAR(3)       
		,REMARK1          CHAR(50)      
		,CUSTKEY          CHAR(10)      
		,VALGIVEN         CHAR(1)       
		,ASSCOMPANY       CHAR(1)       
		,ASSBRANCH        CHAR(4)       
		,ASSEAFID         CHAR(3)       
		,ASSTXCD          CHAR(2)       
		,ASSTXSUB         CHAR(1)       
		,ASSTXREF         CHAR(10)      
		,ASSTXREFSX       CHAR(3)       
		,ASSTXREFVS       CHAR(2)       
		,ACCRINT          CHAR(8)       
		,CQCOLDT          CHAR(10)      
		,REMARKCD1        CHAR(4)       
		,REMARKCD2        CHAR(4)       
		,BATCHTP          CHAR(2)       
		,BATCHNO          CHAR(5)       
		,DOCREF1          CHAR(20)      
		,DOCREF2          CHAR(20)      
		,SWIFTREF         CHAR(20)      
		,MCDREFNO         CHAR(30)      
		,BNKCOMMAMD       CHAR(5)       
		,GRPPRFID         CHAR(10)      
		,OFFICERCD        CHAR(10)      
		,OSRCDVER         CHAR(3)       
		,DLRBEARAMT       DECIMAL(15,2) 
		,CMPBEARAMT       CHAR(8)       
		,DLRBEAR          CHAR(1)       
		,DLRBEARDT        CHAR(10)      
		,SETTBANKAC       CHAR(20)      
		,SETTACCTNM       CHAR(60)      
		,PARACGRPCD       CHAR(5)         
	)

	INSERT INTO #Details
	(
			 TRADEACKEY
			,COMPANYID
			,BRANCHID
			,EAFID
			,ACCTNO
			,ACCTSBNO
			,CURRCODE
			,SUBACCTTYP
			,TRXCD
			,MRKTCD
			,PRODCD
			,BRKGCD
			,BROKERCD
			,DLREAFID
			,DEALERCD
			,ORGCOMPANY
			,ORGBRANCH
			,ORGEAFID
			,ORGCURR
			,ALCOMPANY
			,ALBRANCH
			,ALEAFID
			,ALACCTNO
			,ALACCTSBNO
			,BASISCD
			,CANCELTNR
			,CHRGCD
			,INTTRXID
			,TRXSUBCD
			,TRXREFNO
			,TRXREFSX
			,TRXREFVS
			,TRXDT
			,TRXVLDT
			,INTORDNO
			,TRDORDNO
			,TRDPRICE
			,TRXQTY
			,TRXAMT
			,TRXAMTL
			,TRXEXRT
			,ORGTRXDT
			,ORGTRDPRC
			,ORGTRXAMT
			,ORGEXRT
			,DTDUEDLV
			,FREEOFPAYM
			,ULTTRDPTY
			,FOREXGNLS
			,MRKTTRADE
			,CANCELIND
			,SCRIPLESS
			,OSTRADEKEY
			,APPCOMPANY
			,APPBRANCH
			,APPEAFID
			,APPTXCD
			,APPTXSUB
			,APPTXREF
			,APPTXREFSX
			,APPTXREFVS
			,APPBFAMT
			,APPBFQTY
			,APPEXRT
			,APPTXDT
			,APPDUEDT
			,BRKGAMT
			,CLRFEEAMT
			,DOCSTMAMT
			,SALESTAX
			,OTHCHG
			,VATAMT
			,RBTAMT
			,COMMAMT
			,ACCRINTPD
			,BNKCOMMAMT
			,BNKCOMMPD
			,CURAPPDT
			,FINPD
			,FINYR
			,PARTICULAR
			,RELDOCNO
			,SHORTSELL
			,CHEQUECD
			,SETTMODECD
			,SETTCURR
			,SETTAMT
			,SETTEXRT
			,SETTBANK
			,SETTREF
			,CHEQUEDT
			,BANKCD
			,BANKBRANCH
			,CBCOMPANY
			,CBBRANCH
			,CASHBKID
			,CBTRXKEY
			,REJECTIONR
			,BANKINREF
			,CDSNUMBER
			,ODDLOTIND
			,INTMETHOD
			,LOANPRD
			,SBLTRXRATE
			,SRVRTCDDS
			,SRVRTCDCF
			,SRVRTCDST
			,SRVRTCDVT
			,USRENTERED
			,DTENTERED
			,TMENTERED
			,USRCHECKED
			,DTCHECKED
			,TMCHECKED
			,USRAPPROVE
			,DTAPPROVED
			,TMAPPROVED
			,USRPOSTED
			,DTPOSTED
			,TMPOSTED
			,RCDSTAT
			,RCDVERSION
			,PGMLSTUPD
			,TRIGGERACT
			,WRKSTN
			,CHKRACTION
			,APPSTATUS
			,CAKEY
			,CADTLKEY
			,AMOUNT1
			,AMOUNT2
			,AMOUNT3
			,DATE1
			,DATE2
			,QUANTITY1
			,QUANTITY2
			,QUANTITY3
			,RCDKEY1
			,RCDKEY2
			,RCDKEY3
			,CALLWARIND
			,ORGBRKGAMT
			,ORGCLRFAMT
			,ORGDOCSAMT
			,STKDIVIND
			,CSHDIVIND
			,RGTISSIND
			,ENTITLRGT
			,PRCTYPE
			,DTDUEPAY
			,ISLSECIND
			,MRKTTRDREF
			,ACCTTYPECD
			,ACCTGRPCD
			,REMARKCD
			,TRXCOMPANY
			,TRXBRANCH
			,TRXEAFID
			,REMARK1
			,CUSTKEY
			,VALGIVEN
			,ASSCOMPANY
			,ASSBRANCH
			,ASSEAFID
			,ASSTXCD
			,ASSTXSUB
			,ASSTXREF
			,ASSTXREFSX
			,ASSTXREFVS
			,ACCRINT
			,CQCOLDT
			,REMARKCD1
			,REMARKCD2
			,BATCHTP
			,BATCHNO
			,DOCREF1
			,DOCREF2
			,SWIFTREF
			,MCDREFNO
			,BNKCOMMAMD
			,GRPPRFID
			,OFFICERCD
			,OSRCDVER
			,DLRBEARAMT
			,CMPBEARAMT
			,DLRBEAR
			,DLRBEARDT
			,SETTBANKAC
			,SETTACCTNM
			,PARACGRPCD 
	)
		SELECT	
		    ''
		   ,''
		   ,[CDSACOpenBranch (selectsource-4)]
		   ,''
		   ,CON.AcctNo
		   ,''
		   ,''
		   ,''
		   ,C.TradedCurrCd
		   ,INS.HomeExchCd
		   ,SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd))
		   ,''
		   ,''
		   ,''
		   ,DEA.[DealerCode (selectsource-21)]
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''--TRXSUBCD	Y
		   ,C.ContractNo
		   ,''--TRXREFSX	
		   ,''
		   ,C.ContractDate
		   ,''
		   ,''
		   ,''
		   ,CON.TradedPrice
		   ,CON.TradedQty
		   ,CON.NetAmountTrade
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,(CASE WHEN CONTRACTAMEN.ContractAmendNo=0 THEN 'N' ELSE 'Y' END) AS CANCELIND--CANCELIND	
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''--APPTXCD	
		   ,''--APPTXSUB	
		   ,''--APPTXREF	
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,CON.ClientBrokerageSetl
		   ,A.FeeTaxSetl--CLRFEEAMT	
		   ,B.FeeTaxSetl--DOCSTMAMT	
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''--RELDOCNO	
		   ,''
		   ,''--CHEQUECD	
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,DEA.[CDSNo (textinput-19)]
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,C.SetlDate
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		   ,''
		 ,''
		   ,''
		   ,''
		   ,0--DLRBEARAMT	
		   ,''
		   ,''--DLRBEAR	
		   ,''
		   ,''
		   ,''
		   ,''
		FROM 
		GlobalBO.transmanagement.Tb_TransactionsSettled C
		LEFT JOIN 
			(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl 
			 FROM 
				GlobalBO.contracts.Tb_ContractFeeDetails CF
			 INNER JOIN  
				GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
			) AS A ON A.ContractNo =  C.ContractNo
		LEFT JOIN 
			(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl 
			 FROM 
				GlobalBO.contracts.Tb_ContractFeeDetails CF
			 INNER JOIN  
				GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
			) AS B ON B.ContractNo = C.ContractNo
		INNER JOIN 
			GlobalBO.setup.Tb_instrument INS ON INS.InstrumentId = C.InstrumentId
		INNER JOIN 
			GlobalBO.Contracts.Tb_ContractOutstanding CON ON INS.InstrumentId = CON.InstrumentId
		INNER JOIN 
			CQBTempDB.export.tb_formdata_1409 DEA ON DEA.[AccountNumber (textinput-5)]=CON.AcctNo
		INNER JOIN 
			GlobalBO.Contracts.Tb_ContractOutstanding CONTRACTAMEN ON CONTRACTAMEN.AcctNo = DEA.[AccountNumber (textinput-5)]
		WHERE INS.InstrumentCd LIKE '%.XKLS%'
	
		
		-- RESULT SET
		SELECT 
			TRADEACKEY + COMPANYID + BRANCHID  + EAFID + ACCTNO + ACCTSBNO + CURRCODE + SUBACCTTYP + TRXCD + MRKTCD 
			+ PRODCD + BRKGCD + BROKERCD + DLREAFID + DEALERCD + ORGCOMPANY + ORGBRANCH + ORGEAFID + ORGCURR + ALCOMPANY 
			+ ALBRANCH + ALEAFID + ALACCTNO + ALACCTSBNO + BASISCD + CANCELTNR + CHRGCD + INTTRXID + TRXSUBCD + TRXREFNO 
			+ TRXREFSX + TRXREFVS + TRXDT + TRXVLDT + INTORDNO + TRDORDNO + CAST(TRDPRICE AS CHAR(10)) + CAST(TRXQTY AS CHAR(10)) 
			+ CAST(TRXAMT AS CHAR(10)) + TRXAMTL + TRXEXRT + ORGTRXDT + ORGTRDPRC + ORGTRXAMT + ORGEXRT + DTDUEDLV + FREEOFPAYM 
			+ ULTTRDPTY + FOREXGNLS + MRKTTRADE + CANCELIND + SCRIPLESS + OSTRADEKEY + APPCOMPANY + APPBRANCH + APPEAFID + APPTXCD 
			+ APPTXSUB + APPTXREF + APPTXREFSX + APPTXREFVS + APPBFAMT + APPBFQTY + APPEXRT + APPTXDT + APPDUEDT + BRKGAMT 
			+ CAST(CLRFEEAMT AS CHAR(10)) + DOCSTMAMT + SALESTAX + OTHCHG + VATAMT + RBTAMT + COMMAMT + ACCRINTPD + BNKCOMMAMT 
			+ BNKCOMMPD + CURAPPDT + FINPD + FINYR + PARTICULAR + RELDOCNO + SHORTSELL + CHEQUECD + SETTMODECD + SETTCURR + SETTAMT 
			+ SETTEXRT + SETTBANK + SETTREF + CHEQUEDT + BANKCD + BANKBRANCH + CBCOMPANY + CBBRANCH + CASHBKID + CBTRXKEY + REJECTIONR 
			+ BANKINREF + CDSNUMBER + ODDLOTIND + INTMETHOD + LOANPRD + SBLTRXRATE + SRVRTCDDS + SRVRTCDCF + SRVRTCDST + SRVRTCDVT 
			+ USRENTERED+ DTENTERED + TMENTERED + USRCHECKED + DTCHECKED + TMCHECKED + USRAPPROVE+ DTAPPROVED+ TMAPPROVED
			+ USRPOSTED + DTPOSTED  + TMPOSTED  + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT+ WRKSTN + CHKRACTION+ APPSTATUS 
			+ CAKEY     + CADTLKEY  + AMOUNT1   + AMOUNT2 + AMOUNT3 + DATE1+ DATE2+ QUANTITY1 + QUANTITY2 + QUANTITY3 + RCDKEY1 
			+ RCDKEY2   + RCDKEY3   + CALLWARIND+ ORGBRKGAMT+ ORGCLRFAMT+ ORGDOCSAMT+ STKDIVIND + CSHDIVIND + RGTISSIND + ENTITLRGT 
			+ PRCTYPE   + DTDUEPAY  + ISLSECIND + MRKTTRDREF+ ACCTTYPECD+ ACCTGRPCD + REMARKCD  + TRXCOMPANY+ TRXBRANCH + TRXEAFID  
			+ REMARK1   + CUSTKEY   + VALGIVEN  + ASSCOMPANY+ ASSBRANCH + ASSEAFID  + ASSTXCD   + ASSTXSUB  + ASSTXREF  + ASSTXREFSX
			+ ASSTXREFVS+ ACCRINT   + CQCOLDT   + REMARKCD1 + REMARKCD2 + BATCHTP   + BATCHNO   + DOCREF1   + DOCREF2   + SWIFTREF  
			+ MCDREFNO  + BNKCOMMAMD+ GRPPRFID + OFFICERCD + OSRCDVER  + (CASE WHEN DLRBEARAMT =0 THEN '' END)  + CMPBEARAMT+ DLRBEAR   + DLRBEARDT + SETTBANKAC
			+ SETTACCTNM+ PARACGRPCD    
		FROM 
			#Details
	
	DROP TABLE #Details
END