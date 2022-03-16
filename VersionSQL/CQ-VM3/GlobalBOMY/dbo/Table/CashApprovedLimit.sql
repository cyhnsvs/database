/****** Object:  Table [dbo].[CashApprovedLimit]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CashApprovedLimit](
	[BusinessDate] [date] NULL,
	[AcctNo] [varchar](30) NULL,
	[AcctServiceType] [varchar](20) NULL,
	[ParentGroup] [varchar](20) NULL,
	[CashMultiplier] [decimal](24, 9) NULL,
	[CollMultiplier] [decimal](24, 9) NULL,
	[ApprovedLimit] [decimal](24, 9) NULL,
	[AvailableCleanLimit] [decimal](24, 9) NULL,
	[CashBalance] [decimal](24, 9) NULL,
	[PendingCashBalance] [decimal](24, 9) NULL,
	[TotalCashBalance] [decimal](24, 9) NULL,
	[DrPurchase] [decimal](24, 9) NULL,
	[DrContraLoss] [decimal](24, 9) NULL,
	[DrSetoffLoss] [decimal](24, 9) NULL,
	[DrInterest] [decimal](24, 9) NULL,
	[DrNonTrade] [decimal](24, 9) NULL,
	[TotalDebit] [decimal](24, 9) NULL,
	[CrSales] [decimal](24, 9) NULL,
	[CrSalesT1] [decimal](24, 9) NULL,
	[CrContraGain] [decimal](24, 9) NULL,
	[CrSetoffGain] [decimal](24, 9) NULL,
	[CrInterest] [decimal](24, 9) NULL,
	[CrNonTrade] [decimal](24, 9) NULL,
	[TotalCredit] [decimal](24, 9) NULL,
	[NetCreditDebit] [decimal](24, 9) NULL,
	[NetOSBalance] [decimal](24, 9) NULL,
	[CappedMktValue] [decimal](24, 9) NULL,
	[CapBuyLimit] [decimal](24, 9) NULL,
	[CalBuyLimit] [decimal](24, 9) NULL,
	[RealBuyLimit] [decimal](24, 9) NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifedBy] [varchar](30) NULL,
	[ModifiedDate] [datetime] NULL,
	[DrOverduePurchase] [decimal](24, 9) NULL,
	[DrUnrealizedLoss] [decimal](24, 9) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CashM__67DE6983]  DEFAULT ((1)) FOR [CashMultiplier]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CollM__68D28DBC]  DEFAULT ((1)) FOR [CollMultiplier]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__Appro__69C6B1F5]  DEFAULT ((0)) FOR [ApprovedLimit]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__Avail__6ABAD62E]  DEFAULT ((0)) FOR [AvailableCleanLimit]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CashB__6BAEFA67]  DEFAULT ((0)) FOR [CashBalance]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__Pendi__6CA31EA0]  DEFAULT ((0)) FOR [PendingCashBalance]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__Total__6D9742D9]  DEFAULT ((0)) FOR [TotalCashBalance]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__DrPur__6E8B6712]  DEFAULT ((0)) FOR [DrPurchase]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__DrCon__6F7F8B4B]  DEFAULT ((0)) FOR [DrContraLoss]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__DrSet__7073AF84]  DEFAULT ((0)) FOR [DrSetoffLoss]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__DrInt__7167D3BD]  DEFAULT ((0)) FOR [DrInterest]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__DrNon__725BF7F6]  DEFAULT ((0)) FOR [DrNonTrade]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__Total__73501C2F]  DEFAULT ((0)) FOR [TotalDebit]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CrSal__74444068]  DEFAULT ((0)) FOR [CrSales]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CrSal__753864A1]  DEFAULT ((0)) FOR [CrSalesT1]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CrCon__762C88DA]  DEFAULT ((0)) FOR [CrContraGain]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CrSet__7720AD13]  DEFAULT ((0)) FOR [CrSetoffGain]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CrInt__7814D14C]  DEFAULT ((0)) FOR [CrInterest]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__CrNon__7908F585]  DEFAULT ((0)) FOR [CrNonTrade]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__Total__79FD19BE]  DEFAULT ((0)) FOR [TotalCredit]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__NetCr__7AF13DF7]  DEFAULT ((0)) FOR [NetCreditDebit]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__NetOS__7BE56230]  DEFAULT ((0)) FOR [NetOSBalance]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF__CashAppro__Cappe__7CD98669]  DEFAULT ((0)) FOR [CappedMktValue]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF_CashApprovedLimit_CreatedBy]  DEFAULT ('SYSTEM') FOR [CreatedBy]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF_CashApprovedLimit_CreatedDate_1]  DEFAULT (getdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[CashApprovedLimit] ADD  CONSTRAINT [DF_CashApprovedLimit_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]