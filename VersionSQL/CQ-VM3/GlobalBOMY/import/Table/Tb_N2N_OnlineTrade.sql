/****** Object:  Table [import].[Tb_N2N_OnlineTrade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_N2N_OnlineTrade](
	[ConDate] [datetime] NULL,
	[ClientNo] [char](9) NULL,
	[StockNo] [char](6) NULL,
	[BuySell] [char](1) NULL,
	[MatchedPrice] [char](8) NULL,
	[OrderNo] [char](8) NULL,
	[TerminalNo] [char](3) NULL,
	[MatchedQty] [char](8) NULL,
	[BranchId] [char](3) NULL,
	[OnlineFlag] [char](1) NULL
) ON [PRIMARY]