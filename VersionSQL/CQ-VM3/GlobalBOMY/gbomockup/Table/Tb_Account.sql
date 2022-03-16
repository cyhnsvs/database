/****** Object:  Table [gbomockup].[Tb_Account]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [gbomockup].[Tb_Account](
	[AcctNo] [varchar](20) NOT NULL,
	[CompanyId] [bigint] NOT NULL,
	[ExtRefKey] [varchar](50) NULL,
	[BranchId] [bigint] NOT NULL,
	[AcctSegregationType] [varchar](20) NOT NULL,
	[AcctCategory] [varchar](10) NOT NULL,
	[AcctMarginType] [varchar](20) NOT NULL,
	[ServiceType] [varchar](10) NOT NULL,
	[GroupAccountNo] [varchar](50) NULL,
	[MainClientId] [bigint] NOT NULL,
	[AcctType] [varchar](50) NULL,
	[ChequeName] [nvarchar](150) NULL,
	[AcctExecutiveCd] [varchar](50) NOT NULL,
	[ClientBaseCurrCd] [char](3) NOT NULL,
	[DefaultSetlCurrCd] [char](3) NULL,
	[ResidenceAddressId] [bigint] NOT NULL,
	[MailingAddressId] [bigint] NOT NULL,
	[Email] [varchar](100) NULL,
	[AcctCreationDate] [date] NULL,
	[AcctStatus] [varchar](10) NOT NULL,
	[AcctStatusRemarks] [varchar](250) NULL,
	[Remarks] [varchar](250) NULL,
	[RecordId] [uniqueidentifier] NOT NULL,
	[ActionInd] [char](1) NOT NULL,
	[CurrentUser] [varchar](64) NOT NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDate] [datetime2](0) NOT NULL,
	[ModifiedBy] [varchar](64) NULL,
	[ModifiedDate] [datetime2](0) NULL,
	[PledgeInd] [char](1) NOT NULL,
	[MMFInd] [char](1) NOT NULL,
	[CreditLimit] [decimal](24, 9) NOT NULL,
	[TaxInd] [char](1) NOT NULL,
	[EConsent] [char](1) NOT NULL,
	[WithholdingTax] [decimal](16, 9) NOT NULL,
 CONSTRAINT [PK_Tb_Account] PRIMARY KEY CLUSTERED 
(
	[AcctNo] ASC,
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_AcctSegregationType_1]  DEFAULT ('House') FOR [AcctSegregationType]
ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_PledgeInd]  DEFAULT ('N') FOR [PledgeInd]
ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_MMFInd]  DEFAULT ('N') FOR [MMFInd]
ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_CreditLimit]  DEFAULT ((0)) FOR [CreditLimit]
ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_TaxInd]  DEFAULT ('Y') FOR [TaxInd]
ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_EConsent]  DEFAULT ('Y') FOR [EConsent]
ALTER TABLE [gbomockup].[Tb_Account] ADD  CONSTRAINT [DF_Tb_Account_WithholdingTax]  DEFAULT ((0)) FOR [WithholdingTax]