/****** Object:  Procedure [export].[USP_FRA_IFCASHACCI]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFCASHACCI] 
(
	@idteProcessDate DATE
)
AS
BEGIN
--EXEC [export].[USP_FRA_IFCASHACCI] '2021-01-01'

	SET NOCOUNT ON;

	CREATE TABLE #IFDEFAULTR
	(
		 COMPANYID		CHAR(1)			
		,BRANCHID	    CHAR(4)			
		,EAFID	        CHAR(3)			
		,ACCTNO	        CHAR(10)		
		,ACCTSBNO	    CHAR(4)			
		,CURRCODE	    CHAR(3)			
		,SUBACCTTYP	    CHAR(2)			
		,TRXCD	        CHAR(2)			
		,ORGCOMPANY	    CHAR(1)			
		,ORGBRANCH	    CHAR(4)			
		,ORGEAFID	    CHAR(3)			
		,ALCOMPANY	    CHAR(1)			
		,ALBRANCH	    CHAR(4)			
		,ALEAFID	    CHAR(3)			
		,ALACCTNO	    CHAR(1)			
		,ALACCTSBNO	    CHAR(4)			
		,CANCELTNR	    CHAR(4)			
		,CHRGCD	        CHAR(3)			
		,INTTRXID	    CHAR(6)			
		,TRXSUBCD	    CHAR(1)			
		,TRXREFNO	    CHAR(10)		
		,TRXREFSX	    CHAR(3)			
		,TRXREFVS	    CHAR(2)			
		,TRXDT	        CHAR(10)--Date	
		,TRXVLDT	    CHAR(10)		
		,TRXQTY	        CHAR(5)			
		,TRXAMT	        DECIMAL(15,2)	
		,TRXAMTL	    CHAR(8)			
		,TRXEXRT	    CHAR(5)			
		,CANCELIND	    CHAR(1)			
		,APPCOMPANY	    CHAR(1)			
		,APPBRANCH	    CHAR(4)			
		,APPEAFID	    CHAR(3)			
		,APPTXCD	    CHAR(2)			
		,APPTXSUB	    CHAR(1)			
		,APPTXREF	    CHAR(10)		
		,APPTXREFSX	    CHAR(3)			
		,APPTXREFVS	    CHAR(2)			
		,APPTXDT	    CHAR(10)		
		,VATAMT	        CHAR(5)			
		,BNKCOMMAMT	    CHAR(5)			
		,BNKCOMMPD	    CHAR(5)			
		,CURAPPDT	    CHAR(10)		
		,FINPD	        CHAR(2)			
		,FINYR	        CHAR(3)			
		,PARTICULAR	    CHAR(50)		
		,RELDOCNO	    CHAR(15)		
		,CHEQUECD	    CHAR(1)			
		,SETTMODECD	    CHAR(2)			
		,SETTCURR	    CHAR(3)			
		,SETTAMT	    CHAR(8)			
		,SETTEXRT	    CHAR(5)			
		,SETTBANK	    CHAR(50)		
		,SETTREF	    CHAR(15)		
		,CHEQUEDT	    CHAR(10)		
		,BANKCD	        CHAR(4)			
		,BANKBRANCH	    CHAR(10)		
		,CBCOMPANY	    CHAR(1)			
		,CBBRANCH	    CHAR(4)			
		,CASHBKID	    CHAR(3)			
		,CBTRXKEY	    CHAR(6)			
		,REJECTIONR	    CHAR(4)			
		,BANKINREF	    CHAR(10)		
		,INTMETHOD	    CHAR(1)			
		,USRENTERED	    CHAR(10)		
		,DTENTERED	    CHAR(10)		
		,TMENTERED	    CHAR(8)			
		,USRCHECKED	    CHAR(10)		
		,DTCHECKED	    CHAR(10)		
		,TMCHECKED	    CHAR(8)			
		,USRAPPROVE	    CHAR(10)		
		,DTAPPROVED	    CHAR(10)		
		,TMAPPROVED	    CHAR(8)			
		,USRPOSTED	    CHAR(10)		
		,DTPOSTED	    CHAR(10)		
		,TMPOSTED	    CHAR(8)			
		,RCDSTAT	    CHAR(1)			
		,RCDVERSION	    CHAR(3)			
		,PGMLSTUPD	    CHAR(10)		
		,TRIGGERACT	    CHAR(1)			
		,WRKSTN	        CHAR(10)		
		,CHKRACTION	    CHAR(1)			
		,APPSTATUS	    CHAR(1)			
		,AMOUNT1	    CHAR(8)			
		,AMOUNT2	    CHAR(8)			
		,AMOUNT3	    CHAR(8)			
		,DATE1	        CHAR(10)		
		,DATE2	        CHAR(10)		
		,QUANTITY1	    CHAR(5)			
		,QUANTITY2	    CHAR(5)			
		,QUANTITY3	    CHAR(5)			
		,DTDUEPAY	    CHAR(10)		
		,ACCTTYPECD	    CHAR(2)			
		,ACCTGRPCD	    CHAR(5)			
		,TRXCOMPANY	    CHAR(1)			
		,TRXBRANCH	    CHAR(4)			
		,TRXEAFID	    CHAR(3)			
		,REMARK1	    CHAR(50)		
		,CUSTKEY	    CHAR(10)		
		,VALGIVEN	    CHAR(1)			
		,CQCOLDT	    CHAR(10)		
		,BATCHTP	    CHAR(2)			
		,BATCHNO	    CHAR(5)			
		,DOCREF1	    CHAR(20)		
		,DOCREF2	    CHAR(20)		
		,SWIFTREF	    CHAR(20)		
		,MCDREFNO	    CHAR(30)		
		,BNKCOMMAMD	    CHAR(5)			
		,GRPPRFID	    CHAR(10)		
		,OFFICERCD	    CHAR(10)		
		,DLRBEARAMT	    CHAR(8)			
		,CMPBEARAMT	    CHAR(8)			
		,DLRBEAR	    CHAR(1)			
		,DLRBEARDT	    CHAR(10)		
		,SETTBANKAC	    CHAR(20)		
		,SETTACCTNM	    CHAR(60)		
		,PARACGRPCD	    CHAR(5)			
	)
	
	INSERT INTO #IFDEFAULTR
	(
		 COMPANYID	
		,BRANCHID	
		,EAFID	
		,ACCTNO	
		,ACCTSBNO	
		,CURRCODE	
		,SUBACCTTYP	
		,TRXCD	
		,ORGCOMPANY	
		,ORGBRANCH	
		,ORGEAFID	
		,ALCOMPANY	
		,ALBRANCH	
		,ALEAFID	
		,ALACCTNO	
		,ALACCTSBNO	
		,CANCELTNR	
		,CHRGCD	
		,INTTRXID	
		,TRXSUBCD	
		,TRXREFNO	
		,TRXREFSX	
		,TRXREFVS	
		,TRXDT	
		,TRXVLDT	
		,TRXQTY	
		,TRXAMT	
		,TRXAMTL	
		,TRXEXRT	
		,CANCELIND	
		,APPCOMPANY	
		,APPBRANCH	
		,APPEAFID	
		,APPTXCD	
		,APPTXSUB	
		,APPTXREF	
		,APPTXREFSX	
		,APPTXREFVS	
		,APPTXDT	
		,VATAMT	
		,BNKCOMMAMT	
		,BNKCOMMPD	
		,CURAPPDT	
		,FINPD	
		,FINYR	
		,PARTICULAR	
		,RELDOCNO	
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
		,INTMETHOD	
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
		,AMOUNT1	
		,AMOUNT2	
		,AMOUNT3	
		,DATE1	
		,DATE2	
		,QUANTITY1	
		,QUANTITY2	
		,QUANTITY3	
		,DTDUEPAY	
		,ACCTTYPECD	
		,ACCTGRPCD	
		,TRXCOMPANY	
		,TRXBRANCH	
		,TRXEAFID	
		,REMARK1	
		,CUSTKEY	
		,VALGIVEN	
		,CQCOLDT	
		,BATCHTP	
		,BATCHNO	
		,DOCREF1	
		,DOCREF2	
		,SWIFTREF	
		,MCDREFNO	
		,BNKCOMMAMD	
		,GRPPRFID	
		,OFFICERCD	
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
	,Branch.[BranchID (textinput-1)] --BRANCHID
	,''
	,TRANSSETTL.AcctNo--ACCTNO
	,''
	,TRANSSETTL.TradedCurrCd--CURRCODE	
	,''
	,''--TRXCD
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,TRANSSETTL.ContractNo --TRXREFNO
	,''
	,''
	,TRANSSETTL.TradeDate--TRXDT
	,''
	,''
	,TRANSSETTL.NetAmountSetl--TRXAMT
	,''
	,''
	,(CASE WHEN CONTRACTAMEN.ContractAmendNo=0 THEN 'N' ELSE 'Y' END) AS CANCELIND--CANCELIND
	,''
	,''
	,''
	,''--APPTXCD
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''--PARTICULAR
	,''--RELDOCNO
	,''--CHEQUECD  
	,''
	,''
	,''
	,''
	,''--SETTBANK
	,''--SETTREF
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,Branch.[BranchLocation (textinput-2)]--TRXBRANCH 
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''
	,''--SETTACCTNM
	,Acc.[ParentGroup (selectsource-3)]--PARACGRPCD  account parrent account group
	FROM CQBTempDB.export.tb_formdata_1409 Acc
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionsSettled TRANSSETTL ON TRANSSETTL.AcctNo = Acc.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.tb_formdata_1377 Dealer ON Dealer.[DealerCode (textinput-35)] = Acc.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.tb_formdata_1374 Branch ON Branch.[BranchID (textinput-1)] = Dealer.[BranchID (selectsource-1)]
	INNER JOIN GlobalBO.Contracts.Tb_ContractOutstanding CONTRACTAMEN ON CONTRACTAMEN.AcctNo = Acc.[AccountNumber (textinput-5)]
	WHERE TRANSSETTL.TRANSTYPE IN ('CHDP','CHWD')
	-- RESULT SET 

	SELECT 
		 COMPANYID + BRANCHID + EAFID + ACCTNO + ACCTSBNO + CURRCODE + SUBACCTTYP + TRXCD + ORGCOMPANY + ORGBRANCH + ORGEAFID + ALCOMPANY + ALBRANCH 
		 + ALEAFID + ALACCTNO + ALACCTSBNO + CANCELTNR + CHRGCD	+ INTTRXID + TRXSUBCD + TRXREFNO + TRXREFSX + TRXREFVS + TRXDT + TRXVLDT + TRXQTY 
		 + TRXAMT + TRXAMTL + TRXEXRT + CANCELIND + APPCOMPANY + APPBRANCH + APPEAFID + APPTXCD + APPTXSUB + APPTXREF + APPTXREFSX + APPTXREFVS 
		 + APPTXDT + VATAMT	+ BNKCOMMAMT + BNKCOMMPD + CURAPPDT + FINPD + FINYR + PARTICULAR + RELDOCNO + CHEQUECD + SETTMODECD + SETTCURR + SETTAMT 
		 + SETTEXRT + SETTBANK + SETTREF + CHEQUEDT + BANKCD + BANKBRANCH + CBCOMPANY + CBBRANCH + CASHBKID + CBTRXKEY + REJECTIONR + BANKINREF 
		 + INTMETHOD + USRENTERED + DTENTERED + TMENTERED + USRCHECKED + DTCHECKED + TMCHECKED + USRAPPROVE + DTAPPROVED + TMAPPROVED + USRPOSTED 
		 + DTPOSTED + TMPOSTED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + WRKSTN	+ CHKRACTION+ APPSTATUS+ AMOUNT1+ AMOUNT2+ AMOUNT3+ DATE1 
		 + DATE2 + QUANTITY1 + QUANTITY2 + QUANTITY3 + DTDUEPAY + ACCTTYPECD + ACCTGRPCD + TRXCOMPANY + TRXBRANCH + TRXEAFID + REMARK1 + CUSTKEY 
		 + VALGIVEN + CQCOLDT + BATCHTP + BATCHNO + DOCREF1 + DOCREF2 + SWIFTREF + MCDREFNO + BNKCOMMAMD + GRPPRFID + OFFICERCD + DLRBEARAMT 
		 + CMPBEARAMT + DLRBEAR + DLRBEARDT + SETTBANKAC + SETTACCTNM + PARACGRPCD	
	FROM #IFDEFAULTR

END