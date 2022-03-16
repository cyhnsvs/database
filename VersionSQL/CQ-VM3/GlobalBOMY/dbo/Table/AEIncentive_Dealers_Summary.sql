/****** Object:  Table [dbo].[AEIncentive_Dealers_Summary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AEIncentive_Dealers_Summary](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[BusinessDate] [date] NULL,
	[TeamId] [bigint] NULL,
	[AcctExecutiveCd] [varchar](30) NULL,
	[BranchId] [varchar](20) NULL,
	[SetlCurrCd] [varchar](20) NULL,
	[ClientBrokerageSetl] [decimal](24, 9) NULL,
	[IncentiveAmount] [decimal](24, 9) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[AEIncentive_Dealers_Summary] ADD  DEFAULT ((0)) FOR [IncentiveAmount]