/****** Object:  Procedure [export].[USP_FRA_IFSHRBALA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFSHRBALA]
(
	@idteProcessDate DATETIME
)
AS
/*
EXEC [export].[USP_FRA_IFSHRBALA] '2020-06-01'
*/
BEGIN
	
	-- CASH BALANCE
	CREATE TABLE #Detail
	(
		 MRKTCD	      CHAR(4)		
		,PRODCD	      CHAR(10)
		,SHRPOOLID	  CHAR(5)
		,COMPANYID	  CHAR(1)
		,BRANCHID	  CHAR(4)
		,EAFID	      CHAR(3)
		,ACCTNO	      CHAR(10)
		,ACCTSBNO	  CHAR(4)
		,SECINCD	  CHAR(15)
		,TOTCDSQT	  CHAR(5)
		,TOTCDSNOM	  CHAR(5)
		,TOTPHYQT	  CHAR(5)
		,TOTPHYNOM	  CHAR(5)
		,AVAILCDSQT	  DECIMAL(9,2)
		,AVAILPHYQT	  CHAR(5)
		,SHRHLDCOST	  CHAR(8)
		,SHRHLDVAL	  CHAR(8)
		,MGNBCDSQT	  CHAR(5)
		,MGNBPHYQT	  CHAR(5)
		,MGNMRKTVAL	  CHAR(8)
		,MGNBVAL	  CHAR(8)
		,UGAINLOSS	  CHAR(8)
		,SHRENTITLE	  CHAR(5)
		,SHRHLDEXDT	  CHAR(10)
		,SHRHLDLGDT	  CHAR(10)
		,CLOSEPRICE	  CHAR(6)
		,USRCREATED	  CHAR(10)
		,DTCREATED	  CHAR(10)
		,TMCREATED	  CHAR(8)
		,USRUPDATED	  CHAR(10)
		,DTUPDATED	  CHAR(10)
		,TMUPDATED	  CHAR(8)
		,RCDSTAT	  CHAR(1)
		,RCDVERSION	  CHAR(3)
		,PGMLSTUPD	  CHAR(10)
		,TRIGGERACT	  CHAR(1)
		,PURCVAL	  CHAR(6)
		,PURCNVAL	  CHAR(6)
		,PLEDGEVAL	  CHAR(6)
		,PLEDGENVAL	  CHAR(6)
		,NMGNMKTVAL	  CHAR(8)
		,CUSTKEY	  CHAR(10)
		,ACCTGRPCD	  CHAR(5)
		,ACCTTYPECD	  CHAR(2)
		,TEXT1	      CHAR(10)
		,TEXT2	      CHAR(10)
		,TEXT3	      CHAR(10)
		,PARACGRPCD	  CHAR(8)
	)

	INSERT INTO #Detail
	(
		  MRKTCD	    
		 ,PRODCD	    
		 ,SHRPOOLID	
		 ,COMPANYID	
		 ,BRANCHID	
		 ,EAFID	    
		 ,ACCTNO	    
		 ,ACCTSBNO	
		 ,SECINCD	
		 ,TOTCDSQT	
		 ,TOTCDSNOM	
		 ,TOTPHYQT	
		 ,TOTPHYNOM	
		 ,AVAILCDSQT	
		 ,AVAILPHYQT	
		 ,SHRHLDCOST	
		 ,SHRHLDVAL	
		 ,MGNBCDSQT	
		 ,MGNBPHYQT	
		 ,MGNMRKTVAL	
		 ,MGNBVAL	
		 ,UGAINLOSS	
		 ,SHRENTITLE	
		 ,SHRHLDEXDT	
		 ,SHRHLDLGDT	
		 ,CLOSEPRICE	
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
		 ,PURCVAL	
		 ,PURCNVAL	
		 ,PLEDGEVAL	
		 ,PLEDGENVAL	
		 ,NMGNMKTVAL	
		 ,CUSTKEY	
		 ,ACCTGRPCD	
		 ,ACCTTYPECD	
		 ,TEXT1	    
		 ,TEXT2	    
		 ,TEXT3	    
		 ,PARACGRPCD						
	)
	SELECT 
		  HomeExchCd	--MRKTCD	
		 ,SUBSTRING(INS.InstrumentCd,0,CHARINDEX('.',INS.InstrumentCd))	--PRODCD	
		 ,'CSTDY'	--SHRPOOLID	
		 ,''				
		 ,[CDSACOpenBranch (selectsource-4)]	--BRANCHID	
		 ,''				
		 ,CON.AcctNo	--ACCTNO	
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,(CASE WHEN [AvailableTradingLimit (textinput-55)] =0 THEN '' ELSE [AvailableTradingLimit (textinput-55)] END) --AVAILCDSQT
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,''				
		 ,[ParentGroup (selectsource-3)]	--PARACGRPCD
	FROM 
		GlobalBO.Contracts.Tb_ContractOutstanding CON
	INNER JOIN 
		CQBTempDB.export.tb_formdata_1409 BRANCH ON BRANCH.[AccountNumber (textinput-5)] = CON.AcctNo
	INNER JOIN 
		GlobalBO.setup.Tb_instrument INS ON INS.InstrumentId = CON.InstrumentId
	WHERE INS.InstrumentCd LIKE '%.XKLS%' 
		
	-- RESULT SET
	--SELECT 
	--	  MRKTCD + PRODCD + SHRPOOLID + COMPANYID + BRANCHID + EAFID + ACCTNO + ACCTSBNO + SECINCD + TOTCDSQT + TOTCDSNOM + TOTPHYQT + TOTPHYNOM 
	--	  + CAST(AVAILCDSQT AS CHAR(5)) + AVAILPHYQT + SHRHLDCOST + SHRHLDVAL + MGNBCDSQT + MGNBPHYQT + MGNMRKTVAL + MGNBVAL + UGAINLOSS + SHRENTITLE + SHRHLDEXDT 
	--	  + SHRHLDLGDT + CLOSEPRICE + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD 
	--	  + TRIGGERACT + PURCVAL + PURCNVAL + PLEDGEVAL + PLEDGENVAL + NMGNMKTVAL + CUSTKEY + ACCTGRPCD + ACCTTYPECD + TEXT1 + TEXT2 + TEXT3 + PARACGRPCD	
	--FROM 
	--	#Detail

	DROP TABLE #Detail
END