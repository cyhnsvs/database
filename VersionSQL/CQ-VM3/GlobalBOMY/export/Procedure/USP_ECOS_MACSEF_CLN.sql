/****** Object:  Procedure [export].[USP_ECOS_MACSEF_CLN]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEF_CLN]
(
	@idteProcessDate DATE
)
AS
-- ONLINE CLIENT INFO
-- EXEC [export].[USP_ECOS_MACSEF_CLN] '2020-06-01'
BEGIN
	CREATE TABLE #Clients
	(
		 RecordType		CHAR(1)
		,AcctNo			CHAR(9)
		,CLientName		CHAR(50)
		,ClientType		CHAR(8)
		,ICNo			CHAR(20)
		,OldICNo		CHAR(20)
		,BranchID		CHAR(4)
		,CDSNo			CHAR(10)
		,DealerID		CHAR(10)
		,[Status]		CHAR(2)
		,HomePhoneNo	CHAR(12)
		,OfficePhoneNo	CHAR(12)
		,MobilePhoneNo	CHAR(12)
		,Address1		CHAR(50)
		,Address2		CHAR(50)
		,Address3		CHAR(50)
		,Address4		CHAR(50)
		,PostCode		CHAR(5)
		,Email			CHAR(50)
		,UserID			CHAR(12)
		,RecordInd		CHAR(1)
		,CashMultiplier	CHAR(5)
	)
	INSERT INTO #Clients
	(
		 RecordType		
		,AcctNo		
		,CLientName		
		,ClientType		
		,ICNo			
		,OldICNo		
		,BranchID		
		,CDSNo			
		,DealerID		
		,[Status]		
		,HomePhoneNo	
		,OfficePhoneNo	
		,MobilePhoneNo	
		,Address1		
		,Address2		
		,Address3		
		,Address4		
		,PostCode		
		,Email			
		,UserID			
		,RecordInd		
		,CashMultiplier	
	)
	SELECT 
		1,
		Account.[AccountNumber (textinput-5)],
		Customer.[CustomerName (textinput-3)],
		[ClientType (selectbasic-26)],
		Customer.[IDNumber (textinput-5)],
		Customer.[AlternateIDNumber (textinput-6)],
		Dealer.[BranchID (selectsource-1)],
		Account.[CDSNo (textinput-19)],
		Dealer.[BFEDealerCode (textinput-26)],
		Account.[Tradingaccount (selectsource-31)],
		[PhoneHouse (textinput-55)],
		[PhoneOffice (textinput-17)],
		[PhoneMobile (textinput-57)],
		[Address1 (textinput-35)],
		[Address2 (textinput-36)],
		[Address3 (textinput-37)],
		[State (textinput-39)],
		[Postcode (textinput-40)],
		[Email (textinput-58)],
		[CustomerID (textinput-1)],
		'N',
		Account.[MultiplierforCashDeposit (textinput-56)]		
	FROM 
		CQBTempDB.export.Tb_FormData_1409 Account
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 Customer ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1377 Dealer ON Account.[DealerCode (selectsource-21)] = Dealer.[DealerCode (textinput-35)]
	WHERE 
		ISNULL(Account.[CDSNo (textinput-19)],'') <> '' 
	AND 
		ISNULL([MRIndicator (multipleradiosinline-4)],'') LIKE '%M+%' 
		
	-- UPDATE Record Indicator
	UPDATE C
	SET C.RecordInd = CASE WHEN S.[AccountNumber (textinput-5)] IS NOT NULL THEN 'O' ELSE 'N' END
	FROM 
		#Clients C
	LEFT JOIN 
		GlobalBORpt.form.Tb_FormData_1409 S ON C.AcctNo = S.[AccountNumber (textinput-5)] AND C.UserID = S.[CustomerID (selectsource-1)] 
											AND CAST(dateadd(day,datediff(day,1,@idteProcessDate),0) AS DATE) = CAST(S.CreatedTime AS DATE)			
		

	

	-- BATCH TRAIL 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Clients)
	
	CREATE TABLE #ClientTrail
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	)
	INSERT INTO #ClientTrail
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate, 105))

	-- BATCH DETAILS - RESULT SET
	SELECT 
		ISNULL(RecordType,'') + '|' + ISNULL(AcctNo,'') + '|' +  ISNULL(CLientName,'') + '|' +  ISNULL(ClientType,'') + '|' + 
		ISNULL(ICNo,'') + '|' +  ISNULL(OldICNo,'') + '|' +  ISNULL(BranchID,'')+ '|' +  ISNULL(CDSNo,'') + '|' +  ISNULL(DealerID,'') + '|' +  
		ISNULL([Status],'') + '|' +  ISNULL(HomePhoneNo,'') + '|' +  ISNULL(OfficePhoneNo,'') + '|' +  ISNULL(MobilePhoneNo,'') + '|' +  
		ISNULL(Address1,'') + '|' +  ISNULL(Address2,'') + '|' +  ISNULL(Address3,'') + '|' +  ISNULL(Address4,'') + '|' +  ISNULL(PostCode,'')
		+ '|' +  ISNULL(Email,'') + '|' +  ISNULL(UserID,'') + '|' +  ISNULL(RecordInd,'') + '|' +  ISNULL(CashMultiplier,'')
	FROM 
		#Clients
	UNION ALL
	-- BATCH TRAIL - RESULT SET
	SELECT 
		RecordType + '|' +  RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + '|' +  ProcessDate
	FROM
		#ClientTrail

	DROP TABLE #Clients
	DROP TABLE #ClientTrail

END
	