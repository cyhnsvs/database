/****** Object:  Table [import].[Tb_BURSA_CFT053]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BURSA_CFT053](
	[BillingDate] [varchar](8) NULL,
	[AccountNumber] [varchar](9) NULL,
	[AccountType] [varchar](2) NULL,
	[Date1] [varchar](8) NULL,
	[Date2] [varchar](8) NULL,
	[FeeAmount] [varchar](11) NULL,
	[GSTRate] [varchar](3) NULL,
	[GSTAmount] [varchar](4) NULL,
	[Rebate] [varchar](4) NULL,
	[NetAmount] [varchar](11) NULL,
	[FeeType] [varchar](1) NULL,
	[TaxInvoice] [varchar](22) NULL,
	[Status] [varchar](1) NULL,
	[Cancellation] [varchar](10) NULL,
	[CreditNote] [varchar](22) NULL,
	[Name] [varchar](60) NULL,
	[Qualifier] [varchar](120) NULL,
	[SourceFileName] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]