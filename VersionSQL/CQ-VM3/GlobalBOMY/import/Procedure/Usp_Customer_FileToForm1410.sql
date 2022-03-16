/****** Object:  Procedure [import].[Usp_Customer_FileToForm1410]    Committed by VersionSQL https://www.versionsql.com ******/

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
  Kristine				2021/09/07				Customer Info Form Update 2.0

PARAMETERS
EXEC [import].[Usp_Customer_ValidateImportData]
EXEC [import].[Usp_Customer_FileToForm1410] 
************************************************************************************/
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		

		BEGIN TRANSACTION;
	--DEPENDENCY ON CUSTOMER & ACCOUNT MAPPING SCRIPT

		Exec CQBTempDB.form.[Usp_CreateImportTable] 1410;

		---- Select * from CQBTempDB.[import].[Tb_FormData_1410]

		TRUNCATE TABLE [CQBTempDB].[import].Tb_FormData_1410;
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid6]
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid7]
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid2]
		TRUNCATE TABLE [CQBTempDB].[import].[Tb_FormData_1410_grid1]

		DECLARE @lastCustomerID BIGINT, @lastRunNo BIGINT,@customerId BIGINT
			,@UploadInputPath VARCHAR(100) =  'D:\CQBuilder\CQBUploads\';		
		SET @customerId = (SELECT [textinput-4] FROM CQBuilder.form.Tb_FormData_5 WHERE [textinput-3] = 'MsecCustomerID')

		INSERT INTO CQBTempDB.[import].[Tb_FormData_1410]
			  ([RecordID]
			  ,[Action]
			  ,[AccountTypesProductInfo (grid-1)]
			  ,[ModeofClientAcquisition (selectbasic-25)]
			  ,[ClientType (selectbasic-26)]
			  ,[Authorizationdetails (grid-7)]
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
			  ,[Dateofincorporated (dateinput-19)]
			  ,[BusinessNature (selectsource-39)]
			  ,[ShareHolder (grid-4)]
			  ,[Director (grid-8)]
			  ,[AuthorisedCapital (textinput-12)]
			  ,[PaidUpCapital (textinput-13)]
			  ,[CompanyNetAsset (textinput-164)]
			  ,[AuthorizedPersonnel (grid-5)]
			  ,[LEAPStartDate (dateinput-11)]
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
			  ,[SpouseIDExpiryDate (dateinput-9)]
			  ,[SpouseEmploymentStatus (selectsource-21)]
			  ,[SpouseIndustriesSpecialization (selectsource-23)]
			  ,[SpouseOccupationDesignation (selectsource-41)]
			  ,[SpouseNameofCompany (textinput-22)]
			  ,[SpousePhoneNo (textinput-24)]
			  ,[SpouseGrossAnnualIncome (multipleradios-1)]
			  ,[UserID (textinput-165)]
			  ,[OnlineSystemIndicator (multiplecheckboxesinline-2)]
			  -- Registered Address as per NRIC
			  ,[Address1 (textinput-35)]
			  ,[Address2 (textinput-36)]
			  ,[Address3 (textinput-37)]
			  ,[Town (textinput-38)]
			  ,[State (textinput-39)]
			  ,[State (selectsource-25)]
			  ,[Country (selectsource-24)]
			  ,[Postcode (textinput-40)]
			  -- CORRESPONDENCE ADDRESS
			  ,[SameasRegisteredAddress (multiplecheckboxesinline-1)]
			  ,[Address1 (textinput-41)]
			  ,[Address2 (textinput-42)]
			  ,[Address3 (textinput-43)]
			  ,[Town (textinput-44)]
			  ,[State (textinput-45)]
			  ,[State (selectsource-26)]
			  ,[Country (selectsource-27)]
			  ,[Postcode (textinput-46)]
			  ,[CDSeStatement (multipleradiosinline-30)]
			  ,[PhoneHouse (textinput-55)]
			  ,[PhoneMobile (textinput-57)]
			  ,[CompanyTelNo (textinput-166)]
			  ,[ContactPersonName (textinput-167)]
			  ,[MobileNumber (textinput-168)]
			  ,[Email (textinput-58)]
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
			  ,[RelatedDetails (grid-2)]
			  ,[PoliticalExposedPerson (selectbasic-24)]
			  ,[PEPClassification (multipleradiosinline-38)]
			  ,[FEAResidentofMalaysia (selectbasic-23)]
			  ,[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]
			  ,[PDPA (multipleradiosinline-23)]
			  ,[TaxResidentoutsideMalaysia (selectbasic-40)]
			  ,[IDSSStartDate (dateinput-10)]
			  ,[TaxIdentificationNumber (textinput-149)]
			  ,[TaxCountry (selectsource-30)]
			  ,[FirstName (textinput-150)]
			  ,[MiddleName (textinput-151)]
			  ,[LastName (textinput-152)]
			  ,[AddressCity (textinput-153)]
			  ,[AddressCountry (selectsource-31)]
			  ,[IDSSSignedTC (uploadinput-3)]
			  ,[BirthCity (textinput-154)]
			  ,[BirthCountry (selectsource-32)]
			  ,[LEAP (multipleradiosinline-36)]
			  ,[IdentificationNumber (textinput-157)]
			  ,[ShareholderType (textinput-158)]
			  ,[Name (textinput-159)]
			  ,[AddressCity (textinput-160)]
			  ,[AddressCountry (selectsource-33)]
			  ,[IDSS (multipleradiosinline-17)]
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
			  ,[BursaAnywhere (multipleradiosinline-34)]
			  ,[NRICPassportEnclosed (selectbasic-31)]
			  ,[NRIC (uploadinput-1)]
			  ,[BankParticularsasperBankStatement (selectbasic-34)]
			  ,[BankStatement (uploadinput-2)]
			  ,[SignatureVerified (selectbasic-37)]
			  ,[CDSandTrading (uploadinput-9)]
			  ,[RiskProfilingMode (multipleradiosinline-37)]
			  ,[RiskProfilingScore (textinput-155)]
			  ,[RiskProfiling (selectbasic-42)]
			  ,[RiskProfiling (textinput-156)]
			  ,[PromotionIndicator (selectsource-37)]
			  ,[CDSPayment (selectsource-34)]
			  ,[OthersCDSPayment (textinput-161)]
			  ,[Remarks (textinput-169)]
			  ,[DateDeclaredBankruptcyorWindingup (dateinput-21)]
			  ,[DateDischargedBankruptcyorWindingup (dateinput-22)]
			  ,[LegalStatus (selectsource-38)]
			  ,[BankruptcyorWindingupStatus (multipleradiosinline-35)]
			  ,[SummonorDefaultinPaymentStatus (selectbasic-41)]
			  ,[Remark1 (textinput-170)]
			  ,[Remark2 (textinput-171)]
		)	

		-- DECLARE @UploadInputPath VARCHAR(100) =  'D:\CQBuilder\CQBUploads\'
		SELECT TGC.UniqueID
			  ,COALESCE(TGC.Action, 'I') AS [Action]
			  ,'' AS [AccountTypesProductInfo (grid-1)]
			  ,COALESCE(TGC.ModeofClientAcquisition
							,CASE COALESCE(TGC.ClientType, 'I')
								WHEN 'C' THEN 'FTF'
								ELSE '' END
					) AS [ModeofClientAcquisition (selectbasic-25)]
			  ,COALESCE(TGC.ClientType, 'I') AS [ClientType (selectbasic-26)]
			  ,'' AS [Authorizationdetails (grid-7)]
			  ,TGC.CustomerID AS [CustomerID (textinput-1)]
			  ,TGC.OldCustomerID AS [OldCustomerID (textinput-131)]
			  ,TGC.Title AS [Title (textinput-2)]
			  ,TGC.CustomerName AS [CustomerName (textinput-3)]
			  ,COALESCE(TGC.Nationality,'MY') AS [Nationality (selectsource-4)]
			  ,COALESCE(TGC.PermanentResidenceofMalaysia
							,CASE COALESCE(TGC.Nationality,'MY')
								WHEN 'MY'	THEN 'N'
								ELSE 'Y'	END
					) AS [PermanentResidenceofMalaysia (multipleradiosinline-2)]
			  ,COALESCE(TGC.IDType
							, CASE COALESCE(TGC.ClientType, 'I')	
								WHEN 'I'	THEN IIF('Y' = COALESCE(TGC.PermanentResidenceofMalaysia	-- if permanent Resident is  Y
																	,CASE COALESCE(TGC.Nationality,'MY')
																		WHEN 'MY'	THEN 'N'
																		ELSE 'Y'	END )
															,'NC', 'PN')	
								WHEN 'C'	THEN 'BR'	END
					) AS [IDType (selectsource-1)]
			  ,TGC.IDNumber AS [IDNumber (textinput-5)]
			  ,TGC.IDExpiryDate AS [IDExpiryDate (dateinput-6)]
			  ,TGC.AlternateIDType AS [AlternateIDType (selectsource-2)]
			  ,TGC.AlternateIDNumber AS [AlternateIDNumber (textinput-6)]
			  ,TGC.AlternateIDExpiryDate AS [AlternateIDExpiryDate (dateinput-7)]
			  ,COALESCE(TGC.Gender, 'M')  AS [Gender (selectbasic-1)]
			  ,COALESCE(TGC.MaritalStatus, 'S') AS [MaritalStatus (selectsource-11)]
			  ,COALESCE(TGC.DateofBirth, '') AS [DateofBirth (dateinput-1)]	
			  ,COALESCE(TGC.Race, '') AS [Race (selectsource-3)] --TODO: FINALIZE
			  ,TGC.Ownership AS [Ownership (selectsource-35)]
			  ,COALESCE(TGC.CountryofResidence, 'MY') AS [CountryofResidence (selectsource-5)]
			  ,COALESCE(TGC.BumiputraStatus ,CASE WHEN TGC.BumiputraStatus IN ('M','B','N','K','D') THEN 'Y' END	--“Malay, Bidayuh, Iban, Kadazan, Murut” 
											,'N'
				) AS [BumiputraStatus (multipleradiosinline-1)]  
			  ,TGC.PlaceofIncorporation AS [PlaceofIncorporation (selectsource-42)]
			  ,TGC.Dateofincorporated AS [Dateofincorporated (dateinput-19)]
			  ,TGC.BusinessNature AS [BusinessNature (selectsource-39)]
			  ,'' AS [ShareHolder (grid-4)]
			  ,'' AS [Director (grid-8)]
			  ,TGC.AuthorisedCapital AS [AuthorisedCapital (textinput-12)]
			  ,TGC.PaidUpCapital AS [PaidUpCapital (textinput-13)]
			  ,TGC.CompanyNetAsset AS [CompanyNetAsset (textinput-164)]
			  ,'' AS [AuthorizedPersonnel (grid-5)]
			  ,TGC.LEAPStartDate AS [LEAPStartDate (dateinput-11)]
			  ,COALESCE(TGC.ThirdParty3rdAuthorisation, 'N') AS [ThirdParty3rdAuthorisation (multipleradiosinline-33)]
			  ,TGC.ThirdPartyStartdate AS [Startdate (dateinput-16)]
			  ,TGC.ThirdPartyEnddate AS [Enddate (dateinput-17)]
			  ,COALESCE(TGC.EmploymentStatus
							,CASE TGC.EmploymentStatus
									WHEN 'Others'	THEN 'Self-employed'
						 	 END
				) AS [EmploymentStatus (selectsource-13)]
			  ,COALESCE(TGC.IndustriesSpecialization
							,CASE TGC.EmploymentStatus
								WHEN 'Student'		THEN 'Education/Training'
								WHEN 'Housewife'	THEN 'Others'
								WHEN 'Retired'		THEN 'Others'
							 END
				) AS [IndustriesSpecialization (selectsource-6)]
			  ,TGC.OccupationDesignation AS [OccupationDesignation (selectsource-40)]
			  ,TGC.NameofCompany AS [NameofCompany (textinput-15)]
			  ,TGC.PhoneOffice AS [PhoneOffice (textinput-17)]
			  ,TGC.GrossAnnualIncome AS [GrossAnnualIncome (multipleradios-3)]
			  ,TGC.EstimatedNetWorth AS [EstimatedNetWorth (multipleradios-4)]
			  ,TGC.SpouseName AS [SpouseName (textinput-18)]
			  ,COALESCE(TGC.SpouseNationality,'MY') AS [SpouseNationality (selectsource-20)]
			  ,COALESCE(TGC.SpousePermanentResidenceofMalaysia
							,CASE COALESCE(TGC.Nationality,'MY')
								WHEN 'MY'	THEN 'N'
								ELSE 'Y'	END
					) AS [PermanentResidenceofMalaysia (multipleradiosinline-29)]
			  ,COALESCE(TGC.SpouseIDType
							,IIF('Y' = COALESCE(TGC.SpousePermanentResidenceofMalaysia	-- if permanent Resident is  Y
													,CASE COALESCE(TGC.SpouseNationality,'MY')
														WHEN 'MY'	THEN 'N'
														ELSE 'Y'	END )
										,'NC', 'PN')
					) AS [SpouseIDType (selectsource-8)]
			  ,TGC.SpouseIDNumber AS [SpouseIDNumber (textinput-20)]
			  ,TGC.SpouseIDExpiryDate AS [SpouseIDExpiryDate (dateinput-9)]
			  ,TGC.SpouseEmploymentStatus AS [SpouseEmploymentStatus (selectsource-21)]
			  ,COALESCE(TGC.SpouseIndustriesSpecialization
							,CASE TGC.SpouseEmploymentStatus
								WHEN 'Student'		THEN 'Education/Training'
								WHEN 'Housewife'	THEN 'Others'
								WHEN 'Retired'		THEN 'Others'
							 END
				) AS [SpouseIndustriesSpecialization (selectsource-23)]
			  ,TGC.SpouseOccupationDesignation AS [SpouseOccupationDesignation (selectsource-41)]
			  ,TGC.SpouseNameofCompany AS [SpouseNameofCompany (textinput-22)]
			  ,TGC.SpousePhoneNo AS [SpousePhoneNo (textinput-24)]
			  ,TGC.SpouseGrossAnnualIncome AS [SpouseGrossAnnualIncome (multipleradios-1)]
			  ,TGC.UserID AS [UserID (textinput-165)]
			  ,COALESCE(TGC.OnlineSystemIndicator,'M+') AS [OnlineSystemIndicator (multiplecheckboxesinline-2)]
			  -- Registered Address as per NRIC
			  ,TGC.RAAddress1 AS [Address1 (textinput-35)]
			  ,TGC.RAAddress2 AS [Address2 (textinput-36)]
			  ,TGC.RAAddress3 AS [Address3 (textinput-37)]
			  ,TGC.RATown AS [Town (textinput-38)]
			  ,TGC.RAStateNotMalaysia  AS [State (textinput-39)]
			  ,TGC.RAStateOfMalaysia AS [State (selectsource-25)]
			  ,COALESCE(TGC.RACountry, 'MY') AS [Country (selectsource-24)]
			  ,TGC.RAPostcode AS [Postcode (textinput-40)]
			  -- CORRESPONDENCE ADDRESS
			  ,IIF(TGC.SameasRegisteredAddress = '0','',TGC.SameasRegisteredAddress) AS [SameasRegisteredAddress (multiplecheckboxesinline-1)]
			  ,COALESCE(TGC.CAAddress1, IIF(TGC.SameasRegisteredAddress = '1', TGC.RAAddress1, '')) AS [Address1 (textinput-41)]
			  ,COALESCE(TGC.CAAddress2, IIF(TGC.SameasRegisteredAddress = '1', TGC.RAAddress2, '')) AS [Address2 (textinput-42)]
			  ,COALESCE(TGC.CAAddress3, IIF(TGC.SameasRegisteredAddress = '1', TGC.RAAddress3, '')) AS [Address3 (textinput-43)]
			  ,COALESCE(TGC.CATown, IIF(TGC.SameasRegisteredAddress = '1', TGC.RATown, '')) AS [Town (textinput-44)]
			  ,COALESCE(TGC.CAStateNotMalaysia, IIF(TGC.SameasRegisteredAddress = '1', TGC.RAStateNotMalaysia, '')) AS [State (textinput-45)]
			  ,COALESCE(TGC.CAStateOfMalaysia, IIF(TGC.SameasRegisteredAddress = '1', TGC.RAStateOfMalaysia, ''))  AS [State (selectsource-26)]
			  ,COALESCE(TGC.CACountry, IIF(TGC.SameasRegisteredAddress = '1', TGC.RACountry, 'MY')) AS [Country (selectsource-27)]
			  ,COALESCE(TGC.CAPostcode, IIF(TGC.SameasRegisteredAddress = '1', TGC.RAPostcode, '')) AS [Postcode (textinput-46)]
			  ,COALESCE(TGC.CDSeStatement, 'Y') AS [CDSeStatement (multipleradiosinline-30)]
			  ,TGC.PhoneHouse AS [PhoneHouse (textinput-55)]
			  ,TGC.PhoneMobile AS [PhoneMobile (textinput-57)]
			  ,TGC.CompanyTelNo AS [CompanyTelNo (textinput-166)]
			  ,TGC.ContactPersonName AS [ContactPersonName (textinput-167)]
			  ,TGC.MobileNumber AS [MobileNumber (textinput-168)]
			  ,TGC.Email AS [Email (textinput-58)]
			 ,COALESCE(TGC.ContractDelivery, 'Portal') AS [ContractDelivery (selectsource-28)]
			 ,COALESCE(TGC.DailyTransactionDelivery, 'Portal') AS [DailyTransactionDelivery (selectsource-36)]
			 ,COALESCE(TGC.MonthlyStmDelivery, 'Portal') AS [MonthlyStmDelivery (selectsource-29)]		
			  ,TGC.[1HowOftenDoYouKeepTrackonMarket] AS [1HowOftenDoYouKeepTrackonMarket (selectbasic-4)]
			  ,TGC.[2Timeframetoholdastock] AS [2Timeframetoholdastock (selectbasic-5)]
			  ,TGC.[3TypeofSecuritiesProductInterestedtickoneormore] AS [3TypeofSecuritiesProductInterestedtickoneormore (multiplecheckboxes-2)]
			  ,TGC.TypeofSecuritiesOthers AS [textinput125 (textinput-125)]
			  ,TGC.[4TradingStrategyApproachUsingInterestedtickoneormore] AS [4TradingStrategyApproachUsingInterestedtickoneormore (multiplecheckboxes-3)]
			  ,TGC.TradingStrategyOthers AS [textinput126 (textinput-126)]
			  ,TGC.[5Doyouinvestinotherinvestmentproductstickoneormore] AS [5Doyouinvestinotherinvestmentproductstickoneormore (multiplecheckboxes-4)]
			  ,TGC.OthersInvestmentProduct AS [textinput127 (textinput-127)]
			  ,TGC.[6Whatisyourmainsourceoffundsforinvestment] AS [6Whatisyourmainsourceoffundsforinvestment (multiplecheckboxes-5)]
			  ,TGC.MainSourceOthers AS [textinput128 (textinput-128)]
			  ,TGC.[7HowlonghaveyoubeentradingintheMalaysiamarket] AS [7HowlonghaveyoubeentradingintheMalaysiamarket (selectbasic-10)]
			  ,TGC.[8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify] AS [8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify (selectbasic-11)]
			  ,TGC.OthersTradingAccountBroker AS [textinput129 (textinput-129)]
			  ,TGC.[9Doyouholdorhavepreviouslyheldanysharemargintradingaccount] AS [9Doyouholdorhavepreviouslyheldanysharemargintradingaccount (selectbasic-12)]
			  ,TGC.[10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof] AS [10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof (textarea-4)]
			  ,TGC.[11WhatisyourexpectedReturnoninvestmentfortheshortterm] AS [11WhatisyourexpectedReturnoninvestmentfortheshortterm (selectbasic-13)]
			  ,TGC.[12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses] AS [12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses (selectbasic-14)]
			  ,TGC.Courses AS [textinput130 (textinput-130)]
			  ,TGC.TradingMode AS [TradingMode (selectbasic-27)]
			  ,'' AS [FinancialDetails (grid-6)]
			  ,'' AS [RelatedDetails (grid-2)]
			  ,COALESCE(TGC.PoliticalExposedPerson, 'N') AS [PoliticalExposedPerson (selectbasic-24)]
			  ,TGC.PEPClassification AS [PEPClassification (multipleradiosinline-38)]
			  ,TGC.FEAResidentofMalaysia AS [FEAResidentofMalaysia (selectbasic-23)]
			  ,TGC.FEAhaveDomesticRinggitBorrowing AS [FEAhaveDomesticRinggitBorrowing (selectbasic-30)]
			  ,COALESCE(TGC.PDPA, 'Y') AS [PDPA (multipleradiosinline-23)]
			  ,COALESCE(TGC.TaxResidentoutsideMalaysia, 'NO') AS [TaxResidentoutsideMalaysia (selectbasic-40)]
			  ,TGC.IDSSStartDate AS [IDSSStartDate (dateinput-10)]
			  -- CRS FOR INDV
			  ,TGC.TaxIdentificationNumber AS [TaxIdentificationNumber (textinput-149)]
			  ,TGC.TaxCountry AS [TaxCountry (selectsource-30)]
			  ,TGC.FirstName AS [FirstName (textinput-150)]
			  ,TGC.MiddleName AS [MiddleName (textinput-151)]
			  ,TGC.LastName AS [LastName (textinput-152)]
			  ,TGC.CRSIndAddressCity AS [AddressCity (textinput-153)]
			  ,TGC.CRSIndAddressCountry AS [AddressCountry (selectsource-31)]
			  ,IIF(ISNULL(TGC.IDSSSignedTC ,'') <> '', CONCAT(@UploadInputPath,TGC.IDSSSignedTC ),'')
				AS [IDSSSignedTC (uploadinput-3)]
			  ,TGC.BirthCity AS [BirthCity (textinput-154)]
			  ,TGC.BirthCountry AS [BirthCountry (selectsource-32)]
			  ,COALESCE(TGC.LEAP,'N') AS [LEAP (multipleradiosinline-36)]
			  -- CRS FOR ORG
			  ,TGC.IdentificationNumber AS [IdentificationNumber (textinput-157)]
			  ,TGC.ShareholderType AS [ShareholderType (textinput-158)]
			  ,TGC.Name AS [Name (textinput-159)]
			  ,TGC.CRSCorpAddressCity AS [AddressCity (textinput-160)]
			  ,TGC.CRSCorpAddressCountry AS [AddressCountry (selectsource-33)]
			  ,COALESCE(TGC.IDSS,'N') AS [IDSS (multipleradiosinline-17)]
			  ,IIF(ISNULL(TGC.LEAPSignedTC ,'') <> '', CONCAT(@UploadInputPath,TGC.LEAPSignedTC ),'')
				AS [LEAPSignedTC (uploadinput-4)]
			  ,COALESCE(TGC.ETFLI,'N') AS [ETFLI (multipleradiosinline-20)]
			  ,TGC.ETFLIStartDate AS [ETFLIStartDate (dateinput-13)]
			  ,IIF(ISNULL(TGC.ETFLISignedTC ,'') <> '', CONCAT(@UploadInputPath,TGC.ETFLISignedTC ),'')
				AS [ETFLISignedTC (uploadinput-5)]
			  ,COALESCE(TGC.W8BEN,'N') AS [W8BEN (multipleradiosinline-21)]
			  ,TGC.W8BENStartDate AS [W8BENStartDate (dateinput-14)]
			  ,TGC.W8BENExpiryDate AS [W8BENExpiryDate (dateinput-18)]
			  ,IIF(ISNULL(TGC.W8BENSignedTC ,'') <> '', CONCAT(@UploadInputPath,TGC.W8BENSignedTC ),'')
				AS [W8BENSignedTC (uploadinput-6)]
			  ,COALESCE(TGC.LetterofUndertakingforTWSE,'N') AS [LetterofUndertakingforTWSE (multipleradiosinline-22)]
			  ,TGC.TWSEStartDate AS [TWSEStartDate (dateinput-20)]
			  ,IIF(ISNULL(TGC.TWSESignedTC ,'') <> '', CONCAT(@UploadInputPath,TGC.TWSESignedTC ),'')
				AS [TWSESignedTC (uploadinput-10)]
			  ,COALESCE(TGC.Algo,'N') AS [Algo (multipleradiosinline-31)]
			  ,TGC.AlgoStartDate AS [AlgoStartDate (dateinput-15)]
			  ,IIF(ISNULL(TGC.AlgoSignedTC ,'') <> '', CONCAT(@UploadInputPath,TGC.AlgoSignedTC),'')
				AS [AlgoSignedTC (uploadinput-7)]
			  ,COALESCE(TGC.SophisticatedInvestor, 'N') AS [SophisticatedInvestor (multipleradiosinline-32)]
			  ,COALESCE(TGC.BursaAnywhere, 'N') AS [BursaAnywhere (multipleradiosinline-34)]
			  ,TGC.NRICPassportEnclosed AS [NRICPassportEnclosed (selectbasic-31)]
			  ,IIF(ISNULL(TGC.NRIC ,'') <> '', CONCAT(@UploadInputPath,TGC.NRIC ),'') 
				AS [NRIC (uploadinput-1)]
			  ,TGC.BankParticularsasperBankStatement AS [BankParticularsasperBankStatement (selectbasic-34)]
			  ,IIF(ISNULL(TGC.BankStatement ,'') <> '', CONCAT(@UploadInputPath,TGC.BankStatement ),'')
				AS [BankStatement (uploadinput-2)]
			  ,TGC.SignatureVerified AS [SignatureVerified (selectbasic-37)]
			  ,IIF(ISNULL(TGC.CDSandTrading ,'') <> '', CONCAT(@UploadInputPath,TGC.CDSandTrading ),'')
				AS [CDSandTrading (uploadinput-9)]
			  ,COALESCE(TGC.RiskProfilingMode, 'A') AS [RiskProfilingMode (multipleradiosinline-37)]
			  ,'' AS [RiskProfilingScore (textinput-155)]
			  ,'' AS [RiskProfiling (selectbasic-42)]
			  ,'' AS [RiskProfiling (textinput-156)]
			  ,TGC.PromotionIndicator AS [PromotionIndicator (selectsource-37)]
			  ,TGC.CDSPayment AS [CDSPayment (selectsource-34)]
			  ,TGC.OthersCDSPayment AS [OthersCDSPayment (textinput-161)]
			  ,TGC.Remarks AS [Remarks (textinput-169)]
			  ,TGC.DateDeclaredBankruptcyorWindingup AS [DateDeclaredBankruptcyorWindingup (dateinput-21)]
			  ,TGC.DateDischargedBankruptcyorWindingup AS [DateDischargedBankruptcyorWindingup (dateinput-22)]
			  ,TGC.LegalStatus AS [LegalStatus (selectsource-38)]
			  ,TGC.BankruptcyorWindingupStatus AS [BankruptcyorWindingupStatus (multipleradiosinline-35)]
			  ,COALESCE(TGC.SummonorDefaultinPaymentStatus, 'N') AS [SummonorDefaultinPaymentStatus (selectbasic-41)]
			  ,TGC.Remark1 AS [Remark1 (textinput-170)]
			  ,TGC.Remark2 AS [Remark2 (textinput-171)]
			  --into #Tb_Gbo_CustomerInfo
        FROM [import].[Tb_Gbo_CustomerInfo] AS TGC
		WHERE TGC.ImportStatus = 'P'
		-- Updating CustomerId in FORMDATA 

		UPDATE CQBTempDB.[import].[Tb_FormData_1410]
		set	[CustomerID (textinput-1)] = @customerId - 1,
		@customerId = @customerId + 1;


