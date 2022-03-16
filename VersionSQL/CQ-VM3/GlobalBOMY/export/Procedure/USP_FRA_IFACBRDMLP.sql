/****** Object:  Procedure [export].[USP_FRA_IFACBRDMLP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFACBRDMLP]
(
	@idteProcessDate DATETIME
)
AS
/*
EXEC [export].[USP_FRA_IFACBRDMLP] '2020-06-01'
*/
BEGIN
	
	-- CASH BALANCE
	CREATE TABLE #Detail
	(
		 COMPANYID		CHAR(1)
		,BRANCHID		CHAR(4)
		,EAFID			CHAR(3)
		,ACCTNO			CHAR(10)
		,ACCTSBNO		CHAR(4)
		,MRKTCD			CHAR(4)
		,MKTBOARDCD		CHAR(4)
		,SECSHRMULT		DECIMAL(5,2)
		,RATE1			CHAR(3)
		,RATE2			CHAR(3)
		,RATE3			CHAR(3)
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

	)

	INSERT INTO #Detail
	(
		  COMPANYID	
		 ,BRANCHID	
		 ,EAFID		
		 ,ACCTNO		
		 ,ACCTSBNO	
		 ,MRKTCD		
		 ,MKTBOARDCD	
		 ,SECSHRMULT	
		 ,RATE1		
		 ,RATE2		
		 ,RATE3		
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
	)
	SELECT 
		 ''
		,''
		,''
		,[AccountNumber (textinput-5)]
		,''
		,''
		,''
		,[MultiplierforSharePledged (textinput-57)]--SECSHRMULT	
		,''
		,''
		,''
		,''
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
		
	-- RESULT SET
	SELECT 
		  COMPANYID	+ BRANCHID + EAFID + ACCTNO + ACCTSBNO + MRKTCD + MKTBOARDCD + CAST(SECSHRMULT AS CHAR(3)) + RATE1 + RATE2 + RATE3 + USRCREATED + DTCREATED + TMCREATED	
		  + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT 
	FROM 
		#Detail

	DROP TABLE #Detail

END