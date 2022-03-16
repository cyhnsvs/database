/****** Object:  Procedure [export].[USP_FRA_IFSHRBALB]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFSHRBALB]
(
	@idteProcessDate DATETIME
)
AS
/*
EXEC [export].[USP_FRA_IFSHRBALB] '2020-06-01'
*/
BEGIN
	
	-- CASH BALANCE
	CREATE TABLE #Detail
	(
		 EXTBALKEY		CHAR(12)	DEFAULT('')
		,CUSTKEY		CHAR(10)	DEFAULT('')
		,ACCTTYPECD		CHAR(2)		DEFAULT('')
		,PARACGRPCD		CHAR(5)		DEFAULT('')
		,ACCTGRPCD		CHAR(5)		DEFAULT('')
		,NOMININD		CHAR(1)		DEFAULT('')
		,USRCREATED		CHAR(10)	DEFAULT('')
		,DTCREATED		CHAR(10)	DEFAULT('')
		,TMCREATED		CHAR(8)		DEFAULT('')
		,USRUPDATED		CHAR(10)	DEFAULT('')
		,DTUPDATED		CHAR(10)	DEFAULT('')
		,TMUPDATED		CHAR(8)		DEFAULT('')
		,RCDSTAT		CHAR(1)		DEFAULT('')
		,RCDVERSION		CHAR(6)		DEFAULT('')
		,PGMLSTUPD		CHAR(10)	DEFAULT('')
		,MCDTYPE		CHAR(1)		DEFAULT('')
		,MCDCDSNM		CHAR(9)		DEFAULT('')
		,MCDCOMPID		CHAR(1)		DEFAULT('')
		,MCDBRNID		CHAR(4)		DEFAULT('')
		,MCDEAFID		CHAR(3)		DEFAULT('')
		,MCDCLNACCT		CHAR(10)	DEFAULT('')
		,MCDCLTSBNO		CHAR(4)		DEFAULT('')
		,MCDSTK			CHAR(6)		DEFAULT('')
		,MCDMRKTCD		CHAR(4)		DEFAULT('')
		,MCDPRODCD		CHAR(10)	DEFAULT('')
		,MCDFREEBAL		CHAR(12)	DEFAULT('')
		,MCDMARKBAL		CHAR(12)	DEFAULT('')
		,MCDUCLRBAL		CHAR(12)	DEFAULT('')
		,MCDSUSPBAL		CHAR(12)	DEFAULT('')
		,MCDPAYBAL		CHAR(12)	DEFAULT('')
		,MCDRECBAL		CHAR(12)	DEFAULT('')
		,MCDBUYBAL		CHAR(12)	DEFAULT('')
	)

	INSERT INTO #Detail
	(
		 PARACGRPCD
		,MCDCLNACCT
		,MCDMRKTCD
		,MCDPRODCD
		,MCDFREEBAL					
	)
	SELECT 
		 ISNULL([ParentGroup (selectsource-3)],''),	
		 ISNULL(A.[AccountNumber (textinput-5)],''),
		 ISNULL(ListedExchCd,''),	
		 ISNULL(SUBSTRING(C.InstrumentCd,0,CHARINDEX('.',C.InstrumentCd)),''),						
		 ISNULL(CAST(CustodyAssetsBalance AS DECIMAL(9,2)),0)			
	FROM 
		CQBTempDB.export.tb_formdata_1409 A 
	INNER JOIN
		CQBTempDB.export.tb_formdata_1410 Cust ON A.[CustomerID (selectsource-1)] = Cust.[CustomerID (textinput-1)]
	LEFT JOIN
		GlobalBORpt.valuation.Tb_CustodyAssetsRPValuationCollateralRpt C ON A.[AccountNumber (textinput-5)] = C.AcctNo
	WHERE 
		[ParentGroup (selectsource-3)] NOT IN ('M','G') AND [CountryofResidence (selectsource-5)] <> 'MY'
		
	-- RESULT SET
	SELECT 
		 EXTBALKEY + CUSTKEY + ACCTTYPECD + PARACGRPCD + ACCTGRPCD + NOMININD + USRCREATED		
		 + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT	 + RCDVERSION		
		 + PGMLSTUPD + MCDTYPE + MCDCDSNM + MCDCOMPID + MCDBRNID + MCDEAFID + MCDCLNACCT		
		 + MCDCLTSBNO + MCDSTK + MCDMRKTCD + MCDPRODCD + MCDFREEBAL + MCDMARKBAL + MCDUCLRBAL		
		 + MCDSUSPBAL + MCDPAYBAL + MCDRECBAL + MCDBUYBAL		 
	FROM 
		#Detail AS ShareHolding

END