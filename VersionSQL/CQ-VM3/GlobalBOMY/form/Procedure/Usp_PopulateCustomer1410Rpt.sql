/****** Object:  Procedure [form].[Usp_PopulateCustomer1410Rpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_PopulateCustomer1410Rpt]        
 @iintCompanyId BIGINT,        
 @ostrReturnMessage VARCHAR(400) OUTPUT        
AS        
/***********************************************************************************         
        
Name              : [form].[Usp_PopulateCustomer1409Rpt]        
Created By        : Fadlin        
Created Date      : 09/12/2020
Last Updated Date :         
Description       : this sp transfers the account from main CQB database to the reporting database        
					uses a same server/different server switch to determine which source database to use        
Table(s) Used     :         
        
Modification History :        
 ModifiedBy :   Project UIN:		ModifiedDate :  Reason :        
 
 
													
PARAMETERS         
 @iintCompanyId - the company id        
 @ostrReturnMessage - output any info/error message generated        
        
Used By :        
        EXEC [form].[Usp_PopulateCustomer1410Rpt]  1,''
************************************************************************************/        
BEGIN        
        
 SET NOCOUNT ON;        
        
 BEGIN TRY        
     BEGIN TRANSACTION        
                
		DECLARE @dteBusinessDate DATE;       
		    
		SELECT @dteBusinessDate = DateValue        
		FROM GlobalBORpt.setup.Tb_Date        
		WHERE CompanyId = @iintCompanyId AND  DateCd = 'BusDate' ;              
		
		--SET @dteBusinessDate = '2020-12-08';

		DELETE FROM GlobalBORpt.form.Tb_FormData_1410 
		WHERE ReportDate = @dteBusinessDate;   

		INSERT INTO GlobalBORpt.[form].[Tb_FormData_1410]
		(
			[ReportDate]
			,[RecordID]
			,[CreatedBy]
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
			,[AccountTypesProductInfo (grid-1)]
			,[ModeofClientAcquisition (selectbasic-25)]
			,[ClientType (selectbasic-26)]
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
			,[CountryofResidence (selectsource-5)]
			,[BumiputraStatus (multipleradiosinline-1)]
			,[PlaceofIncorporation (textinput-7)]
			,[BusinessNature (textinput-8)]
			,[ShareHolder (grid-4)]
			,[CorporateShareholding (textinput-12)]
			,[PaidUpCapital (textinput-13)]
			,[AuthorizedPersonnel (grid-5)]
			,[Numberofauthorisedpersonnelrequired (selectbasic-39)]
			,[ThirdParty3rdAuthorisation (multipleradiosinline-33)]
			,[Startdate (dateinput-16)]
			,[Enddate (dateinput-17)]
			,[Authorizationdetails (grid-7)]
			,[EmploymentStatus (selectsource-13)]
			,[JobSector (selectsource-12)]
			,[IndustriesSpecialization (selectsource-6)]
			,[OccupationDesignation (selectsource-7)]
			,[NameofCompany (textinput-15)]
			,[PhoneOffice (textinput-17)]
			,[SpouseName (textinput-18)]
			,[SpouseNationality (selectsource-20)]
			,[PermanentResidenceofMalaysia (multipleradiosinline-29)]
			,[SpouseIDType (selectsource-8)]
			,[SpouseIDNumber (textinput-20)]
			,[SpouseIDExpiryDate (dateinput-9)]
			,[SpouseEmploymentStatus (selectsource-21)]
			,[SpouseJobSector (selectsource-22)]
			,[SpouseIndustriesSpecialization (selectsource-23)]
			,[SpouseOccupationDesignation (selectsource-10)]
			,[SpouseNameofCompany (textinput-22)]
			,[SpouseGrossAnnualIncome (multipleradios-1)]
			,[SpouseEstimatedNetWorth (multipleradios-2)]
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
			,[State (selectsource-26)]
			,[Country (selectsource-27)]
			,[Postcode (textinput-46)]
			,[PhoneHouse (textinput-55)]
			,[PhoneMobile (textinput-57)]
			,[Email (textinput-58)]
			,[CDSeStatement (multipleradiosinline-30)]
			,[ContractDelivery (selectsource-28)]
			,[MonthlyStmDelivery (selectsource-29)]
			,[GrossAnnualIncome (multipleradios-3)]
			,[EstimatedNetWorth (multipleradios-4)]
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
			,[W8BEN (multipleradiosinline-21)]
			,[W8BENStartDate (dateinput-14)]
			,[W8BENExpiryDate (dateinput-18)]
			,[W8BENSignedTC (uploadinput-6)]
			,[LetterofUndertakingforTWSE (multipleradiosinline-22)]
			,[PDPA (multipleradiosinline-23)]
			,[eDividend (multipleradiosinline-24)]
			,[Algo (multipleradiosinline-31)]
			,[AlgoStartDate (dateinput-15)]
			,[AlgoSignedTC (uploadinput-7)]
			,[SophisticatedInvestor (multipleradiosinline-32)]
			,[TaxIdentificationNumber (textinput-149)]
			,[TaxCountry (selectsource-30)]
			,[FirstName (textinput-150)]
			,[MiddleName (textinput-151)]
			,[LastName (textinput-152)]
			,[AddressCity (textinput-153)]
			,[AddressCountry (selectsource-31)]
			,[BirthCity (textinput-154)]
			,[BirthCountry (selectsource-32)]
			,[IdentificationNumber (textinput-157)]
			,[ShareholderType (textinput-158)]
			,[Name (textinput-159)]
			,[AddressCity (textinput-160)]
			,[AddressCountry (selectsource-33)]
			,[NRIC (uploadinput-1)]
			,[Passport (uploadinput-8)]
			,[BankStatement (uploadinput-2)]
			,[DigitalSignature (signature-1)]
			,[CDSandTrading (uploadinput-9)]
			,[NRICPassportEnclosed (selectbasic-31)]
			,[NameasperNRICPassport (selectbasic-32)]
			,[RegisteredAddressasperNRIC (selectbasic-33)]
			,[BankParticularsasperBankStatement (selectbasic-34)]
			,[eKYCProfile (selectbasic-35)]
			,[CDSPayment (selectsource-34)]
			,[OthersCDSPayment (textinput-161)]
			,[SignatureVerified (selectbasic-37)]
			,[PROMO16Indicator (selectbasic-38)]
			,[RiskProfilingScore (textinput-155)]
			,[RiskProfiling (textinput-156)]
        )
		SELECT
			@dteBusinessDate
			,[RecordID]
			,[CreatedBy]
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
			,[AccountTypesProductInfo (grid-1)]
			,[ModeofClientAcquisition (selectbasic-25)]
			,[ClientType (selectbasic-26)]
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
			,[CountryofResidence (selectsource-5)]
			,[BumiputraStatus (multipleradiosinline-1)]
			,[PlaceofIncorporation (textinput-7)]
			,[BusinessNature (textinput-8)]
			,[ShareHolder (grid-4)]
			,[CorporateShareholding (textinput-12)]
			,[PaidUpCapital (textinput-13)]
			,[AuthorizedPersonnel (grid-5)]
			,[Numberofauthorisedpersonnelrequired (selectbasic-39)]
			,[ThirdParty3rdAuthorisation (multipleradiosinline-33)]
			,[Startdate (dateinput-16)]
			,[Enddate (dateinput-17)]
			,[Authorizationdetails (grid-7)]
			,[EmploymentStatus (selectsource-13)]
			,[JobSector (selectsource-12)]
			,[IndustriesSpecialization (selectsource-6)]
			,[OccupationDesignation (selectsource-7)]
			,[NameofCompany (textinput-15)]
			,[PhoneOffice (textinput-17)]
			,[SpouseName (textinput-18)]
			,[SpouseNationality (selectsource-20)]
			,[PermanentResidenceofMalaysia (multipleradiosinline-29)]
			,[SpouseIDType (selectsource-8)]
			,[SpouseIDNumber (textinput-20)]
			,[SpouseIDExpiryDate (dateinput-9)]
			,[SpouseEmploymentStatus (selectsource-21)]
			,[SpouseJobSector (selectsource-22)]
			,[SpouseIndustriesSpecialization (selectsource-23)]
			,[SpouseOccupationDesignation (selectsource-10)]
			,[SpouseNameofCompany (textinput-22)]
			,[SpouseGrossAnnualIncome (multipleradios-1)]
			,[SpouseEstimatedNetWorth (multipleradios-2)]
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
			,[State (selectsource-26)]
			,[Country (selectsource-27)]
			,[Postcode (textinput-46)]
			,[PhoneHouse (textinput-55)]
			,[PhoneMobile (textinput-57)]
			,[Email (textinput-58)]
			,[CDSeStatement (multipleradiosinline-30)]
			,[ContractDelivery (selectsource-28)]
			,[MonthlyStmDelivery (selectsource-29)]
			,[GrossAnnualIncome (multipleradios-3)]
			,[EstimatedNetWorth (multipleradios-4)]
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
			,[W8BEN (multipleradiosinline-21)]
			,[W8BENStartDate (dateinput-14)]
			,[W8BENExpiryDate (dateinput-18)]
			,[W8BENSignedTC (uploadinput-6)]
			,[LetterofUndertakingforTWSE (multipleradiosinline-22)]
			,[PDPA (multipleradiosinline-23)]
			,[eDividend (multipleradiosinline-24)]
			,[Algo (multipleradiosinline-31)]
			,[AlgoStartDate (dateinput-15)]
			,[AlgoSignedTC (uploadinput-7)]
			,[SophisticatedInvestor (multipleradiosinline-32)]
			,[TaxIdentificationNumber (textinput-149)]
			,[TaxCountry (selectsource-30)]
			,[FirstName (textinput-150)]
			,[MiddleName (textinput-151)]
			,[LastName (textinput-152)]
			,[AddressCity (textinput-153)]
			,[AddressCountry (selectsource-31)]
			,[BirthCity (textinput-154)]
			,[BirthCountry (selectsource-32)]
			,[IdentificationNumber (textinput-157)]
			,[ShareholderType (textinput-158)]
			,[Name (textinput-159)]
			,[AddressCity (textinput-160)]
			,[AddressCountry (selectsource-33)]
			,[NRIC (uploadinput-1)]
			,[Passport (uploadinput-8)]
			,[BankStatement (uploadinput-2)]
			,[DigitalSignature (signature-1)]
			,[CDSandTrading (uploadinput-9)]
			,[NRICPassportEnclosed (selectbasic-31)]
			,[NameasperNRICPassport (selectbasic-32)]
			,[RegisteredAddressasperNRIC (selectbasic-33)]
			,[BankParticularsasperBankStatement (selectbasic-34)]
			,[eKYCProfile (selectbasic-35)]
			,[CDSPayment (selectsource-34)]
			,[OthersCDSPayment (textinput-161)]
			,[SignatureVerified (selectbasic-37)]
			,[PROMO16Indicator (selectbasic-38)]
			,[RiskProfilingScore (textinput-155)]
			,[RiskProfiling (textinput-156)]
		FROM CQBTempDB.export.Tb_FormData_1410;

		--DELETE FROM form.Tb_FormData_1409 WHERE ReportDate <= DATEADD(day, -7, GETDATE());
    COMMIT TRANSACTION        
    END TRY        
    BEGIN CATCH     
    
		ROLLBACK TRANSACTION;     
		
		SELECT @ostrReturnMessage = ERROR_MESSAGE();        
        EXECUTE GlobalBORpt.utilities.usp_RethrowError ',[form].[Usp_PopulateCustomer1410Rpt] '; 
   
    END CATCH        
            
    SET NOCOUNT OFF;         
        
END 