﻿/****** Object:  Table [import].[Tb_Account_BEFORE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Account_BEFORE](
	[CustomerKey] [varchar](50) NULL,
	[CompanyID] [varchar](50) NULL,
	[BranchID] [varchar](50) NULL,
	[EAFID] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[AccountSubCode] [varchar](50) NULL,
	[AccountName] [varchar](200) NULL,
	[BFEShortName] [varchar](50) NULL,
	[NomineesName1] [varchar](50) NULL,
	[NomineesName2] [varchar](200) NULL,
	[NomineesName3] [varchar](50) NULL,
	[NomineesName4] [varchar](50) NULL,
	[AbbreviatedName] [varchar](50) NULL,
	[IDType] [varchar](50) NULL,
	[IDNumber] [varchar](50) NULL,
	[AlternateID] [varchar](50) NULL,
	[AlternateIDNumber] [varchar](50) NULL,
	[CustomerType] [varchar](50) NULL,
	[ForeignAccountHolder] [varchar](50) NULL,
	[AccountGroup] [varchar](50) NULL,
	[ParentGroup] [varchar](50) NULL,
	[AccountType] [varchar](50) NULL,
	[AccountClass] [varchar](50) NULL,
	[ClientCategory] [varchar](50) NULL,
	[CADEntityType1] [varchar](50) NULL,
	[CADEntityType2] [varchar](50) NULL,
	[MarketCode] [varchar](50) NULL,
	[AveragingOption] [varchar](50) NULL,
	[CompanyId1] [varchar](50) NULL,
	[BranchId1] [varchar](50) NULL,
	[EAFID1] [varchar](50) NULL,
	[AveragingAccountNo] [varchar](50) NULL,
	[AccountSubCode1] [varchar](50) NULL,
	[OddLotAveragingOption] [varchar](50) NULL,
	[RelatedACNo1a] [varchar](50) NULL,
	[RelatedACNo1b] [varchar](50) NULL,
	[RelatedACNo2a] [varchar](50) NULL,
	[RelatedACNo2b] [varchar](50) NULL,
	[RelatedACNo3a] [varchar](50) NULL,
	[RelatedACNo3b] [varchar](50) NULL,
	[RelatedACNo4a] [varchar](50) NULL,
	[RelatedACNo4b] [varchar](50) NULL,
	[RelatedACNo5a] [varchar](50) NULL,
	[RelatedACNo5b] [varchar](50) NULL,
	[BumiputraStatus] [varchar](50) NULL,
	[Officer] [varchar](50) NULL,
	[ServiceOfficer] [varchar](50) NULL,
	[Financier] [varchar](50) NULL,
	[StatementPrinting] [varchar](50) NULL,
	[PrintCombineStatement] [varchar](50) NULL,
	[PlaceOfIncorporation] [varchar](50) NULL,
	[RelationshipToPrint] [varchar](50) NULL,
	[SMSClient] [varchar](50) NULL,
	[TrustClient] [varchar](50) NULL,
	[PaymentToAccount] [varchar](50) NULL,
	[CorrespondenceMethods] [varchar](50) NULL,
	[PhoneHouse] [varchar](50) NULL,
	[PhoneOffice] [varchar](50) NULL,
	[PhoneMobile] [varchar](50) NULL,
	[FaxNo] [varchar](50) NULL,
	[Telex] [varchar](50) NULL,
	[InternetMail] [varchar](50) NULL,
	[SwiftAddress] [varchar](50) NULL,
	[CorrTitle] [varchar](50) NULL,
	[CorrName] [varchar](50) NULL,
	[CorrAdd1] [varchar](50) NULL,
	[CorrAdd2] [varchar](50) NULL,
	[CorrAdd3] [varchar](50) NULL,
	[CorrAdd4] [varchar](50) NULL,
	[CorrAdd5] [varchar](50) NULL,
	[CorrPostCode] [varchar](50) NULL,
	[ForeignAdd] [varchar](50) NULL,
	[1stDupContCorrTitle] [varchar](50) NULL,
	[1stDupContCorrName] [varchar](50) NULL,
	[1stDupContCorrAdd1] [varchar](50) NULL,
	[1stDupContCorrAdd2] [varchar](50) NULL,
	[1stDupContCorrAdd3] [varchar](50) NULL,
	[1stDupContCorrAdd4] [varchar](50) NULL,
	[1stDupContCorrAdd5] [varchar](50) NULL,
	[1stDupContCorrPostCode] [varchar](50) NULL,
	[2ndDupContCorrTitle] [varchar](50) NULL,
	[2ndDupContCorrName] [varchar](50) NULL,
	[2ndDupContCorrAdd1] [varchar](50) NULL,
	[2ndDupContCorrAdd2] [varchar](50) NULL,
	[2ndDupContCorrAdd3] [varchar](50) NULL,
	[2ndDupContCorrAdd4] [varchar](50) NULL,
	[2ndDupContCorrAdd5] [varchar](50) NULL,
	[2ndDupContCorrPostCode] [varchar](50) NULL,
	[3rdDupContCorrTitle] [varchar](50) NULL,
	[3rdDupContCorrName] [varchar](50) NULL,
	[3rdDupContCorrAdd1] [varchar](50) NULL,
	[3rdDupContCorrAdd2] [varchar](50) NULL,
	[3rdDupContCorrAdd3] [varchar](50) NULL,
	[3rdDupContCorrAdd4] [varchar](50) NULL,
	[3rdDupContCorrAdd5] [varchar](50) NULL,
	[3rdDupContCorrPostCode] [varchar](50) NULL,
	[NameOfCompany] [varchar](50) NULL,
	[Occupation] [varchar](50) NULL,
	[NatureOfBusiness] [varchar](50) NULL,
	[DateEmployed] [varchar](50) NULL,
	[OffAdd1] [varchar](50) NULL,
	[OffAdd2] [varchar](50) NULL,
	[OffAddCityTown] [varchar](50) NULL,
	[OffState] [varchar](50) NULL,
	[OffPostCode] [varchar](255) NULL,
	[OffCountry] [varchar](50) NULL,
	[OffTelNo] [varchar](50) NULL,
	[OffFaxNo] [varchar](50) NULL,
	[AnnualIncome] [varchar](50) NULL,
	[LegalStatus] [varchar](50) NULL,
	[BankruptcyOrWindingUpStatus] [varchar](50) NULL,
	[Remarks1] [varchar](50) NULL,
	[Remarks2] [varchar](50) NULL,
	[ReferredByKYC] [varchar](100) NULL,
	[ApplicationStatus] [varchar](50) NULL,
	[ApplicationSerialNo] [varchar](50) NULL,
	[IntroducerIndicatorInternal] [varchar](50) NULL,
	[IntroducerCode] [varchar](50) NULL,
	[IncomeSharingFeeCode] [varchar](255) NULL,
	[DateJoined] [varchar](50) NULL,
	[BrokerageSharingFeeCode] [varchar](50) NULL,
	[AvgOutstandingAmount] [varchar](50) NULL,
	[AuthorisedRepresentive] [varchar](50) NULL,
	[BrokerCodeDealerEAFIDDealerCode] [varchar](50) NULL,
	[SendClientInfoToBFE] [varchar](50) NULL,
	[AccountStatus] [varchar](50) NULL,
	[DateSuspend] [varchar](50) NULL,
	[UserSuspend] [varchar](50) NULL,
	[DateClosed] [varchar](50) NULL,
	[UserClosed] [varchar](50) NULL,
	[FirstTradeDate] [varchar](50) NULL,
	[LastTradeDate] [varchar](50) NULL,
	[DateAccountOpened] [varchar](50) NULL,
	[Dormant] [varchar](50) NULL
) ON [PRIMARY]