/****** Object:  Procedure [export].[USP_FRA_IFACBAL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFACBAL]
(
	@idteProcessDate DATETIME
)
AS
/*
ACCOUNT CASH BALANCE
EXEC [export].[USP_FRA_IFACBAL] '2020-06-01'
*/
BEGIN
	
	-- CASH BALANCE
	CREATE TABLE #CashBalance
	(
		 COMPANYID		 CHAR(1)
		,BRANCHID		 CHAR(4)
		,EAFID			 CHAR(3)
		,ACCTNO			 CHAR(10)
		,ACCTSBNO		 CHAR(4)
		,CURRCODE		 CHAR(3)
		,SUBACCTTYP		 CHAR(2)
		,OPNACBAL		 CHAR(8)
		,MTDDBAMT		 CHAR(8)
		,MTDCRAMT		 CHAR(8)
		,DLYOPNBAL		 CHAR(8)
		,DLYDBAMT		 CHAR(8)
		,DLYCRAMT		 CHAR(8)
		,CURACBAL		 CHAR(8)
		,AVAILACBAL		 DECIMAL(15,2)
		,UNCLRTRD		 CHAR(8)
		,PENDAMT		 CHAR(8)
		,APPROVELIM		 CHAR(8)
		,PRVMTDINT		 CHAR(8)
		,CURMTDINT		 CHAR(8)
		,INTAMTCOMP		 CHAR(8)
		,DTINTCOMP		 CHAR(8)
		,PRVMTHINT		 CHAR(8)
		,YTDINTACCR		 CHAR(8)
		,OSRCVBLAMT		 CHAR(8)
		,OSPAYBLAMT		 CHAR(8)
		,ACCTSTAT		 CHAR(2)
		,DTACCTOPEN		 CHAR(10)
		,DTCLOSED		 CHAR(10)
		,DTSUSPND		 CHAR(10)
		,USRCLOSED		 CHAR(10)
		,USROPENED		 CHAR(10)
		,USRSUSPND		 CHAR(10)
		,USRAPPROVE		 CHAR(10)
		,DTAPPROVED		 CHAR(10)
		,TMAPPROVED		 CHAR(8)
		,LSTTRXDT		 CHAR(10)
		,ACCTGRPCD		 CHAR(5)
		,CUSTKEY		 CHAR(10)
		,AMOUNT1		 CHAR(8)
		,AMOUNT2		 CHAR(8)
		,AMOUNT3		 CHAR(8)
		,AMOUNT4		 CHAR(8)
		,AMOUNT5		 CHAR(8)
		,DATE1			 CHAR(10)
		,DATE2			 CHAR(10)
		,DATE3			 CHAR(10)
		,DATE4			 CHAR(10)
		,DATE5			 CHAR(10)
		,USRCREATED		 CHAR(10)
		,DTCREATED		 CHAR(10)
		,TMCREATED		 CHAR(8)
		,USRUPDATED		 CHAR(10)
		,DTUPDATED		 CHAR(10)
		,TMUPDATED		 CHAR(8)
		,RCDSTAT		 CHAR(1)
		,RCDVERSION		 CHAR(3)
		,PGMLSTUPD		 CHAR(10)
		,TRIGGERACT		 CHAR(1)
		,ACCTTYPECD		 CHAR(2)
		,TEXT1			 CHAR(10)
		,TEXT2			 CHAR(10)
		,TEXT3			 CHAR(10)
		,PARACGRPCD		 CHAR(5)
	)

	INSERT INTO #CashBalance
	(
		  COMPANYID		
		 ,BRANCHID		
		 ,EAFID			
		 ,ACCTNO			
		 ,ACCTSBNO		
		 ,CURRCODE		
		 ,SUBACCTTYP		
		 ,OPNACBAL		
		 ,MTDDBAMT		
		 ,MTDCRAMT		
		 ,DLYOPNBAL		
		 ,DLYDBAMT		
		 ,DLYCRAMT		
		 ,CURACBAL		
		 ,AVAILACBAL		
		 ,UNCLRTRD		
		 ,PENDAMT		
		 ,APPROVELIM		
		 ,PRVMTDINT		
		 ,CURMTDINT		
		 ,INTAMTCOMP		
		 ,DTINTCOMP		
		 ,PRVMTHINT		
		 ,YTDINTACCR		
		 ,OSRCVBLAMT		
		 ,OSPAYBLAMT		
		 ,ACCTSTAT		
		 ,DTACCTOPEN		
		 ,DTCLOSED		
		 ,DTSUSPND		
		 ,USRCLOSED		
		 ,USROPENED		
		 ,USRSUSPND		
		 ,USRAPPROVE		
		 ,DTAPPROVED		
		 ,TMAPPROVED		
		 ,LSTTRXDT		
		 ,ACCTGRPCD		
		 ,CUSTKEY		
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
		 ,ACCTTYPECD		
		 ,TEXT1			
		 ,TEXT2			
		 ,TEXT3			
		 ,PARACGRPCD					
	)
	SELECT 
		 ''		
		,[CDSACOpenBranch (selectsource-4)]		
		,''			
		,[AccountNumber (textinput-5)]			
		,''		
		,Cash.CurrCd		
		,[AccountType (selectsource-7)]		
		,''		
		,''		
		,''		
		,''		
		,''		
		,''		
		,''		
		,Cash.Balance		
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
		,''	
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
		CQBTempDB.export.Tb_FormData_1409 Account
	INNER JOIN 
		GlobalBO.holdings.Tb_Cash cash ON Account.[AccountNumber (textinput-5)] =  Cash.AcctNo

		
	-- RESULT SET
	SELECT 
		 COMPANYID + BRANCHID + EAFID + ACCTNO + ACCTSBNO + CURRCODE + SUBACCTTYP + OPNACBAL + MTDDBAMT	+ MTDCRAMT + DLYOPNBAL + DLYDBAMT + DLYCRAMT + CURACBAL		
		 + CAST(AVAILACBAL AS CHAR(8)) + UNCLRTRD + PENDAMT + APPROVELIM	+ PRVMTDINT + CURMTDINT	+ INTAMTCOMP + DTINTCOMP + PRVMTHINT + YTDINTACCR + OSRCVBLAMT + OSPAYBLAMT	+ ACCTSTAT		
		 + DTACCTOPEN + DTCLOSED + DTSUSPND	+ USRCLOSED	+ USROPENED	+ USRSUSPND	+ USRAPPROVE + DTAPPROVED + TMAPPROVED + LSTTRXDT + ACCTGRPCD + CUSTKEY + AMOUNT1 + AMOUNT2		
		 + AMOUNT3 + AMOUNT4 + AMOUNT5 + DATE1 + DATE2 + DATE3 + DATE4 + DATE5 + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION		
		 + PGMLSTUPD + TRIGGERACT + ACCTTYPECD + TEXT1 + TEXT2 + TEXT3 + PARACGRPCD
	FROM 
		#CashBalance

	DROP TABLE #CashBalance

END