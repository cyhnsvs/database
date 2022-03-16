/****** Object:  Table [import].[Tb_BTX_SCOTRS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BTX_SCOTRS](
	[RecordType] [varchar](1) NULL,
	[SellerBrokerNo] [varchar](3) NULL,
	[SellerBrokerBranch] [varchar](3) NULL,
	[SellerCDSAcctNo] [varchar](9) NULL,
	[TradeDate] [varchar](8) NULL,
	[TRSNo] [varchar](8) NULL,
	[BuyerBrokerNo] [varchar](3) NULL,
	[BuyerBrokerBranch] [varchar](3) NULL,
	[BuyerCDSAcctNo] [varchar](9) NULL,
	[Side] [varchar](1) NULL,
	[StockCode] [varchar](6) NULL,
	[Qty] [varchar](9) NULL,
	[Price] [varchar](6) NULL,
	[LotCode] [varchar](1) NULL,
	[TerminalId] [varchar](3) NULL,
	[OrderNo] [varchar](8) NULL,
	[ShortSell] [varchar](1) NULL,
	[SourceFileName] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]