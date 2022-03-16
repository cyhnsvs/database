/****** Object:  Table [dbo].[CashApprovedLimit_Margin]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CashApprovedLimit_Margin](
	[BusinessDate] [date] NULL,
	[AcctNo] [varchar](30) NULL,
	[FormulaSelected] [varchar](30) NULL,
	[AutoOrManual] [char](1) NULL,
	[ApprovedLimit] [decimal](24, 9) NULL,
	[CalBuyLimit] [decimal](24, 9) NULL,
	[RealBuyLimit] [decimal](24, 9) NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifedBy] [varchar](64) NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CashApprovedLimit_Margin] ADD  CONSTRAINT [DF__CashAppro__AutoO__2B947552]  DEFAULT ('A') FOR [AutoOrManual]
ALTER TABLE [dbo].[CashApprovedLimit_Margin] ADD  CONSTRAINT [DF__CashAppro__Appro__2C88998B]  DEFAULT ((0)) FOR [ApprovedLimit]
ALTER TABLE [dbo].[CashApprovedLimit_Margin] ADD  CONSTRAINT [DF_CashApprovedLimit_Margin_CreatedBy]  DEFAULT ('SYSTEM') FOR [CreatedBy]
ALTER TABLE [dbo].[CashApprovedLimit_Margin] ADD  CONSTRAINT [DF_CashApprovedLimit_Margin_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[CashApprovedLimit_Margin] ADD  CONSTRAINT [DF_CashApprovedLimit_Margin_CreatedDate1]  DEFAULT (getdate()) FOR [ModifiedDate]