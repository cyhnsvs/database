/****** Object:  Table [import].[Tb_BURSA_CFT001]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BURSA_CFT001](
	[RecordType] [varchar](1) NULL,
	[StockCode] [varchar](6) NULL,
	[ContractDate] [varchar](8) NULL,
	[SellerTRSNo] [varchar](9) NULL,
	[SellerAcctNo] [varchar](9) NULL,
	[TradedQty] [varchar](10) NULL,
	[QtyShortfall] [varchar](10) NULL,
	[CreatedDate] [date] NULL,
	[FileName] [varchar](100) NULL
) ON [PRIMARY]