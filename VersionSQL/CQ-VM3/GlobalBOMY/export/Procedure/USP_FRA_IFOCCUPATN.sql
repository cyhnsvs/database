/****** Object:  Procedure [export].[USP_FRA_IFOCCUPATN]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFOCCUPATN]
(
	@idteProcessDate DATETIME
)
AS
/*
DEALER DETAILS 
EXEC [export].[USP_FRA_IFMOFAGPR] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 OCCUPCD		CHAR(150)
		,DESCRIPTN	    CHAR(30)
		,USRCREATED	    CHAR(10)
		,DTCREATED	    CHAR(10)
		,TMCREATED	    CHAR(8)
		,USRUPDATED	    CHAR(10)
		,DTUPDATED	    CHAR(10)
		,TMUPDATED	    CHAR(8)
		,RCDSTAT	    CHAR(1)
		,RCDVERSION	    CHAR(3)
		,PGMLSTUPD	    CHAR(10) 	 
	)

	INSERT INTO #Details
	(
		 OCCUPCD	
		,DESCRIPTN	
		,USRCREATED	
		,DTCREATED	
		,TMCREATED	
		,USRUPDATED	
		,DTUPDATED	
		,TMUPDATED	
		,RCDSTAT	
		,RCDVERSION	
		,PGMLSTUPD	  
	)
	SELECT 
		   [OccupationDesignation (selectsource-40)]--OCCUPCD
		  ,[SpouseOccupationDesignation (selectsource-41)]--DESCRIPTN
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
		  CQBTempDB.export.tb_formdata_1410
		  --INNER JOIN GlobalBO.Contracts.Tb_ContractOutstanding CON ON INS.InstrumentId = CON.InstrumentId
		  --INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account ON Account.[AccountNumber (textinput-5)] = CON.AcctNo
		  --WHERE INS.InstrumentCd LIKE '%.XKLS%'
		
	-- RESULT SET
	SELECT 
		   OCCUPCD + DESCRIPTN + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD	
	FROM 
		#Details

	DROP TABLE #Details
END