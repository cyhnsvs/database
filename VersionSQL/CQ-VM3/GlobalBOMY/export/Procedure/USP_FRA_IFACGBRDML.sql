/****** Object:  Procedure [export].[USP_FRA_IFACGBRDML]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFACGBRDML]
(
	@idteProcessDate DATETIME
)
AS
/*
ACCOUNT DEALER DETAILS
EXEC [export].[USP_FRA_IFACGBRDML] '2020-06-01'
*/
BEGIN
	
	-- CASH BALANCE
	CREATE TABLE #Detail
	(
		 ACCTGRPCD		CHAR(5)
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
		  ACCTGRPCD	
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
		 [AccountGroupCode (textinput-1)]
		,[MarketCode (selectsource-6)]
		,''	
		,''	--SECSHRMULT	
		,''
		,''
		,''
		,''	
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
		CQBTempDB.export.Tb_FormData_1437 AccountGrp
		
	-- RESULT SET
	SELECT 
		  ACCTGRPCD	+ MRKTCD + MKTBOARDCD + SECSHRMULT + RATE1 + RATE2 + RATE3 + USRCREATED + DTCREATED + TMCREATED	
		  + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT 
	FROM 
		#Detail
	
	DROP TABLE #Detail
END