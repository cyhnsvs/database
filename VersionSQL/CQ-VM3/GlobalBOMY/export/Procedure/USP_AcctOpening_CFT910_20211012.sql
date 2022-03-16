/****** Object:  Procedure [export].[USP_AcctOpening_CFT910_20211012]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_AcctOpening_CFT910_20211012]
(
	@idteProcessDate DATE
)
AS
/*
Description : STP Bulk Account opening Request File to Bank.
Test Input	: EXEC [export].[USP_AcctOpening_CFT910] '2020-06-01'
*/
BEGIN
	
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
		'02', -- Bulk Account Opening Type
		REPLACE(CONVERT(VARCHAR,@idteProcessDate,103),'/',''),
		'0001',
		'AA012001',
		'ZALIFAH',
		' '
		
	---- Data Record
	--CREATE TABLE export.Tb_BURSA_CFT910
	--(
	--	RecordType			CHAR(1),
	--	ParticiapantCode	CHAR(9),
	--	AcctNo				CHAR(9),
	--	AcctType			CHAR(2),
	--	NRICId				CHAR(14),		
	--	OldNRICId			CHAR(14),
	--	ExistInvInd			CHAR(1),
	--	InvestorName		CHAR(60),
	--	InvestorType		CHAR(2),
	--	[Nationality/POI]   CHAR(3),
	--	Race				CHAR(1),
	--	Address1			CHAR(45),
	--	Address2			CHAR(45),
	--	Town				CHAR(25),
	--	[State]				CHAR(1),
	--	PostalCode			CHAR(5),
	--	Country				CHAR(3),
	--	BeneficialOwner		CHAR(1),
	--	Qualifier1			CHAR(60),
	--	Qualifier2			CHAR(60),
	--	CorrAddress1		CHAR(45),
	--	CorrAddress2		CHAR(45),
	--	CorrTown			CHAR(25),
	--	CorrState			CHAR(1),
	--	CorrPostalCode		CHAR(5),
	--	CorrCountry			CHAR(3),
	--	PhoneIdd			CHAR(3),
	--	PhoneStd			CHAR(5),
	--	PhoneLocal			CHAR(8),
	--	PhoneExt			CHAR(3),
	--	AcctStatus			CHAR(1),
	--	BankAccount			CHAR(20),
	--	BankCode			CHAR(6),
	--	ConsolidateInd		CHAR(1),
	--	JointInd			CHAR(1),
	--	PhoneMobileIdd		CHAR(3),
	--	PhoneMobileCode		CHAR(3),
	--	PhoneMobileNo		CHAR(8),
	--	Email				CHAR(200),
	--	DateConsentEnd		CHAR(8),
	--	Remarks				CHAR(30),
	--	TaggingCode			CHAR(1),
	--	Filler				CHAR(44),
	--	Status				varchar(1),
	--	StatusRemarks		varchar(2000),
	--);
	TRUNCATE TABLE export.Tb_BURSA_CFT910;

	INSERT INTO export.Tb_BURSA_CFT910
	(
		 RecordType			
		,ParticiapantCode	
		,AcctNo				
		,AcctType			
		,NRICId				
		,OldNRICId			
		,ExistInvInd			
		,InvestorName		
		,InvestorType		
		,[Nationality/POI]   
		,Race				
		,Address1			
		,Address2			
		,Town				
		,[State]				
		,PostalCode			
		,Country				
		,BeneficialOwner		
		,Qualifier1			
		,Qualifier2			
		,CorrAddress1		
		,CorrAddress2		
		,CorrTown			
		,CorrState			
		,CorrPostalCode		
		,CorrCountry			
		,PhoneIdd			
		,PhoneStd			
		,PhoneLocal			
		,PhoneExt			
		,AcctStatus			
		,BankAccount			
		,BankCode			
		,ConsolidateInd		
		,JointInd			
		,PhoneMobileIdd		
		,PhoneMobileCode		
		,PhoneMobileNo		
		,Email				
		,DateConsentEnd		
		,Remarks				
		,TaggingCode			
		,Filler
		,Status
		,StatusRemarks
	)
	SELECT 
		1,
		'000012001',
		'' AS [AccountNumber (textinput-5)], --CDS No
		CASE WHEN [ParentGroup (selectsource-3)]='M' THEN 'WT' ELSE 'ZT' END AS [AccountType (selectsource-7)], --hardcoded
		CASE WHEN [IDType (selectsource-1)]='NC' AND LEN([IDNumber (textinput-5)]) = 12 
			 THEN LEFT([IDNumber (textinput-5)],6)+'-'+RIGHT(LEFT([IDNumber (textinput-5)],8),2)+'-'+RIGHT([IDNumber (textinput-5)],4) 
			 ELSE LEFT([IDNumber (textinput-5)],14) END,
		[AlternateIDNumber (textinput-6)],
		'', -- Exisitng Investor Indicator  
		Customer.[CustomerName (textinput-3)],
		CASE WHEN [ClientType (selectbasic-26)] = 'C' 
			 THEN 'O'
			 ELSE [ClientType (selectbasic-26)] END,
		[Nationality (selectsource-4)],
		CASE WHEN [ClientType (selectbasic-26)] = 'I' 
			 THEN CASE WHEN [BumiputraStatus (multipleradiosinline-1)] = 'Y' 
					   OR [Race (selectsource-3)] IN ('B', 'N', 'K', 'M', 'D') THEN 'B'
					   ELSE [Race (selectsource-3)]
				  END
			 ELSE 'Z'+[Ownership (selectsource-35)]
			 END,
		CASE WHEN LEN([Address1 (textinput-35)]) > 45 
			 THEN LEFT([Address1 (textinput-35)],45) ELSE [Address1 (textinput-35)] END,
		CASE WHEN LEN([Address1 (textinput-35)]) > 45 
			 THEN SUBSTRING([Address1 (textinput-35)],46,LEN([Address1 (textinput-35)])) + ' ' + [Address2 (textinput-36)] ELSE [Address2 (textinput-36)] END,
		[Town (textinput-38)],
		--CASE WHEN [Country (selectsource-24)] = 'MY' THEN [State (selectsource-25)] ELSE [State (textinput-39)] END,
		CASE WHEN [State (selectsource-25)] = 'PRK' THEN 'A'
			 WHEN [State (selectsource-25)] = 'SGR' THEN 'B'
			 WHEN [State (selectsource-25)] = 'PHG' THEN 'C'
			 WHEN [State (selectsource-25)] = 'KLT' THEN 'D'
			 WHEN [State (selectsource-25)] = 'JHR' THEN 'J'
			 WHEN [State (selectsource-25)] = 'KDH' THEN 'K'
			 WHEN [State (selectsource-25)] = 'LBN' THEN 'L'
			 WHEN [State (selectsource-25)] = 'MLC' THEN 'M'
			 WHEN [State (selectsource-25)] = 'NSL' THEN 'N'
			 WHEN [State (selectsource-25)] = 'PNG' THEN 'P'
			 WHEN [State (selectsource-25)] = 'PRL' THEN 'R'
			 WHEN [State (selectsource-25)] = 'SBH' THEN 'S'
			 WHEN [State (selectsource-25)] = 'TRG' THEN 'T'
			 WHEN [State (selectsource-25)] = 'WPN' THEN 'W'
			 WHEN [State (selectsource-25)] = 'SRK' THEN 'Y'
			 ELSE ''
		END,
		--CASE WHEN [State (textinput-39)] = 'PERAK' THEN 'A'
		--	 WHEN [State (textinput-39)] = 'SELANGOR' THEN 'B'
		--	 WHEN [State (textinput-39)] = 'PAHANG' THEN 'C'
		--	 WHEN [State (textinput-39)] = 'KELANTAN' THEN 'D'
		--	 WHEN [State (textinput-39)] = 'JOHOR' THEN 'J'
		--	 WHEN [State (textinput-39)] = 'KEDAH' THEN 'K'
		--	 WHEN [State (textinput-39)] = 'WILAYAH PERSEKUTUAN LABUAN' THEN 'L'
		--	 WHEN [State (textinput-39)] = 'MELAKA' THEN 'M'
		--	 WHEN [State (textinput-39)] = 'NEGERI SEMBILAN' THEN 'N'
		--	 WHEN [State (textinput-39)] = 'PULAU PINANG' THEN 'P'
		--	 WHEN [State (textinput-39)] = 'PERLIS' THEN 'R'
		--	 WHEN [State (textinput-39)] = 'SABAH' THEN 'S'
		--	 WHEN [State (textinput-39)] = 'TERENGGANU' THEN 'T'
		--	 WHEN [State (textinput-39)] = 'WILAYAH PERSEKUTUAN' THEN 'W'
		--	 WHEN [State (textinput-39)] = 'SARAWAK' THEN 'Y'
		--	 ELSE ''
		--END,
		LEFT([Postcode (textinput-40)],5),
		ISNULL(CM1.BursaCountryCode,[Country (selectsource-24)]),
		CASE WHEN [NomineeInd (selectsource-5)] <>'N' OR [ParentGroup (selectsource-3)] = 'G'
			 THEN CASE WHEN [NomineeInd (selectsource-5)] = 'T' THEN 'M' ELSE 'F' END
			 ELSE '' END, -- Beneficial Owner Code 
		CASE WHEN [NomineeInd (selectsource-5)] <>'N' OR [ParentGroup (selectsource-3)] = 'G' 
			 THEN [NomineesName2 (textinput-7)] ELSE '' END, -- Qualifier1 
		CASE WHEN [NomineeInd (selectsource-5)] <>'N' OR [ParentGroup (selectsource-3)] = 'G' 
			 THEN [CustomerName (textinput-3)] ELSE '' END, -- Qualifier2 
		[Address1 (textinput-41)],
		[Address2 (textinput-42)],
		[Town (textinput-44)],
		--CASE WHEN [Country (selectsource-24)] = 'MY' THEN [State (selectsource-25)] ELSE [State (textinput-39)] END,
		CASE WHEN [State (selectsource-26)] = 'PRK' THEN 'A'
			 WHEN [State (selectsource-26)] = 'SGR' THEN 'B'
			 WHEN [State (selectsource-26)] = 'PHG' THEN 'C'
			 WHEN [State (selectsource-26)] = 'KLT' THEN 'D'
			 WHEN [State (selectsource-26)] = 'JHR' THEN 'J'
			 WHEN [State (selectsource-26)] = 'KDH' THEN 'K'
			 WHEN [State (selectsource-26)] = 'LBN' THEN 'L'
			 WHEN [State (selectsource-26)] = 'MLC' THEN 'M'
			 WHEN [State (selectsource-26)] = 'NSL' THEN 'N'
			 WHEN [State (selectsource-26)] = 'PNG' THEN 'P'
			 WHEN [State (selectsource-26)] = 'PRL' THEN 'R'
			 WHEN [State (selectsource-26)] = 'SBH' THEN 'S'
			 WHEN [State (selectsource-26)] = 'TRG' THEN 'T'
			 WHEN [State (selectsource-26)] = 'WPN' THEN 'W'
			 WHEN [State (selectsource-26)] = 'SRK' THEN 'Y'
			 ELSE ''
		END,
		LEFT([Postcode (textinput-46)],5),
		ISNULL(CM2.BursaCountryCode,[Country (selectsource-27)]),
		'', -- Phone-Idd 
		SUBSTRING([PhoneHouse (textinput-55)],0,CHARINDEX('-',[PhoneHouse (textinput-55)])),
		SUBSTRING([PhoneHouse (textinput-55)],CHARINDEX('-',[PhoneHouse (textinput-55)]) + 1,LEN([PhoneHouse (textinput-55)])),
		'', --Phone-Ext
		[Tradingaccount (selectsource-31)],
		ISNULL(BG.[Account Number (TextBox)],''), -- Bank Account 
		ISNULL(ISNULL(BM.BursaBankCode,BG.[Bank (Dropdown)]),''), -- Bank Code 
		[eDividend (multipleradiosinline-24)], -- Consolidate eDividend Information indicator 
		ISNULL(BG.[Joint Account  (Dropdown)],''), -- Joint Bank Account Ind -N
		'',  --PhoneMobile-Idd 
		LEFT(SUBSTRING([PhoneMobile (textinput-57)],0,CHARINDEX('-',[PhoneMobile (textinput-57)])),3),
		LEFT(SUBSTRING([PhoneMobile (textinput-57)],CHARINDEX('-',[PhoneMobile (textinput-57)]) + 1,LEN([PhoneMobile (textinput-57)])),8),
		[Email (textinput-58)],
		'', -- Consent Expiry Date Defaul to Empty for Request Type '02' 
		'' [Remarks (textinput-72)],
		'Y', 
		'',
		'C',
		''
	FROM CQBTempDB.export.Tb_FormData_1409 Account
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	LEFT JOIN GlobalBOMY.export.Tb_Bursa_Country_Mapping AS CM1
		ON Customer.[Country (selectsource-24)] = CM1.GBOCountryCode
	LEFT JOIN GlobalBOMY.export.Tb_Bursa_Country_Mapping AS CM2
		ON Customer.[Country (selectsource-27)] = CM2.GBOCountryCode
	LEFT JOIN 
		(SELECT * 
		 FROM CQBTempDB.export.Tb_FormData_1410_grid6
		 WHERE [ (Radio Button)] = 'Y'
		 UNION
		 SELECT b.* 
		 FROM CQBTempDB.export.Tb_FormData_1410_grid6 as b
		 INNER JOIN 
			 (
				 SELECT g.RecordID, ROW_NUMBER() OVER (PARTITION BY g.RecordID ORDER BY RowIndex) as rn
				 FROM CQBTempDB.export.Tb_FormData_1410_grid6 as g
				 LEFT JOIN 
					(SELECT DISTINCT RecordID 
					 FROM CQBTempDB.export.Tb_FormData_1410_grid6
					 WHERE [ (Radio Button)]='Y'
					 GROUP BY RecordID
					 ) as gd
				 ON g.RecordID = gd.RecordID
				 WHERE gd.RecordID IS NULL
			) AS B1
		ON b.RecordID = b1.RecordID and b1.rn = 1
	) BG 
		ON Customer.RecordID = BG.RecordID
	LEFT JOIN GlobalBOMY.export.Tb_Bursa_Bank_Mapping AS BM
		ON BG.[Bank (Dropdown)] = BM.GBOBankCode
	WHERE Account.[CDSNo (textinput-19)] = 'DUMMY' AND [CustomerID (textinput-1)] = '0319015';
	
	-- TRAILER RECORD
	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(1) FROM export.Tb_BURSA_CFT910);

	CREATE TABLE #Trailer
	(
		RecordType		CHAR(1),
		TotalRecords	CHAR(9),
		Filler			CHAR(820)
	);

	INSERT INTO #Trailer 
	VALUES('2',RIGHT(REPLICATE('0',9) + CAST(@Count as varchar(50)),9),'');

	-- RESULT SET 
	SELECT RecordType + ParticipantRequest + RequestType + RequestDate + ReqSeqNo + GroupID + UserID + Filler
	FROM #Header
	
	UNION ALL
	
	SELECT RecordType+ ParticiapantCode+ AcctNo+ AcctType+ NRICId+ OldNRICId+ ExistInvInd+ InvestorName+ InvestorType+ [Nationality/POI]+ Race
		    + Address1+ Address2+ Town+ [State]+ PostalCode+ Country+ BeneficialOwner+ Qualifier1+ Qualifier2+ CorrAddress1+ CorrAddress2
			+ CorrTown+ CorrState+ CorrPostalCode+ CorrCountry+ PhoneIdd+ PhoneStd+ PhoneLocal+ PhoneExt+ AcctStatus+ BankAccount+ BankCode
			+ ConsolidateInd+ JointInd+ PhoneMobileIdd+ PhoneMobileCode+ PhoneMobileNo+ Email+ DateConsentEnd+ Remarks+ TaggingCode+ Filler	
	FROM export.Tb_BURSA_CFT910
	
	UNION ALL
	
	SELECT RecordType + TotalRecords + Filler
	FROM #Trailer;

END