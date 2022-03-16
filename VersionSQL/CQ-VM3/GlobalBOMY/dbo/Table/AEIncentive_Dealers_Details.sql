/****** Object:  Table [dbo].[AEIncentive_Dealers_Details]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AEIncentive_Dealers_Details](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[BusinessDate] [date] NULL,
	[TeamId] [bigint] NULL,
	[AcctExecutiveCd] [varchar](30) NULL,
	[AcctExecutiveCdMR] [varchar](30) NULL,
	[BranchId] [varchar](20) NULL,
	[SetlCurrCd] [varchar](20) NULL,
	[ClientBrokerageSetl] [decimal](24, 9) NULL,
	[IncentiveType] [varchar](50) NULL,
	[IncentiveTierGroupId] [bigint] NULL,
	[IncentiveTierGroupCd] [varchar](20) NULL,
	[IncentiveAmount] [decimal](24, 9) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[AEIncentive_Dealers_Details] ADD  DEFAULT ('') FOR [AcctExecutiveCdMR]
ALTER TABLE [dbo].[AEIncentive_Dealers_Details] ADD  DEFAULT ('') FOR [IncentiveType]
ALTER TABLE [dbo].[AEIncentive_Dealers_Details] ADD  DEFAULT ((0)) FOR [IncentiveAmount]