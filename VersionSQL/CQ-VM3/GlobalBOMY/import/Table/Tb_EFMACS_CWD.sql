/****** Object:  Table [import].[Tb_EFMACS_CWD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_EFMACS_CWD](
	[RecordType] [varchar](1) NULL,
	[TransactionDate] [varchar](20) NULL,
	[ReferenceNo] [varchar](20) NULL,
	[ClientBranchCode] [varchar](5) NULL,
	[ClientCode] [varchar](15) NULL,
	[AvailableTrustAmt] [varchar](15) NULL,
	[BankDeposited] [varchar](10) NULL,
	[BankAcct] [varchar](20) NULL,
	[WithdrawalAmt] [varchar](15) NULL,
	[Remarks] [varchar](120) NULL,
	[WithdrawalType] [varchar](5) NULL,
	[Status] [varchar](3) NULL,
	[SourceFileName] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]