/****** Object:  Procedure [import].[Usp_3_Customer_FileToForm1410_20210819]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_3_Customer_FileToForm1410]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 06/04/2020
Last Updated Date :             
Description       : this sp is used to insert Customer file data into CQForm Customer
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_3_Customer_FileToForm1410]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DEPENDENCY ON CUSTOMER & ACCOUNT MAPPING SCRIPT


		Exec CQBTempDB.form.[Usp_CreateImportTable] 1410;
		--Select * from CQBTempDB.[import].[Tb_FormData_1410]

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1410;

		IF OBJECT_ID('tempdb..#FinancialDetail') IS NOT NULL DROP TABLE #FinancialDetail;

		DECLARE @lastCustomerID BIGINT, @lastRunNo BIGINT;

		CREATE TABLE #FinancialDetail ( 
			RowIndex BIGINT, 
			CustomerKey Varchar(50), 
			SettlementACName Varchar(200), 
			SettlementBankAC Varchar(50), 
			BankCode Varchar(50),
			JointAccount Varchar(50)
		);

		INSERT INTO #FinancialDetail
		SELECT 
			ROW_NUMBER() over (partition by CustomerKey order by SettlementBankAC DESC, SettlementACName DESC, BankCode DESC) As rowIndex,
			*
		FROM (SELECT DISTINCT 
				AC.CustomerKey,
				ATL.SettlementACName,
				ATL.SettlementBankAC,
				BankCode,
				CASE WHEN LEN(Telex) IN (2,3) THEN RIGHT(LEFT(Telex,2),1) ELSE 'N' END AS JA
			FROM [import].Tb_Account as AC 
			INNER JOIN import.Tb_AccountMarketInfo As ATL
			ON Ac.AccountNumber = ATL.AccountNo
			WHERE SettlementACName <> '' OR SettlementBankAC <> '' OR BankCode <> '') AS F;

		IF OBJECT_ID('tempdb..#AccountProductTypeDetail') IS NOT NULL DROP TABLE #AccountProductTypeDetail;

		CREATE TABLE #AccountProductTypeDetail ( 
			RowIndex BIGINT, 
			CustomerKey Varchar(50),
			AccountType Varchar(50), 
			Algo Varchar(500),
			Foreigner Varchar(10), 
			DealerCode Varchar(50), 
			Nominees Varchar(50),
			CDSNo Varchar(50),
			Financier Varchar(100)
		);

		INSERT INTO #AccountProductTypeDetail
		SELECT 
			ROW_NUMBER() over (partition by CustomerKey order by AccountNumber) As rowIndex,
			CustomerKey,
			AM.AccountType2DigitCode,
			CASE WHEN AC.AccountGroup IN ('QC1','QJ1','QL1') THEN 'Elfstone' ELSE '' END,
			CASE WHEN AM.ForeignIndicator = 'Y' THEN 'Foreign' ELSE '' END,
			AC.BrokerCodeDealerEAFIDDealerCode,
			CASE WHEN AMI.NomineeInd <> '' THEN 'Y' ELSE 'N' END, 
			AMI.CDSNo,
			Financier
		FROM [import].Tb_Account as AC 
		--INNER JOIN import.Tb_AccountTypeList As ATL
		--ON Replace(ac.AccountNumber, ac.CustomerKey,'') = ATL.CharCode
		--ON AC.AccountGroup = ATL.CharCode
		INNER JOIN import.Tb_AccountNoMapping AS AM
		ON AC.AccountNumber = AM.OldAccountNo
		LEFT JOIN import.Tb_AccountMarketInfo As AMI
		ON AMI.AccountNo = AC.AccountNumber
		WHERE AC.AccountStatus<>'C' AND AC.AccountGroup NOT IN ('B','D','K','X','RMCOL','RMCOM','R','KLSE','SCANS');

		INSERT INTO CQBTempDB.[import].[Tb_FormData_1410]
           ([RecordID]
           ,[Action]
           ,[AccountTypesProductInfo (grid-1)]
           ,[ModeofClientAcquisition (selectbasic-25)]
           ,[ClientType (selectbasic-26)]
           ,[DateofBirth (dateinput-1)]
           ,[BirthCity (textinput-154)]
           ,[IdentificationNumber (textinput-157)]
           ,[ShareholderType (textinput-158)]
           ,[BirthCountry (selectsource-32)]
           ,[Name (textinput-159)]
           ,[AddressCity (textinput-160)]
           ,[AddressCountry (selectsource-33)]
           ,[DigitalSignature (signature-1)]
           ,[CDSandTrading (uploadinput-9)]
           ,[NRICPassportEnclosed (selectbasic-31)]
           ,[NameasperNRICPassport (selectbasic-32)]
           ,[RegisteredAddressasperNRIC (selectbasic-33)]
           ,[BankParticularsasperBankStatement (selectbasic-34)]
           ,[eKYCProfile (selectbasic-35)]
           ,[CDSPayment (selectsource-34)]
           ,[SignatureVerified (selectbasic-37)]
           ,[PROMO16Indicator (selectbasic-38)]
           ,[RiskProfilingScore (textinput-155)]
           ,[RiskProfiling (textinput-156)]
           ,[CustomerID (textinput-1)]
           ,[OldCustomerID (textinput-131)]
           ,[Title (textinput-2)]
           ,[CustomerName (textinput-3)]
           ,[PermanentResidenceofMalaysia (multipleradiosinline-2)]
           ,[ShareHolder (grid-4)]
           ,[FinancialDetails (grid-6)]
           ,[Nationality (selectsource-4)]
           ,[IDType (selectsource-1)]
           ,[IDNumber (textinput-5)]
           ,[IDExpiryDate (dateinput-6)]
           ,[AlternateIDType (selectsource-2)]
           ,[AlternateIDNumber (textinput-6)]
           ,[AlternateIDExpiryDate (dateinput-7)]
           ,[Gender (selectbasic-1)]
           ,[MaritalStatus (selectsource-11)]
           ,[Race (selectsource-3)]
           ,[CountryofResidence (selectsource-5)]
           ,[BumiputraStatus (multipleradiosinline-1)]
           ,[PlaceofIncorporation (textinput-7)]
           ,[BusinessNature (textinput-8)]
           ,[CorporateShareholding (textinput-12)]
           ,[PaidUpCapital (textinput-13)]
           ,[AuthorizedPersonnel (grid-5)]
           ,[Numberofauthorisedpersonnelrequired (selectbasic-39)]
           ,[W8BEN (multipleradiosinline-21)]
           ,[W8BENStartDate (dateinput-14)]
           ,[W8BENSignedTC (uploadinput-6)]
           ,[EmploymentStatus (selectsource-13)]
           ,[JobSector (selectsource-12)]
           ,[IndustriesSpecialization (selectsource-6)]
           ,[OccupationDesignation (textinput-162)]
           ,[NameofCompany (textinput-15)]
           ,[PhoneOffice (textinput-17)]
           ,[SpouseName (textinput-18)]
           ,[SpouseNationality (selectsource-20)]
           ,[PermanentResidenceofMalaysia (multipleradiosinline-29)]
           ,[SpouseIDNumber (textinput-20)]
           ,[SpouseIDExpiryDate (dateinput-9)]
           ,[AlgoStartDate (dateinput-15)]
           ,[SpouseIDType (selectsource-8)]
           ,[SpouseEmploymentStatus (selectsource-21)]
           ,[SpouseJobSector (selectsource-22)]
           ,[SpouseIndustriesSpecialization (selectsource-23)]
           ,[SpouseOccupationDesignation (textinput-163)]
           ,[SpouseNameofCompany (textinput-22)]
           ,[SpouseGrossAnnualIncome (multipleradios-1)]
           ,[SpouseEstimatedNetWorth (multipleradios-2)]
           ,[AlgoSignedTC (uploadinput-7)]
           ,[SpousePhoneNo (textinput-24)]
           ,[RelatedDetails (grid-2)]
           ,[Address1 (textinput-35)]
           ,[Address2 (textinput-36)]
           ,[Address3 (textinput-37)]
           ,[Town (textinput-38)]
           ,[State (textinput-39)]
           ,[State (selectsource-25)]
           ,[Country (selectsource-24)]
           ,[Postcode (textinput-40)]
           ,[SameasRegisteredAddress (multiplecheckboxesinline-1)]
           ,[Address1 (textinput-41)]
           ,[Address2 (textinput-42)]
           ,[Address3 (textinput-43)]
           ,[Town (textinput-44)]
           ,[State (textinput-45)]
           ,[Postcode (textinput-46)]
           ,[PhoneHouse (textinput-55)]
           ,[State (selectsource-26)]
           ,[Country (selectsource-27)]
           ,[PhoneMobile (textinput-57)]
           ,[Email (textinput-58)]
           ,[CDSeStatement (multipleradiosinline-30)]
           ,[ContractDelivery (selectsource-28)]
           ,[MonthlyStmDelivery (selectsource-29)]
           ,[GrossAnnualIncome (multipleradios-3)]
           ,[EstimatedNetWorth (multipleradios-4)]
           ,[1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
           ,[NRIC (uploadinput-1)]
           ,[2Timeframetoholdastock (selectbasic-5)]
           ,[3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)]
           ,[textinput125 (textinput-125)]
           ,[4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)]
           ,[textinput126 (textinput-126)]
           ,[5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)]
           ,[textinput127 (textinput-127)]
           ,[6Whatisyourmainsourceoffundsforinvestment (multiplecheckboxes-5)]
           ,[textinput128 (textinput-128)]
           ,[7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)]
           ,[8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)]
           ,[textinput129 (textinput-129)]
           ,[9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)]
           ,[10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)]
           ,[11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)]
           ,[12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)]
           ,[textinput130 (textinput-130)]
           ,[TradingMode (selectbasic-27)]
           ,[SettlementMode (selectbasic-28)]
           ,[multiplecheckboxes6 (multiplecheckboxes-6)]
           ,[PoliticalExposedPerson (selectbasic-24)]
           ,[textinput132 (textinput-132)]
           ,[IDSS (multipleradiosinline-17)]
           ,[IDSSStartDate (dateinput-10)]
           ,[IDSSSignedTC (uploadinput-3)]
           ,[LEAP (selectbasic-29)]
           ,[LEAPStartDate (dateinput-11)]
           ,[LEAPSignedTC (uploadinput-4)]
           ,[FEAResidentofMalaysia (selectbasic-23)]
           ,[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]
           ,[ETFLI (multipleradiosinline-20)]
           ,[ETFLIStartDate (dateinput-13)]
           ,[ETFLISignedTC (uploadinput-5)]
           ,[LetterofUndertakingforTWSE (multipleradiosinline-22)]
           ,[PDPA (multipleradiosinline-23)]
           ,[eDividend (multipleradiosinline-24)]
           ,[Algo (multipleradiosinline-31)]
           ,[SophisticatedInvestor (multipleradiosinline-32)]
		   ,[BursaAnywhere (multipleradiosinline-34)]
           ,[TaxIdentificationNumber (textinput-149)]
           ,[Passport (uploadinput-8)]
           ,[BankStatement (uploadinput-2)]
           ,[TaxCountry (selectsource-30)]
           ,[FirstName (textinput-150)]
           ,[MiddleName (textinput-151)]
           ,[LastName (textinput-152)]
           ,[AddressCity (textinput-153)]
           ,[AddressCountry (selectsource-31)])
		
		SELECT 
			null as [RecordID],
			'I' as [Action],
			--(
			--	SELECT 
			--		rowIndex,
			--		Ac.AccountType As seq1,
			--		Ac.Algo as seq2, --Algo
			--		AC.Foreigner As seq3,
			--		Ac.DealerCode As seq4,
			--		Ac.Nominees As seq5, 
			--		Ac.CDSNo As seq6,
			--		AC.Financier As seq7 --Financier
			--	FROM #AccountProductTypeDetail as AC 
			--	WHERE ac.CustomerKey = a.CustomerID
			--	FOR JSON PATH
			--) 
			'' As [AccountTypesProductInfo (grid-1)],
			CASE WHEN B.ReferredByKYCList LIKE '%NFTF%' THEN 'PNFTF' ELSE '' END as  [ModeofClientAcquisition (selectbasic-25)],
			 CASE WHEN A.CustomerType = '1' THEN 'I' ELSE 'C' END as  [ClientType (selectbasic-26)],
			A.DateOfBirth as  [DateofBirth (dateinput-1)],
			'' as  [BirthCity (textinput-154)],
			'' as  [IdentificationNumber (textinput-157)],
			'' as  [ShareholderType (textinput-158)],
			'' as  [BirthCountry (selectsource-32)],
			'' as  [Name (textinput-159)],
			'' as  [AddressCity (textinput-160)],
			'' as  [AddressCountry (selectsource-32)],
			'' as  [DigitalSignature (signature-1)],
			'' as  [CDSandTrading (uploadinput-9)],
			'' as  [NRICPassportEnclosed (selectbasic-31)],
			'' as  [NameasperNRICPassport (selectbasic-32)],
			'' as  [RegisteredAddressasperNRIC (selectbasic-33)],
			'' as  [BankParticularsasperBankStatement (selectbasic-34)],
			'' as  [eKYCProfile (selectbasic-35)],
			'' as  [CDSPayment (selectsource-34)],
			'' as  [SignatureVerified (selectbasic-37)],
			CASE WHEN B.ReferredByKYCList LIKE '%16%' THEN 'Y' ELSE 'N' END as  [PROMO16Indicator (selectbasic-38)],
			'' as  [RiskProfilingScore (textinput-155)],
			'' as  [RiskProfiling (textinput-156)],
			ISNULL(CIM.NewCustomerID,A.CustomerID) as [CustomerID (textinput-1)],
			A.CustomerID as  [OldCustomerID (textinput-131)], --CIM.OldCustomerID 
			A.Title as  [Title (textinput-2)],
			A.CustomerName as  [CustomerName (textinput-3)],
			ISNULL(NULLIF(A.PermanentResident,''),'N') as  [PermanentResidenceofMalaysia (multipleradiosinline-2)],
			--(
			--	SELECT 
			--		1 As rowIndex,
			--		'' As seq1,'' As seq2,'' As seq3,'' As seq4
			--	FOR JSON PATH
			--) As [ShareHolder (grid-4)],
			'' As [ShareHolder (grid-4)],
			--(
			--	SELECT 
			--		rowIndex,
			--		'' AS seq1,
			--		SettlementACName As seq2,
			--		SettlementBankAC As seq3,
			--		BankCode As seq4,
			--		JointAccount As seq5
			--	FROM #FinancialDetail As FD
			--	WHERE FD.CustomerKey = a.CustomerID
			--	FOR JSON PATH
			--) As  [FinancialDetails (grid-6)],
			'' As  [FinancialDetails (grid-6)],
			A.Nationality as  [Nationality (selectsource-4)],
			A.IDType as  [IDType (selectsource-1)],
			A.IDNumber as  [IDNumber (textinput-5)],
			'' as  [IDExpiryDate (dateinput-6)],
			A.AlternateID as  [AlternateIDType (selectsource-2)],
			A.AlternateIDNumber as  [AlternateIDNumber (textinput-6)],
			'' as  [AlternateIDExpiryDate (dateinput-7)],
			CASE WHEN A.Sex = 'N' THEN '' ELSE A.Sex END as [Gender (selectbasic-1)],
			ISNULL(NULLIF(A.MaritalStatus,''),'NA') as  [MaritalStatus (selectsource-11)],
			CASE WHEN A.Race IN ('B','D','K','M','N') THEN 'B' ELSE A.Race END as [Race (selectsource-3)],
			A.CountryOfResidence as  [CountryofResidence (selectsource-5)],
			ISNULL(NULLIF(A.BumiputraStatus,''),'N') as  [BumiputraStatus (multipleradiosinline-1)],
			A.PlaceOfIncorporation as  [PlaceofIncorporation (textinput-7)],
			A.BusinessNature as  [BusinessNature (textinput-8)],
			'' as  [CorporateShareholding (textinput-12)],
			'' as  [PaidUpCapital (textinput-13)],
			--(
			--	SELECT 
			--		1 As rowIndex,
			--		'' As seq1,'' As seq2,'' As seq3,'' As seq4,'' As seq5
			--	FOR JSON PATH
			--) as  [AuthorizedPersonnel (grid-5)],
			'' as  [AuthorizedPersonnel (grid-5)],
			'' as [Numberofauthorisedpersonnelrequired (selectbasic-39)],
			'N' as  [W8BEN (multipleradiosinline-21)],
			'' as  [W8BENStartDate (dateinput-14)],
			'' as  [W8BENSignedTC (uploadinput-6)],
			'' as  [EmploymentStatus (selectsource-13)],
			'' as  [JobSector (selectsource-12)],
			'' as  [IndustriesSpecialization (selectsource-6)],
			--CASE WHEN A.Occupation NOT IN (SELECT RefCD FROM import.Tb_CodeReference where RefType like '%Occupation%') THEN 'NA' ELSE A.Occupation END as  [OccupationDesignation (selectsource-7)],
			--A.Occupation as [OccupationDesignation (textinput-162)],
			O.DESCRIPTION as [OccupationDesignation (textinput-162)],
			'' as  [NameofCompany (textinput-15)],
			A.PhoneOffice as  [PhoneOffice (textinput-17)],
			'' as  [SpouseName (textinput-18)],
			'' as  [SpouseNationality (selectsource-20)],
			'' as  [PermanentResidenceofMalaysia (multipleradiosinline-29)],
			'' as  [SpouseIDNumber (textinput-20)],
			'' as  [SpouseIDExpiryDate (dateinput-9)],
			'' as  [AlgoStartDate (dateinput-15)],
			'' as  [SpouseIDType (selectsource-8)],
			'' as  [SpouseEmploymentStatus (selectsource-21)],
			'' as  [SpouseJobSector (selectsource-22)],
			'' as  [SpouseIndustriesSpecialization (selectsource-23)],
			'' as  [SpouseOccupationDesignation (textinput-163)],
			'' as  [SpouseNameofCompany (textinput-22)],
			'' as  [SpouseGrossAnnualIncome (multipleradios-1)],
			'' as  [SpouseEstimatedNetWorth (multipleradios-2)],
			'' as  [AlgoSignedTC (uploadinput-7)],
			'' as  [SpousePhoneNo (textinput-24)],
			--(
			--	SELECT 
			--		1 As rowIndex,
			--		'' As seq1,'' As seq2,'' As seq3
			--	FOR JSON PATH
			--) As   [RelatedDetails (grid-2)],
			'' As   [RelatedDetails (grid-2)],
			A.RegisteredAddress1 as  [Address1 (textinput-35)],
			A.RegisteredAddress2 as  [Address2 (textinput-36)],
			A.RegisteredAddress3 as  [Address3 (textinput-37)],
			'' as  [Town (textinput-38)],
			A.RegisteredAddress4 as  [State (textinput-39)],
			CASE WHEN (A.CountryOfResidence = 'MY' OR A.RegisteredAddress5 IN ('MALA','MALAYISA','MALAYSAIA','MALAYSIA','MALAYSIS','MALYSIA','MELAKA','MELAKA MALAYSIA','MLAYSIA'))
						AND LEN(PostCode)=5 AND ISNUMERIC(PostCode)=1
				THEN CASE WHEN (PostCode>='40000' AND PostCode<='48300') OR (PostCode>='63000' AND PostCode<='68100') THEN 'SGR'
						  WHEN PostCode>='20000' AND PostCode<='24300' THEN 'TRG'
						  WHEN PostCode>='93000' AND PostCode<='98859' THEN 'SRK'
						  WHEN PostCode>='88000' AND PostCode<='91309' THEN 'SBH'
						  WHEN PostCode>='05000' AND PostCode<='09810' THEN 'KDH'
						  WHEN PostCode>='15000' AND PostCode<='18500' THEN 'KLT'
						  WHEN PostCode>='70000' AND PostCode<='73509' THEN 'NSL'
						  WHEN PostCode>='10000' AND PostCode<='14400' THEN 'PNG'
						  WHEN PostCode>='79000' AND PostCode<='86900' THEN 'JHR'
						  WHEN PostCode>='75000' AND PostCode<='78309' THEN 'MLC'
						  WHEN PostCode>='01000' AND PostCode<='02000' THEN 'PRL'
						  WHEN PostCode>='30000' AND PostCode<='36810' THEN 'PRK'
						  WHEN (PostCode>='25000' AND PostCode<='28800') OR (PostCode>='39000' AND PostCode<='39200')
								OR PostCode='49000' OR PostCode='69000'  OR (PostCode>='28000' AND PostCode<='28350')
									THEN 'PHG' 
						  WHEN (PostCode>='50000' AND PostCode<='60000') OR (PostCode>='62300' AND PostCode<='62988') THEN 'WPN' 
						  WHEN PostCode>='87000' AND PostCode<='87033' THEN 'LBN'
						  ELSE '' END
					ELSE '' END as  [State (selectsource-25)],
			CASE WHEN A.RegisteredAddress5 IN ('MALA','MALAYISA','MALAYSAIA','MALAYSIA','MALAYSIS','MALYSIA','MELAKA','MELAKA MALAYSIA','MLAYSIA')
					THEN 'MY' ELSE A.RegisteredAddress5 END as  [Country (selectsource-24)],
			A.PostCode as  [Postcode (textinput-40)],
			'' as  [SameasRegisteredAddress (multiplecheckboxesinline-1)],
			A.CorrOrBusinessAdd1 as  [Address1 (textinput-41)],
			A.CorrOrBusinessAdd2 as  [Address2 (textinput-42)],
			A.CorrOrBusinessAdd3 as  [Address3 (textinput-43)],
			'' as  [Town (textinput-44)],
			A.CorrOrBusinessAdd4 as  [State (textinput-45)],
			A.CorrOrBusinessPostCode as  [Postcode (textinput-46)],
			A.PhoneHouse as  [PhoneHouse (textinput-55)],
			CASE WHEN (A.CorrOrBusinessAdd5 IN ('MALA','MALAYISA','MALAYSAIA','MALAYSIA','MALAYSIS','MALYSIA','MELAKA','MELAKA MALAYSIA','MLAYSIA'))
						AND LEN(CorrOrBusinessPostCode)=5 AND ISNUMERIC(CorrOrBusinessPostCode)=1
				THEN CASE WHEN (CorrOrBusinessPostCode>='40000' AND CorrOrBusinessPostCode<='48300') OR (CorrOrBusinessPostCode>='63000' AND CorrOrBusinessPostCode<='68100') THEN 'SGR'
						  WHEN CorrOrBusinessPostCode>='20000' AND CorrOrBusinessPostCode<='24300' THEN 'TRG'
						  WHEN CorrOrBusinessPostCode>='93000' AND CorrOrBusinessPostCode<='98859' THEN 'SRK'
						  WHEN CorrOrBusinessPostCode>='88000' AND CorrOrBusinessPostCode<='91309' THEN 'SBH'
						  WHEN CorrOrBusinessPostCode>='05000' AND CorrOrBusinessPostCode<='09810' THEN 'KDH'
						  WHEN CorrOrBusinessPostCode>='15000' AND CorrOrBusinessPostCode<='18500' THEN 'KLT'
						  WHEN CorrOrBusinessPostCode>='70000' AND CorrOrBusinessPostCode<='73509' THEN 'NSL'
						  WHEN CorrOrBusinessPostCode>='10000' AND CorrOrBusinessPostCode<='14400' THEN 'PNG'
						  WHEN CorrOrBusinessPostCode>='79000' AND CorrOrBusinessPostCode<='86900' THEN 'JHR'
						  WHEN CorrOrBusinessPostCode>='75000' AND CorrOrBusinessPostCode<='78309' THEN 'MLC'
						  WHEN CorrOrBusinessPostCode>='01000' AND CorrOrBusinessPostCode<='02000' THEN 'PRL'
						  WHEN CorrOrBusinessPostCode>='30000' AND CorrOrBusinessPostCode<='36810' THEN 'PRK'
						  WHEN (CorrOrBusinessPostCode>='25000' AND CorrOrBusinessPostCode<='28800') OR (CorrOrBusinessPostCode>='39000' AND CorrOrBusinessPostCode<='39200')
								OR CorrOrBusinessPostCode='49000' OR CorrOrBusinessPostCode='69000'  OR (CorrOrBusinessPostCode>='28000' AND CorrOrBusinessPostCode<='28350')
									THEN 'PHG'
						  WHEN (CorrOrBusinessPostCode>='50000' AND CorrOrBusinessPostCode<='60000') OR (CorrOrBusinessPostCode>='62300' AND CorrOrBusinessPostCode<='62988') THEN 'WPN' 
						  WHEN CorrOrBusinessPostCode>='87000' AND CorrOrBusinessPostCode<='87033' THEN 'LBN'
						  ELSE '' END
					ELSE '' END as  [State (selectsource-26)],
			A.CorrOrBusinessAdd5 as  [Country (selectsource-27)],
			A.PhoneMobile as  [PhoneMobile (textinput-57)],
			A.Email as  [Email (textinput-58)],
			CASE WHEN LEN(Telex) = 3 THEN SUBSTRING(A.Telex,3,1) 
				 WHEN ISNULL(A.Email,'') <> '' THEN 'Y' ELSE 'N' END as [CDSeStatement (multipleradiosinline-30)],
			'' as  [ContractDelivery (selectsource-28)],
			'' as  [MonthlyStmDelivery (selectsource-29)],
			CASE WHEN CAST(A.AnnualIncome as decimal(24,9)) <= 50000 THEN '1'
				 WHEN CAST(A.AnnualIncome as decimal(24,9)) <= 100000 THEN '2'
				 WHEN CAST(A.AnnualIncome as decimal(24,9)) <= 250000 THEN '3'
				 WHEN CAST(A.AnnualIncome as decimal(24,9)) <= 500000 THEN '4'
				 WHEN CAST(A.AnnualIncome as decimal(24,9)) <= 1000000 THEN '5'
				 WHEN CAST(A.AnnualIncome as decimal(24,9)) > 1000000 THEN '6'
					ELSE '1' END as [GrossAnnualIncome (multipleradios-3)],
			'' as  [EstimatedNetWorth (multipleradios-4)],
			'' as  [1HowOftenDoYouKeepTrackonMarket (selectbasic-4)],
			'' as  [NRIC (uploadinput-1)],
			'' as  [2Timeframetoholdastock (selectbasic-5)],
			'4' as  [3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)],
			'' as  [textinput125 (textinput-125)],
			'7' as  [4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)],
			'' as  [textinput126 (textinput-126)],
			'7' as  [5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)],
			'' as  [textinput127 (textinput-127)],
			'5' as  [6Whatisyourmainsourceoffundsforinvestment (multiplecheckboxes-5)],
			'' as  [textinput128 (textinput-128)],
			'' as  [7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)],
			'' as  [8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)],
			'' as  [textinput129 (textinput-129)],
			'' as  [9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)],
			'' as  [10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)],
			'' as  [11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)],
			'' as  [12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)],
			'' as  [textinput130 (textinput-130)],
			'' as  [TradingMode (selectbasic-27)],
			'' as  [SettlementMode (selectbasic-28)],
			'' as  [multiplecheckboxes6 (multiplecheckboxes-6)],
			'N' as  [PoliticalExposedPerson (selectbasic-24)],
			'' as  [textinput132 (textinput-132)],
			CASE WHEN B.ReferredByKYCList LIKE '%IDSS%' THEN 'Y' ELSE 'N' END as [IDSS (multipleradiosinline-17)],
			'' as  [IDSSStartDate (dateinput-10)],
			'' as  [IDSSSignedTC (uploadinput-3)],
			CASE WHEN B.ReferredByKYCList LIKE '%LEAP%' THEN 'Y' ELSE 'N' END as  [LEAP (selectbasic-29)],
			'' as  [LEAPStartDate (dateinput-11)],
			'' as  [LEAPSignedTC (uploadinput-4)],
			CASE WHEN B.ReferredByKYCList LIKE '%MCNB%' OR B.ReferredByKYCList LIKE '%MCRB%' THEN '1' ELSE '' END as  [FEAResidentofMalaysia (selectbasic-23)], --1 = resident, 2 = non-resident
			CASE WHEN B.ReferredByKYCList LIKE '%MCRB%' THEN 'Y' ELSE 'N' END as  [FEAhaveDomesticRinggitBorrowing (selectbasic-30)],
			CASE WHEN B.ReferredByKYCList LIKE '%ETFLI%' THEN 'Y' ELSE 'N' END as  [ETFLI (multipleradiosinline-20)],
			'' as  [ETFLIStartDate (dateinput-13)],
			'' as  [ETFLISignedTC (uploadinput-5)],
			'N' as  [LetterofUndertakingforTWSE (multipleradiosinline-22)],
			'Y' as  [PDPA (multipleradiosinline-23)],
			CASE WHEN LEN(Telex) IN (1,2,3) THEN SUBSTRING(A.Telex,1,1) ELSE 'N' END as [eDividend (multipleradiosinline-24)],
			'N' as  [Algo (multipleradiosinline-31)],
			'N' as  [SophisticatedInvestor (multipleradiosinline-32)],
			CASE WHEN B.ReferredByKYCList LIKE '%BA%' THEN 'Y' ELSE 'N' END as [BursaAnywhere (multipleradiosinline-34)],
			'' as  [TaxIdentificationNumber (textinput-149)],
			'' as  [Passport (uploadinput-8)],
			'' as  [BankStatement (uploadinput-2)],
			'' as  [TaxCountry (selectsource-30)],
			'' as  [FirstName (textinput-150)],
			'' as  [MiddleName (textinput-151)],
			'' as  [LastName (textinput-152)],
			'' as  [AddressCity (textinput-153)],
			'' as  [AddressCountry (selectsource-31)]
			--'' as  [GuarantorName (textinput-134)],
			--'' as  [GuarantorIDType (selectsource-17)],
			--'' as  [GuarantorIDNumber (textinput-136)],
			--'' as  [GuarantorExpiryDate (dateinput-8)],
			--'' as  [GuarantorPhoneNo (textinput-137)],
			--'' as  [GuarantorAddress1 (textinput-138)],
			--'' as  [GuarantorAddress2 (textinput-139)],
			--'' as  [GuarantorAddress3 (textinput-140)],
			--'' as  [GuarantorState (textinput-141)],
			--'' as  [GuarantorCountry (selectsource-19)],
			--'' as  [GuarantorPostcode (textinput-142)],
		FROM import.Tb_Customer As A
		INNER JOIN (
			select CustomerKey,COUNT(1) AS AccCount 
			from import.Tb_Account 
			WHERE AccountGroup NOT IN ('D','K','X','RMCOL','RMCOM','R','KLSE','SCANS') 
			group by CustomerKey) AS AC
		ON A.CustomerID = AC.CustomerKey
		LEFT JOIN (
			select CustomerKey, 
					stuff((SELECT DISTINCT ',' + ReferredByKYC 
							FROM import.Tb_Account
							WHERE CustomerKey=b.CustomerKey
							FOR XML PATH ('')), 1,1,'') AS ReferredByKYCList
			FROM import.Tb_Account as b
			GROUP BY CustomerKey) AS B
		ON A.CustomerID = B.CustomerKey
		--LEFT JOIN import.Tb_AccountMarketInfo As C
		--ON B.AccountNumber=C.AccountNo
		LEFT JOIN [import].[Tb_CustomerIDMapping] As CIM
		ON A.CustomerID = CIM.OldCustomerID
		LEFT JOIN import.Tb_Occupation AS O
		ON A.Occupation = O.OCCUPCD
		WHERE LEN(CustomerID)<>3 AND AccCount >= 1
		AND (EXISTS (SELECT 1 FROM import.Tb_Account WHERE AccountGroup NOT IN ('D','K','X','RMCOL','RMCOM','R','KLSE','SCANS') AND CustomerKey = A.CustomerID AND AccountStatus<>'C')
			OR (CustomerID IN ('ALB001','CKF008','MBM105','TBF003','WSK005','RSB008','LWY013')))
		--AND NOT EXISTS (select 1 from import.Tb_Account where CustomerKey = A.CustomerID AND AccountGroup IN ('D','K','X','RMCOL','RMCOM','R','KLSE','SCANS'))
		--ORDER BY CustomerKey

		INSERT INTO CQBTempDB.[import].[Tb_FormData_1410]
           ([RecordID]
           ,[Action]
           ,[AccountTypesProductInfo (grid-1)]
           ,[ModeofClientAcquisition (selectbasic-25)]
           ,[ClientType (selectbasic-26)]
           ,[DateofBirth (dateinput-1)]
           ,[BirthCity (textinput-154)]
           ,[IdentificationNumber (textinput-157)]
           ,[ShareholderType (textinput-158)]
           ,[BirthCountry (selectsource-32)]
           ,[Name (textinput-159)]
           ,[AddressCity (textinput-160)]
           ,[AddressCountry (selectsource-33)]
           ,[DigitalSignature (signature-1)]
           ,[CDSandTrading (uploadinput-9)]
           ,[NRICPassportEnclosed (selectbasic-31)]
           ,[NameasperNRICPassport (selectbasic-32)]
           ,[RegisteredAddressasperNRIC (selectbasic-33)]
           ,[BankParticularsasperBankStatement (selectbasic-34)]
           ,[eKYCProfile (selectbasic-35)]
           ,[CDSPayment (selectsource-34)]
           ,[SignatureVerified (selectbasic-37)]
           ,[PROMO16Indicator (selectbasic-38)]
           ,[RiskProfilingScore (textinput-155)]
           ,[RiskProfiling (textinput-156)]
           ,[CustomerID (textinput-1)]
           ,[OldCustomerID (textinput-131)]
           ,[Title (textinput-2)]
           ,[CustomerName (textinput-3)]
           ,[PermanentResidenceofMalaysia (multipleradiosinline-2)]
           ,[ShareHolder (grid-4)]
           ,[FinancialDetails (grid-6)]
           ,[Nationality (selectsource-4)]
           ,[IDType (selectsource-1)]
           ,[IDNumber (textinput-5)]
           ,[IDExpiryDate (dateinput-6)]
           ,[AlternateIDType (selectsource-2)]
           ,[AlternateIDNumber (textinput-6)]
           ,[AlternateIDExpiryDate (dateinput-7)]
           ,[Gender (selectbasic-1)]
           ,[MaritalStatus (selectsource-11)]
           ,[Race (selectsource-3)]
           ,[CountryofResidence (selectsource-5)]
           ,[BumiputraStatus (multipleradiosinline-1)]
           ,[PlaceofIncorporation (textinput-7)]
           ,[BusinessNature (textinput-8)]
           ,[CorporateShareholding (textinput-12)]
           ,[PaidUpCapital (textinput-13)]
           ,[AuthorizedPersonnel (grid-5)]
           ,[Numberofauthorisedpersonnelrequired (selectbasic-39)]
           ,[W8BEN (multipleradiosinline-21)]
           ,[W8BENStartDate (dateinput-14)]
           ,[W8BENSignedTC (uploadinput-6)]
           ,[EmploymentStatus (selectsource-13)]
           ,[JobSector (selectsource-12)]
           ,[IndustriesSpecialization (selectsource-6)]
           ,[OccupationDesignation (textinput-162)]
           ,[NameofCompany (textinput-15)]
           ,[PhoneOffice (textinput-17)]
           ,[SpouseName (textinput-18)]
           ,[SpouseNationality (selectsource-20)]
           ,[PermanentResidenceofMalaysia (multipleradiosinline-29)]
           ,[SpouseIDNumber (textinput-20)]
           ,[SpouseIDExpiryDate (dateinput-9)]
           ,[AlgoStartDate (dateinput-15)]
           ,[SpouseIDType (selectsource-8)]
           ,[SpouseEmploymentStatus (selectsource-21)]
           ,[SpouseJobSector (selectsource-22)]
           ,[SpouseIndustriesSpecialization (selectsource-23)]
           ,[SpouseOccupationDesignation (textinput-163)]
           ,[SpouseNameofCompany (textinput-22)]
           ,[SpouseGrossAnnualIncome (multipleradios-1)]
           ,[SpouseEstimatedNetWorth (multipleradios-2)]
           ,[AlgoSignedTC (uploadinput-7)]
           ,[SpousePhoneNo (textinput-24)]
           ,[RelatedDetails (grid-2)]
           ,[Address1 (textinput-35)]
           ,[Address2 (textinput-36)]
           ,[Address3 (textinput-37)]
           ,[Town (textinput-38)]
           ,[State (textinput-39)]
           ,[State (selectsource-25)]
           ,[Country (selectsource-24)]
           ,[Postcode (textinput-40)]
           ,[SameasRegisteredAddress (multiplecheckboxesinline-1)]
           ,[Address1 (textinput-41)]
           ,[Address2 (textinput-42)]
           ,[Address3 (textinput-43)]
           ,[Town (textinput-44)]
           ,[State (textinput-45)]
           ,[Postcode (textinput-46)]
           ,[PhoneHouse (textinput-55)]
           ,[State (selectsource-26)]
           ,[Country (selectsource-27)]
           ,[PhoneMobile (textinput-57)]
           ,[Email (textinput-58)]
           ,[CDSeStatement (multipleradiosinline-30)]
           ,[ContractDelivery (selectsource-28)]
           ,[MonthlyStmDelivery (selectsource-29)]
           ,[GrossAnnualIncome (multipleradios-3)]
           ,[EstimatedNetWorth (multipleradios-4)]
           ,[1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
           ,[NRIC (uploadinput-1)]
           ,[2Timeframetoholdastock (selectbasic-5)]
           ,[3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)]
           ,[textinput125 (textinput-125)]
           ,[4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)]
           ,[textinput126 (textinput-126)]
           ,[5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)]
           ,[textinput127 (textinput-127)]
           ,[6Whatisyourmainsourceoffundsforinvestment (multiplecheckboxes-5)]
           ,[textinput128 (textinput-128)]
           ,[7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)]
           ,[8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)]
           ,[textinput129 (textinput-129)]
           ,[9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)]
           ,[10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)]
           ,[11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)]
           ,[12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)]
           ,[textinput130 (textinput-130)]
           ,[TradingMode (selectbasic-27)]
           ,[SettlementMode (selectbasic-28)]
           ,[multiplecheckboxes6 (multiplecheckboxes-6)]
           ,[PoliticalExposedPerson (selectbasic-24)]
           ,[textinput132 (textinput-132)]
           ,[IDSS (multipleradiosinline-17)]
           ,[IDSSStartDate (dateinput-10)]
           ,[IDSSSignedTC (uploadinput-3)]
           ,[LEAP (selectbasic-29)]
           ,[LEAPStartDate (dateinput-11)]
           ,[LEAPSignedTC (uploadinput-4)]
           ,[FEAResidentofMalaysia (selectbasic-23)]
           ,[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]
           ,[ETFLI (multipleradiosinline-20)]
           ,[ETFLIStartDate (dateinput-13)]
           ,[ETFLISignedTC (uploadinput-5)]
           ,[LetterofUndertakingforTWSE (multipleradiosinline-22)]
           ,[PDPA (multipleradiosinline-23)]
           ,[eDividend (multipleradiosinline-24)]
           ,[Algo (multipleradiosinline-31)]
           ,[SophisticatedInvestor (multipleradiosinline-32)]
           ,[TaxIdentificationNumber (textinput-149)]
           ,[Passport (uploadinput-8)]
           ,[BankStatement (uploadinput-2)]
           ,[TaxCountry (selectsource-30)]
           ,[FirstName (textinput-150)]
           ,[MiddleName (textinput-151)]
           ,[LastName (textinput-152)]
           ,[AddressCity (textinput-153)]
           ,[AddressCountry (selectsource-31)])
		SELECT C.[RecordID]
		   ,C.[Action]
           ,C.[AccountTypesProductInfo (grid-1)]
           ,C.[ModeofClientAcquisition (selectbasic-25)]
           ,C.[ClientType (selectbasic-26)]
           ,C.[DateofBirth (dateinput-1)]
           ,C.[BirthCity (textinput-154)]
           ,C.[IdentificationNumber (textinput-157)]
           ,C.[ShareholderType (textinput-158)]
           ,C.[BirthCountry (selectsource-32)]
           ,C.[Name (textinput-159)]
           ,C.[AddressCity (textinput-160)]
           ,C.[AddressCountry (selectsource-33)]
           ,C.[DigitalSignature (signature-1)]
           ,C.[CDSandTrading (uploadinput-9)]
           ,C.[NRICPassportEnclosed (selectbasic-31)]
           ,C.[NameasperNRICPassport (selectbasic-32)]
           ,C.[RegisteredAddressasperNRIC (selectbasic-33)]
           ,C.[BankParticularsasperBankStatement (selectbasic-34)]
           ,C.[eKYCProfile (selectbasic-35)]
           ,C.[CDSPayment (selectsource-34)]
           ,C.[SignatureVerified (selectbasic-37)]
           ,C.[PROMO16Indicator (selectbasic-38)]
           ,C.[RiskProfilingScore (textinput-155)]
           ,C.[RiskProfiling (textinput-156)]
           ,AIM.NewCustomerID
           ,C.[OldCustomerID (textinput-131)]
           ,C.[Title (textinput-2)]
           ,C.[CustomerName (textinput-3)]
           ,C.[PermanentResidenceofMalaysia (multipleradiosinline-2)]
           ,C.[ShareHolder (grid-4)]
           ,C.[FinancialDetails (grid-6)]
           ,C.[Nationality (selectsource-4)]
           ,C.[IDType (selectsource-1)]
           ,C.[IDNumber (textinput-5)]
           ,C.[IDExpiryDate (dateinput-6)]
           ,C.[AlternateIDType (selectsource-2)]
           ,C.[AlternateIDNumber (textinput-6)]
           ,C.[AlternateIDExpiryDate (dateinput-7)]
           ,C.[Gender (selectbasic-1)]
           ,C.[MaritalStatus (selectsource-11)]
           ,C.[Race (selectsource-3)]
           ,C.[CountryofResidence (selectsource-5)]
           ,C.[BumiputraStatus (multipleradiosinline-1)]
           ,C.[PlaceofIncorporation (textinput-7)]
           ,C.[BusinessNature (textinput-8)]
           ,C.[CorporateShareholding (textinput-12)]
           ,C.[PaidUpCapital (textinput-13)]
           ,C.[AuthorizedPersonnel (grid-5)]
           ,C.[Numberofauthorisedpersonnelrequired (selectbasic-39)]
           ,C.[W8BEN (multipleradiosinline-21)]
           ,C.[W8BENStartDate (dateinput-14)]
           ,C.[W8BENSignedTC (uploadinput-6)]
           ,C.[EmploymentStatus (selectsource-13)]
           ,C.[JobSector (selectsource-12)]
           ,C.[IndustriesSpecialization (selectsource-6)]
           ,C.[OccupationDesignation (textinput-162)]
           ,C.[NameofCompany (textinput-15)]
           ,C.[PhoneOffice (textinput-17)]
           ,C.[SpouseName (textinput-18)]
           ,C.[SpouseNationality (selectsource-20)]
           ,C.[PermanentResidenceofMalaysia (multipleradiosinline-29)]
           ,C.[SpouseIDNumber (textinput-20)]
           ,C.[SpouseIDExpiryDate (dateinput-9)]
           ,C.[AlgoStartDate (dateinput-15)]
           ,C.[SpouseIDType (selectsource-8)]
           ,C.[SpouseEmploymentStatus (selectsource-21)]
           ,C.[SpouseJobSector (selectsource-22)]
           ,C.[SpouseIndustriesSpecialization (selectsource-23)]
           ,C.[SpouseOccupationDesignation (textinput-163)]
           ,C.[SpouseNameofCompany (textinput-22)]
           ,C.[SpouseGrossAnnualIncome (multipleradios-1)]
           ,C.[SpouseEstimatedNetWorth (multipleradios-2)]
           ,C.[AlgoSignedTC (uploadinput-7)]
           ,C.[SpousePhoneNo (textinput-24)]
           ,C.[RelatedDetails (grid-2)]
           ,C.[Address1 (textinput-35)]
           ,C.[Address2 (textinput-36)]
           ,C.[Address3 (textinput-37)]
           ,C.[Town (textinput-38)]
           ,C.[State (textinput-39)]
           ,C.[State (selectsource-25)]
           ,C.[Country (selectsource-24)]
           ,C.[Postcode (textinput-40)]
           ,C.[SameasRegisteredAddress (multiplecheckboxesinline-1)]
           ,C.[Address1 (textinput-41)]
           ,C.[Address2 (textinput-42)]
           ,C.[Address3 (textinput-43)]
           ,C.[Town (textinput-44)]
           ,C.[State (textinput-45)]
           ,C.[Postcode (textinput-46)]
           ,C.[PhoneHouse (textinput-55)]
           ,C.[State (selectsource-26)]
           ,C.[Country (selectsource-27)]
           ,C.[PhoneMobile (textinput-57)]
           ,C.[Email (textinput-58)]
           ,C.[CDSeStatement (multipleradiosinline-30)]
           ,C.[ContractDelivery (selectsource-28)]
           ,C.[MonthlyStmDelivery (selectsource-29)]
           ,C.[GrossAnnualIncome (multipleradios-3)]
           ,C.[EstimatedNetWorth (multipleradios-4)]
           ,C.[1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
           ,C.[NRIC (uploadinput-1)]
           ,C.[2Timeframetoholdastock (selectbasic-5)]
           ,C.[3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)]
           ,C.[textinput125 (textinput-125)]
           ,C.[4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)]
           ,C.[textinput126 (textinput-126)]
           ,C.[5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)]
           ,C.[textinput127 (textinput-127)]
           ,C.[6Whatisyourmainsourceoffundsforinvestment (multiplecheckboxes-5)]
           ,C.[textinput128 (textinput-128)]
           ,C.[7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)]
           ,C.[8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)]
           ,C.[textinput129 (textinput-129)]
           ,C.[9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)]
           ,C.[10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)]
           ,C.[11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)]
           ,C.[12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)]
           ,C.[textinput130 (textinput-130)]
           ,C.[TradingMode (selectbasic-27)]
           ,C.[SettlementMode (selectbasic-28)]
           ,C.[multiplecheckboxes6 (multiplecheckboxes-6)]
           ,C.[PoliticalExposedPerson (selectbasic-24)]
           ,C.[textinput132 (textinput-132)]
           ,C.[IDSS (multipleradiosinline-17)]
           ,C.[IDSSStartDate (dateinput-10)]
           ,C.[IDSSSignedTC (uploadinput-3)]
           ,C.[LEAP (selectbasic-29)]
           ,C.[LEAPStartDate (dateinput-11)]
           ,C.[LEAPSignedTC (uploadinput-4)]
           ,C.[FEAResidentofMalaysia (selectbasic-23)]
           ,C.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]
           ,C.[ETFLI (multipleradiosinline-20)]
           ,C.[ETFLIStartDate (dateinput-13)]
           ,C.[ETFLISignedTC (uploadinput-5)]
           ,C.[LetterofUndertakingforTWSE (multipleradiosinline-22)]
           ,C.[PDPA (multipleradiosinline-23)]
           ,C.[eDividend (multipleradiosinline-24)]
           ,C.[Algo (multipleradiosinline-31)]
           ,C.[SophisticatedInvestor (multipleradiosinline-32)]
           ,C.[TaxIdentificationNumber (textinput-149)]
           ,C.[Passport (uploadinput-8)]
           ,C.[BankStatement (uploadinput-2)]
           ,C.[TaxCountry (selectsource-30)]
           ,C.[FirstName (textinput-150)]
           ,C.[MiddleName (textinput-151)]
           ,C.[LastName (textinput-152)]
           ,C.[AddressCity (textinput-153)]
           ,C.[AddressCountry (selectsource-31)]
		FROM CQBTempDB.[import].[Tb_FormData_1410] AS C
		--INNER JOIN [import].Tb_CustomerIDMapping As CI
		--ON C.[OldCustomerID (textinput-131)] = CI.OldCustomerID
		INNER JOIN [import].Tb_AccountNoMapping As AIM
		ON C.[OldCustomerID (textinput-131)] = AIM.OldCustomerID
		LEFT JOIN CQBTempDB.[import].[Tb_FormData_1410] As CC
		ON AIM.NewCustomerID = CC.[CustomerID (textinput-1)]
		WHERE AIM.OldCustomerID LIKE 'IVT%' AND CC.[CustomerID (textinput-1)] IS NULL AND AIM.NewAccountNo IS NOT NULL;

		INSERT INTO CQBTempDB.import.Tb_FormData_1410_grid1 --AccountTypesProductInfo (grid-1)
			([RecordID],[Action],[RowIndex],[Account Type (Dropdown)],[Algo (TextBox)],[Foreign (CheckBox)]
			,[Dealer Code (TextBox)],[Nominees (Radio Button)],[CDS No (TextBox)],[Financier (Dropdown)])
		SELECT C.IDD, C.Action, AP.RowIndex, AP.AccountType, AP.Algo, AP.Foreigner, AP.DealerCode, AP.Nominees, AP.CDSNo, AP.Financier
		FROM CQBTempDB.import.Tb_FormData_1410 AS C
		INNER JOIN #AccountProductTypeDetail AS AP
		ON C.[OldCustomerID (textinput-131)] = AP.CustomerKey;

		--INSERT INTO CQBTempDB.import.Tb_FormData_1410_grid2 --RelatedDetails (grid-2)
		
		--INSERT INTO CQBTempDB.import.Tb_FormData_1410_grid4 --ShareHolder (grid-4)
		
		--INSERT INTO CQBTempDB.import.Tb_FormData_1410_grid5 --AuthorizedPersonnel (grid-5)
		
		INSERT INTO CQBTempDB.import.Tb_FormData_1410_grid6 --FinancialDetails (grid-6)
			 ([RecordID],[Action],[RowIndex],[ (Radio Button)],[Account Holder Name (TextBox)],[Account Number (TextBox)]
			 ,[Bank (Dropdown)],[Joint Account  (Dropdown)])
		SELECT C.IDD, C.Action, FD.RowIndex, 'N', FD.SettlementACName, FD.SettlementBankAC, FD.BankCode, FD.JointAccount
		FROM CQBTempDB.import.Tb_FormData_1410 AS C
		INNER JOIN #FinancialDetail AS FD
		ON C.[OldCustomerID (textinput-131)] = FD.CustomerKey;

		UPDATE CQBTempDB.import.Tb_FormData_1410_grid6
		SET [ (Radio Button)]='Y' WHERE RowIndex=1;

		-- UPDATE BURSA ANYWHERE FLAG
		UPDATE Customer
		SET [BursaAnywhere (multipleradiosinline-34)] = 'Y' 
		FROM CQBTEMPDB.import.TB_FORMDATA_1410 Customer 
		INNER JOIN GlobalBOMY.import.Tb_Bursa_BATransactions Trans ON Customer.[IDNumber (textinput-5)] = REPLACE(Trans.ID_NRIC,'-','')

		--select * from CQBTempDB.import.Tb_FormData_1410_grid6 where RecordID=12821
		--select * from CQBTempDB.import.Tb_FormData_1410_grid6 where RecordID=98
		--select * from CQBTempDB.import.Tb_FormData_1410_grid6 where RecordID=338

		--select RecordID, [Account Holder Name (TextBox)], count(1) from CQBTempDB.import.Tb_FormData_1410_grid6
		--group by RecordID, [Account Holder Name (TextBox)]
		--having count(1)>1
		--order by RecordID

		--select RecordID, [Account Number (TextBox)], count(1) from CQBTempDB.import.Tb_FormData_1410_grid6
		--group by RecordID, [Account Number (TextBox)]
		--having count(1)>1
		--order by RecordID
		--INSERT INTO CQBTempDB.import.Tb_FormData_1410_grid7 --Authorizationdetails (grid-7)

		EXEC CQBuilder.[dbo].[Usp_CalculateProfileRating];

		SELECT TOP 1 @lastCustomerID = [CustomerID (textinput-1)] + 1
		FROM CQBTempDB.[import].[Tb_FormData_1410] 
		order by [CustomerID (textinput-1)] desc

		--SELECT @lastRunNo = [textinput-4]
		--FROM CQBuilder.form.Tb_FormData_5
		--WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active'
		
		--IF(@lastRunNo < @lastCustomerID)
		--BEGIN
		UPDATE CQBuilder.form.Tb_FormData_5
		SET FormDetails = JSON_MODIFY(JSON_MODIFY(FormDetails, '$[0].textinput4', @lastCustomerID), '$[1].textinput4', @lastCustomerID)
		WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active';
		--END
		
		--SELECT COUNT(1) FROM CQBTempDB.[import].Tb_FormData_1410 --146046
		--Select * from CQBTempDB.[import].[Tb_FormData_1410] where [OldCustomerID (textinput-131)] IN ('ALB001','CKF008','MBM105','TBF003','WSK005')
		--Select * from CQBTempDB.[import].[Tb_FormData_1410_grid1] where RecordID=1
		--Select * from CQBTempDB.[import].[Tb_FormData_1410_grid6] where RecordID=1
		--select * from #FinancialDetail where CustomerKey='TZP001'
		--select * from import.Tb_AccountMarketInfo where AccountNo LIKE 'TZP001%'

		DROP TABLE #AccountProductTypeDetail;
		DROP TABLE #FinancialDetail;

        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
	    
	    ROLLBACK TRANSACTION;
	    
        DECLARE @intErrorNumber INT
	        ,@intErrorLine INT
	        ,@intErrorSeverity INT
	        ,@intErrorState INT
	        ,@strObjectName VARCHAR(200)
			,@ostrReturnMessage VARCHAR(4000);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

   --     EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	  --      --,@ostrReturnMessage
			--,''
	  --      ,@intErrorLine
	  --      ,@strObjectName
	  --      ,NULL /*Code Section not available*/
	  --      ,'Process fail.';

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );

    END CATCH
    
    SET NOCOUNT OFF;
END