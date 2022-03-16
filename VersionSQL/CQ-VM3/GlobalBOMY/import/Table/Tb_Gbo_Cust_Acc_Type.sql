/****** Object:  Table [import].[Tb_Gbo_Cust_Acc_Type]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_Cust_Acc_Type](
	[CustomerUniqueID] [int] NULL,
	[RowIndex] [int] NULL,
	[Action] [nvarchar](50) NULL,
	[AccountType] [nvarchar](50) NULL,
	[Algo] [nvarchar](max) NULL,
	[Foreign_] [nvarchar](50) NULL,
	[DealerCode] [nvarchar](max) NULL,
	[Financier] [nvarchar](50) NULL,
	[OnlineTradingAccess] [nvarchar](1) NULL,
	[SettlementMode] [nvarchar](1) NULL,
	[TransferCreditTransToTrust] [nvarchar](1) NULL,
	[DeductTrustToSettlePurchase] [nvarchar](1) NULL,
	[DeductTrustToSettleDR] [nvarchar](50) NULL,
	[MRCode] [nvarchar](max) NULL,
	[ReferenceSource] [nvarchar](max) NULL,
	[GeneratedCustomerID] [nvarchar](100) NULL,
	[CDSNo] [nvarchar](100) NULL,
	[ImportStatus] [varchar](1) NULL,
	[ImportRemarks] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]