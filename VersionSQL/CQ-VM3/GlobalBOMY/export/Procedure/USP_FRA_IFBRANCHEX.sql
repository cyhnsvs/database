/****** Object:  Procedure [export].[USP_FRA_IFBRANCHEX]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFBRANCHEX]
(
	@idteProcessDate DATETIME
)
AS
/*
EXEC [export].[USP_FRA_IFBRANCHEX] '2020-06-01'
*/
BEGIN	
	
	CREATE TABLE #Detail
	(
		 COMPANYID		CHAR(1)
		,BRANCHID		CHAR(4)
		,CONTRALOSS		CHAR(8)
		,GRACEPRD		CHAR(2)
		,GRCPRDTYPE		CHAR(1)
		,SECCSHMULT		DECIMAL(5,2)
		,SECSHRMULT		CHAR(3)
		,SECNSHMULT		CHAR(3)
		,DLRNETDEPM		CHAR(3)
		,RATE1			CHAR(3)
		,RATE2			CHAR(3)
		,RATE3			CHAR(3)
		,AMOUNT1		CHAR(8)
		,AMOUNT2		CHAR(8)
		,AMOUNT3		CHAR(8)
		,TEXT1			CHAR(10)
		,TEXT2			CHAR(10)
		,TEXT3			CHAR(10)
		,SUSPTYPE		CHAR(1)
		,SUSPCRIT1		CHAR(4)
		,CTLOSSPER		CHAR(3)
		,SUSPCRIT2		CHAR(4)
		,GRACEPRD1		CHAR(2)
		,GRCPRDTYP1		CHAR(1)
		,SUSPCRIT3		CHAR(4)
		,CONTRALOS1		CHAR(8)
		,CONTRALOS2		CHAR(8)
		,GRACEPRD2		CHAR(2)
		,GRCPRDTYP2		CHAR(1)
		,SUSPCRIT4		CHAR(4)
		,CONTRALOS3		CHAR(8)
		,GRACEPRD3		CHAR(2)
		,GRCPRDTYP3		CHAR(1)
		,TPDAYS			CHAR(2)
		,TPDAYTYPE		CHAR(1)
		,TSDAYS			CHAR(2)
		,TSDAYTYPE		CHAR(1)
		,IND1			CHAR(1)
		,IND2			CHAR(1)
		,IND3			CHAR(1)
		,USRCREATED		CHAR(10)
		,DTCREATED		CHAR(10)
		,TMCREATED		CHAR(8)
		,USRUPDATED		CHAR(10)
		,DTUPDATED		CHAR(10)
		,TMUPDATED		CHAR(8)
		,RCDSTAT		CHAR(1)
		,RCDVERSION		CHAR(3)
		,PGMLSTUPD		CHAR(10)
		,TRIGGERACT		CHAR(1)
		,ALWODDAVG		CHAR(1)
		,CUFCSHMULT		CHAR(3)
		,TRINTOSDR		CHAR(1)
		,EARMRKOSP		CHAR(1)
	)

	INSERT INTO #Detail
	(
		  COMPANYID	
		 ,BRANCHID	
		 ,CONTRALOSS	
		 ,GRACEPRD	
		 ,GRCPRDTYPE	
		 ,SECCSHMULT	
		 ,SECSHRMULT	
		 ,SECNSHMULT	
		 ,DLRNETDEPM	
		 ,RATE1		
		 ,RATE2		
		 ,RATE3		
		 ,AMOUNT1	
		 ,AMOUNT2	
		 ,AMOUNT3	
		 ,TEXT1		
		 ,TEXT2		
		 ,TEXT3		
		 ,SUSPTYPE	
		 ,SUSPCRIT1	
		 ,CTLOSSPER	
		 ,SUSPCRIT2	
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
		 ,TPDAYS		
		 ,TPDAYTYPE	
		 ,TSDAYS		
		 ,TSDAYTYPE	
		 ,IND1		
		 ,IND2		
		 ,IND3		
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
		 ,ALWODDAVG	
		 ,CUFCSHMULT	
		 ,TRINTOSDR	
		 ,EARMRKOSP		 												
	)
	SELECT DISTINCT
		 ''
		,[BranchID (textinput-1)]
		,''
		,''
		,''
		,[MultiplierforCashDeposit (textinput-56)]
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
		,''
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
		CQBTempDB.export.Tb_FormData_1374 Branch
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Branch.[BranchID (textinput-1)] = Account.[CDSACOpenBranch (selectsource-4)]
		
	-- RESULT SET
	SELECT 
		    COMPANYID + BRANCHID + CONTRALOSS + GRACEPRD + GRCPRDTYPE + CAST(SECCSHMULT AS CHAR(3)) + SECSHRMULT	+ SECNSHMULT + DLRNETDEPM + RATE1 + RATE2 + RATE3 + AMOUNT1	+ AMOUNT2 + AMOUNT3	
			+ TEXT1 + TEXT2 + TEXT3 + SUSPTYPE + SUSPCRIT1 + CTLOSSPER + SUSPCRIT2 + GRACEPRD1 + GRCPRDTYP1	+ SUSPCRIT3 + CONTRALOS1 + CONTRALOS2 + GRACEPRD2 + GRCPRDTYP2	
			+ SUSPCRIT4 + CONTRALOS3 + GRACEPRD3 + GRCPRDTYP3 + TPDAYS + TPDAYTYPE + TSDAYS + TSDAYTYPE	+ IND1 + IND2 + IND3 + USRCREATED + DTCREATED + TMCREATED + USRUPDATED	
			+ DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + ALWODDAVG	+ CUFCSHMULT + TRINTOSDR + EARMRKOSP			 			
	FROM 
		#Detail

	DROP TABLE #Detail
END