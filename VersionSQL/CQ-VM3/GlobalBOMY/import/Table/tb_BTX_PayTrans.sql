/****** Object:  Table [import].[tb_BTX_PayTrans]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[tb_BTX_PayTrans](
	[RecordType] [decimal](1, 0) NULL,
	[ClientCode] [char](15) NULL,
	[BranchCode] [decimal](3, 0) NULL,
	[TransactionType] [char](2) NULL,
	[TransactionNo] [decimal](20, 0) NULL,
	[BankName] [char](50) NULL,
	[BankBranch] [char](100) NULL,
	[BankAccount] [char](30) NULL,
	[PaymentMethodType] [char](3) NULL,
	[TransactionAmount] [decimal](18, 2) NULL,
	[Currency] [char](3) NULL,
	[ConvertToMYR] [char](1) NULL,
	[Remarks] [char](50) NULL,
	[DepositType] [char](2) NULL,
	[DepositDate] [datetime] NULL,
	[DepositTime] [datetime] NULL,
	[ChequeNo] [decimal](6, 0) NULL,
	[ContractContraOthersNo] [char](11) NULL,
	[TradeDate] [datetime] NULL,
	[Quantity] [decimal](10, 0) NULL,
	[InterestAmountPaid] [decimal](18, 2) NULL,
	[PaymentByTrust] [decimal](18, 2) NULL,
	[PaymentByBank] [decimal](18, 2) NULL,
	[BankRefNo] [char](30) NULL,
	[FPXtransactionId] [char](20) NULL,
	[Filler] [char](15) NULL
) ON [PRIMARY]