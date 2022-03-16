/****** Object:  Table [import].[Tb_Financier]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Financier](
	[FinancierCode] [varchar](10) NULL,
	[FinancierName] [varchar](50) NULL,
	[ContactPerson] [varchar](40) NULL,
	[Address1] [varchar](40) NULL,
	[Address2] [varchar](40) NULL,
	[Address3] [varchar](40) NULL,
	[Address4] [varchar](40) NULL,
	[Country] [varchar](40) NULL,
	[ZipOrPostalCode] [varchar](10) NULL,
	[TelephoneNo] [varchar](10) NULL,
	[FaxNo] [varchar](15) NULL,
	[EmailAddress] [varchar](15) NULL,
	[DialupNo] [varchar](15) NULL,
	[SWIFTAccount] [varchar](10) NULL,
	[Telex] [varchar](10) NULL,
	[UserCreated] [varchar](8) NULL,
	[DateCreated] [varchar](10) NULL,
	[TimeCreated] [varchar](10) NULL,
	[UserUpdated] [varchar](8) NULL,
	[DateUpdated] [varchar](50) NULL,
	[TimeUpdated] [varchar](50) NULL
) ON [PRIMARY]