/****** Object:  Table [import].[Tb_DMA_Trades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_DMA_Trades](
	[CTR_Date] [char](8) NULL,
	[CDSNo] [char](16) NULL,
	[StockCode] [char](10) NULL,
	[BuySell] [char](9) NULL,
	[Price] [decimal](10, 3) NULL,
	[OrderNo] [decimal](22, 0) NULL,
	[TerminalId] [decimal](11, 0) NULL,
	[Qty] [decimal](10, 0) NULL,
	[ClientRef] [char](16) NULL,
	[Ack] [char](10) NULL,
	[Memo] [char](20) NULL,
	[PrevOrderNo] [char](22) NULL
) ON [PRIMARY]