----- Financial details ---  GRID-6

		INSERT INTO CQBTempDB.[import].[Tb_FormData_1410_grid6] (
			[RecordID],
			[Action],
			[RowIndex],
			[ (Radio Button)],
			[Account Holder Name (TextBox)],
			[Account Number (TextBox)],
			[Bank (Dropdown)],
			[Joint Account (Dropdown)],
			[Consolidation (Radio Button)]
		)
		SELECT
			CUSTOMER.IDD AS RecordID,
			TGF.Action_ AS [Action],
			TGF.RowIndex AS [RowIndex],
			TGF.DefaultBankAccount AS [ (Radio Button)],
			TGF.AccountHolderName AS [Account Holder Name (TextBox)],
			TGF.AccountNumber AS [Account Number (TextBox)],
			TGF.Bank AS [Bank (Dropdown)],
			TGF.JointAccount AS [Joint Account (Dropdown)],
			COALESCE(TGC.eDividend,'Y') AS [eDividend (Radio Button)]
		FROM [GlobalBOMY].[import].[Tb_Gbo_FinancialDetails] AS TGF
		LEFT JOIN [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC ON TGC.UniqueID = TGF.CustomerUniqueID
		LEFT JOIN [CQBTempDB].[import].Tb_FormData_1410 CUSTOMER ON TGC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]
		

