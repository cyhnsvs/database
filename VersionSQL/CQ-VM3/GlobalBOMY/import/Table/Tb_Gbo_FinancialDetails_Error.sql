/****** Object:  Table [import].[Tb_Gbo_FinancialDetails_Error]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_FinancialDetails_Error](
	[CustomerUniqueID] [varchar](max) NULL,
	[RowIndex] [varchar](max) NULL,
	[Action_] [varchar](max) NULL,
	[DefaultBankAccount] [varchar](max) NULL,
	[AccountHolderName] [varchar](max) NULL,
	[AccountNumber] [varchar](max) NULL,
	[Bank] [varchar](max) NULL,
	[JointAccount] [varchar](max) NULL,
	[ImportStatus] [nvarchar](max) NULL,
	[ImportRemarks] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]