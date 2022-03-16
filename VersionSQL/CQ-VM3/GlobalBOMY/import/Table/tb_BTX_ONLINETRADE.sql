/****** Object:  Table [import].[tb_BTX_ONLINETRADE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[tb_BTX_ONLINETRADE](
	[TransactionDate] [char](10) NULL,
	[ClientCode] [char](9) NULL,
	[StockCode] [char](6) NULL,
	[OrderType] [char](1) NULL,
	[Price] [char](8) NULL,
	[SequenceNo] [char](8) NULL,
	[TerminalID] [char](3) NULL,
	[MatchedQuantity] [char](8) NULL,
	[BranchCode] [char](3) NULL,
	[OrderSource] [char](1) NULL
) ON [PRIMARY]