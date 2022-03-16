/****** Object:  Table [import].[Tb_ECOS_WithdrawalInfo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ECOS_WithdrawalInfo](
	[RequestNo] [varchar](255) NULL,
	[ClientCode] [varchar](255) NULL,
	[RequestDate] [varchar](255) NULL,
	[AvailTrustAmt] [varchar](255) NULL,
	[BankDeposit] [varchar](255) NULL,
	[BankAcctNo] [varchar](255) NULL,
	[WithdrawalAmt] [varchar](255) NULL,
	[Remarks] [varchar](255) NULL,
	[WithdrawalType] [varchar](255) NULL,
	[ReceiptNo] [varchar](255) NULL,
	[Status] [varchar](255) NULL,
	[LastUpdated] [varchar](255) NULL,
	[UpdatedBy] [varchar](255) NULL,
	[SubmittedBy] [varchar](255) NULL,
	[AvailTrustAmtMinusOS] [varchar](255) NULL,
	[SourceFileName] [varchar](255) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]