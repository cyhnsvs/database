﻿/****** Object:  Procedure [import].[Usp_Customer_FileToForm1410_20210907]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_Customer_FileToForm1410] 
AS
/***********************************************************************             
            
Created By        : Raman
Created Date      : 04/04/2021
Last Updated Date :             
Description       : this sp is used to insert Customer file data into CQForm Customer
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
  Kristine				2021/08/12				Customer Info Form Update (v.1.9)

PARAMETERS
EXEC [import].[Usp_Customer_FileToForm1410] 
************************************************************************************/
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

		BEGIN TRANSACTION;
	--DEPENDENCY ON CUSTOMER & ACCOUNT MAPPING SCRIPT

		Exec CQBTempDB.form.[Usp_CreateImportTable] 1410;

		--Select * from CQBTempDB.[import].[Tb_FormData_1410]

		TRUNCATE TABLE [CQBTempDB].[import].Tb_FormData_1410;
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid6]
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid7]
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid2]
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid1]

		DECLARE @lastCustomerID BIGINT, @lastRunNo BIGINT,@customerId BIGINT;		
		SET @customerId = (SELECT [textinput-4] FROM CQBuilder.form.Tb_FormData_5 WHERE [textinput-3] = 'MsecCustomerID')


		INSERT INTO CQBTempDB.[import].[Tb_FormData_1410]
           ([RecordID]
           ,[Action]
           ,[AccountTypesProductInfo (grid-1)]
           ,[ModeofClientAcquisition (selectbasic-25)]
           ,[ClientType (selectbasic-26)]
           ,[Dateofincorporated (dateinput-19)]
           ,[CustomerID (textinput-1)]
           ,[OldCustomerID (textinput-131)]
           ,[Title (textinput-2)]
           ,[CustomerName (textinput-3)]
           ,[Nationality (selectsource-4)]
           ,[PermanentResidenceofMalaysia (multipleradiosinline-2)]
           ,[IDType (selectsource-1)]
           ,[IDNumber (textinput-5)]
           ,[IDExpiryDate (dateinput-6)]
           ,[AlternateIDType (selectsource-2)]
           ,[AlternateIDNumber (textinput-6)]
           ,[AlternateIDExpiryDate (dateinput-7)]
           ,[Gender (selectbasic-1)]
           ,[MaritalStatus (selectsource-11)]
           ,[DateofBirth (dateinput-1)]
           ,[Race (selectsource-3)]
           ,[Ownership (selectsource-35)]
           ,[CountryofResidence (selectsource-5)]
           ,[BumiputraStatus (multipleradiosinline-1)]
           ,[PlaceofIncorporation (selectsource-42)]
           ,[BusinessNature (selectsource-39)]
           ,[ShareHolder (grid-4)]
           ,[AuthorisedCapital (textinput-12)]
           ,[Authorizationdetails (grid-7)]
           ,[PaidUpCapital (textinput-13)]
           ,[CompanyNetAsset (textinput-164)]
           ,[AuthorizedPersonnel (grid-5)]
           ,[SpouseIDExpiryDate (dateinput-9)]
           ,[ModeofSignatory (selectbasic-39)]
           ,[ThirdParty3rdAuthorisation (multipleradiosinline-33)]
           ,[Startdate (dateinput-16)]
           ,[Enddate (dateinput-17)]
           ,[EmploymentStatus (selectsource-13)]
           ,[IndustriesSpecialization (selectsource-6)]
           ,[OccupationDesignation (selectsource-40)]
           ,[NameofCompany (textinput-15)]
           ,[PhoneOffice (textinput-17)]
           ,[GrossAnnualIncome (multipleradios-3)]
           ,[EstimatedNetWorth (multipleradios-4)]
           ,[SpouseName (textinput-18)]
           ,[SpouseNationality (selectsource-20)]
           ,[PermanentResidenceofMalaysia (multipleradiosinline-29)]
           ,[SpouseIDType (selectsource-8)]
           ,[SpouseIDNumber (textinput-20)]
           ,[BursaAnywhere (multipleradiosinline-34)]
           ,[NRICPassportEnclosed (selectbasic-31)]
           ,[NRIC (uploadinput-1)]
           ,[BankParticularsasperBankStatement (selectbasic-34)]
           ,[BankStatement (uploadinput-2)]
           ,[SignatureVerified (selectbasic-37)]
           ,[CDSandTrading (uploadinput-9)]
           ,[RiskProfilingScore (textinput-155)]
           ,[RiskProfiling (textinput-156)]
           ,[PromotionIndicator (selectsource-37)]
           ,[CDSPayment (selectsource-34)]
           ,[OthersCDSPayment (textinput-161)]
           ,[Remarks (textinput-169)]
           ,[LegalStatus (selectsource-38)]
           ,[BankruptcyorWindingupStatus (multipleradiosinline-35)]
           ,[SummonorDefaultinPaymentStatus (selectbasic-41)]
           ,[DateDeclaredBankruptcyorWindingup (dateinput-21)]
           ,[DateDischargedBankruptcyorWindingup (dateinput-22)]
           ,[Remark1 (textinput-170)]
           ,[Remark2 (textinput-171)]
           ,[SpouseEmploymentStatus (selectsource-21)]
           ,[SpouseIndustriesSpecialization (selectsource-23)]
           ,[SpouseOccupationDesignation (selectsource-41)]
           ,[SpouseNameofCompany (textinput-22)]
           ,[SpouseGrossAnnualIncome (multipleradios-1)]
           ,[SpousePhoneNo (textinput-24)]
           ,[UserID (textinput-165)]
           ,[OnlineSystemIndicator (multiplecheckboxesinline-2)]
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
           ,[PDPA (multipleradiosinline-23)]
           ,[State (selectsource-26)]
           ,[Country (selectsource-27)]
           ,[Postcode (textinput-46)]
           ,[PhoneHouse (textinput-55)]
           ,[PhoneMobile (textinput-57)]
           ,[CompanyTelNo (textinput-166)]
           ,[ContactPersonName (textinput-167)]
           ,[MobileNumber (textinput-168)]
           ,[Email (textinput-58)]
           ,[CDSeStatement (multipleradiosinline-30)]
           ,[ContractDelivery (selectsource-28)]
           ,[DailyTransactionDelivery (selectsource-36)]
           ,[MonthlyStmDelivery (selectsource-29)]
           ,[1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
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
           ,[FinancialDetails (grid-6)]
           ,[eDividend (multipleradiosinline-24)]
           ,[RelatedDetails (grid-2)]
           ,[PoliticalExposedPerson (selectbasic-24)]
           ,[FEAResidentofMalaysia (selectbasic-23)]
           ,[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]
           ,[TaxResidentoutsideMalaysia (selectbasic-40)]
           ,[TaxIdentificationNumber (textinput-149)]
           ,[TaxCountry (selectsource-30)]
           ,[FirstName (textinput-150)]
           ,[MiddleName (textinput-151)]
           ,[LastName (textinput-152)]
           ,[AddressCity (textinput-153)]
           ,[AddressCountry (selectsource-31)]
           ,[BirthCity (textinput-154)]
           ,[LEAP (multipleradiosinline-36)]
           ,[BirthCountry (selectsource-32)]
           ,[IdentificationNumber (textinput-157)]
           ,[LEAPStartDate (dateinput-11)]
           ,[ShareholderType (textinput-158)]
           ,[Name (textinput-159)]
           ,[AddressCity (textinput-160)]
           ,[AddressCountry (selectsource-33)]
           ,[IDSS (multipleradiosinline-17)]
           ,[IDSSStartDate (dateinput-10)]
           ,[IDSSSignedTC (uploadinput-3)]
           ,[LEAPSignedTC (uploadinput-4)]
           ,[ETFLI (multipleradiosinline-20)]
           ,[ETFLIStartDate (dateinput-13)]
           ,[ETFLISignedTC (uploadinput-5)]
           ,[W8BEN (multipleradiosinline-21)]
           ,[W8BENStartDate (dateinput-14)]
           ,[W8BENExpiryDate (dateinput-18)]
           ,[W8BENSignedTC (uploadinput-6)]
           ,[LetterofUndertakingforTWSE (multipleradiosinline-22)]
           ,[TWSEStartDate (dateinput-20)]
           ,[TWSESignedTC (uploadinput-10)]
           ,[Algo (multipleradiosinline-31)]
           ,[AlgoStartDate (dateinput-15)]
           ,[AlgoSignedTC (uploadinput-7)]
           ,[SophisticatedInvestor (multipleradiosinline-32)]
		   ,[Director (grid-8)]
		   ,[RiskProfiling (selectbasic-42)]
		   ,[RiskProfilingMode (multipleradiosinline-37)]
		   ,[PEPClassification (multipleradiosinline-38)]
		)	

			SELECT
				NULL AS [RecordID]
				,'I' AS [Action]
				,'' AS [AccountTypesProductInfo (grid-1)]
				,CASE TGC.ModeofClientAcquisition 
					WHEN 'ONFTF'	THEN 'ENFTFV'
					WHEN 'PFTF'		THEN 'NFTFV'
					WHEN 'PNFTF'	THEN 'FTF'
					ELSE IIF(TGC.ClientType = 'C' AND ISNULL(TGC.ModeofClientAcquisition,'') = '', 'FTF',  TGC.ModeofClientAcquisition)
				 END AS [ModeofClientAcquisition (selectbasic-25)]
				,TGC.ClientType AS [ClientType (selectbasic-26)]
				,'' AS [Dateofincorporated (dateinput-19)]	
				,TGC.CustomerID AS [CustomerID (textinput-1)]
				,TGC.OldCustomerID AS [OldCustomerID (textinput-131)]
				,TGC.Title AS [Title (textinput-2)]
				,TGC.CustomerName AS [CustomerName (textinput-3)]
				,TGC.Nationality AS [Nationality (selectsource-4)]
				,TGC.PermanentResidenceofMalaysia AS [PermanentResidenceofMalaysia (multipleradiosinline-2)]
				,TGC.IDType AS [IDType (selectsource-1)]
				,TGC.IDNumber AS [IDNumber (textinput-5)]
				,TGC.IDExpiryDate AS [IDExpiryDate (dateinput-6)]
				,TGC.AlternateIDType AS [AlternateIDType (selectsource-2)]
				,TGC.AlternateIDNumber AS [AlternateIDNumber (textinput-6)]
				,TGC.AlternateIDExpiryDate AS [AlternateIDExpiryDate (dateinput-7)]
				,TGC.Gender AS [Gender (selectbasic-1)]
				,TGC.MaritalStatus  AS [MaritalStatus (selectsource-11)]
				,TGC.DateofBirth  AS [DateofBirth (dateinput-1)]
				,TGC.Race AS [Race (selectsource-3)]
				,'' AS [Ownership (selectsource-35)]
				,TGC.CountryofResidence AS [CountryofResidence (selectsource-5)]
				,TGC.BumiputraStatus AS [BumiputraStatus (multipleradiosinline-1)]
				,TGC.PlaceOfIncorporation AS [PlaceofIncorporation (selectsource-42)]
				,TGC.BusinessNature AS [BusinessNature (selectsource-39)]
				,'' AS [ShareHolder (grid-4)]
				,TGC.CorporateShareholding AS [AuthorisedCapital (textinput-12)]	
				,'' AS [Authorizationdetails (grid-7)]
				,TGC.PaidUpCapital AS [PaidUpCapital (textinput-13)]
				,'' AS [CompanyNetAsset (textinput-164)]	
				,'' AS [AuthorizedPersonnel (grid-5)]
				,TGC.SpouseIDExpiryDate AS [SpouseIDExpiryDate (dateinput-9)]
				,TGC.NumberofAuthorisedPersonnelRequired  AS [ModeofSignatory (selectbasic-39)]	
				,TGC.ThirdParty3rdAuthorisation AS [ThirdParty3rdAuthorisation (multipleradiosinline-33)] 
				,'' AS [Startdate (dateinput-16)]
				,'' AS [Enddate (dateinput-17)]
				,TGC.EmploymentStatus AS [EmploymentStatus (selectsource-13)]	
				,TGC.IndustriesSpecialization  [IndustriesSpecialization (selectsource-6)] 
				,TGC.OccupationDesignation AS [OccupationDesignation (selectsource-40)]	
				,TGC.NameofCompany AS [NameofCompany (textinput-15)]
				,TGC.PhoneOffice AS [PhoneOffice (textinput-17)]
				,TGC.GrossAnnualIncome AS [GrossAnnualIncome (multipleradios-3)]		
				,TGC.EstimatedNetWorth AS [EstimatedNetWorth (multipleradios-4)]		
				,TGC.SpouseName AS [SpouseName (textinput-18)]
				,TGC.SpouseNationality AS [SpouseNationality (selectsource-20)]
				,TGC.SpousePermanentResidenceofMalaysia AS [PermanentResidenceofMalaysia (multipleradiosinline-29)]
				,TGC.SpouseIDType AS [SpouseIDType (selectsource-8)]
				,TGC.SpouseIDNumber AS [SpouseIDNumber (textinput-20)]
				,'' AS [BursaAnywhere (multipleradiosinline-34)]
				,'' AS [NRICPassportEnclosed (selectbasic-31)]
				,'' AS [NRIC (uploadinput-1)]--TGC.NRIC 
				,'' AS [BankParticularsasperBankStatement (selectbasic-34)]
				,'' AS [BankStatement (uploadinput-2)] --TGC.BankStatement
				,'' AS [SignatureVerified (selectbasic-37)]
				,'' AS [CDSandTrading (uploadinput-9)]
				,'' AS [RiskProfilingScore (textinput-155)]
				,'' AS [RiskProfiling (textinput-156)]
				,'' AS [PromotionIndicator (selectsource-37)]
				,'' AS [CDSPayment (selectsource-34)]
				,'' AS [OthersCDSPayment (textinput-161)]
				,'' AS [Remarks (textinput-169)]
				,'' AS [LegalStatus (selectsource-38)]
				,'N' AS [BankruptcyorWindingupStatus (multipleradiosinline-35)]
				,'N' AS [SummonorDefaultinPaymentStatus (selectbasic-41)]
				,'' AS [DateDeclaredBankruptcyorWindingup (dateinput-21)]
				,'' AS [DateDischargedBankruptcyorWindingup (dateinput-22)]
				,'' AS [Remark1 (textinput-170)]
				,'' AS [Remark2 (textinput-171)]
				,TGC.SpouseEmploymentStatus AS [SpouseEmploymentStatus (selectsource-21)]
				,TGC.SpouseIndustriesSpecialization AS [SpouseIndustriesSpecialization (selectsource-23)]
				,TGC.SpouseOccupationDesignation AS [SpouseOccupationDesignation (selectsource-41)]
				,TGC.SpouseNameofCompany AS [SpouseNameofCompany (textinput-22)]
				,TGC.SpouseGrossAnnualIncome AS [SpouseGrossAnnualIncome (multipleradios-1)]
				,TGC.SpousePhoneNo AS [SpousePhoneNo (textinput-24)]
				,'' AS [UserID (textinput-165)]
				,'' AS [OnlineSystemIndicator (multiplecheckboxesinline-2)]
				,TGC.RAAddress1 AS [Address1 (textinput-35)]
				,TGC.RAAddress2 AS [Address2 (textinput-36)]
				,TGC.RAAddress3 AS [Address3 (textinput-37)]
				,TGC.RATown AS [Town (textinput-38)]
				,TGC.RAStateOfMalaysia AS [State (textinput-39)]
				,TGC.RAStateNotMalaysia AS [State (selectsource-25)]
				,TGC.RACountry AS [Country (selectsource-24)]
				,TGC.RAPostcode AS [Postcode (textinput-40)]
				,TGC.SameasRegisteredAddress AS [SameasRegisteredAddress (multiplecheckboxesinline-1)]
				,TGC.CAAddress1 AS [Address1 (textinput-41)]
				,TGC.CAAddress2 AS [Address2 (textinput-42)]
				,TGC.CAAddress3 AS [Address3 (textinput-43)]
				,TGC.CATown AS [Town (textinput-44)]
				,TGC.CAStateOfMalaysia AS [State (textinput-45)]
				,TGC.PDPA AS [PDPA (multipleradiosinline-23)]
				,TGC.CAStateNotMalaysia AS [State (selectsource-26)]
				,TGC.CACountry AS [Country (selectsource-27)]
				,'' AS [Postcode (textinput-46)]
				,TGC.PhoneHouse AS [PhoneHouse (textinput-55)]
				,TGC.PhoneMobile AS [PhoneMobile (textinput-57)]
				,'' AS [CompanyTelNo (textinput-166)]
				,'' AS [ContactPersonName (textinput-167)]
				,'' AS [MobileNumber (textinput-168)]
				,TGC.Email AS [Email (textinput-58)]
				,ISNULL(NULLIF(TGC.CDSeStatement,''), 'Y')  AS [CDSeStatement (multipleradiosinline-30)]
				,ISNULL(NULLIF(TGC.ContractDelivery,''), 'Portal') AS [ContractDelivery (selectsource-28)]
				,'Portal' AS [DailyTransactionDelivery (selectsource-36)]
				,ISNULL(NULLIF(TGC.MonthlyStmDelivery,''), 'Portal') AS [MonthlyStmDelivery (selectsource-29)]
				,TGC.HowOftenDoYouKeepTrackonMarket AS [1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
				,TGC.Timeframetoholdastock AS [2Timeframetoholdastock (selectbasic-5)]
				,TGC.TypeofSecuritiesProductInterestedtickoneormore AS [3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)]
				,'' AS [textinput125 (textinput-125)]
				,TGC.TradingStrategyApproachUsingInterestedtickoneormore AS [4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)]
				,'' AS [textinput126 (textinput-126)]
				,TGC.Doyouinvestinotherinvestmentproductstickoneormore AS [5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)]
				,'' AS [textinput127 (textinput-127)]
				,TGC.Whatisyourmainsourceoffundsforinvestment AS [6Whatisyourmainsourceoffundsforinvestment (multiplecheckboxes-5)]
				,'' AS [textinput128 (textinput-128)]
				,TGC.HowlonghaveyoubeentradingintheMalaysiamarket AS [7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)]
				,TGC.DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify AS [8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)]
				,'' AS [textinput129 (textinput-129)]
				,TGC.Doyouholdorhavepreviouslyheldanysharemargintradingaccount AS [9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)]
				,TGC.Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof AS [10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)]
				,TGC.WhatisyourexpectedReturnoninvestmentfortheshortterm AS [11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)]
				,TGC.HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses AS [12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)]
				,'' AS [textinput130 (textinput-130)]
				,TGC.TradingMode AS [TradingMode (selectbasic-27)]
				,'' AS [FinancialDetails (grid-6)]
				,TGC.eDividend AS [eDividend (multipleradiosinline-24)]
				,'' AS [RelatedDetails (grid-2)]
				,TGC.PoliticalExposedPerson AS [PoliticalExposedPerson (selectbasic-24)]
				,TGC.FEAResidentofMalaysia AS [FEAResidentofMalaysia (selectbasic-23)]
				,TGC.FEAhaveDomesticRinggitBorrowing AS [FEAhaveDomesticRinggitBorrowing (selectbasic-30)]
				,'' AS [TaxResidentoutsideMalaysia (selectbasic-40)]
				,'' AS [TaxIdentificationNumber (textinput-149)]
				,TGC.TaxCountry AS [TaxCountry (selectsource-30)]
				,TGC.FirstName AS [FirstName (textinput-150)]
				,TGC.MiddleName AS [MiddleName (textinput-151)]
				,TGC.LastName AS [LastName (textinput-152)]
				,'' AS [AddressCity (textinput-153)]
				,'' AS [AddressCountry (selectsource-31)]
				,'' AS [BirthCity (textinput-154)]
				,TGC.LEAP AS [LEAP (multipleradiosinline-36)]
				,'' AS [BirthCountry (selectsource-32)]
				,'' AS [IdentificationNumber (textinput-157)]
				,TGC.LEAPStartDate AS [LEAPStartDate (dateinput-11)]
				,'' AS [ShareholderType (textinput-158)]
				,'' AS [Name (textinput-159)]
				,'' AS [AddressCity (textinput-160)]
				,'' AS [AddressCountry (selectsource-33)]
				,TGC.IDSS AS [IDSS (multipleradiosinline-17)]
				,TGC.IDSSStartDate AS [IDSSStartDate (dateinput-10)]
				,TGC.IDSSSignedTC AS [IDSSSignedTC (uploadinput-3)]
				,TGC.LEAPSignedTC AS [LEAPSignedTC (uploadinput-4)]
				,TGC.ETFLI AS [ETFLI (multipleradiosinline-20)]
				,TGC.ETFLIStartDate AS [ETFLIStartDate (dateinput-13)]
				,TGC.ETFLISignedTC AS [ETFLISignedTC (uploadinput-5)]
				,'' AS [W8BEN (multipleradiosinline-21)]
				,'' AS [W8BENStartDate (dateinput-14)]
				,'' AS [W8BENExpiryDate (dateinput-18)]
				,'' AS [W8BENSignedTC (uploadinput-6)]
				,TGC.LetterofUndertakingforTWSE AS [LetterofUndertakingforTWSE (multipleradiosinline-22)]
				,'' AS [TWSEStartDate (dateinput-20)]
				,'' AS [TWSESignedTC (uploadinput-10)]
				,TGC.Algo AS [Algo (multipleradiosinline-31)]
				,TGC.AlgoStartDate AS [AlgoStartDate (dateinput-15)]
				,TGC.AlgoSignedTC AS [AlgoSignedTC (uploadinput-7)]
				,IIF(ISNULL(TGC.SophisticatedInvestor,'') = '', 'N', TGC.SophisticatedInvestor) AS [SophisticatedInvestor (multipleradiosinline-32)]
				,'' AS [Director (grid-8)]
				,'' AS [RiskProfiling (selectbasic-42)] -- todo: compute later!
				,'A' AS [RiskProfilingMode (multipleradiosinline-37)]
				,'' AS [PEPClassification (multipleradiosinline-38)]
        FROM [import].[Tb_Gbo_CustomerInfo] AS TGC


		-- Updating CustomerId in FORMDATA 

		UPDATE CQBTempDB.[import].[Tb_FormData_1410]
		set	[CustomerID (textinput-1)] = @customerId - 1,
		@customerId = @customerId + 1;

