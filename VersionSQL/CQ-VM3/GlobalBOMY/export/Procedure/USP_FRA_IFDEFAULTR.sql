/****** Object:  Procedure [export].[USP_FRA_IFDEFAULTR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFDEFAULTR]
(
	@idteProcessDate DATETIME
)
AS
/*
WATCH LIST DETAILS 
EXEC [export].[USP_FRA_IFDEFAULTR] '2020-06-01'
*/
BEGIN
	
	-- DETAILS
	CREATE TABLE #Details
	(
		 DEFAULTKEY  CHAR(6)  
		,CUSTKEY     CHAR(15) 
		,EXCHDOCREF  CHAR(15) 
		,IDTYPECD    CHAR(2)  
		,IDNUMBER    CHAR(15) 
		,IDTYPECD1   CHAR(2)  
		,CLTPASSPNO  CHAR(20) 
		,IDNUMBER1   CHAR(15) 
		,RACECD      CHAR(2)  
		,DFTNAME     CHAR(50) 
		,CORRADDR1   CHAR(40) 
		,CORRADDR2   CHAR(40) 
		,CORRADDR3   CHAR(40) 
		,CORRADDR4   CHAR(40) 
		,CORRADDR5   CHAR(40) 
		,CORRPOSTCD  CHAR(10) 
		,REMARK1     CHAR(50) 
		,REMARK2     CHAR(50) 
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
		,TRXAMT      CHAR(8)  
		,DEFAULTDT   CHAR(10) 
		,CIRCUPLIFT  CHAR(15) 
		,UPLIFTDT    CHAR(10) 
		,DFTTYPE     CHAR(1)  
		,REASONCD    CHAR(4)  
		,DFTSTATUS   CHAR(1)  
		,DTRPTEXCH   CHAR(10) 
		,DTKIV       CHAR(10) 
		,DTCLOSE     CHAR(10) 
		,AMTOSINT    CHAR(8)      
	)

	INSERT INTO #Details
	(
		  DEFAULTKEY 
		 ,CUSTKEY    
		 ,EXCHDOCREF 
		 ,IDTYPECD   
		 ,IDNUMBER   
		 ,IDTYPECD1  
		 ,CLTPASSPNO 
		 ,IDNUMBER1  
		 ,RACECD     
		 ,DFTNAME    
		 ,CORRADDR1  
		 ,CORRADDR2  
		 ,CORRADDR3  
		 ,CORRADDR4  
		 ,CORRADDR5  
		 ,CORRPOSTCD 
		 ,REMARK1    
		 ,REMARK2    
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
		 ,TRXAMT     
		 ,DEFAULTDT  
		 ,CIRCUPLIFT 
		 ,UPLIFTDT   
		 ,DFTTYPE    
		 ,REASONCD   
		 ,DFTSTATUS  
		 ,DTRPTEXCH  
		 ,DTKIV      
		 ,DTCLOSE    
		 ,AMTOSINT   
	)
	SELECT 
	
		  ''
		 ,[IDNumber (textinput-2)]
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
		 ,[Details (textarea-1)]
		 ,''
		 ,''
		 ,FORMAT(CreatedTime,'MM/dd/yyyy')
		 ,''
		 ,''
		 ,FORMAT(UpdatedTime,'MM/dd/yyyy')
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''--,[Type (selectsource-1)]
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		 ,''
		FROM 
		CQBTempDB.export.tb_formdata_1661 Watch
	--INNER JOIN 
	--	GlobalBO.holdings.Tb_Cash cash ON Account.[AccountNumber (textinput-5)] =  Cash.AcctNo
			
	-- RESULT SET
	SELECT 
		  DEFAULTKEY + CUSTKEY + EXCHDOCREF + IDTYPECD + IDNUMBER + IDTYPECD1 + CLTPASSPNO + IDNUMBER1 + RACECD + DFTNAME   
		+ CORRADDR1 + CORRADDR2 + CORRADDR3 + CORRADDR4 + CORRADDR5 + CORRPOSTCD + REMARK1 + REMARK2 + USRCREATED + DTCREATED 
		+ TMCREATED + USRUPDATED +ISNULL(DTUPDATED,'') + TMUPDATED + RCDSTAT + RCDVERSION + PGMLSTUPD + TRIGGERACT + TRXAMT + DEFAULTDT 
		+ CIRCUPLIFT + UPLIFTDT + DFTTYPE + REASONCD + DFTSTATUS + DTRPTEXCH + DTKIV + DTCLOSE + AMTOSINT  
	FROM 
		#Details

	DROP TABLE #Details
END