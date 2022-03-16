﻿/****** Object:  Procedure [export].[USP_FRA_IFBRANCH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFBRANCH]
(
	@idteProcessDate DATETIME
)
AS
/*
EXEC [export].[USP_FRA_IFBRANCH] '2020-06-01'
*/
BEGIN
	
	
	CREATE TABLE #Detail
	(
		 COMPANYID		CHAR(1)
		,BRANCHID		CHAR(4)
		,COUNTRYCD		CHAR(3)
		,CURRCODE		CHAR(3)
		,CALENDARID		CHAR(2)
		,BRNAME			CHAR(30)
		,MAINBRANCH		CHAR(1)
		,CORRADDR1		CHAR(40)
		,CORRADDR2		CHAR(40)
		,CORRADDR3		CHAR(40)
		,CORRADDR4		CHAR(40)
		,CORRNAME		CHAR(40)
		,CORRPOSTCD		CHAR(10)
		,PHONE			CHAR(15)
		,FAX			CHAR(15)
		,DIALUPNO		CHAR(15)
		,TELEX			CHAR(10)
		,SWIFTADD		CHAR(15)
		,CURFINPD		CHAR(2)
		,CURFINYR		CHAR(3)
		,CURAPPDT		CHAR(10)
		,GLBRNHPX		CHAR(10)
		,BASELENDRT		CHAR(5)
		,NWBSLNDRT		CHAR(5)
		,DTBSLNDEFF		CHAR(10)
		,USRCREATED		CHAR(10)
		,DTCREATED		CHAR(10)
		,TMCREATED		CHAR(8)
		,USRUPDATED		CHAR(10)
		,DTUPDATED		CHAR(10)
		,TMUPDATED		CHAR(8)
		,PGMLSTUPD		CHAR(10)
		,RCDSTAT		CHAR(1)
		,RCDVERSION		CHAR(3)
		,TRIGGERACT		CHAR(1)
		,DEFCSHBKID		CHAR(3)
		,BROKERCD		CHAR(5)
		,INETMAIL		CHAR(50)
	)

	INSERT INTO #Detail
	(
		  COMPANYID	
		 ,BRANCHID	
		 ,COUNTRYCD	
		 ,CURRCODE	
		 ,CALENDARID	
		 ,BRNAME		
		 ,MAINBRANCH	
		 ,CORRADDR1	
		 ,CORRADDR2	
		 ,CORRADDR3	
		 ,CORRADDR4	
		 ,CORRNAME	
		 ,CORRPOSTCD	
		 ,PHONE		
		 ,FAX		
		 ,DIALUPNO	
		 ,TELEX		
		 ,SWIFTADD	
		 ,CURFINPD	
		 ,CURFINYR	
		 ,CURAPPDT	
		 ,GLBRNHPX	
		 ,BASELENDRT	
		 ,NWBSLNDRT	
		 ,DTBSLNDEFF	
		 ,USRCREATED	
		 ,DTCREATED	
		 ,TMCREATED	
		 ,USRUPDATED	
		 ,DTUPDATED	
		 ,TMUPDATED	
		 ,PGMLSTUPD	
		 ,RCDSTAT	
		 ,RCDVERSION	
		 ,TRIGGERACT	
		 ,DEFCSHBKID	
		 ,BROKERCD	
		 ,INETMAIL	 												
	)
	SELECT 
		 ''
		,[BranchID (textinput-1)]
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
		CQBTempDB.export.Tb_FormData_1374
		
	-- RESULT SET
	SELECT 
		    COMPANYID + BRANCHID + COUNTRYCD + CURRCODE + CALENDARID + BRNAME + MAINBRANCH + CORRADDR1 + CORRADDR2	+ CORRADDR3 + CORRADDR4 + CORRNAME + CORRPOSTCD
			+ PHONE + FAX + DIALUPNO + TELEX + SWIFTADD + CURFINPD + CURFINYR + CURAPPDT + GLBRNHPX	+ BASELENDRT + NWBSLNDRT + DTBSLNDEFF + USRCREATED + DTCREATED	
			+ TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED + PGMLSTUPD + RCDSTAT + RCDVERSION + TRIGGERACT + DEFCSHBKID + BROKERCD + INETMAIL		 			
	FROM 
		#Detail

	DROP TABLE #Detail
END