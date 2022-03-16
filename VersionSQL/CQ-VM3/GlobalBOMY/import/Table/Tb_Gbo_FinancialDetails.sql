/****** Object:  Table [import].[Tb_Gbo_FinancialDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_FinancialDetails](
	[CustomerUniqueID] [int] NULL,
	[RowIndex] [int] NULL,
	[Action_] [varchar](1) NULL,
	[DefaultBankAccount] [varchar](1) NULL,
	[AccountHolderName] [varchar](max) NULL,
	[AccountNumber] [varchar](max) NULL,
	[Bank] [varchar](max) NULL,
	[JointAccount] [varchar](1) NULL,
	[ImportStatus] [varchar](1) NULL,
	[ImportRemarks] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]