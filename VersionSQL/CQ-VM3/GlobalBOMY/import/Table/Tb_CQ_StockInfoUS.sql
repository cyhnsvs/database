/****** Object:  Table [import].[Tb_CQ_StockInfoUS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CQ_StockInfoUS](
	[CompanyCode] [char](10) NULL,
	[CompanyName] [char](60) NULL,
	[ChineseName] [char](60) NULL,
	[MinQty] [decimal](10, 0) NULL,
	[CurrencyCode] [char](3) NULL,
	[SecurityID] [char](12) NULL,
	[SecurityCode] [char](4) NULL,
	[Market] [char](2) NULL,
	[Exchange] [char](4) NULL,
	[Symbol] [char](12) NULL,
	[Symbolsfx] [char](15) NULL,
	[StartDate] [char](11) NULL,
	[ExpiryDate] [char](11) NULL,
	[CounterStatus] [char](1) NULL,
	[SecurityType] [char](1) NULL,
	[ISINCode] [char](12) NULL,
	[PrimaryTradingCounter] [char](10) NULL
) ON [PRIMARY]