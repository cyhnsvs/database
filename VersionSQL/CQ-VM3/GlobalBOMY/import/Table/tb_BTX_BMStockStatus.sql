/****** Object:  Table [import].[tb_BTX_BMStockStatus]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[tb_BTX_BMStockStatus](
	[StockCode] [char](10) NULL,
	[SyariahStockIndicator] [char](60) NULL,
	[StockIndexCode] [char](60) NULL,
	[ShortSellIndicator] [char](10) NULL,
	[StockStatus] [char](3) NULL,
	[BoardCode] [char](12) NULL,
	[SectorCode] [char](4) NULL,
	[MarketCode] [char](2) NULL,
	[ParentStockNo] [char](10) NULL,
	[SecurityType] [char](1) NULL,
	[IssuedShares] [decimal](20, 0) NULL,
	[ISIN] [char](12) NULL,
	[SecurityCurrency] [char](3) NULL,
	[LastDonePrice] [decimal](25, 6) NULL,
	[ListingDate] [char](11) NULL,
	[ExpiryDate] [char](11) NULL,
	[PN17GN3Indicator] [char](1) NULL,
	[BoardLotSize] [decimal](10, 0) NULL,
	[StockName] [char](60) NULL,
	[StockShortName] [char](50) NULL,
	[ReferencePrice] [decimal](25, 6) NULL
) ON [PRIMARY]