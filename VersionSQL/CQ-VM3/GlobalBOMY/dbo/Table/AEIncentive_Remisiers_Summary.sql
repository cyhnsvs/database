/****** Object:  Table [dbo].[AEIncentive_Remisiers_Summary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AEIncentive_Remisiers_Summary](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[BusinessDate] [date] NULL,
	[AcctExecutiveCd] [varchar](30) NULL,
	[BranchId] [varchar](20) NULL,
	[SetlCurrCd] [varchar](20) NULL,
	[ClientBrokerageSetl] [decimal](24, 9) NULL,
	[IndividualIncentiveAmount] [decimal](24, 9) NULL,
	[KioskIncentiveAmount] [decimal](24, 9) NULL,
	[AdditionalKioskIncentiveAmount] [decimal](24, 9) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[AEIncentive_Remisiers_Summary] ADD  DEFAULT ((0)) FOR [IndividualIncentiveAmount]
ALTER TABLE [dbo].[AEIncentive_Remisiers_Summary] ADD  DEFAULT ((0)) FOR [KioskIncentiveAmount]
ALTER TABLE [dbo].[AEIncentive_Remisiers_Summary] ADD  DEFAULT ((0)) FOR [AdditionalKioskIncentiveAmount]