----- IndividualAuthorization -- GRID7

		INSERT INTO [CQBTempDB].[import].[Tb_FormData_1410_grid7] (
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

----- RELATED DETAILS -- GRIS2

		INSERT INTO [CQBTempDB].[import].[Tb_FormData_1410_grid2] (
			[RecordID],
			[Action],
			[RowIndex],
			[Related Account Name (TextBox)],
			[Relationship (TextBox)],
			[Related Account Number (TextBox)]
		)
		SELECT 
		CUSTOMER.IDD AS [RecordID],
		TGRD.Action_,
		TGRD.RowIndex AS [RowIndex],
		TGRD.RelatedAccountName AS [Related Account Name (TextBox)],
		TGRD.Relationship AS [Relationship (TextBox)],
		TGRD.RelatedAccountNumber AS [Related Account Number (TextBox)]
		FROM [GlobalBOMY].[import].[Tb_Gbo_RelatedDetails] TGRD
		LEFT JOIN [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC ON TGC.UniqueID = TGRD.CustomerUniqueID
		LEFT JOIN [CQBTempDB].[import].Tb_FormData_1410 CUSTOMER ON TGC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]

----- Customer Account Type -- Grid1 -- TODO: to finalize
       INSERT INTO [CQBTempDB].[import].[Tb_FormData_1410_grid1] (
			[RecordID],
			[Action],
			[RowIndex],
			[Account Type (Dropdown)],		
			[Algo (TextBox)],
			[Foreign (CheckBox)],
			[Dealer Code (TextBox)],
			[Nominees (Radio Button)],
			[CDS No (TextBox)],
			[Financier (Dropdown)],
			[Online Trading Access (CheckBox)]
	   )
	   SELECT 
		   CUSTOMER.IDD AS [RecordID],
		   TGCA.[Action],
		   TGCA.RowIndex AS [RowIndex],
		   TGCA.AccountType AS [Account Type (Dropdown)],
		   TGCA.Algo AS [Algo (TextBox)],
		   TGCA.Foreign_ AS [Foreign (CheckBox)],
		   TGCA.DealerCode AS [Dealer Code (TextBox)],	--AC.BrokerCodeDealerEAFIDDealerCode,
		   CASE WHEN AMI.NomineeInd <> '' THEN 'Y' ELSE 'N' END  AS [Nominees (Radio Button)], 
		   AMI.CDSNo AS [CDS No (TextBox)],
		   TGCA.Financier AS [Financier (Dropdown)],
		   TGCA.OnlineTradingAccess [Online Trading Access (CheckBox)]
	   FROM [GlobalBOMY].[import].[Tb_Gbo_Cust_Acc_Type] TGCA
	   LEFT JOIN [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC ON TGC.UniqueID = TGCA.CustomerUniqueID
	   LEFT JOIN [CQBTempDB].[import].Tb_FormData_1410 CUSTOMER ON TGC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]
	   LEFT JOIN [import].Tb_Account as AC ON AC.IDNumber = CUSTOMER.[IDNumber (textinput-5)]            
	   LEFT JOIN [import].Tb_AccountMarketInfo As AMI ON AMI.AccountNo = AC.AccountNumber
	   WHERE TGCA.ImportStatus = 'P'


	   -- ===== UPDATE DIGIT CODE ===== 
		UPDATE C
		SET C.[DigitCode (TextBox)] = COALESCE(WithDigitCode.Matched_DigitCode, WithDigitCode.[Account Type (Dropdown)]) 
		--SELECT COALESCE(WithDigitCode.Matched_DigitCode, WithDigitCode.[Account Type (Dropdown)]) 
		--	,C.RecordID 
		--	,C.RowIndex
		FROM CQBTempDB.import.Tb_FormData_1410_grid1 AS C
		INNER JOIN  (
			SELECT ROW_NUMBER() OVER (PARTITION BY C.IDD, C.RowIndex  
									  -- PRIORITIZE MATCHED DIGIT CODE
									  ORDER BY  CASE WHEN (ISNULL(C.[Algo (TextBox)],'') = A2.[AlgoSystem (selectsource-1)])	-- ALGO
															AND (((ISNULL(C.[Nominees (Radio Button)],'') = 'N' AND A2.[NomineesInd (selectbasic-2)] IN ('N',''))  OR ISNULL(C.[Nominees (Radio Button)],'') = A2.[NomineesInd (selectbasic-2)]))	-- NOMINEES
															AND (ISNULL(C.[Financier (Dropdown)],'') = A2.[ExternalMarginFinancier (selectsource-2)] )	-- FINANCIER
														THEN 1
												ELSE 2 END 
									  ) AS [PriorityNo],
						--iif(ISNULL(C.[Algo (TextBox)],'') = A2.[AlgoSystem (selectsource-1)],1,0) as c1,
						--iif(((ISNULL(C.[Nominees (Radio Button)],'') = 'N' AND A2.[NomineesInd (selectbasic-2)] IN ('N',''))  OR ISNULL(C.[Nominees (Radio Button)],'') = A2.[NomineesInd (selectbasic-2)]),1,0) as c2,
						--iif((ISNULL(C.[Financier (Dropdown)],'') = A2.[ExternalMarginFinancier (selectsource-2)]),1,0) as c3,
				CASE WHEN (ISNULL(C.[Algo (TextBox)],'') = A2.[AlgoSystem (selectsource-1)])	-- ALGO
							AND (((ISNULL(C.[Nominees (Radio Button)],'') = 'N' AND A2.[NomineesInd (selectbasic-2)] IN ('N',''))  OR ISNULL(C.[Nominees (Radio Button)],'') = A2.[NomineesInd (selectbasic-2)]))	-- NOMINEES
							AND (ISNULL(C.[Financier (Dropdown)],'') = A2.[ExternalMarginFinancier (selectsource-2)])	-- FINANCIER
						THEN A2.[2DigitCode (textinput-1)] 
						ELSE A1.[2DigitCode (textinput-1)]
						END 
					AS Matched_DigitCode,
					A2.[2DigitCode (textinput-1)] AS [A2.2DigitCode (textinput-1)],
					A1.[2DigitCode (textinput-1)] AS [A1.2DigitCode (textinput-1)],
					C.*,
				A1.[CharCode (textinput-3)] [Account Group]
			FROM [CQBTempDB].[import].[Tb_FormData_1410_grid1] C
				INNER JOIN CQBTempDB.export.Tb_FormData_1457 A1 
					ON C.[Account Type (Dropdown)] = A1.[2DigitCode (textinput-1)]-- ACCOUNT TYPE
				LEFT JOIN CQBTempDB.export.Tb_FormData_1457 A2
					ON A1.[CharCode (textinput-3)] = A2.[CharCode (textinput-3)] -- CHAR CODE
		) AS WithDigitCode 
			ON  C.RecordID = WithDigitCode.RecordID  AND C.RowIndex = WithDigitCode.RowIndex
		WHERE WithDigitCode.PriorityNo = 1
		--order by C.RecordID,C.RowIndex
	   


	   UPDATE CQBTempDB.import.Tb_FormData_1410_grid6
		SET [ (Radio Button)]='Y' WHERE RowIndex=1;

		-- * fields in [GlobalBOMY].[import].[Tb_Gbo_Cust_Acc_Type] need to sync in Account Form in trigger later :
		--SettlementMode
		--TransferCreditTransToTrust
		--DeductTrustToSettlePurchase
		--DeductTrustToSettleDR
		--MRCode
		--ReferenceSource
		UPDATE TGCA
		SET TGCA.GeneratedCustomerID = Customer.[CustomerID (textinput-1)]
		FROM [GlobalBOMY].[import].[Tb_Gbo_Cust_Acc_Type] TGCA
			INNER JOIN [CQBTempDB].[import].[Tb_FormData_1410] Customer
				ON Customer.RecordID = TGCA.CustomerUniqueID
		WHERE TGCA.ImportStatus = 'P'
					
--		-- UPDATE BURSA ANYWHERE FLAG
		UPDATE Customer
		SET [BursaAnywhere (multipleradiosinline-34)] = 'Y' 
		FROM CQBTEMPDB.import.TB_FORMDATA_1410 Customer 
		INNER JOIN GlobalBOMY.import.Tb_Bursa_BATransactions Trans ON Customer.[IDNumber (textinput-5)] = REPLACE(Trans.ID_NRIC,'-','')

		EXEC CQBuilder.[dbo].[Usp_CalculateProfileRating];

		SELECT TOP 1 @lastCustomerID = [CustomerID (textinput-1)] + 1
		FROM CQBTempDB.[import].[Tb_FormData_1410] 
		order by [CustomerID (textinput-1)] desc
		
		
		IF (@lastCustomerID IS NOT NULL)
		BEGIN
			UPDATE CQBuilder.form.Tb_FormData_5
			SET FormDetails = JSON_MODIFY(JSON_MODIFY(FormDetails, '$[0].textinput4', @lastCustomerID), '$[1].textinput4', @lastCustomerID)
			WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active';
		END
		

		UPDATE [import].[Tb_Gbo_CustomerInfo]
		SET ImportStatus = IIF(ImportStatus = 'P', 'C', ImportStatus )
		
		UPDATE import.Tb_Gbo_Cust_Acc_Type
		SET ImportStatus = IIF(ImportStatus = 'P', 'C',ImportStatus)


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