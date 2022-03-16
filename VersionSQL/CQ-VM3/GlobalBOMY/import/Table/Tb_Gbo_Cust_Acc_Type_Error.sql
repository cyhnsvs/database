/****** Object:  Table [import].[Tb_Gbo_Cust_Acc_Type_Error]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_Cust_Acc_Type_Error](
	[CustomerUniqueID] [nvarchar](max) NULL,
	[RowIndex] [nvarchar](max) NULL,
	[Action] [nvarchar](max) NULL,
	[AccountType] [nvarchar](max) NULL,
	[Algo] [nvarchar](max) NULL,
	[Foreign_] [nvarchar](max) NULL,
	[DealerCode] [nvarchar](max) NULL,
	[Financier] [nvarchar](max) NULL,
	[OnlineTradingAccess] [nvarchar](max) NULL,
	[SettlementMode] [nvarchar](max) NULL,
	[TransferCreditTransToTrust] [nvarchar](max) NULL,
	[DeductTrustToSettlePurchase] [nvarchar](max) NULL,
	[DeductTrustToSettleDR] [nvarchar](max) NULL,
	[MRCode] [nvarchar](max) NULL,
	[ReferenceSource] [nvarchar](max) NULL,
	[GeneratedCustomerID] [nvarchar](max) NULL,
	[CDSNo] [nvarchar](max) NULL,
	[ImportStatus] [nvarchar](max) NULL,
	[ImportRemarks] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]