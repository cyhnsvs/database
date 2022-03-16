/****** Object:  Table [import].[Tb_N2N_TradeDone]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_N2N_TradeDone](
	[SequenceNumberOfRecord] [int] NULL,
	[TransactionDate] [smalldatetime] NULL,
	[TradingAccount] [char](10) NULL,
	[DealerID] [char](10) NULL,
	[CDSNumber] [char](10) NULL,
	[ExchangeCode] [char](5) NULL,
	[StockCode] [char](10) NULL,
	[Side] [char](1) NULL,
	[Quantity] [decimal](12, 4) NULL,
	[Price] [decimal](6, 4) NULL,
	[ExchangeOrderNumber] [int] NULL,
	[BranchID] [char](5) NULL,
	[ExecutionReferenceID] [int] NULL,
	[SubmittedBy] [char](1) NULL
) ON [PRIMARY]