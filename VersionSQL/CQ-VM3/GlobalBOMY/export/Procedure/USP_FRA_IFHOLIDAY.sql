/****** Object:  Procedure [export].[USP_FRA_IFHOLIDAY]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFHOLIDAY]
(
	@idteProcessDate DATETIME
)
AS
/*
DEALER DETAILS 
EXEC [export].[USP_FRA_IFHOLIDAY] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 CALENDARID  CHAR(2) 
		,HOLDATE     CHAR(10)    
		,USRCREATED  CHAR(10)
		,DTCREATED   CHAR(10)
		,TMCREATED   CHAR(8) 
		,USRUPDATED  CHAR(10)
		,DTUPDATED   CHAR(10)
		,TMUPDATED   CHAR(8) 
		,RCDSTAT     CHAR(1) 
		,RCDVERSION  CHAR(3) 
		,PGMLSTUPD   CHAR(10)
		,TRIGGERACT  CHAR(1) 
		,DESCRIPTN   CHAR(30)   
	)

	INSERT INTO #Details
	(
		  CALENDARID
		 ,HOLDATE   
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
		 ,DESCRIPTN  
	)
	SELECT 
		  C.CalendarCd
		 ,FORMAT (CalendarDate, 'MM/dd/yyyy')
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
		 ,Remarks
	FROM GlobalBO.setup.Tb_CalendarDate CD
	INNER JOIN GlobalBO.setup.Tb_Calendar C On CD.CalendarId = C.CalendarId
	WHERE
		C.CalendarCd = 'MY'
	-- RESULT SET
	SELECT 
		   CALENDARID + HOLDATE + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED 
		   + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + DESCRIPTN 
	FROM 
		#Details

	DROP TABLE #Details
END