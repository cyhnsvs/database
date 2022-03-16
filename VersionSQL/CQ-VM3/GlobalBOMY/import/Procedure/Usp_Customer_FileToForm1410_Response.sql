/****** Object:  Procedure [import].[Usp_Customer_FileToForm1410_Response]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- EXEC [import].[Usp_Customer_FileToForm1410_Response]

-- =============================================
CREATE PROCEDURE [import].[Usp_Customer_FileToForm1410_Response]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DROP TABLE IF EXISTS #CustomerInfo
	DROP TABLE IF EXISTS #CustomerAcctType
	DROP TABLE IF EXISTS #FinancialDetails
	DROP TABLE IF EXISTS #IndividualAuthorization
	DROP TABLE IF EXISTS #RelatedDetails
	

	SELECT UniqueID
		,IDNumber
		,CustomerID
		,BursaAnywhere
		,ImportStatus
		,ImportRemarks
		INTO #CustomerInfo
	FROM [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] 
	UNION ALL
	SELECT UniqueID
		,IDNumber
		,CustomerID
		,BursaAnywhere
		,'R' ImportStatus
		,CONCAT('[ERROR]: ',ErrorDescription,'; ') ImportRemarks
	FROM [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo_Error] 


	SELECT CustomerUniqueID
		,CDSNo
		,ImportStatus
		,ImportRemarks 
		INTO #CustomerAcctType
	FROM import.Tb_Gbo_Cust_Acc_Type
	UNION ALL
	SELECT CustomerUniqueID
		,CDSNo
		,ImportStatus
		,CONCAT('[ERROR]: ',ImportRemarks,'; ') ImportRemarks 
	FROM import.Tb_Gbo_Cust_Acc_Type_Error 


	SELECT CustomerUniqueID
		,ImportStatus
		,ImportRemarks
		INTO #FinancialDetails
	FROM import.Tb_Gbo_FinancialDetails
	UNION ALL
	SELECT  CustomerUniqueID
		,ImportStatus
		,CONCAT('[ERROR]: ',ImportRemarks,'; ') ImportRemarks 
	FROM import.Tb_Gbo_FinancialDetails_Error 

	
	SELECT CustomerUniqueID
		,ImportStatus
		,ImportRemarks
		INTO #IndividualAuthorization
	FROM import.Tb_Gbo_IndividualAuthorizatio
	UNION ALL
	SELECT  CustomerUniqueID
		,ImportStatus
		,CONCAT('[ERROR]: ',ImportRemarks,'; ') ImportRemarks 
	FROM import.Tb_Gbo_IndividualAuthorization_Error
		

	SELECT CustomerUniqueID
		,ImportStatus
		,ImportRemarks
		INTO #RelatedDetails
	FROM import.Tb_Gbo_RelatedDetails
	UNION ALL
	SELECT  CustomerUniqueID
		,ImportStatus
		,CONCAT('[ERROR]: ',ImportRemarks,'; ') ImportRemarks 
	FROM import.Tb_Gbo_RelatedDetails_Error
		
	----------------------------------------------------------------------
	
	SELECT 'UniqueID|IDNumber|CustomerID|AccountNo|CDSNo|Status|Remarks|BursaAnywhere' as [Result]
	UNION ALL
	SELECT
		--TGC.UniqueID AS UniqueID,
		--TGC.IDNumber AS IDNumber,
		--CUSTOMER.[CustomerID (textinput-1)] AS CustomerID, --TGA.GeneratedCustomerID AS CustomerID,
		----CONCAT(CUSTOMER.[CustomerID (textinput-1)],A_GRID.[DigitCode (TextBox)]) AS AccountNo,
		--ACCOUNT.[selectsource-1] AS AccountNo,
		--TGA.CDSNo,
		--TGC.BursaAnywhere,
		--IIF(TGC.ImportStatus = 'R' OR TGA.ImportStatus = 'R' OR TGF.ImportStatus = 'R' OR TGI.ImportStatus = 'R' OR TGR.ImportStatus = 'R','R','C')  AS [Status],
		--CONCAT(TGC.ImportRemarks,TGA.ImportRemarks) AS Remarks
		------UniqueID,
		CONCAT(TGC.UniqueID
			,'|',TGC.IDNumber
			,'|',CUSTOMER.[CustomerID (textinput-1)]
			,'|',ACCOUNT.[selectsource-1] 
			,'|',TGA.CDSNo
			,'|',IIF(TGC.ImportStatus = 'R' OR TGA.ImportStatus = 'R' OR TGF.ImportStatus = 'R' OR TGI.ImportStatus = 'R' OR TGR.ImportStatus = 'R','R','C') 
			,'|',TGC.ImportRemarks, TGA.ImportRemarks, TGF.ImportRemarks, TGI.ImportRemarks, TGR.ImportRemarks
			,'|',TGC.BursaAnywhere) as [Result]
	FROM #CustomerInfo TGC
	LEFT JOIN #CustomerAcctType TGA ON TGC.UniqueID = TGA.CustomerUniqueID
	LEFT JOIN #FinancialDetails TGF ON TGC.UniqueID = TGF.CustomerUniqueID
	LEFT JOIN #IndividualAuthorization TGI ON TGC.UniqueID = TGI.CustomerUniqueID
	LEFT JOIN #RelatedDetails TGR ON TGC.UniqueID = TGR.CustomerUniqueID

	LEFT JOIN CQBTempDB.import.Tb_FormData_1410 CUSTOMER ON CUSTOMER.[IDNumber (textinput-5)] = TGC.IDNumber
	LEFT JOIN CQBuilder.form.Tb_FormData_1409 ACCOUNT ON 
				CUSTOMER.[CustomerID (textinput-1)] = ACCOUNT.[selectsource-1]
	



	/* previous code
	-----------------------------
	SELECT ImportStatus, ImportRemarks,[UniqueID],[Action],[ModeofClientAcquisition],[ClientType],[CustomerID],[OldCustomerID],[Title],[CustomerName],[Nationality],[PermanentResidenceofMalaysia],[IDType],[IDNumber],[IDExpiryDate],[AlternateIDType],[AlternateIDNumber],[AlternateIDExpiryDate],[Gender],[MaritalStatus],[DateofBirth],[Race],[Ownership],[CountryofResidence],[BumiputraStatus],[PlaceOfIncorporation],[DateofIncorporated],[BusinessNature],[AuthorisedCapital],[PaidUpCapital],[CompanyNetAsset],[ModeofSignatory],[ThirdParty3rdAuthorisation],[ThirdPartyStartdate],[ThirdPartyEnddate],[EmploymentStatus],[IndustriesSpecialization],[OccupationDesignation],[NameofCompany],[PhoneOffice],[GrossAnnualIncome],[EstimatedNetWorth],[SpouseName],[SpouseNationality],[SpousePermanentResidenceofMalaysia],[SpouseIDType],[SpouseIDNumber],[SpouseIDExpiryDate],[SpouseEmploymentStatus],[SpouseIndustriesSpecialization],[SpouseOccupationDesignation],[SpouseNameofCompany],[SpouseGrossAnnualIncome],[SpousePhoneNo],[UserID],[OnlineSystemIndicator],[RAAddress1],[RAAddress2],[RAAddress3],[RATown],[RAStateOfMalaysia],[RAStateNotMalaysia],[RACountry],[RAPostcode],[SameasRegisteredAddress],[CAAddress1],[CAAddress2],[CAAddress3],[CATown],[CAStateOfMalaysia],[CAStateNotMalaysia],[CACountry],[CAPostcode],[PhoneHouse],[PhoneMobile],[CompanyTelNo],[ContactPersonName],[MobileNumber],[Email],[CDSeStatement],[ContractDelivery],[DailyTransactionDelivery],[MonthlyStmDelivery],[1HowOftenDoYouKeepTrackonMarket],[2Timeframetoholdastock],[3TypeofSecuritiesProductInterestedtickoneormore],[TypeofSecuritiesOthers],[4TradingStrategyApproachUsingInterestedtickoneormore],[TradingStrategyOthers],[5Doyouinvestinotherinvestmentproductstickoneormore],[OthersInvestmentProduct],[6Whatisyourmainsourceoffundsforinvestment],[MainSourceOthers],[7HowlonghaveyoubeentradingintheMalaysiamarket],[8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify],[OthersTradingAccountBroker],[9Doyouholdorhavepreviouslyheldanysharemargintradingaccount],[10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof],[11WhatisyourexpectedReturnoninvestmentfortheshortterm],[12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses],[Courses],[TradingMode],[eDividend],[PoliticalExposedPerson],[PEPClassification],[FEAResidentofMalaysia],[FEAhaveDomesticRinggitBorrowing],[PDPA],[TaxResidentOutsideMalaysia],[TaxIdentificationNumber],[TaxCountry],[FirstName],[MiddleName],[LastName],[CRSIndAddressCity],[CRSIndAddressCountry],[BirthCity],[BirthCountry],[IdentificationNumber],[ShareholderType],[Name],[CRSCorpAddressCity],[CRSCorpAddressCountry],[IDSS],[IDSSStartDate],[IDSSSignedTC],[LEAP],[LEAPStartDate],[LEAPSignedTC],[ETFLI],[ETFLIStartDate],[ETFLISignedTC],[W8BEN],[W8BENStartDate],[W8BENExpiryDate],[W8BENSignedTC],[LetterofUndertakingforTWSE],[TWSEStartDate],[TWSESignedTC],[Algo],[AlgoStartDate],[AlgoSignedTC],[SophisticatedInvestor],[BursaAnywhere],[NRICPassportEnclosed],[NRIC],[BankParticularsasperBankStatement],[BankStatement],[SignatureVerified],[CDSandTrading],[RiskProfilingMode],[PromotionIndicator],[CDSPayment],[OthersCDSPayment],[Remarks],[LegalStatus],[BankruptcyOrWindingupStatus],[SummonOrDefaultinPaymentStatus],[DateDeclaredBankruptcyOrWindingup],[DateDischargedBankruptcyOrWindingup],[Remark1],[Remark2]
		FROM [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo]
		UNION ALL
		SELECT 'R' AS ImportStatus,CONCAT('[ERROR]: ',ErrorDescription) AS ImportRemarks,[UniqueID],[Action],[ModeofClientAcquisition],[ClientType],[CustomerID],[OldCustomerID],[Title],[CustomerName],[Nationality],[PermanentResidenceofMalaysia],[IDType],[IDNumber],[IDExpiryDate],[AlternateIDType],[AlternateIDNumber],[AlternateIDExpiryDate],[Gender],[MaritalStatus],[DateofBirth],[Race],[Ownership],[CountryofResidence],[BumiputraStatus],[PlaceOfIncorporation],[DateofIncorporated],[BusinessNature],[AuthorisedCapital],[PaidUpCapital],[CompanyNetAsset],[ModeofSignatory],[ThirdParty3rdAuthorisation],[ThirdPartyStartdate],[ThirdPartyEnddate],[EmploymentStatus],[IndustriesSpecialization],[OccupationDesignation],[NameofCompany],[PhoneOffice],[GrossAnnualIncome],[EstimatedNetWorth],[SpouseName],[SpouseNationality],[SpousePermanentResidenceofMalaysia],[SpouseIDType],[SpouseIDNumber],[SpouseIDExpiryDate],[SpouseEmploymentStatus],[SpouseIndustriesSpecialization],[SpouseOccupationDesignation],[SpouseNameofCompany],[SpouseGrossAnnualIncome],[SpousePhoneNo],[UserID],[OnlineSystemIndicator],[RAAddress1],[RAAddress2],[RAAddress3],[RATown],[RAStateOfMalaysia],[RAStateNotMalaysia],[RACountry],[RAPostcode],[SameasRegisteredAddress],[CAAddress1],[CAAddress2],[CAAddress3],[CATown],[CAStateOfMalaysia],[CAStateNotMalaysia],[CACountry],[CAPostcode],[PhoneHouse],[PhoneMobile],[CompanyTelNo],[ContactPersonName],[MobileNumber],[Email],[CDSeStatement],[ContractDelivery],[DailyTransactionDelivery],[MonthlyStmDelivery],[1HowOftenDoYouKeepTrackonMarket],[2Timeframetoholdastock],[3TypeofSecuritiesProductInterestedtickoneormore],[TypeofSecuritiesOthers],[4TradingStrategyApproachUsingInterestedtickoneormore],[TradingStrategyOthers],[5Doyouinvestinotherinvestmentproductstickoneormore],[OthersInvestmentProduct],[6Whatisyourmainsourceoffundsforinvestment],[MainSourceOthers],[7HowlonghaveyoubeentradingintheMalaysiamarket],[8DoyouhaveTradingAccountswithotherbrokersIfyespleasespecify],[OthersTradingAccountBroker],[9Doyouholdorhavepreviouslyheldanysharemargintradingaccount],[10Pleaselistdownupto5ofyourfavouritestocksoranystocksthatyouknowof],[11WhatisyourexpectedReturnoninvestmentfortheshortterm],[12HaveyouattendedanycoursesbeforeIfyeswhattypeofcourses],[Courses],[TradingMode],[eDividend],[PoliticalExposedPerson],[PEPClassification],[FEAResidentofMalaysia],[FEAhaveDomesticRinggitBorrowing],[PDPA],[TaxResidentOutsideMalaysia],[TaxIdentificationNumber],[TaxCountry],[FirstName],[MiddleName],[LastName],[CRSIndAddressCity],[CRSIndAddressCountry],[BirthCity],[BirthCountry],[IdentificationNumber],[ShareholderType],[Name],[CRSCorpAddressCity],[CRSCorpAddressCountry],[IDSS],[IDSSStartDate],[IDSSSignedTC],[LEAP],[LEAPStartDate],[LEAPSignedTC],[ETFLI],[ETFLIStartDate],[ETFLISignedTC],[W8BEN],[W8BENStartDate],[W8BENExpiryDate],[W8BENSignedTC],[LetterofUndertakingforTWSE],[TWSEStartDate],[TWSESignedTC],[Algo],[AlgoStartDate],[AlgoSignedTC],[SophisticatedInvestor],[BursaAnywhere],[NRICPassportEnclosed],[NRIC],[BankParticularsasperBankStatement],[BankStatement],[SignatureVerified],[CDSandTrading],[RiskProfilingMode],[PromotionIndicator],[CDSPayment],[OthersCDSPayment],[Remarks],[LegalStatus],[BankruptcyOrWindingupStatus],[SummonOrDefaultinPaymentStatus],[DateDeclaredBankruptcyOrWindingup],[DateDischargedBankruptcyOrWindingup],[Remark1],[Remark2]
		FROM [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo_Error2]
	-----------------------------

	DECLARE @ROWCOUNT BIGINT;

	SET @ROWCOUNT = (select count(*) FROM [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC
	LEFT JOIN [CQBTempDB].[import].[Tb_FormData_1410] CUSTOMER ON CUSTOMER.[IDNumber (textinput-5)] = TGC.IDNumber
	WHERE	
		CUSTOMER.IDD IS NULL)

    -- Insert statements for procedure here
	
	CREATE TABLE #Response
	(
		UniqueID	int,
		IDNumber	varchar(50),
		CustomerID	varchar(max),
		AccountNo	varchar(max),
		CDSNo		varchar(max),
		Status		varchar(max),
		Remarks		varchar(max)
	)

	IF (@ROWCOUNT = 0 )
	BEGIN
	---INSERT STATEMENT FOR SUCCESS 

	INSERT INTO #Response
	(
		UniqueID,
		IDNumber,
		CustomerID,
		AccountNo,
		CDSNo,
		Status,
		Remarks
	)
	SELECT
	TGC.UniqueID AS UniqueID,
	TGC.IDNumber AS IDNumber,
	CUSTOMER.[CustomerID (textinput-1)] AS CustomerID,
	ACCOUNT.[AccountNumber (textinput-5)] AS AccountNo,
	ACCOUNT.[CDSNo (textinput-19)] AS CDSNo,
	'Success' AS Status,
	'' AS Remarks
	FROM [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC
	INNER JOIN [CQBTempDB].[import].[Tb_FormData_1410] CUSTOMER ON CUSTOMER.[IDNumber (textinput-5)] = TGC.IDNumber
	LEFT JOIN [CQBTempDB].[import].[Tb_FormData_1409] ACCOUNT ON CUSTOMER.[CustomerID (textinput-1)] = ACCOUNT.[CustomerID (selectsource-1)]
	--LEFT JOIN [GlobalBOMY].import.Tb_AccountNoMapping ACCNOMAP ON  ACCOUNT.[CustomerID (selectsource-1)] = ACCNOMAP.NewCustomerID
	END

	ELSE
	BEGIN
	-- INSERT STATEMENT FOR FAILURE

	INSERT INTO #Response
	(
		UniqueID,
		IDNumber,
		CustomerID,
		AccountNo,
		CDSNo,
		Status,
		Remarks
	)
	SELECT 
	TGC.UniqueID AS UniqueID,
	TGC.IDNumber AS IDNumber,
	CUSTOMER.[CustomerID (textinput-1)] AS CustomerID,
	ACCOUNT.[AccountNumber (textinput-5)] AS AccountNo,
	ACCOUNT.[CDSNo (textinput-19)] AS CDSNo,
	'R' AS Status,
	'' AS Remarks
	FROM [GlobalBOMY].[import].[Tb_Gbo_CustomerInfo] TGC
	LEFT JOIN [CQBTempDB].[import].[Tb_FormData_1410] CUSTOMER ON CUSTOMER.[IDNumber (textinput-5)] = TGC.IDNumber
	LEFT JOIN [CQBTempDB].[import].[Tb_FormData_1409] ACCOUNT ON CUSTOMER.[CustomerID (textinput-1)] = ACCOUNT.[CustomerID (selectsource-1)]
	--LEFT JOIN [GlobalBOMY].import.Tb_AccountNoMapping ACCNOMAP ON  ACCOUNT.[CustomerID (selectsource-1)] = ACCNOMAP.NewCustomerID
	END

	--SELECT * FROM #Response

	--RESULT TYPE

	SELECT CAST(UniqueID AS VARCHAR) +'|'+ IDNumber +'|'+ CustomerID +'|'+ ISNULL(AccountNo,'') +'|'+ ISNULL(CDSNo,'') +'|'+ ISNULL(Status,'') +'|'+ ISNULL(Remarks,'') as [Result]
	FROM #Response
	*/

END