--- Financial details ---  GRID-6

		INSERT INTO CQBTempDB.[import].[Tb_FormData_1410_grid6]
		(
		[RecordID],
		[Action],
		[RowIndex],
		[ (Radio Button)],
		[Account Holder Name (TextBox)],
		[Account Number (TextBox)],
		[Bank (Dropdown)],
		[Joint Account  (Dropdown)]
		)
		SELECT
		CUSTOMER.IDD AS RecordID,
		TGF.Action_ AS [Action],
		TGF.RowIndex AS [RowIndex],
		TGF.DefaultBankAccount AS [ (Radio Button)],
		TGF.AccountHolderName AS [Account Holder Name (TextBox)],
		TGF.AccountNumber AS [Account Number (TextBox)],
		TGF.Bank AS [Bank (Dropdown)],
		TGF.JointAccount AS [Joint Account  (Dropdown)]
		FROM [GlobalBOMY].[import].[Tb_Gbo_FinancialDetails] AS TGF
		LEFT JOIN [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC ON TGC.UniqueID = TGF.CustomerUniqueID
		LEFT JOIN [CQBTempDB].[import].Tb_FormData_1410 CUSTOMER ON TGC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]
		
		

--- IndividualAuthorization -- GRID7

		INSERT INTO [CQBTempDB].[import].[Tb_FormData_1410_grid7]
		(
		[RecordID],
		[Action],
		[RowIndex],
		[Name (TextBox)],
		[NRIC No. (TextBox)]
		)
		SELECT 
		CUSTOMER.IDD AS [RecordID],
		TGIA.Action_ AS [Action],
		TGIA.RowIndex AS [RowIndex],
		TGIA.Name AS [Name (TextBox)],
		TGIA.NRICNo AS [NRIC No. (TextBox)]
		FROM [GlobalBOMY].[import].[Tb_Gbo_IndividualAuthorizatio] TGIA
		LEFT JOIN [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC ON TGC.UniqueID = TGIA.CustomerUniqueID
		LEFT JOIN [CQBTempDB].[import].Tb_FormData_1410 CUSTOMER ON TGC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]

