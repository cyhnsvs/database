/****** Object:  Procedure [import].[Usp_Customer_ValidateImportData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_Customer_ValidateImportData]
AS
/**********************************************************************************             
            
Created By        : Kristine
Created Date      : 2021-09-28
Last Updated Date :             
Description       : this sp is used to validate the imported data from MSEC. 
					the same validations in the form are validated here
            
Table(s) Used     :  GlobalBOMY.[import].[Tb_Gbo_CustomerInfo]
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
  

PARAMETERS
EXEC [import].[Usp_Customer_ValidateImportData]

SELECT ImportStatus, ImportRemarks,*
		FROM [import].[Tb_Gbo_CustomerInfo]
		where importstatus = 'R'
************************************************************************************/
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		

		BEGIN TRANSACTION;		
		/***************************** MANDATORY CHECK: IF ANY OF CONDITIONS ARE NOT MEANT, IMPORTSTATUS IS SET TO REJECTED (R) *****************************/
		
		UPDATE TGC
		SET TGC.ImportRemarks
		   = CONCAT(CASE WHEN UniqueID IS NULL THEN '[ERROR]: "UniqueID" is mandatory; ' END,
					CASE WHEN Action IS NULL THEN '[ERROR]: "Action" is mandatory; ' END,
					CASE WHEN ModeofClientAcquisition IS NULL THEN '[ERROR]: "ModeofClientAcquisition" is mandatory; ' END,
					
					CASE WHEN CustomerName IS NULL THEN '[ERROR]: "CustomerName" is mandatory; ' END,
					CASE WHEN Nationality IS NULL THEN '[ERROR]: "Nationality" is mandatory; ' END,
					CASE WHEN PermanentResidenceofMalaysia IS NULL THEN '[ERROR]: "PermanentResidenceofMalaysia" is mandatory; ' END,
					CASE WHEN IDType IS NULL THEN '[ERROR]: "IDType" is mandatory; ' END,
					CASE WHEN UPPER(IDType) = 'PN' AND IDExpiryDate IS NULL THEN '[ERROR]: "IDExpiryDate" is mandatory; ' END,
					CASE WHEN UPPER(IDType) IN ('OC','NC') AND IDNumber IS NOT NULL AND LEN(LTRIM(RTRIM(IDNumber))) <> 12 THEN '[ERROR]: "IDNumber" must be 12 digits; ' END,
					CASE WHEN IDNumber IS NULL THEN '[ERROR]: "IDNumber" is mandatory; ' 
						 WHEN CIdNoUnique.[IDNumber (textinput-5)] IS NOT NULL THEN '[ERROR]: "IDNumber" already exists in the form; ' END,
					--CASE WHEN UPPER(AlternateIDType) IN ('OC','NC') AND AlternateIDNumber IS NOT NULL AND LEN(LTRIM(RTRIM(AlternateIDNumber))) <> 12 THEN '[ERROR]: "AlternateIDNumber" must be 12 digits; ' END,
					CASE WHEN UPPER(AlternateIDType) = 'PN' THEN CONCAT( CASE WHEN AlternateIDNumber IS NULL THEN '[ERROR]: "AlternateIDNumber" is mandatory;' END
																		,CASE WHEN AlternateIDExpiryDate IS NULL THEN '[ERROR]: "AlternateIDExpiryDate" is mandatory;' END) END,
					CASE WHEN ClientType IS NULL THEN '[ERROR]: "ClientType" is mandatory; ' 
						 ELSE CASE ClientType 
								WHEN 'I'	
									THEN CONCAT(CASE WHEN Gender IS NULL THEN '[ERROR]: "Gender" is mandatory; ' END,
												CASE WHEN MaritalStatus IS NULL THEN '[ERROR]: "MaritalStatus" is mandatory; ' END,
												CASE WHEN MaritalStatus = 'M' 
														THEN CONCAT(CASE WHEN SpouseName IS NULL THEN '[ERROR]: "SpouseName" is mandatory; ' END,
																	CASE WHEN SpouseNationality IS NULL THEN '[ERROR]: "SpouseNationality" is mandatory; ' END,
																	CASE WHEN SpousePermanentResidenceofMalaysia IS NULL THEN '[ERROR]: "SpousePermanentResidenceofMalaysia" is mandatory; ' END,
																	CASE WHEN SpouseIDType IS NULL THEN '[ERROR]: "SpouseIDType" is mandatory; ' END,
																	CASE WHEN SpouseIDType = 'PN' AND SpouseIDExpiryDate IS NULL THEN '[ERROR]: "SpouseIDExpiryDate" is mandatory; ' END,
																	CASE WHEN SpouseIDType IN ('OC','NC') AND SpouseIDNumber IS NOT NULL AND LEN(LTRIM(RTRIM(SpouseIDNumber))) <> 12 THEN '[ERROR]: "SpouseIDNumber" must be 12 digits; ' END,
																	CASE WHEN SpouseIDNumber IS NULL THEN '[ERROR]: "SpouseIDNumber" is mandatory; ' END,
																	CASE WHEN SpouseEmploymentStatus IS NULL THEN '[ERROR]: "SpouseEmploymentStatus" is mandatory; ' END,
																	CASE WHEN LOWER(SpouseEmploymentStatus) IN ('employed','self-employed' )
																			THEN CONCAT(CASE WHEN SpouseIndustriesSpecialization IS NULL THEN '[ERROR]: "SpouseIndustriesSpecialization" is mandatory; ' END,
																						CASE WHEN SpouseOccupationDesignation IS NULL THEN '[ERROR]: "SpouseOccupationDesignation" is mandatory; ' END,
																						CASE WHEN SpouseNameofCompany IS NULL THEN '[ERROR]: "SpouseNameofCompany" is mandatory; ' END,
																						CASE WHEN SpousePhoneNo IS NULL THEN '[ERROR]: "SpousePhoneNo" is mandatory; ' END
																			) END 
														) END,
												CASE WHEN DateofBirth IS NULL THEN '[ERROR]: "DateofBirth" is mandatory; ' 
													 WHEN ((0+ FORMAT(GETDATE(),'yyyyMMdd') - FORMAT(CAST(DateofBirth AS date),'yyyyMMdd') ) /10000 ) < 18 THEN '[ERROR]: "DateofBirth" customer age must be 18 yrs old and above to register; ' 
													 END,
												CASE WHEN Race IS NULL THEN '[ERROR]: "Race" is mandatory; ' END,
												CASE WHEN BumiputraStatus IS NULL THEN '[ERROR]: "BumiputraStatus" is mandatory; ' END,
												CASE WHEN CountryofResidence IS NULL THEN '[ERROR]: "CountryofResidence" is mandatory; ' END,
												CASE WHEN EmploymentStatus IS NULL THEN '[ERROR]: "EmploymentStatus" is mandatory; ' END,
												CASE WHEN LOWER(EmploymentStatus) = 'employed' 
														THEN CONCAT(CASE WHEN IndustriesSpecialization IS NULL THEN '[ERROR]: "IndustriesSpecialization" is mandatory; ' END,
																	CASE WHEN OccupationDesignation IS NULL THEN '[ERROR]: "OccupationDesignation" is mandatory; ' END,
																	CASE WHEN NameofCompany IS NULL THEN '[ERROR]: "NameofCompany" is mandatory; ' END,
																	CASE WHEN PhoneOffice IS NULL THEN '[ERROR]: "PhoneOffice" is mandatory; ' END) END,
												CASE WHEN GrossAnnualIncome IS NULL THEN '[ERROR]: "GrossAnnualIncome" is mandatory; ' END,
												CASE WHEN EstimatedNetWorth IS NULL THEN '[ERROR]: "EstimatedNetWorth" is mandatory; ' END,
												CASE WHEN ThirdParty3rdAuthorisation IS NULL THEN '[ERROR]: "ThirdParty3rdAuthorisation" is mandatory; ' END,
												CASE WHEN PhoneMobile IS NULL THEN '[ERROR]: "PhoneMobile" is mandatory; ' 
													 WHEN CHARINDEX('-',PhoneMobile) = 0 THEN  '[ERROR]: "PhoneMobile" invalid format. Must have "-" ; ' 
													 WHEN LEN(PhoneMobile) < 4 OR ISNUMERIC(LEFT(PhoneMobile,CHARINDEX('-',PhoneMobile)-1) ) = 0 OR ISNUMERIC(SUBSTRING(PhoneMobile,CHARINDEX('-',PhoneMobile)+1, LEN(PhoneMobile))) = 0  THEN '[ERROR]: "PhoneMobile" invalid data; '
												END,
												CASE WHEN TaxResidentOutsideMalaysia IS NULL THEN '[ERROR]: "TaxResidentOutsideMalaysia" is mandatory; ' 
													 ELSE CASE WHEN TaxResidentOutsideMalaysia <> 'NO'
																THEN CONCAT(CASE WHEN TaxIdentificationNumber IS NULL THEN '[ERROR]: "TaxIdentificationNumber" is mandatory; ' END,
																			CASE WHEN TaxCountry IS NULL THEN '[ERROR]: "TaxCountry" is mandatory; ' END,
																			CASE WHEN FirstName IS NULL THEN '[ERROR]: "FirstName" is mandatory; ' END,
																			CASE WHEN LastName IS NULL THEN '[ERROR]: "LastName" is mandatory; ' END,
																			CASE WHEN CRSIndAddressCity IS NULL THEN '[ERROR]: "CRSIndAddressCity" is mandatory; ' END,
																			CASE WHEN CRSIndAddressCountry IS NULL THEN '[ERROR]: "CRSIndAddressCountry" is mandatory; ' END,
																			CASE WHEN BirthCity IS NULL THEN '[ERROR]: "BirthCity" is mandatory; ' END,
																			CASE WHEN BirthCountry IS NULL THEN '[ERROR]: "BirthCountry" is mandatory; ' END
																			)
															END
												 END
												
												)

								WHEN 'C'	
									THEN CONCAT(CASE WHEN Ownership IS NULL THEN '[ERROR]: "Ownership" is mandatory; ' END,
												CASE WHEN PlaceOfIncorporation IS NULL THEN '[ERROR]: "PlaceOfIncorporation" is mandatory; ' END,
												CASE WHEN DateofIncorporated IS NULL THEN '[ERROR]: "DateofIncorporated" is mandatory; ' END,
												CASE WHEN BusinessNature IS NULL THEN '[ERROR]: "BusinessNature" is mandatory; ' END,
												CASE WHEN AuthorisedCapital IS NULL THEN '[ERROR]: "AuthorisedCapital" is mandatory; ' END,
												CASE WHEN PaidUpCapital IS NULL THEN '[ERROR]: "PaidUpCapital" is mandatory; ' END,
												CASE WHEN CompanyNetAsset IS NULL THEN '[ERROR]: "CompanyNetAsset" is mandatory; ' END,
												CASE WHEN ModeofSignatory IS NULL THEN '[ERROR]: "ModeofSignatory" is mandatory; ' END,
												CASE WHEN CompanyTelNo IS NULL THEN '[ERROR]: "CompanyTelNo" is mandatory; ' END,
												CASE WHEN ContactPersonName IS NULL THEN '[ERROR]: "ContactPersonName" is mandatory; ' END,
												CASE WHEN MobileNumber IS NULL THEN '[ERROR]: "MobileNumber" is mandatory; ' 
													 WHEN CHARINDEX('-',MobileNumber) = 0 THEN  '[ERROR]: "MobileNumber" invalid format. Must have "-" ; ' 
													 WHEN LEN(MobileNumber) < 4 OR ISNUMERIC(LEFT(MobileNumber,CHARINDEX('-',MobileNumber)-1) ) = 0 OR ISNUMERIC(SUBSTRING(MobileNumber,CHARINDEX('-',MobileNumber)+1, LEN(MobileNumber))) = 0  THEN '[ERROR]: "MobileNumber" invalid data; '
												END
											)
								END
					END,
					
					CASE WHEN TradingMode = 'Online' THEN CASE WHEN UserID IS NULL THEN '[ERROR]: "UserID" is mandatory; ' 
														  ELSE CONCAT(CASE WHEN LEN(LTRIM(RTRIM(UserID))) NOT BETWEEN 6 AND 12 THEN '[ERROR]: "UserID" must be 6 to 12 characters; ' END
																	 ,CASE WHEN UserID LIKE '%[^a-Z0-9]%' THEN '[ERROR]: "UserID" should not contain special characters' END
																	 ,CASE WHEN C.[UserID (textinput-165)] IS NOT NULL THEN '[ERROR]: "UserID" already exists in the form' END)
														  END
					END, 
					CASE WHEN OnlineSystemIndicator IS NULL THEN '[ERROR]: "OnlineSystemIndicator" is mandatory; ' END,
					CASE WHEN RAAddress1 IS NULL THEN '[ERROR]: "RAAddress1" is mandatory; ' END,
					CASE WHEN RACountry IS NULL THEN '[ERROR]: "RACountry" is mandatory; ' 
						 ELSE CASE WHEN UPPER(RACountry) = 'MY' 
									THEN CONCAT(CASE WHEN RATown IS NULL THEN '[ERROR]: "RATown" is mandatory; ' END,
												CASE WHEN RAStateOfMalaysia IS NULL THEN '[ERROR]: "RAStateOfMalaysia" is mandatory; ' END,
												CASE WHEN RAPostcode IS NULL THEN '[ERROR]: "RAPostcode" is mandatory; ' END
									) END
					END,
					CASE WHEN ISNULL(SameasRegisteredAddress,'0') = '0' AND CAAddress1 IS NULL THEN '[ERROR]: "CAAddress1" is mandatory; ' END,
					CASE WHEN ISNULL(SameasRegisteredAddress,'0') = '0' AND CACountry IS NULL THEN '[ERROR]: "CACountry" is mandatory; ' 
						 ELSE CASE WHEN UPPER(CACountry) = 'MY' 
									THEN CONCAT(CASE WHEN ISNULL(SameasRegisteredAddress,'0') = '0' AND CATown IS NULL THEN '[ERROR]: "CATown" is mandatory; ' END,
												CASE WHEN ISNULL(SameasRegisteredAddress,'0') = '0' AND CAStateOfMalaysia IS NULL THEN '[ERROR]: "CAStateOfMalaysia" is mandatory; ' END,
												CASE WHEN ISNULL(SameasRegisteredAddress,'0') = '0' AND CAPostcode IS NULL THEN '[ERROR]: "CAPostcode" is mandatory; ' END
									) END
					END, 
					CASE WHEN Email IS NULL THEN '[ERROR]: "Email" is mandatory; ' END,
					CASE WHEN [3TypeofSecuritiesProductInterestedtickoneormore] = '4' AND TypeofSecuritiesOthers IS NULL THEN '[ERROR]: "TypeofSecuritiesOthers" is mandatory; ' END,
					CASE WHEN [4TradingStrategyApproachUsingInterestedtickoneormore] = '7' AND TradingStrategyOthers IS NULL THEN '[ERROR]: "TradingStrategyOthers" is mandatory; ' END,
					CASE WHEN [5Doyouinvestinotherinvestmentproductstickoneormore] = '7' AND OthersInvestmentProduct IS NULL THEN '[ERROR]: "OthersInvestmentProduct" is mandatory; ' END,
					CASE WHEN [6Whatisyourmainsourceoffundsforinvestment] = '5' AND MainSourceOthers IS NULL THEN '[ERROR]: "MainSourceOthers" is mandatory; ' END,
					CASE WHEN UPPER([8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify]) = 'Y' AND OthersTradingAccountBroker IS NULL THEN '[ERROR]: "OthersTradingAccountBroker" is mandatory; ' END,
					CASE WHEN TradingMode IS NULL THEN '[ERROR]: "TradingMode" is mandatory; ' END,
					CASE WHEN eDividend IS NULL THEN '[ERROR]: "eDividend" is mandatory; ' END,
					CASE WHEN PoliticalExposedPerson IS NULL THEN '[ERROR]: "PoliticalExposedPerson" is mandatory; ' END,
					CASE WHEN PoliticalExposedPerson = 'Y' AND PEPClassification IS NULL THEN '[ERROR]: "PEPClassification" is mandatory; ' END,
					CASE WHEN PDPA IS NULL THEN '[ERROR]: "PDPA" is mandatory; ' END,
					CASE WHEN BursaAnywhere IS NULL THEN '[ERROR]: "BursaAnywhere" is mandatory; ' END,
					CASE WHEN NRICPassportEnclosed IS NULL THEN '[ERROR]: "NRICPassportEnclosed" is mandatory; ' END,
					CASE WHEN BankParticularsasperBankStatement IS NULL THEN '[ERROR]: "BankParticularsasperBankStatement" is mandatory; ' END,
					CASE WHEN SignatureVerified IS NULL THEN '[ERROR]: "SignatureVerified" is mandatory; ' END,
					CASE WHEN RiskProfilingMode IS NULL THEN '[ERROR]: "RiskProfilingMode" is mandatory; ' END,
					CASE WHEN UPPER(CDSPayment) = 'OT' AND  OthersCDSPayment IS NULL THEN '[ERROR]: "OthersCDSPayment" is mandatory; ' END
				)
		FROM [import].[Tb_Gbo_CustomerInfo] TGC	
			--LEFT JOIN CQBuilder.form.Tb_FormData_1410 C ON NULLIF(TGC.UserID,'') IS NOT NULL AND NULLIF(C.[textinput-165],'') IS NOT NULL AND TGC.UserID = C.[textinput-165]
			LEFT JOIN CQBTempDB.export.Tb_FormData_1410 C ON NULLIF(TGC.UserID,'') IS NOT NULL AND NULLIF(C.[UserID (textinput-165)],'') IS NOT NULL AND TGC.UserID = C.[UserID (textinput-165)]
			--LEFT JOIN CQBuilder.form.Tb_FormData_1410 CIdNoUnique ON NULLIF(TGC.IDNumber,'') IS NOT NULL AND NULLIF(CIdNoUnique.[textinput-5],'') IS NOT NULL 
			--														AND NULLIF(TGC.IDType,'') IS NOT NULL AND NULLIF(CIdNoUnique.[selectsource-1],'') IS NOT NULL 
			--														AND TGC.IDNumber = CIdNoUnique.[textinput-5] AND TGC.IDType = CIdNoUnique.[selectsource-1]
			LEFT JOIN CQBTempDB.export.Tb_FormData_1410 CIdNoUnique ON NULLIF(TGC.IDNumber,'') IS NOT NULL AND NULLIF(CIdNoUnique.[IDNumber (textinput-5)],'') IS NOT NULL 
																	AND NULLIF(TGC.IDType,'') IS NOT NULL AND NULLIF(CIdNoUnique.[IDType (selectsource-1)],'') IS NOT NULL 
																	AND TGC.IDNumber = CIdNoUnique.[IDNumber (textinput-5)] AND TGC.IDType = CIdNoUnique.[IDType (selectsource-1)]
		WHERE TGC.ImportStatus <> 'R'


		UPDATE [import].[Tb_Gbo_CustomerInfo]
		SET ImportStatus = CASE WHEN NULLIF(ImportRemarks,'') IS NOT NULL	THEN 'R'	ELSE 'P'	END
	
		--SELECT ImportStatus, ImportRemarks FROM [import].[Tb_Gbo_CustomerInfo]

		--SELECT *
		--FROM [import].[Tb_Gbo_CustomerInfo]
		--WHERE ImportStatus <> 'R'
		
		

		/************************ OPTIONS CHECK (SELECT BASIC / RADIO SELECTION / CHECKBOX): IF ANY OF CONDITIONS ARE NOT MEANT, IMPORTSTATUS IS SET TO REJECTED (R) *************************/
		
		UPDATE [import].[Tb_Gbo_CustomerInfo]
		SET ImportRemarks = CONCAT(ImportRemarks, 
 			CASE WHEN [Action] IS NOT NULL AND UPPER([Action]) NOT IN ('I','U') THEN '[WARNING]: "Action" value provided is not existing in field options; ' END,
			CASE WHEN ClientType IS NOT NULL AND UPPER(ClientType) NOT IN ('I','C') THEN '[WARNING]: "ClientType" value provided is not existing in field options; ' END,
			CASE WHEN ModeofClientAcquisition IS NOT NULL AND UPPER(ModeofClientAcquisition) NOT IN ('ENFTFV','NFTFV','FTF') THEN '[WARNING]: "ModeofClientAcquisition" value provided is not existing in field options; ' END,
			CASE WHEN PermanentResidenceofMalaysia IS NOT NULL AND UPPER(PermanentResidenceofMalaysia) NOT IN ('Y','N') THEN '[WARNING]: "PermanentResidenceofMalaysia" value provided is not existing in field options; ' END,	
			CASE ClientType 
				 WHEN 'I'	THEN CONCAT(
					CASE WHEN Gender IS NOT NULL AND UPPER(Gender) NOT IN ('M','F','') THEN '[WARNING]: "Gender" value provided is not existing in field options; ' END,
					CASE WHEN MaritalStatus = 'M'	THEN CONCAT(
								CASE WHEN SpousePermanentResidenceofMalaysia IS NOT NULL AND SpousePermanentResidenceofMalaysia NOT IN ('Y','N') THEN '"SpousePermanentResidenceofMalaysia" value provided is not existing in field options; ' END,
								CASE WHEN SpouseGrossAnnualIncome IS NOT NULL AND SpouseGrossAnnualIncome NOT BETWEEN 1 AND 6 THEN '"SpouseGrossAnnualIncome" value provided is not existing in field options; ' END
							)
					 END,
					CASE WHEN BumiputraStatus IS NOT NULL AND UPPER(BumiputraStatus) NOT IN ('Y','N') THEN '[WARNING]: "PermanentResidenceofMalaysia" value provided is not existing in field options; ' END,
					CASE WHEN GrossAnnualIncome IS NOT NULL AND GrossAnnualIncome NOT BETWEEN 1 AND 6 THEN '[WARNING]: "GrossAnnualIncome" value provided is not existing in field options; ' END,
					CASE WHEN EstimatedNetWorth IS NOT NULL AND EstimatedNetWorth NOT BETWEEN 1 AND 6THEN '[WARNING]: "EstimatedNetWorth" value provided is not existing in field options; ' END,
					CASE WHEN ThirdParty3rdAuthorisation IS NOT NULL AND UPPER(ThirdParty3rdAuthorisation) NOT IN ('Y','N') THEN '[WARNING]: "ThirdParty3rdAuthorisation" value provided is not existing in field options; ' END				
					)
				 WHEN 'C'	THEN 
					CASE WHEN ModeofSignatory IS NOT NULL AND ModeofSignatory BETWEEN 0 AND 2 THEN '[WARNING]: "ModeofSignatory" value provided is not existing in field options; ' END
			END,
			CASE WHEN OnlineSystemIndicator IS NOT NULL AND UPPER(OnlineSystemIndicator) NOT IN ('M+','MV','N2')	THEN '[WARNING]: "OnlineSystemIndicator" value provided is not existing in field options; ' END,
			CASE WHEN SameasRegisteredAddress IS NOT NULL AND SameasRegisteredAddress NOT IN ('1','0') THEN '[WARNING]: "SameasRegisteredAddress" value provided is not existing in field options; ' END,
			CASE WHEN CDSeStatement IS NOT NULL AND UPPER(CDSeStatement) NOT IN ('Y','N') THEN '[WARNING]: "CDSeStatement" value provided is not existing in field options; ' END,
			CASE WHEN [1HowOftenDoYouKeepTrackonMarket] IS NOT NULL AND [1HowOftenDoYouKeepTrackonMarket] NOT BETWEEN 1 AND 4 THEN '[WARNING]: "1HowOftenDoYouKeepTrackonMarket" value provided is not existing in field options; ' END,
			CASE WHEN [2Timeframetoholdastock] IS NOT NULL AND [2Timeframetoholdastock] NOT BETWEEN 1 AND 6 THEN '[WARNING]: "2Timeframetoholdastock" value provided is not existing in field options; ' END,
			CASE WHEN [3TypeofSecuritiesProductInterestedtickoneormore] IS NOT NULL AND [3TypeofSecuritiesProductInterestedtickoneormore] NOT BETWEEN 1 AND 4 THEN '[WARNING]: "3TypeofSecuritiesProductInterestedtickoneormore" value provided is not existing in field options; ' END,
			CASE WHEN [4TradingStrategyApproachUsingInterestedtickoneormore] IS NOT NULL AND [4TradingStrategyApproachUsingInterestedtickoneormore] NOT BETWEEN 1 AND 7 THEN '[WARNING]: "4TradingStrategyApproachUsingInterestedtickoneormore" value provided is not existing in field options; ' END,
			CASE WHEN [5Doyouinvestinotherinvestmentproductstickoneormore] IS NOT NULL AND [5Doyouinvestinotherinvestmentproductstickoneormore] NOT  BETWEEN 1 AND 7 THEN '[WARNING]: "5Doyouinvestinotherinvestmentproductstickoneormore" value provided is not existing in field options; ' END,
			CASE WHEN [6Whatisyourmainsourceoffundsforinvestment] IS NOT NULL AND [6Whatisyourmainsourceoffundsforinvestment] NOT BETWEEN 1 AND 5 THEN '[WARNING]: "6Whatisyourmainsourceoffundsforinvestment" value provided is not existing in field options; ' END,
			CASE WHEN [7HowlonghaveyoubeentradingintheMalaysiamarket] IS NOT NULL AND [7HowlonghaveyoubeentradingintheMalaysiamarket] NOT BETWEEN 1 AND 5 THEN '[WARNING]: "7HowlonghaveyoubeentradingintheMalaysiamarket" value provided is not existing in field options; ' END,
			CASE WHEN [8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify] IS NOT NULL AND [8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify] NOT IN ('Y','N') THEN '[WARNING]: "8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify" value provided is not existing in field options; ' END,
			CASE WHEN [9Doyouholdorhavepreviouslyheldanysharemargintradingaccount] IS NOT NULL AND [9Doyouholdorhavepreviouslyheldanysharemargintradingaccount] NOT IN ('Y','N') THEN '[WARNING]: "9Doyouholdorhavepreviouslyheldanysharemargintradingaccount" value provided is not existing in field options; ' END,
			CASE WHEN [11WhatisyourexpectedReturnoninvestmentfortheshortterm] IS NOT NULL AND [11WhatisyourexpectedReturnoninvestmentfortheshortterm] NOT BETWEEN 1 AND 4 THEN '[WARNING]: "11WhatisyourexpectedReturnoninvestmentfortheshortterm" value provided is not existing in field options; ' END,
			CASE WHEN [12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses] IS NOT NULL AND [12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses] NOT IN ('Y','N') THEN '[WARNING]: "12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses" value provided is not existing in field options; ' END,
			CASE WHEN TradingMode IS NOT NULL AND UPPER(TradingMode) NOT IN ('ONLINE','OFFLINE') THEN '[WARNING]: "TradingMode" value provided is not existing in field options; ' END,
			CASE WHEN eDividend IS NOT NULL AND  UPPER(eDividend) NOT IN ('Y','N')  THEN '[WARNING]: "eDividend" value provided is not existing in field options; ' END,
			CASE WHEN PoliticalExposedPerson IS NOT NULL AND  UPPER(PoliticalExposedPerson) NOT IN ('Y','N')    THEN '[WARNING]: "PoliticalExposedPerson" value provided is not existing in field options; ' END,
			CASE WHEN PEPClassification IS NOT NULL AND  UPPER(PEPClassification) NOT IN ('D','F')  THEN '[WARNING]: "PEPClassification" value provided is not existing in field options; ' END,
			CASE WHEN FEAResidentofMalaysia IS NOT NULL AND  UPPER(FEAResidentofMalaysia) NOT BETWEEN 1 AND 3  THEN '[WARNING]: "FEAResidentofMalaysia" value provided is not existing in field options; ' END,
			CASE WHEN FEAhaveDomesticRinggitBorrowing IS NOT NULL AND  UPPER(FEAhaveDomesticRinggitBorrowing) NOT IN ('Y','N')  THEN '[WARNING]: "FEAhaveDomesticRinggitBorrowing" value provided is not existing in field options; ' END,
			CASE WHEN PDPA IS NOT NULL AND  UPPER(PDPA) NOT IN ('Y','N')    THEN '[WARNING]: "PDPA" value provided is not existing in field options; ' END,
			CASE WHEN TaxResidentoutsideMalaysia IS NOT NULL AND  UPPER(TaxResidentoutsideMalaysia) NOT IN ('CRS','FATCA','BOTH','NO')    THEN '[WARNING]: "TaxResidentoutsideMalaysia" value provided is not existing in field options; ' END,
			CASE WHEN IDSS IS NOT NULL AND  UPPER(IDSS) NOT IN ('Y','N')    THEN '[WARNING]: "IDSS" value provided is not existing in field options; ' END,
			CASE WHEN LEAP IS NOT NULL AND  UPPER(LEAP) NOT IN ('Y','N')    THEN '[WARNING]: "LEAP" value provided is not existing in field options; ' END,
			CASE WHEN ETFLI IS NOT NULL AND  UPPER(ETFLI) NOT IN ('Y','N')  THEN '[WARNING]: "ETFLI" value provided is not existing in field options; ' END,
			CASE WHEN W8BEN IS NOT NULL AND  UPPER(W8BEN) NOT IN ('Y','N')  THEN '[WARNING]: "W8BEN" value provided is not existing in field options; ' END,
			CASE WHEN LetterofUndertakingforTWSE IS NOT NULL AND  UPPER(LetterofUndertakingforTWSE) NOT IN ('Y','N')    THEN '[WARNING]: "LetterofUndertakingforTWSE" value provided is not existing in field options; ' END,
			CASE WHEN Algo IS NOT NULL AND  UPPER(Algo) NOT IN ('Y','N')    THEN '[WARNING]: "Algo" value provided is not existing in field options; ' END,
			CASE WHEN SophisticatedInvestor IS NOT NULL AND  UPPER(SophisticatedInvestor) NOT IN ('Y','N')  THEN '[WARNING]: "SophisticatedInvestor" value provided is not existing in field options; ' END,
			CASE WHEN BursaAnywhere IS NOT NULL AND  UPPER(BursaAnywhere) NOT IN ('Y','N')  THEN '[WARNING]: "BursaAnywhere" value provided is not existing in field options; ' END,
			CASE WHEN NRICPassportEnclosed IS NOT NULL AND UPPER(NRICPassportEnclosed) NOT IN ('Y','N')  THEN '[WARNING]: "NRICPassportEnclosed" value provided is not existing in field options; ' END,
			CASE WHEN BankParticularsasperBankStatement IS NOT NULL AND UPPER(BankParticularsasperBankStatement) NOT IN ('Y','N')  THEN '[WARNING]: "BankParticularsasperBankStatement" value provided is not existing in field options; ' END,
			CASE WHEN SignatureVerified IS NOT NULL AND UPPER(SignatureVerified) NOT IN ('Y','N')  THEN '[WARNING]: "SignatureVerified" value provided is not existing in field options; ' END,
			CASE WHEN RiskProfilingMode IS NOT NULL AND UPPER(RiskProfilingMode) NOT IN ('A','M')  THEN '[WARNING]: "RiskProfilingMode" value provided is not existing in field options; ' END,
			CASE WHEN BankruptcyorWindingupStatus IS NOT NULL AND UPPER(BankruptcyorWindingupStatus) NOT IN ('Y','N')  THEN '[WARNING]: "BankruptcyorWindingupStatus" value provided is not existing in field options; ' END,
			CASE WHEN SummonorDefaultinPaymentStatus IS NOT NULL AND UPPER(SummonorDefaultinPaymentStatus) NOT IN ('Y','N')  THEN '[WARNING]: "SummonorDefaultinPaymentStatus" value provided is not existing in field options; ' END
		)
		


		/************************ OPTIONS CHECK (SELECTSOURCE): IF ANY OF CONDITIONS ARE NOT MEANT, IMPORTSTATUS IS SET TO REJECTED (R) *************************/
		UPDATE TGC	
		SET TGC.ImportRemarks = CONCAT(TGC.ImportRemarks,
			CASE WHEN TGC.Nationality IS NOT NULL AND CR_Nationality.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "Nationality" value provided is not existing in Code Reference Form; ' END,
			CASE WHEN TGC.IDType IS NOT NULL AND CR_IDType.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "IDType" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.AlternateIDType IS NOT NULL AND CR_AlternateIDType.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "AlternateIDType" value provided is not existing in Code Reference Form; ' END,
			CASE WHEN TGC.MaritalStatus IS NOT NULL AND CR_MaritalStatus.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "MaritalStatus" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.Race IS NOT NULL AND CR_Race.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "Race" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.Ownership IS NOT NULL AND CR_Ownership.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "Ownership" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.CountryofResidence IS NOT NULL AND CR_CountryofResidence.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "CountryofResidence" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.PlaceofIncorporation IS NOT NULL AND CR_PlaceofIncorporation.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "PlaceofIncorporation" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.BusinessNature IS NOT NULL AND CR_BusinessNature.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "BusinessNature" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.EmploymentStatus IS NOT NULL AND CR_EmploymentStatus.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "EmploymentStatus" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.IndustriesSpecialization IS NOT NULL AND CR_IndustriesSpecialization.[RiskValue (textinput-2)] IS NULL   THEN '[WARNING]: "IndustriesSpecialization" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.OccupationDesignation IS NOT NULL AND CR_OccupationDesignation.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "OccupationDesignation" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.SpouseNationality IS NOT NULL AND CR_SpouseNationality.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "SpouseNationality" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.SpouseIDType IS NOT NULL AND CR_SpouseIDType.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "SpouseIDType" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.SpouseEmploymentStatus IS NOT NULL AND CR_SpouseEmploymentStatus.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "SpouseEmploymentStatus" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.SpouseIndustriesSpecialization IS NOT NULL AND CR_SpouseIndustriesSpecialization.[RiskValue (textinput-2)] IS NULL   THEN '[WARNING]: "SpouseIndustriesSpecialization" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.SpouseOccupationDesignation IS NOT NULL AND CR_SpouseOccupationDesignation.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "SpouseOccupationDesignation" value provided is not existing in Code Reference Form; ' END,
			CASE WHEN TGC.RAStateOfMalaysia IS NOT NULL AND CR_RAStateOfMalaysia.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "RAStateOfMalaysia" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.RACountry IS NOT NULL AND CR_RACountry.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "RACountry" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.CAStateOfMalaysia IS NOT NULL AND CR_CAStateOfMalaysia.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "CAStateOfMalaysia" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.CACountry IS NOT NULL AND CR_CACountry.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "CACountry" value provided is not existing in Code Reference Form; '   END,
			CASE WHEN TGC.ContractDelivery IS NOT NULL AND CR_ContractDelivery.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "ContractDelivery" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.DailyTransactionDelivery IS NOT NULL AND CR_DailyTransactionDelivery.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "DailyTransactionDelivery" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.MonthlyStmDelivery IS NOT NULL AND CR_MonthlyStmDelivery.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "MonthlyStmDelivery" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.TaxCountry IS NOT NULL AND CR_TaxCountry.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "TaxCountry" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.CRSIndAddressCountry IS NOT NULL AND CR_CRSIndAddressCountry.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "AddressCountry" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.BirthCountry IS NOT NULL AND CR_BirthCountry.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "BirthCountry" value provided is not existing in Code Reference Form; '    END,
			CASE WHEN TGC.CRSCorpAddressCountry IS NOT NULL AND CR_CRSCorpAddressCountry.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "AddressCountry" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.PromotionIndicator IS NOT NULL AND CR_PromotionIndicator.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "PromotionIndicator" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.CDSPayment IS NOT NULL AND CR_CDSPayment.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "CDSPayment" value provided is not existing in Code Reference Form; '  END,
			CASE WHEN TGC.LegalStatus IS NOT NULL AND CR_LegalStatus.[Value (textinput-3)] IS NULL   THEN '[WARNING]: "LegalStatus" value provided is not existing in Code Reference Form; ' END
		),
			---- TO CORRECT POSSIBLE CASING MISMATCH; ONLY CHANGE THOSE WITH MATCHING SOURCE
			TGC.Nationality = IIF(TGC.Nationality IS NOT NULL AND UPPER(CR_Nationality.[Value (textinput-3)]) = UPPER(TGC.Nationality), CR_Nationality.[Value (textinput-3)], TGC.Nationality),
			TGC.IDType = IIF(TGC.IDType IS NOT NULL AND UPPER(CR_IDType.[Value (textinput-3)]) = UPPER(TGC.IDType), CR_IDType.[Value (textinput-3)], TGC.IDType),
			TGC.AlternateIDType = IIF(TGC.AlternateIDType IS NOT NULL AND UPPER(CR_AlternateIDType.[Value (textinput-3)]) = UPPER(TGC.AlternateIDType), CR_AlternateIDType.[Value (textinput-3)], TGC.AlternateIDType),
			TGC.MaritalStatus = IIF(TGC.MaritalStatus IS NOT NULL AND UPPER(CR_MaritalStatus.[Value (textinput-3)]) = UPPER(TGC.MaritalStatus), CR_MaritalStatus.[Value (textinput-3)], TGC.MaritalStatus),
			TGC.Race = IIF(TGC.Race IS NOT NULL AND UPPER(CR_Race.[Value (textinput-3)]) = UPPER(TGC.Race), CR_Race.[Value (textinput-3)], TGC.Race),
			TGC.Ownership = IIF(TGC.Ownership IS NOT NULL AND UPPER(CR_Ownership.[Value (textinput-3)]) = UPPER(TGC.Ownership), CR_Ownership.[Value (textinput-3)], TGC.Ownership),
			TGC.CountryofResidence = IIF(TGC.CountryofResidence IS NOT NULL AND UPPER(CR_CountryofResidence.[Value (textinput-3)]) = UPPER(TGC.CountryofResidence), CR_CountryofResidence.[Value (textinput-3)], TGC.CountryofResidence),
			TGC.PlaceofIncorporation = IIF(TGC.PlaceofIncorporation IS NOT NULL AND UPPER(CR_PlaceofIncorporation.[Value (textinput-3)]) = UPPER(TGC.PlaceofIncorporation), CR_PlaceofIncorporation.[Value (textinput-3)], TGC.PlaceofIncorporation),
			TGC.BusinessNature = IIF(TGC.BusinessNature IS NOT NULL AND UPPER(CR_BusinessNature.[Value (textinput-3)]) = UPPER(TGC.BusinessNature), CR_BusinessNature.[Value (textinput-3)], TGC.BusinessNature),
			TGC.EmploymentStatus = IIF(TGC.EmploymentStatus IS NOT NULL AND UPPER(CR_EmploymentStatus.[Value (textinput-3)]) = UPPER(TGC.EmploymentStatus), CR_EmploymentStatus.[Value (textinput-3)], TGC.EmploymentStatus),
			TGC.IndustriesSpecialization = IIF(TGC.IndustriesSpecialization IS NOT NULL AND UPPER(CR_IndustriesSpecialization.[RiskValue (textinput-2)]) = UPPER(TGC.IndustriesSpecialization), CR_IndustriesSpecialization.[RiskValue (textinput-2)], TGC.IndustriesSpecialization),
			TGC.OccupationDesignation = IIF(TGC.OccupationDesignation IS NOT NULL AND UPPER(CR_OccupationDesignation.[Value (textinput-3)]) = UPPER(TGC.OccupationDesignation), CR_OccupationDesignation.[Value (textinput-3)], TGC.OccupationDesignation),
			TGC.SpouseNationality = IIF(TGC.SpouseNationality IS NOT NULL AND UPPER(CR_SpouseNationality.[Value (textinput-3)]) = UPPER(TGC.SpouseNationality), CR_SpouseNationality.[Value (textinput-3)], TGC.SpouseNationality),
			TGC.SpouseIDType = IIF(TGC.SpouseIDType IS NOT NULL AND UPPER(CR_SpouseIDType.[Value (textinput-3)]) = UPPER(TGC.SpouseIDType), CR_SpouseIDType.[Value (textinput-3)], TGC.SpouseIDType),
			TGC.SpouseEmploymentStatus = IIF(TGC.SpouseEmploymentStatus IS NOT NULL AND UPPER(CR_SpouseEmploymentStatus.[Value (textinput-3)]) = UPPER(TGC.SpouseEmploymentStatus), CR_SpouseEmploymentStatus.[Value (textinput-3)], TGC.SpouseEmploymentStatus),
			TGC.SpouseIndustriesSpecialization = IIF(TGC.SpouseIndustriesSpecialization IS NOT NULL AND UPPER(CR_SpouseIndustriesSpecialization.[RiskValue (textinput-2)]) = UPPER(TGC.SpouseIndustriesSpecialization), CR_SpouseIndustriesSpecialization.[RiskValue (textinput-2)] , TGC.SpouseIndustriesSpecialization),
			TGC.SpouseOccupationDesignation = IIF(TGC.SpouseOccupationDesignation IS NOT NULL AND UPPER(CR_SpouseOccupationDesignation.[Value (textinput-3)]) = UPPER(TGC.SpouseOccupationDesignation), CR_SpouseOccupationDesignation.[Value (textinput-3)], TGC.SpouseOccupationDesignation),
			TGC.RAStateOfMalaysia = IIF(TGC.RAStateOfMalaysia IS NOT NULL AND UPPER(CR_RAStateOfMalaysia.[Value (textinput-3)]) = UPPER(TGC.RAStateOfMalaysia), CR_RAStateOfMalaysia.[Value (textinput-3)], TGC.RAStateOfMalaysia),
			TGC.RACountry = IIF(TGC.RACountry IS NOT NULL AND UPPER(CR_RACountry.[Value (textinput-3)]) = UPPER(TGC.RACountry), CR_RACountry.[Value (textinput-3)], TGC.RACountry),
			TGC.CAStateOfMalaysia = IIF(TGC.CAStateOfMalaysia IS NOT NULL AND UPPER(CR_CAStateOfMalaysia.[Value (textinput-3)]) = UPPER(TGC.CAStateOfMalaysia), CR_CAStateOfMalaysia.[Value (textinput-3)], TGC.CAStateOfMalaysia),
			TGC.CACountry = IIF(TGC.CACountry IS NOT NULL AND UPPER(CR_CACountry.[Value (textinput-3)]) = UPPER(TGC.CACountry), CR_CACountry.[Value (textinput-3)], TGC.CACountry),
			TGC.ContractDelivery = IIF(TGC.ContractDelivery IS NOT NULL AND UPPER(CR_ContractDelivery.[Value (textinput-3)]) = UPPER(TGC.ContractDelivery), CR_ContractDelivery.[Value (textinput-3)], TGC.ContractDelivery),
			TGC.DailyTransactionDelivery = IIF(TGC.DailyTransactionDelivery IS NOT NULL AND UPPER(CR_DailyTransactionDelivery.[Value (textinput-3)]) = UPPER(TGC.DailyTransactionDelivery), CR_DailyTransactionDelivery.[Value (textinput-3)], TGC.DailyTransactionDelivery),
			TGC.MonthlyStmDelivery = IIF(TGC.MonthlyStmDelivery IS NOT NULL AND UPPER(CR_MonthlyStmDelivery.[Value (textinput-3)]) = UPPER(TGC.MonthlyStmDelivery), CR_MonthlyStmDelivery.[Value (textinput-3)], TGC.MonthlyStmDelivery),
			TGC.TaxCountry = IIF(TGC.TaxCountry IS NOT NULL AND UPPER(CR_TaxCountry.[Value (textinput-3)]) = UPPER(TGC.TaxCountry), CR_TaxCountry.[Value (textinput-3)], TGC.TaxCountry),
			TGC.CRSIndAddressCountry = IIF(TGC.CRSIndAddressCountry IS NOT NULL AND UPPER(CR_CRSIndAddressCountry.[Value (textinput-3)]) = UPPER(TGC.CRSIndAddressCountry), CR_CRSIndAddressCountry.[Value (textinput-3)], TGC.CRSIndAddressCountry),
			TGC.BirthCountry = IIF(TGC.BirthCountry IS NOT NULL AND UPPER(CR_BirthCountry.[Value (textinput-3)]) = UPPER(TGC.BirthCountry), CR_BirthCountry.[Value (textinput-3)], TGC.BirthCountry),
			TGC.CRSCorpAddressCountry = IIF(TGC.CRSCorpAddressCountry IS NOT NULL AND UPPER(CR_CRSCorpAddressCountry.[Value (textinput-3)]) = UPPER(TGC.CRSCorpAddressCountry), CR_CRSCorpAddressCountry.[Value (textinput-3)], TGC.CRSCorpAddressCountry),
			TGC.PromotionIndicator = IIF(TGC.PromotionIndicator IS NOT NULL AND UPPER(CR_PromotionIndicator.[Value (textinput-3)]) = UPPER(TGC.PromotionIndicator), CR_PromotionIndicator.[Value (textinput-3)], TGC.PromotionIndicator),
			TGC.CDSPayment = IIF(TGC.CDSPayment IS NOT NULL AND UPPER(CR_CDSPayment.[Value (textinput-3)]) = UPPER(TGC.CDSPayment), CR_CDSPayment.[Value (textinput-3)], TGC.CDSPayment),
			TGC.LegalStatus = IIF(TGC.LegalStatus IS NOT NULL AND UPPER(CR_LegalStatus.[Value (textinput-3)]) = UPPER(TGC.LegalStatus), CR_LegalStatus.[Value (textinput-3)], TGC.LegalStatus)

        FROM [import].[Tb_Gbo_CustomerInfo] AS TGC
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_Nationality  ON  CR_Nationality.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_Nationality.[Value (textinput-3)]) = UPPER(TGC.Nationality)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_IDType   ON  CR_IDType.[CodeType (selectbasic-1)] = 'IDNumberType' AND  UPPER(CR_IDType.[Value (textinput-3)]) = UPPER(TGC.IDType)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_AlternateIDType  ON  CR_AlternateIDType.[CodeType (selectbasic-1)] = 'IDNumberType' AND  UPPER(CR_AlternateIDType.[Value (textinput-3)]) = UPPER(TGC.AlternateIDType)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_MaritalStatus    ON  CR_MaritalStatus.[CodeType (selectbasic-1)] = 'MaritalStatus' AND  UPPER(CR_MaritalStatus.[Value (textinput-3)]) = UPPER(TGC.MaritalStatus)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_Race ON  CR_Race.[CodeType (selectbasic-1)] = 'Race' AND  UPPER(CR_Race.[Value (textinput-3)]) = UPPER(TGC.Race)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_Ownership    ON  CR_Ownership.[CodeType (selectbasic-1)] = 'Ownership' AND  UPPER(CR_Ownership.[Value (textinput-3)]) = UPPER(TGC.Ownership)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_CountryofResidence   ON  CR_CountryofResidence.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_CountryofResidence.[Value (textinput-3)]) = UPPER(TGC.CountryofResidence)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_PlaceofIncorporation ON  CR_PlaceofIncorporation.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_PlaceofIncorporation.[Value (textinput-3)]) = UPPER(TGC.PlaceofIncorporation)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_BusinessNature   ON  CR_BusinessNature.[CodeType (selectbasic-1)] = 'BusinessNature' AND  UPPER(CR_BusinessNature.[Value (textinput-3)]) = UPPER(TGC.BusinessNature)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_EmploymentStatus ON  CR_EmploymentStatus.[CodeType (selectbasic-1)] = 'EmploymentStatus' 
					AND (LOWER(CR_EmploymentStatus.[Value (textinput-3)]) = LOWER(TGC.EmploymentStatus)
						OR LOWER(TGC.EmploymentStatus) = 'others' AND LOWER(CR_EmploymentStatus.[Value (textinput-3)]) = 'self-employed')
			LEFT JOIN CQBTempDB.export.Tb_FormData_1425 CR_IndustriesSpecialization ON  CR_IndustriesSpecialization.[RiskProfileType (selectbasic-1)]= 'Industries' 
					AND (LOWER(CR_IndustriesSpecialization.[RiskValue (textinput-2)]) = LOWER(TGC.IndustriesSpecialization) 
						OR (LOWER(TGC.IndustriesSpecialization) LIKE 'financial institution authorized%' AND CR_IndustriesSpecialization.[RiskValue (textinput-2)] LIKE 'Financial Institution authorized%'))
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_OccupationDesignation    ON  CR_OccupationDesignation.[CodeType (selectbasic-1)] = 'Occupation' AND  UPPER(CR_OccupationDesignation.[Value (textinput-3)]) = UPPER(TGC.OccupationDesignation)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_SpouseNationality    ON  CR_SpouseNationality.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_SpouseNationality.[Value (textinput-3)]) = UPPER(TGC.SpouseNationality)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_SpouseIDType ON  CR_SpouseIDType.[CodeType (selectbasic-1)] = 'IDNumberType' AND  UPPER(CR_SpouseIDType.[Value (textinput-3)]) = UPPER(TGC.SpouseIDType)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_SpouseEmploymentStatus   ON  CR_SpouseEmploymentStatus.[CodeType (selectbasic-1)] = 'EmploymentStatus' 
					AND (LOWER(CR_SpouseEmploymentStatus.[Value (textinput-3)]) = LOWER(TGC.SpouseEmploymentStatus)
						OR (LOWER(TGC.SpouseEmploymentStatus) = 'others' AND LOWER(CR_SpouseEmploymentStatus.[Value (textinput-3)]) = 'self-employed'))
			LEFT JOIN CQBTempDB.export.Tb_FormData_1425 CR_SpouseIndustriesSpecialization   ON  CR_SpouseIndustriesSpecialization.[RiskProfileType (selectbasic-1)] = 'Industries'
					AND (LOWER(CR_SpouseIndustriesSpecialization.[RiskValue (textinput-2)]) = LOWER(TGC.SpouseIndustriesSpecialization) 
						OR (LOWER(TGC.SpouseIndustriesSpecialization) LIKE 'financial institution authorized%' AND CR_SpouseIndustriesSpecialization.[RiskValue (textinput-2)] LIKE 'Financial Institution authorized%'))
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_SpouseOccupationDesignation  ON  CR_SpouseOccupationDesignation.[CodeType (selectbasic-1)] = 'Occupation' AND  UPPER(CR_SpouseOccupationDesignation.[Value (textinput-3)]) = UPPER(TGC.SpouseOccupationDesignation)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_RAStateOfMalaysia    ON  CR_RAStateOfMalaysia.[CodeType (selectbasic-1)] = 'State' AND  UPPER(CR_RAStateOfMalaysia.[Value (textinput-3)]) = UPPER(TGC.RAStateOfMalaysia)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_RACountry    ON  CR_RACountry.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_RACountry.[Value (textinput-3)]) = UPPER(TGC.RACountry)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_CAStateOfMalaysia    ON  CR_CAStateOfMalaysia.[CodeType (selectbasic-1)] = 'State' AND  UPPER(CR_CAStateOfMalaysia.[Value (textinput-3)]) = UPPER(TGC.CAStateOfMalaysia)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_CACountry    ON  CR_CACountry.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_CACountry.[Value (textinput-3)]) = UPPER(TGC.CACountry)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_ContractDelivery ON  CR_ContractDelivery.[CodeType (selectbasic-1)] = 'DeliveryType' AND  UPPER(CR_ContractDelivery.[Value (textinput-3)]) = UPPER(TGC.ContractDelivery)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_DailyTransactionDelivery ON  CR_DailyTransactionDelivery.[CodeType (selectbasic-1)] = 'DeliveryType' AND  UPPER(CR_DailyTransactionDelivery.[Value (textinput-3)]) = UPPER(TGC.DailyTransactionDelivery)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_MonthlyStmDelivery   ON  CR_MonthlyStmDelivery.[CodeType (selectbasic-1)] = 'DeliveryType' AND  UPPER(CR_MonthlyStmDelivery.[Value (textinput-3)]) = UPPER(TGC.MonthlyStmDelivery)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_TaxCountry   ON  CR_TaxCountry.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_TaxCountry.[Value (textinput-3)]) = UPPER(TGC.TaxCountry)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_CRSIndAddressCountry   ON  CR_CRSIndAddressCountry.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_CRSIndAddressCountry.[Value (textinput-3)]) = UPPER(TGC.CRSIndAddressCountry)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_BirthCountry ON  CR_BirthCountry.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_BirthCountry.[Value (textinput-3)]) = UPPER(TGC.BirthCountry)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_CRSCorpAddressCountry   ON  CR_CRSCorpAddressCountry.[CodeType (selectbasic-1)] = 'Country' AND  UPPER(CR_CRSCorpAddressCountry.[Value (textinput-3)]) = UPPER(TGC.CRSCorpAddressCountry)	
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_PromotionIndicator   ON  CR_PromotionIndicator.[CodeType (selectbasic-1)] = 'Promo16' AND  UPPER(CR_PromotionIndicator.[Value (textinput-3)]) = UPPER(TGC.PromotionIndicator)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_CDSPayment   ON  CR_CDSPayment.[CodeType (selectbasic-1)] = 'PayType' AND  UPPER(CR_CDSPayment.[Value (textinput-3)]) = UPPER(TGC.CDSPayment)
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 CR_LegalStatus  ON  CR_LegalStatus.[CodeType (selectbasic-1)] = 'LegalStatus' AND  UPPER(CR_LegalStatus.[Value (textinput-3)]) = UPPER(TGC.LegalStatus)


		/************************ Tb_Gbo_Cust_Acc_Type : MANDATORY CHECK : IF ANY OF CONDITIONS ARE NOT MEANT, IMPORTSTATUS IS SET TO REJECTED (R) *************************/

		UPDATE import.Tb_Gbo_Cust_Acc_Type
		SET ImportRemarks = CONCAT(
			CASE WHEN CustomerUniqueID IS NULL THEN '[ERROR]: "CustomerUniqueID" is mandatory; ' END,
			CASE WHEN RowIndex IS NULL THEN '[ERROR]: "RowIndex" is mandatory; ' END,
			CASE WHEN Action IS NULL THEN '[ERROR]: "Action" is mandatory; ' END,
			CASE WHEN AccountType IS NULL THEN '[ERROR]: "AccountType" is mandatory; ' 
				 ELSE 
					CASE WHEN AccountType = 'G' AND Financier IS NULL	THEN '"Financier" is mandatory; ' END 
			END
		)


		UPDATE import.Tb_Gbo_Cust_Acc_Type
		SET ImportStatus = IIF(NULLIF(ImportRemarks,'') IS NOT NULL, 'R','P')


		/************************ Tb_Gbo_Cust_Acc_Type : OPTIONS CHECK  : IF ANY OF CONDITIONS ARE NOT MEANT, IMPORTSTATUS IS SET TO REJECTED (R) *************************/

		UPDATE ACCT
		SET ACCT.ImportRemarks = CONCAT(ACCT.ImportRemarks, 
			CASE WHEN ACCT.Action IS NOT NULL AND ACCT.Action NOT IN ('I','U')	THEN '[WARNING]: "Action" value provided is not existing in field options; ' END,
			CASE WHEN ACCT.AccountType IS NOT NULL AND REF_AccountType.[2DigitCode (textinput-1)] IS NULL	THEN '[WARNING]: "AccountType" value provided is not existing Account Type List Form; ' END,
			CASE WHEN ACCT.MRCode IS NOT NULL AND REF_MRCode.[RegistrationNo (textinput-2)] IS NULL	THEN '[WARNING]: "MRCode" value provided is not existing MR Form; ' END,
			CASE WHEN ACCT.ReferenceSource IS NOT NULL AND REF_ReferenceSource.[textinput-2] IS NULL	THEN '[WARNING]: "ReferenceSource" value provided is not existing Reference Code Form; ' END,
			CASE WHEN ACCT.Financier IS NOT NULL AND REF_Financier.[Value (textinput-3)] IS NULL	THEN '[WARNING]: "Financier" value provided is not existing Code Reference Form; ' END,
			CASE WHEN ACCT.DealerCode IS NOT NULL AND REF_DealerCode.[DealerCode (textinput-35)] IS NULL	THEN '[WARNING]: "DealerCode" value provided is not existing Code Reference Form; ' END
			)
			,
			---- TO CORRECT POSSIBLE CASING MISMATCH; ONLY CHANGE THOSE WITH MATCHING SOURCE
			ACCT.AccountType = IIF(ACCT.AccountType IS NOT NULL AND REF_AccountType.[2DigitCode (textinput-1)] IS NOT NULL, REF_AccountType.[2DigitCode (textinput-1)], ACCT.AccountType),
			ACCT.MRCode = IIF(ACCT.MRCode IS NOT NULL AND REF_MRCode.[RegistrationNo (textinput-2)] IS NOT NULL, REF_MRCode.[RegistrationNo (textinput-2)], ACCT.MRCode),
			ACCT.ReferenceSource = IIF(ACCT.ReferenceSource IS NOT NULL AND REF_ReferenceSource.[textinput-2] IS NOT NULL, REF_ReferenceSource.[textinput-2], ACCT.ReferenceSource),
			ACCT.Financier = IIF(ACCT.Financier IS NOT NULL AND REF_Financier.[Value (textinput-3)] IS NOT NULL, REF_Financier.[Value (textinput-3)], ACCT.Financier),
			ACCT.DealerCode = IIF(ACCT.DealerCode IS NOT NULL AND REF_DealerCode.[DealerCode (textinput-35)] IS NOT NULL, REF_DealerCode.[DealerCode (textinput-35)], ACCT.DealerCode)
		FROM import.Tb_Gbo_Cust_Acc_Type ACCT
			LEFT JOIN CQBTempDB.export.Tb_FormData_1457 REF_AccountType ON UPPER(ACCT.AccountType) = UPPER(REF_AccountType.[2DigitCode (textinput-1)])
			LEFT JOIN CQBTempDB.export.Tb_FormData_1377 REF_DealerCode ON UPPER(ACCT.DealerCode) = UPPER(REF_DealerCode.[DealerCode (textinput-35)])
			LEFT JOIN CQBTempDB.export.Tb_FormData_1575 REF_MRCode ON UPPER(ACCT.MRCode) = UPPER(REF_MRCode.[RegistrationNo (textinput-2)])
			LEFT JOIN CQBuilder.form.Tb_FormData_1481 /*temp since no cqtempdb.export.Tb_FormData_1481 */ REF_ReferenceSource ON UPPER(ACCT.ReferenceSource) = UPPER(REF_ReferenceSource.[textinput-2])
			LEFT JOIN CQBTempDB.export.Tb_FormData_1319 REF_Financier ON REF_Financier.[CodeType (selectbasic-1)] = 'AccountFinancier' AND UPPER(ACCT.Financier) = UPPER(REF_Financier.[Value (textinput-3)])
				

		--SELECT ImportStatus, ImportRemarks,*
		--FROM [import].[Tb_Gbo_CustomerInfo]

		--SELECT ImportStatus, ImportRemarks,*
		--FROM [import].Tb_Gbo_Cust_Acc_Type


		/************************ Tb_Gbo_FinancialDetails : VALIDATIONS *************************/
		UPDATE import.Tb_Gbo_FinancialDetails
		SET ImportRemarks = CONCAT(
			CASE WHEN CustomerUniqueID IS NULL THEN '[ERROR]: "CustomerUniqueID" is mandatory; ' END,
			CASE WHEN Action_ IS NULL THEN '[ERROR]: "Action" is mandatory; ' END,
			CASE WHEN RowIndex IS NULL THEN '[ERROR]: "RowIndex" is mandatory; ' END,
			CASE WHEN DefaultBankAccount IS NULL THEN '[ERROR]: "DefaultBankAccount" is mandatory; ' END,
			CASE WHEN AccountHolderName IS NULL THEN '[ERROR]: "AccountHolderName" is mandatory; ' END,
			CASE WHEN AccountNumber IS NULL THEN '[ERROR]: "AccountNumber" is mandatory; ' 
				 WHEN IIF(TRY_CAST(AccountNumber AS INT) IS NOT NULL,1,0) = 0 THEN '[ERROR]: "AccountNumber" must be in digits only; ' END,
			CASE WHEN Bank IS NULL THEN '[ERROR]: "Bank" is mandatory; ' END,
			CASE WHEN JointAccount IS NULL THEN '[ERROR]: "JointAccount" is mandatory; ' END
		)

		UPDATE TGF
		SET TGF.ImportRemarks = CONCAT(TGF.ImportRemarks, 
			CASE WHEN NULLIF(TGF.Bank,'') IS NOT NULL AND Bank.[BankCode (textinput-1)] IS NULL	THEN '[WARNING]: "Bank" value provided is not existing in field options; ' END,
			CASE WHEN NULLIF(TGF.JointAccount,'') IS NOT NULL AND TGF.JointAccount NOT IN ('Y','N')	THEN '[WARNING]: "JointAccount" value provided is not existing in field options; ' END
			),
			---- TO CORRECT POSSIBLE CASING MISMATCH; ONLY CHANGE THOSE WITH MATCHING SOURCE
			TGF.Bank = IIF(TGF.Bank IS NOT NULL AND Bank.[BankCode (textinput-1)] IS NOT NULL, Bank.[BankCode (textinput-1)], TGF.Bank)
		FROM import.Tb_Gbo_FinancialDetails TGF
			LEFT JOIN CQBTempDB.export.Tb_FormData_1431 Bank
				ON TGF.Bank = Bank.[BankCode (textinput-1)]
		
		
		UPDATE import.Tb_Gbo_FinancialDetails
		SET ImportStatus = IIF(NULLIF(ImportRemarks,'') IS NOT NULL, 'R','P')

		--select * from import.Tb_Gbo_FinancialDetails
		--select * from import.Tb_Gbo_FinancialDetails_eRROR

		/************************ Tb_Gbo_IndividualAuthorizatio : VALIDATIONS *************************/

		UPDATE import.Tb_Gbo_IndividualAuthorizatio
		SET ImportRemarks = CONCAT(
			CASE WHEN CustomerUniqueID IS NULL THEN '[ERROR]: "CustomerUniqueID" is mandatory; ' END,
			CASE WHEN RowIndex IS NULL THEN '[ERROR]: "RowIndex" is mandatory; ' END,
			CASE WHEN Action_ IS NULL THEN '[ERROR]: "DefaultBankAccount" is mandatory; ' END
		)

		
		UPDATE import.Tb_Gbo_IndividualAuthorizatio
		SET ImportStatus = IIF(NULLIF(ImportRemarks,'') IS NOT NULL, 'R','P')

		--SELECT * FROM import.Tb_Gbo_IndividualAuthorizatio

		/************************ Tb_Gbo_RelatedDetails : VALIDATIONS *************************/

		UPDATE import.Tb_Gbo_RelatedDetails
		SET ImportRemarks = CONCAT(
			CASE WHEN CustomerUniqueID IS NULL THEN '[ERROR]: "CustomerUniqueID" is mandatory; ' END,
			CASE WHEN RowIndex IS NULL THEN '[ERROR]: "RowIndex" is mandatory; ' END,
			CASE WHEN Action_ IS NULL THEN '[ERROR]: "DefaultBankAccount" is mandatory; ' END
		)

		
		UPDATE import.Tb_Gbo_RelatedDetails
		SET ImportStatus = IIF(NULLIF(ImportRemarks,'') IS NOT NULL, 'R','P')

		--SELECT * FROM import.Tb_Gbo_RelatedDetails




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