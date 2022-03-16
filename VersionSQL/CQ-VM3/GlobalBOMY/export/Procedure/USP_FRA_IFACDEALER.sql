/****** Object:  Procedure [export].[USP_FRA_IFACDEALER]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFACDEALER]
(
	@idteProcessDate DATETIME
)
AS
/*
ACCOUNT DEALER DETAILS
EXEC [export].[USP_FRA_IFACDEALER] '2020-06-01'
*/
BEGIN
	
	-- CASH BALANCE
	CREATE TABLE #Detail
	(
		 COMPANYID		 CHAR(1)
		,BRANCHID		 CHAR(4)
		,EAFID			 CHAR(3)
		,ACCTNO			 CHAR(10)
		,ACCTSBNO		 CHAR(4)
		,ACCTDLRNO		 CHAR(2)
		,BROKERCD		 CHAR(5)
		,DLREAFID		 CHAR(3)
		,DEALERCD		 CHAR(4)
		,TRDLIMITPR		 CHAR(3)
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

	)

	INSERT INTO #Detail
	(
		  COMPANYID	
		 ,BRANCHID	
		 ,EAFID		
		 ,ACCTNO		
		 ,ACCTSBNO	
		 ,ACCTDLRNO	
		 ,BROKERCD	
		 ,DLREAFID	
		 ,DEALERCD	
		 ,TRDLIMITPR	
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
		,[CDSACOpenBranch (selectsource-4)]
		,''
		,[AccountNumber (textinput-5)]
		,''
		,''
		,''
		,''
		,[DealerCode (selectsource-21)]
		,''
		,''
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
		  COMPANYID	+ BRANCHID + EAFID + ACCTNO + ACCTSBNO + ACCTDLRNO + BROKERCD + DLREAFID + DEALERCD + TRDLIMITPR + USRCREATED + DTCREATED + TMCREATED	
		  + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT 
	FROM 
		#Detail

	DROP TABLE #Detail
END