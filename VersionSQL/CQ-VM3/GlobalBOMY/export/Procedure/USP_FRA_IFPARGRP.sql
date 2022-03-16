/****** Object:  Procedure [export].[USP_FRA_IFPARGRP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFPARGRP] 
(
	@idteProcessDate DATE
)
AS
BEGIN

	SET NOCOUNT ON;

	CREATE TABLE #IFPARGRP
	(
		 PARACGRPCD		CHAR(5)
		,DESCRIPTN		CHAR(30)
		,IND1			CHAR(1)
		,IND2			CHAR(1)
		,TEXT1			CHAR(10)
		,TEXT2			CHAR(10)
		,AMOUNT1		CHAR(8)
		,AMOUNT2		CHAR(8)
		,QUANTITY1		CHAR(5)
		,QUANTITY2		CHAR(5)
		,DATE1			CHAR(10)
		,DATE2			CHAR(10)
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

	INSERT INTO #IFPARGRP
	(
		 PARACGRPCD	
		,DESCRIPTN	
		,IND1		
		,IND2		
		,TEXT1		
		,TEXT2		
		,AMOUNT1	
		,AMOUNT2	
		,QUANTITY1	
		,QUANTITY2	
		,DATE1		
		,DATE2		
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
		 [2DigitCode (textinput-1)]	
		,[Description (textinput-2)]	
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
		CQBTempDB.export.Tb_FormData_1457 


	--RESULT SET

	SELECT 
		PARACGRPCD + DESCRIPTN + IND1 + IND2 + TEXT1 + TEXT2 + AMOUNT1 + AMOUNT2 + QUANTITY1 + QUANTITY2 + DATE1 + DATE2		
		+ USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + RCDSTAT	+ RCDVERSION + PGMLSTUPD + TRIGGERACT	
	FROM 
		#IFPARGRP	

	DROP TABLE #IFPARGRP
END