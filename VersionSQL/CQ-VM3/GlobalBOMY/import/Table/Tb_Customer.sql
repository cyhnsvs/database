/****** Object:  Table [import].[Tb_Customer]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Customer](
	[CustomerID] [varchar](50) NULL,
	[Title] [varchar](50) NULL,
	[CustomerName] [varchar](200) NULL,
	[BFEShortName] [varchar](50) NULL,
	[CustomerType] [varchar](50) NULL,
	[ForeignAccountHolder] [varchar](50) NULL,
	[IDType] [varchar](50) NULL,
	[IDNumber] [varchar](50) NULL,
	[AlternateID] [varchar](50) NULL,
	[AlternateIDNumber] [varchar](50) NULL,
	[Occupation] [varchar](50) NULL,
	[Sex] [varchar](50) NULL,
	[MaritalStatus] [varchar](200) NULL,
	[DateOfBirth] [varchar](50) NULL,
	[Race] [varchar](50) NULL,
	[Dialect] [varchar](50) NULL,
	[Nationality] [varchar](50) NULL,
	[CountryOfResidence] [varchar](50) NULL,
	[NoOfDependants] [varchar](50) NULL,
	[BumiputraStatus] [varchar](50) NULL,
	[PermanentResident] [varchar](50) NULL,
	[Constitutional] [varchar](255) NULL,
	[PlaceOfIncorporation] [varchar](50) NULL,
	[DateIncorporated] [varchar](50) NULL,
	[BusinessNature] [varchar](50) NULL,
	[RegisteredAddress1] [varchar](50) NULL,
	[RegisteredAddress2] [varchar](50) NULL,
	[RegisteredAddress3] [varchar](50) NULL,
	[RegisteredAddress4] [varchar](50) NULL,
	[RegisteredAddress5] [varchar](50) NULL,
	[PostCode] [varchar](50) NULL,
	[SwiftAddress] [varchar](50) NULL,
	[ResidenceOwnership] [varchar](50) NULL,
	[YearsinResidence] [varchar](50) NULL,
	[PhoneHouse] [varchar](50) NULL,
	[PhoneOffice] [varchar](50) NULL,
	[PhoneMobile] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Telex] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[CorrOrBusinessAdd1] [varchar](50) NULL,
	[CorrOrBusinessAdd2] [varchar](50) NULL,
	[CorrOrBusinessAdd3] [varchar](50) NULL,
	[CorrOrBusinessAdd4] [varchar](50) NULL,
	[CorrOrBusinessAdd5] [varchar](50) NULL,
	[CorrOrBusinessPostCode] [varchar](50) NULL,
	[AnnualIncome] [varchar](50) NULL,
	[OtherIncome1] [varchar](50) NULL,
	[OtherIncome2] [varchar](50) NULL,
	[AuthorizedCapital] [varchar](50) NULL,
	[AuthorizedCapitalAsAt] [varchar](50) NULL,
	[PaidUpCapital] [varchar](50) NULL,
	[PaidUpCapitalAsAt] [varchar](50) NULL,
	[RetainedEarnings] [varchar](50) NULL,
	[RetainedEarningsAsAt] [varchar](50) NULL,
	[LegalStatus] [varchar](50) NULL,
	[BankruptcyOrWindingUpStatus] [varchar](50) NULL,
	[BankruptcyOrWindingUpReason] [varchar](50) NULL,
	[DateDeclaredBankruptcyOrWindingUp] [varchar](50) NULL,
	[DateDischargedBankruptcyOrWindingUp] [varchar](50) NULL,
	[Remarks1] [varchar](50) NULL,
	[Remarks2] [varchar](200) NULL
) ON [PRIMARY]