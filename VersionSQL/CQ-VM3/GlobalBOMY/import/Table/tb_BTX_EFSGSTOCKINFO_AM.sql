/****** Object:  Table [import].[tb_BTX_EFSGSTOCKINFO_AM]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[tb_BTX_EFSGSTOCKINFO_AM](
	[StockCode] [char](10) NULL,
	[StockName] [char](60) NULL,
	[StockChineseName] [char](60) NULL,
	[MinQuantity] [decimal](10, 0) NULL,
	[CurrencyCode] [char](3) NULL,
	[SecurityID] [char](12) NULL,
	[SecurityCode] [char](4) NULL,
	[Market] [char](2) NULL,
	[ExchangeCode] [char](4) NULL,
	[Symbol] [char](12) NULL,
	[SymbolSuffix] [char](15) NULL,
	[StartDate] [char](11) NULL,
	[ExpiryDate] [char](11) NULL,
	[CounterStatus] [char](1) NULL,
	[SecurityType] [char](1) NULL,
	[ISINCode] [char](12) NULL,
	[PrimaryTradingCounter] [char](10) NULL,
	[BoardCode] [char](3) NULL,
	[SectorCode] [char](3) NULL,
	[IssuedShares] [decimal](20, 0) NULL,
	[LastDonePrice] [decimal](25, 6) NULL,
	[StockShortName] [char](50) NULL,
	[ReferencePrice] [decimal](25, 6) NULL
) ON [PRIMARY]