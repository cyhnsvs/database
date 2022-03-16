/****** Object:  Procedure [import].[Usp_OneTime_Customer_FileToForm_20200423]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_OneTime_CustomerFileToCustomerForm]
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
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		--Exec form.[Usp_CreateImportTable] 1410
		--Select * from CQBTempDB.[import].[Tb_FormData_1410]

		;WITH cteAccountList AS
		(
		   SELECT *,
				 ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY AccountNumber DESC) AS rowno
		   FROM import.Tb_Account
		),cteUniqueAccountDetail As (
			SELECT *
			FROM cteAccountList
			WHERE rowno = 1
		)
		
		INSERT INTO CQBTempDB.[import].[Tb_FormData_1410]
				   ([AccountTypesProductInfo (multiplecheckboxes-1)]
				   ,[CustomerID (textinput-1)]
				   ,[OldCustomerID (textinput-131)]
				   ,[Title (textinput-2)]
				   --,[BankAccountNumber5 (textinput-84)]
				   --,[BankCode5 (textinput-85)]
				   --,[JointAccount5 (multipleradiosinline-7)]
				   ,[Financier (textinput-86)]
				   --,[textinput94 (textinput-94)]
				   ,[SetoffInd (selectbasic-15)]
				   ,[SetoffContraGainDebitAmount (selectbasic-16)]
				   ,[SetoffSalesPurchasesReport (selectbasic-17)]
				   ,[SetoffTrustDebitTransactions (selectbasic-18)]
				   ,[SetoffTrustContraLoss (selectbasic-19)]
				   ,[TransferCreditTransactiontoTrust (selectbasic-20)]
				   ,[PrintSetoffStatement (selectbasic-21)]
				   ,[AvailableTradingLimit (textinput-95)]
				   ,[BFEACType (textinput-96)]
				   ,[ClientAssoAllowed (multipleradiosinline-8)]
				   ,[ClientReassignAllowed (multipleradiosinline-9)]
				   ,[ClientCrossAmend (multipleradiosinline-10)]
				   ,[MultiplierforCashDeposit (textinput-97)]
				   --,[IC (uploadinput-1)]
				   ,[MultiplierforSharePledged (textinput-98)]
				   ,[MultiplierforNonShare (textinput-99)]
				   ,[AvailableCleanLineLimit (textinput-100)]
				   ,[TemporaryLimit (textinput-101)]
				   ,[StartDate (dateinput-2)]
				   ,[EndDate (dateinput-3)]
				   ,[Remark2 (textarea-3)]
				   ,[FirstName (textinput-3)]
				   ,[LastName (textinput-4)]
				   ,[DateofBirth (dateinput-1)]
				   ,[IDType (selectsource-1)]
				   ,[IDNumber (textinput-5)]
				   ,[AlternateIDNumber (textinput-6)]
				   ,[Gender (selectbasic-1)]
				   ,[AlternateIDType (selectsource-2)]
				   ,[MaritalStatus (selectsource-11)]
				   ,[Race (selectsource-3)]
				   ,[Nationality (selectsource-4)]
				   ,[CountryofResidence (selectsource-5)]
				   --,[TemporaryLimitwithLevelofAuthorityNEW (textinput-102)]
				   --,[LegalStatus (textinput-103)] -- Removed in latest form
				   --,[BankruptcyorWindingupStatus (textinput-104)] -- Removed in latest form
				   ,[BankruptcyorWindingupReason (textarea-1)]
				   ,[DateDeclaredBankruptcyorWindingup (dateinput-4)]
				   ,[DateDischargedBankruptcyorWindingup (dateinput-5)]
				   ,[Remark1 (textarea-2)]
				   ,[DefaulterList (textinput-105)]
				   ,[SanctionList (textinput-106)]
				   --,[PoliticalExposedPersonIndicatorNEW (textinput-107)]
				   --,[IDSSIndicatorNEW (textinput-108)]
				   ----,[CRSNEW (textinput-109)]
				   --,[LEAPNEW (textinput-110)]
				   --,[FEAResidentofMalaysia (textinput-111)]
				   --,[FEAhaveDomesticRinggitBorrowing (textinput-112)]
				   --,[ETFLIIndicatorNEW (textinput-113)]
				   --,[W8BENIndicatorNEW (textinput-114)]
				   --,[LetterofUndertakingforTWSEindicatorNEW (textinput-115)]
				   --,[PDPAIndicatorNEW (textinput-116)]
				   --,[eDividendNEW (textinput-117)]
				   --,[JointAccountIndicatorNEW (textinput-118)]
				   --,[estatementNEW (textinput-119)]
				   --,[BankStatement (uploadinput-2)]
				   ,[NRICPassportEnclosed (multipleradiosinline-11)]
				   ,[ExistingAccount (multipleradiosinline-12)]
				   ,[AccountNo (textinput-120)]
				   ,[BumiputraStatus (multipleradiosinline-1)]
				   ,[PermanentResidence (multipleradiosinline-2)]
				   ,[PlaceofIncorporation (textinput-7)]
				   ,[BusinessNature (textinput-8)]
				   --,[CorporateShareholderName (textinput-9)]
				   --,[CorporateShareholderIDType (textinput-10)]
				   --,[CorporateShareholderIDNumber (textinput-11)]
				   --,[CorporateShareholding (textinput-12)]
				   ,[PaidUpCapital (textinput-13)]
				   --,[EmploymentStatus (textinput-14)]
				   --,[JobSector (selectsource-12)]
				   --,[IndustriesSpecialization (selectsource-6)]
				   ,[OccupationDesignation (selectsource-7)]
				   ,[NameofCompany (textinput-15)]
				   ,[YearsinEmploymentBusiness (textinput-16)]
				   --,[OfficePhoneNo (textinput-17)]
				   --,[CorrespondenceAddress (multipleradiosinline-13)]
				   --,[SignatureVerified (multipleradiosinline-14)]
				   --,[MTTFClientProfiling (textinput-121)]
				   ,[SpouseFirstName (textinput-18)]
				   ,[SpouseLastName (textinput-19)]
				   --,[SpouseIDType (selectsource-8)]
				   ,[SpouseIDNumber (textinput-20)]
				   --,[SpouseAlternateIDType (selectsource-9)]
				   ,[SpouseAlternateIDNumber (textinput-21)]
				   ,[SpouseNameofCompany (textinput-22)]
				   ,[SpouseYearsinEmploymentBusiness (textinput-23)]
				   --,[SpouseOccupationDesignation (selectsource-10)]
				   ,[SpousePhoneNo (textinput-24)]
				   ,[RelatedACNo1a (textinput-25)]
				   ,[RelatedACNo1b (textinput-26)]
				   ,[RelatedACNo2a (textinput-27)]
				   ,[RelatedACNo2b (textinput-28)]
				   ,[RelatedACNo3a (textinput-29)]
				   ,[RelatedACNo3b (textinput-30)]
				   ,[RelatedACNo4a (textinput-31)]
				   ,[RelatedACNo4b (textinput-32)]
				   ,[RelatedACNo5a (textinput-33)]
				   ,[RelatedACNo5b (textinput-34)]
				   ,[Address1 (textinput-35)]
				   ,[Address2 (textinput-36)]
				   ,[Address3 (textinput-37)]
				   ,[Address4 (textinput-38)]
				   ,[Address5 (textinput-39)]
				   ,[Postcode (textinput-40)]
				   ,[Address1 (textinput-41)]
				   ,[Address2 (textinput-42)]
				   ,[Address3 (textinput-43)]
				   ,[Address4 (textinput-44)]
				   ,[Address5 (textinput-45)]
				   ,[Postcode (textinput-46)]
				   ,[ForeignAddress (textinput-124)]
				   ,[CorrespondenceTitle1stDuplicateContract (textinput-47)]
				   ,[CorrespondenceName (textinput-48)]
				   ,[CorrespondenceAddress1 (textinput-49)]
				   ,[CorrespondenceAddress2 (textinput-50)]
				   ,[CorrespondenceAddress3 (textinput-51)]
				   ,[CorrespondenceAddress4 (textinput-52)]
				   ,[CorrespondenceAddress5 (textinput-53)]
				   ,[CorrespondencePostcode (textinput-54)]
				   ,[PhoneHouse (textinput-55)]
				   ,[PhoneOffice (textinput-56)]
				   ,[PhoneMobile (textinput-57)]
				   ,[Email (textinput-58)]
				   ,[ModeofContactifnoEmail (textinput-59)]
				   ,[GrossAnnualIncome (textinput-60)]
				   ,[EstimatedNetWorth (textinput-61)]
				   ,[OtherIncome1 (textinput-62)]
				   ,[OtherIncome2 (textinput-63)]
				   ,[InvestmentSource (textinput-64)]
				   --,[CustInfoRiskProfile (selectbasic-22)]
				   ,[1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
				   ,[2Timeframetoholdastock (selectbasic-5)]
				   ,[3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)]
				   ,[textinput125 (textinput-125)]
				   ,[4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)]
				   ,[textinput126 (textinput-126)]
				   ,[5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)]
				   ,[textinput127 (textinput-127)]
				   ,[6Whatisyourmainsourceoffundsforinvestment (selectbasic-9)]
				   ,[textinput128 (textinput-128)]
				   ,[7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)]
				   ,[8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)]
				   ,[textinput129 (textinput-129)]
				   ,[9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)]
				   ,[10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)]
				   ,[11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)]
				   ,[12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)]
				   ,[textinput130 (textinput-130)]
				   --,[BankAccountHolderName1 (textinput-71)]
				   --,[BankAccountNumber1 (textinput-72)]
				   --,[BankCode1 (textinput-73)]
				   --,[JointAccount1 (multipleradiosinline-3)]
				   --,[BankAccountHolderName2 (textinput-74)]
				   --,[BankAccountNumber2 (textinput-75)]
				   --,[BankCode2 (textinput-76)]
				   --,[JointAccount2 (multipleradiosinline-4)]
				   --,[BankAccountHolderName3 (textinput-77)]
				   --,[BankAccountNumber3 (textinput-78)]
				   --,[BankCode3 (textinput-79)]
				   --,[JointAccount3 (multipleradiosinline-5)]
				   --,[BankAccountHolderName4 (textinput-80)]
				   --,[BankAccountNumber4 (textinput-81)]
				   --,[BankCode4 (textinput-82)]
				   --,[JointAccount4 (multipleradiosinline-6)]
				   --,[BankAccountHolderName5 (textinput-83)]
				   )
		 SELECT 
			AccountType--[AccountTypesProductInfo (multiplecheckboxes-1)]
           ,A.CustomerID
		   ,A.CustomerID
           ,A.Title
           --,[BankAccountNumber5 (textinput-84)]
           --,[BankCode5 (textinput-85)]
           --,[JointAccount5 (multipleradiosinline-7)]
           ,B.Financier
           --,[textinput94 (textinput-94)]
           ,C.SetoffInd
           ,C.SetoffContraGainDebitAmt
           ,C.SetoffSalesPurchases
           ,C.SetoffTrustDebitTrans
           ,C.SetoffTrustContraLoss
           ,C.TransferCreditTransToTrust
           ,C.PrintSetoffStatement
           ,C.AvailableTradingLimit
           ,C.BFEACType
           ,C.ClientAssoAllowed
           ,C.ClientReassignAllowed
           ,C.ClientCrossAmend
           ,C.MultiplierforCashDeposit
           --,C.IC
           ,C.MultiplierforSharePledged
           ,C.MultiplierforNonShare
           ,C.AvailableCleanLineLimit
           ,C.TemporaryLimit
           ,C.StartDate
           ,C.EndDate
           ,A.Remarks1
           ,A.CustomerName
           ,'' As LastName
           ,A.DateOfBirth
           ,A.IDType
           ,A.IDNumber
           ,A.AlternateIDNumber
           ,A.Sex
           ,A.AlternateID
           ,A.MaritalStatus
           ,A.Race
           ,A.Nationality
           ,A.CountryOfResidence
           --,C.TemporaryLimitwithLevelofAuthorityNEW
           --,A.LegalStatus -- Removed in latest form
           --,A.BankruptcyOrWindingUpStatus -- Removed in latest form
           ,A.BankruptcyOrWindingUpReason
           ,A.DateDeclaredBankruptcyOrWindingUp
           ,A.DateDischargedBankruptcyOrWindingUp
           ,A.Remarks1
           ,'No' As DefaulterList
           ,'No' As SanctionList
           --,'No' As [PoliticalExposedPersonIndicatorNEW (textinput-107)]
           --,'No' As [IDSSIndicatorNEW (textinput-108)]
           ----,[CRSNEW (textinput-109)]
           --,'No' As [LEAPNEW (textinput-110)]
           --,'' As [FEAResidentofMalaysia (textinput-111)]
           --,'' As [FEAhaveDomesticRinggitBorrowing (textinput-112)]
           --,'No' As [ETFLIIndicatorNEW (textinput-113)]
           --,'No' As [W8BENIndicatorNEW (textinput-114)]
           --,'No' As [LetterofUndertakingforTWSEindicatorNEW (textinput-115)]
           --,'Yes' As [PDPAIndicatorNEW (textinput-116)]
           --,'' As [eDividendNEW (textinput-117)]
           --,'' As [JointAccountIndicatorNEW (textinput-118)]
           --,'' As [estatementNEW (textinput-119)]
           --,BankStatement (uploadinput-2)]
           ,'' As [NRICPassportEnclosed (multipleradiosinline-11)]
           ,'No' As [ExistingAccount (multipleradiosinline-12)]
           ,B.AccountNumber
           ,A.BumiputraStatus
           ,A.PermanentResident
           ,A.PlaceOfIncorporation
           ,A.BusinessNature
           --,[CorporateShareholderName (textinput-9)]
           --,[CorporateShareholderIDType (textinput-10)]
           --,[CorporateShareholderIDNumber (textinput-11)]
           --,[CorporateShareholding (textinput-12)]
           ,A.PaidUpCapital
           --,[EmploymentStatus (textinput-14)]
           --,[JobSector (selectsource-12)]
           --,[IndustriesSpecialization (selectsource-6)]
           ,A.Occupation
           ,B.NameOfCompany
           ,'' --[YearsinEmploymentBusiness (textinput-16)]
           --,[OfficePhoneNo (textinput-17)]
           --,[CorrespondenceAddress (multipleradiosinline-13)]
           --,[SignatureVerified (multipleradiosinline-14)]
           --,[MTTFClientProfiling (textinput-121)]
           ,'' As [SpouseFirstName (textinput-18)]
           ,'' As [SpouseLastName (textinput-19)]
           --,[SpouseIDType (selectsource-8)]
           ,'' As [SpouseIDNumber (textinput-20)]
           --,[SpouseAlternateIDType (selectsource-9)]
           ,'' As [SpouseAlternateIDNumber (textinput-21)]
           ,'' As [SpouseNameofCompany (textinput-22)]
           ,'' As [SpouseYearsinEmploymentBusiness (textinput-23)]
           --,[SpouseOccupationDesignation (selectsource-10)]
           ,'' As [SpousePhoneNo (textinput-24)]
           ,B.RelatedACNo1a
           ,B.RelatedACNo1b
           ,B.RelatedACNo2a
           ,B.RelatedACNo2b
           ,B.RelatedACNo3a
           ,B.RelatedACNo3b
           ,B.RelatedACNo4a
           ,B.RelatedACNo4b
           ,B.RelatedACNo5a
           ,B.RelatedACNo5b
           ,A.RegisteredAddress1
           ,A.RegisteredAddress2
           ,A.RegisteredAddress3
           ,A.RegisteredAddress4
           ,A.RegisteredAddress5
           ,A.PostCode
           ,B.CorrAdd1
           ,B.CorrAdd2
           ,B.CorrAdd3
           ,B.CorrAdd4
           ,B.CorrAdd5
           ,B.CorrPostCode
           ,B.ForeignAdd
           ,B.[1stDupContCorrTitle]
           ,B.[1stDupContCorrName]
           ,B.[1stDupContCorrAdd1]
           ,B.[1stDupContCorrAdd2]
           ,B.[1stDupContCorrAdd3]
           ,B.[1stDupContCorrAdd4]
           ,B.[1stDupContCorrAdd5]
           ,B.[1stDupContCorrPostCode]
           ,A.[PhoneHouse]
		   ,A.PhoneOffice
           ,A.[PhoneMobile]
           ,A.[Email]
           ,'' As [ModeofContactifnoEmail (textinput-59)]
           ,A.AnnualIncome
           ,'' As [EstimatedNetWorth (textinput-61)]
           ,A.OtherIncome1
           ,A.OtherIncome2
           ,'' As [InvestmentSource (textinput-64)]
           --,[CustInfoRiskProfile (selectbasic-22)]
           ,'' As [1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
           ,'' As [2Timeframetoholdastock (selectbasic-5)]
           ,'' As [3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)]
           ,'' As [textinput125 (textinput-125)]
           ,'' As [4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)]
           ,'' As [textinput126 (textinput-126)]
           ,'' As [5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)]
           ,'' As [textinput127 (textinput-127)]
           ,'' As [6Whatisyourmainsourceoffundsforinvestment (selectbasic-9)]
           ,'' As [textinput128 (textinput-128)]
           ,'' As [7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)]
           ,'' As [8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)]
           ,'' As [textinput129 (textinput-129)]
           ,'' As [9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)]
           ,'' As [10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)]
           ,'' As [11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)]
           ,'' As [12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)]
           ,'' As [textinput130 (textinput-130)]
           --,[BankAccountHolderName1 (textinput-71)]
           --,[BankAccountNumber1 (textinput-72)]
           --,[BankCode1 (textinput-73)]
           --,[JointAccount1 (multipleradiosinline-3)]
           --,[BankAccountHolderName2 (textinput-74)]
           --,[BankAccountNumber2 (textinput-75)]
           --,[BankCode2 (textinput-76)]
           --,[JointAccount2 (multipleradiosinline-4)]
           --,[BankAccountHolderName3 (textinput-77)]
           --,[BankAccountNumber3 (textinput-78)]
           --,[BankCode3 (textinput-79)]
           --,[JointAccount3 (multipleradiosinline-5)]
           --,[BankAccountHolderName4 (textinput-80)]
           --,[BankAccountNumber4 (textinput-81)]
           --,[BankCode4 (textinput-82)]
           --,[JointAccount4 (multipleradiosinline-6)]
           --,[BankAccountHolderName5 (textinput-83)]
		 FROM import.Tb_Customer As A
		 LEFT JOIN cteUniqueAccountDetail As B
		 ON A.CustomerID = B.CustomerKey
		 LEFT JOIN import.Tb_AccountMarketInfo As C
		 ON B.AccountNumber=C.AccountNo
		 LEFT JOIN import.Tb_AccountMargin As D
		 ON B.AccountNumber=D.AccountNumber
		
		
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