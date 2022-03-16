/****** Object:  Procedure [export].[USP_AcctOpening_CFT910_Consent]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_AcctOpening_CFT910_Consent]
(
	@idteProcessDate DATE
)
AS
/*
Description : STP Bulk Account opening Request File to Bank.
Test Input	: EXEC [export].[USP_AcctOpening_CFT910_Consent] '2021-10-01'
*/
BEGIN
	
	--select * 
	--from import.Tb_Gbo_CustomerInfo as c
	--INNER JOIN CQBTempDB.export.Tb_FormData_1410 as ec
	--on c.IDNumber = ec.[IDNumber (textinput-5)]
	--INNER JOIN CQBuilder.form.Tb_FormData_1409 as ac
	--on ec.[CustomerID (textinput-1)] = ac.[selectsource-1]

	--select * from import.Tb_Gbo_CustomerInfo where importstatus='R'
	
	-- Header Record
	CREATE TABLE #Header
	(
		RecordType			CHAR(1),
		ParticipantRequest	CHAR(9),
		RequestType			CHAR(2),
		RequestDate			CHAR(8),
		ReqSeqNo			CHAR(4),
		GroupID				CHAR(8),
		UserID				CHAR(8),
		Filler				CHAR(790)
	)

	INSERT INTO #Header
	(
		 RecordType			
		,ParticipantRequest	
		,RequestType			
		,RequestDate			
		,ReqSeqNo			
		,GroupID				
		,UserID				
		,Filler				
	)
	SELECT 
		0,
		'000012001',
		'01', -- Bulk Account Consent Registration
		REPLACE(CONVERT(VARCHAR,@idteProcessDate,103),'/',''),
		'0004',
		'AA012001',
		'ZALIFAH',
		' '
		
	---- Data Record

	CREATE TABLE #Tb_BURSA_CFT910
	(
		RecordType			CHAR(1),
		ParticipantCode		CHAR(9),
		AcctNo				CHAR(9),
		AcctType			CHAR(2),
		NRICId				CHAR(14),		
		OldNRICId			CHAR(14),
		ExistInvInd			CHAR(1),
		InvestorName		CHAR(60),
		InvestorType		CHAR(2),
		[Nationality/POI]   CHAR(3),
		Race				CHAR(1),
		Address1			CHAR(45),
		Address2			CHAR(45),
		Town				CHAR(25),
		[State]				CHAR(1),
		PostalCode			CHAR(5),
		Country				CHAR(3),
		BeneficialOwner		CHAR(1),
		Qualifier1			CHAR(60),
		Qualifier2			CHAR(60),
		CorrAddress1		CHAR(45),
		CorrAddress2		CHAR(45),
		CorrTown			CHAR(25),
		CorrState			CHAR(1),
		CorrPostalCode		CHAR(5),
		CorrCountry			CHAR(3),
		PhoneIdd			CHAR(3),
		PhoneStd			CHAR(5),
		PhoneLocal			CHAR(8),
		PhoneExt			CHAR(3),
		AcctStatus			CHAR(1),
		BankAccount			CHAR(20),
		BankCode			CHAR(6),
		ConsolidateInd		CHAR(1),
		JointInd			CHAR(1),
		PhoneMobileIdd		CHAR(3),
		PhoneMobileCode		CHAR(3),
		PhoneMobileNo		CHAR(8),
		Email				CHAR(200),
		DateConsentEnd		CHAR(8),
		Remarks				CHAR(30),
		TaggingCode			CHAR(1),
		Filler				CHAR(44),
		Status				varchar(1),
		StatusRemarks		varchar(2000),
	);

	INSERT INTO #Tb_BURSA_CFT910
	(
		 RecordType,ParticipantCode,AcctNo,AcctType,NRICId,OldNRICId,ExistInvInd,InvestorName		
		,InvestorType,[Nationality/POI],Race,Address1,Address2,Town,[State],PostalCode			
		,Country,BeneficialOwner,Qualifier1, Qualifier2, CorrAddress1, CorrAddress2
		,CorrTown,CorrState,CorrPostalCode,CorrCountry,PhoneIdd,PhoneStd,PhoneLocal,PhoneExt
		,AcctStatus,BankAccount,BankCode,ConsolidateInd,JointInd,PhoneMobileIdd,PhoneMobileCode
		,PhoneMobileNo,Email,DateConsentEnd,Remarks,TaggingCode,Filler,Status,StatusRemarks
	)
	SELECT 
		1 AS RecordType,
		'000012001' AS ParticipantCode,
		[CDSAccount (selectsource-32)] AS AcctNo, --CDS No
		'' AS AcctType, --hardcoded
		'' AS NRICId,
		'' AS OldNRICId,
		'' AS ExistInvInd, -- Exisitng Investor Indicator  
		'' AS InvestorName,
		'' AS InvestorType,
		'' AS [Nationality/POI],
		'' AS Race,
		'' AS Address1,
		'' AS Address2,
		'' AS Town,
		'' AS [State],
		'' AS PostalCode,
		'' AS Country,
		'' AS BeneficialOwner, -- Beneficial Owner Code 
		'' AS Qualifier1, -- Qualifier1 
		'' AS Qualifier2, -- Qualifier2 
		'' AS CorrAddress1,
		'' AS CorrAddress2,
		'' AS CorrTown,
		'' AS CorrState,
		'' AS CorrPostalCode,
		'' AS CorrCountry, 
		'' AS PhoneIdd,  -- Phone-Idd 
		'' AS PhoneStd,
		'' AS PhoneLocal, 
		'' AS PhoneExt, --Phone-Ext
		'' AS AcctStatus,
		'' AS BankAccount, -- Bank Account 
		'' AS BankCode, -- Bank Code 
		'' AS ConsolidateInd, -- Consolidate eDividend Information indicator 
		'' AS JointInd, -- Joint Bank Account Ind -N
		'' AS PhoneMobileIdd,  --PhoneMobile-Idd 
		'' AS PhoneMobileCode,
		'' AS PhoneMobileNo,
		'' AS Email,
		'' AS DateConsentEnd, -- Consent Expiry Date Defaul to Empty for Request Type '02' 
		'' AS Remarks,
		'' AS TaggingCode, 
		'' AS Filler,
		'' AS Status,
		'' AS StatusRemarks
	FROM CQBTempDB.export.Tb_FormData_1409 AS Account
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	INNER JOIN import.Tb_AcctOpening_CFT040 AS BC
		ON Account.[CDSNo (textinput-19)] = BC.AcctNo
	WHERE [CDSNo (textinput-19)]='072772551';

	-- TRAILER RECORD
	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(1) FROM #Tb_BURSA_CFT910);

	CREATE TABLE #Trailer
	(
		RecordType		CHAR(1),
		TotalRecords	CHAR(9),
		Filler			CHAR(820)
	);

	INSERT INTO #Trailer 
	VALUES('2',RIGHT(REPLICATE('0',9) + CAST(@Count as varchar(50)),9),'');

	DECLARE @strFileMax VARCHAR(MAX);

	-- RESULT SET 
	SET @strFileMax = (SELECT RecordType + ParticipantRequest + RequestType + RequestDate + ReqSeqNo + GroupID + UserID + Filler FROM #Header)
	
	SELECT @strFileMax+= STRING_AGG(CAST(RecordType AS VARCHAR(MAX)) +  CAST(ParticipantCode AS VARCHAR(MAX)) +  CAST(AcctNo AS VARCHAR(MAX)) +  CAST(AcctType AS VARCHAR(MAX)) +  CAST(NRICId AS VARCHAR(MAX)) +  CAST(OldNRICId AS VARCHAR(MAX)) +  CAST(ExistInvInd AS VARCHAR(MAX)) +  CAST(InvestorName AS VARCHAR(MAX)) +  CAST(InvestorType AS VARCHAR(MAX)) +  CAST([Nationality/POI] AS VARCHAR(MAX)) +  CAST(Race
		     AS VARCHAR(MAX)) +  CAST(Address1 AS VARCHAR(MAX)) +  CAST(Address2 AS VARCHAR(MAX)) +  CAST(Town AS VARCHAR(MAX)) +  CAST([State] AS VARCHAR(MAX)) +  CAST(PostalCode AS VARCHAR(MAX)) +  CAST(Country AS VARCHAR(MAX)) +  CAST(BeneficialOwner AS VARCHAR(MAX)) +  CAST(Qualifier1 AS VARCHAR(MAX)) +  CAST(Qualifier2 AS VARCHAR(MAX)) +  CAST(CorrAddress1 AS VARCHAR(MAX)) +  CAST(CorrAddress2
			 AS VARCHAR(MAX)) +  CAST(CorrTown AS VARCHAR(MAX)) +  CAST(CorrState AS VARCHAR(MAX)) +  CAST(CorrPostalCode AS VARCHAR(MAX)) +  CAST(CorrCountry AS VARCHAR(MAX)) +  CAST(PhoneIdd AS VARCHAR(MAX)) +  CAST(PhoneStd AS VARCHAR(MAX)) +  CAST(PhoneLocal AS VARCHAR(MAX)) +  CAST(PhoneExt AS VARCHAR(MAX)) +  CAST(AcctStatus AS VARCHAR(MAX)) +  CAST(BankAccount AS VARCHAR(MAX)) +  CAST(BankCode
			 AS VARCHAR(MAX)) +  CAST(ConsolidateInd AS VARCHAR(MAX)) +  CAST(JointInd AS VARCHAR(MAX)) +  CAST(PhoneMobileIdd AS VARCHAR(MAX)) +  CAST(PhoneMobileCode AS VARCHAR(MAX)) +  CAST(PhoneMobileNo AS VARCHAR(MAX)) +  CAST(Email AS VARCHAR(MAX)) +  CAST(DateConsentEnd AS VARCHAR(MAX)) +  CAST(Remarks AS VARCHAR(MAX)) +  CAST(TaggingCode AS VARCHAR(MAX)) +  CAST(Filler AS varchar(MAX)),'')
	FROM #Tb_BURSA_CFT910

	--UNION ALL
	SET @strFileMax+= (SELECT RecordType + TotalRecords + Filler FROM #Trailer);

	SELECT @strFileMax;

	DROP TABLE #Header;
	DROP TABLE #Trailer;
	DROP TABLE #Tb_BURSA_CFT910;

END