--- RELATED DETAILS -- GRIS2

		INSERT INTO [CQBTempDB].[import].[Tb_FormData_1410_grid2]
		(
			[RecordID],
			[RowIndex],
			[Related Account Name (TextBox)],
			[Relationship (TextBox)],
			[Related Account Number (TextBox)]
		)
		SELECT 
		CUSTOMER.IDD AS [RecordID],
		TGRD.RowIndex AS [RowIndex],
		TGRD.RelatedAccountName AS [Related Account Name (TextBox)],
		TGRD.Relationship AS [Relationship (TextBox)],
		TGRD.RelatedAccountNumber AS [Related Account Number (TextBox)]
		FROM [GlobalBOMY].[import].[Tb_Gbo_RelatedDetails] TGRD
		LEFT JOIN [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC ON TGC.UniqueID = TGRD.CustomerUniqueID
		LEFT JOIN [CQBTempDB].[import].Tb_FormData_1410 CUSTOMER ON TGC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]

--- Customer Account Type -- Grid1



       INSERT INTO [CQBTempDB].[import].[Tb_FormData_1410_grid1]
	   (
			[RecordID],
			[RowIndex],
			[Account Type (Dropdown)],		
			[Algo (TextBox)],
			[Foreign (CheckBox)],
			[Dealer Code (TextBox)],
			[Nominees (Radio Button)],
			[CDS No (TextBox)],
			[Financier (Dropdown)]
	   )
	   SELECT 
	   CUSTOMER.IDD AS [RecordID],
	   TGCA.RowIndex AS [RowIndex],
	   TGCA.AccountType AS [Account Type (Dropdown)],
	   TGCA.Algo AS [Algo (TextBox)],
	   TGCA.Foreign_ AS [Foreign (CheckBox)],
	   AC.BrokerCodeDealerEAFIDDealerCode,
	   CASE WHEN AMI.NomineeInd <> '' THEN 'Y' ELSE 'N' END, 
	   AMI.CDSNo,
	   TGCA.Financier AS [Financier (Dropdown)]

	   FROM [GlobalBOMY].[import].[Tb_Gbo_Cust_Acc_Type] TGCA
	   LEFT JOIN [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC ON TGC.UniqueID = TGCA.CustomerUniqueID
	   LEFT JOIN [CQBTempDB].[import].Tb_FormData_1410 CUSTOMER ON TGC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]
	   LEFT JOIN [import].Tb_Account as AC ON AC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]            
	   LEFT JOIN [import].Tb_AccountMarketInfo As AMI ON AMI.AccountNo = AC.AccountNumber

	   UPDATE CQBTempDB.import.Tb_FormData_1410_grid6
		SET [ (Radio Button)]='Y' WHERE RowIndex=1;

		-- UPDATE BURSA ANYWHERE FLAG
		UPDATE Customer
		SET [BursaAnywhere (multipleradiosinline-34)] = 'Y' 
		FROM CQBTEMPDB.import.TB_FORMDATA_1410 Customer 
		INNER JOIN GlobalBOMY.import.Tb_Bursa_BATransactions Trans ON Customer.[IDNumber (textinput-5)] = REPLACE(Trans.ID_NRIC,'-','')


		EXEC CQBuilder.[dbo].[Usp_CalculateProfileRating];

		SELECT TOP 1 @lastCustomerID = [CustomerID (textinput-1)] + 1
		FROM CQBTempDB.[import].[Tb_FormData_1410] 
		order by [CustomerID (textinput-1)] desc

		UPDATE CQBuilder.form.Tb_FormData_5
		SET FormDetails = JSON_MODIFY(JSON_MODIFY(FormDetails, '$[0].textinput4', @lastCustomerID), '$[1].textinput4', @lastCustomerID)
		WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active';


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

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );

    END CATCH
    
    SET NOCOUNT OFF;

END