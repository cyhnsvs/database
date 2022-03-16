/****** Object:  Table [import].[Tb_StockSectorLimitInfo_SampleData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_StockSectorLimitInfo_SampleData](
	[RecordType] [char](1) NULL,
	[ExchangeCode] [char](10) NULL,
	[SectorName] [char](50) NULL,
	[SectorCode] [char](10) NULL,
	[BuyLimit] [char](16) NULL,
	[SellLimit] [char](16) NULL,
	[NetLimit] [char](16) NULL,
	[TotalLimit] [char](16) NULL,
	[BuyTopup] [char](16) NULL,
	[SellTopup] [char](16) NULL,
	[NetTopup] [char](16) NULL,
	[TotalTopup] [char](16) NULL,
	[BuyPrevOrderAmt] [char](16) NULL,
	[SellPrevOrderAmt] [char](16) NULL,
	[NetPrevOrderAmt] [char](16) NULL,
	[TotalPrevOrderAmt] [char](16) NULL,
	[LimitCheckFlag] [char](1) NULL,
	[Filler] [char](3) NULL,
	[LastPosition] [char](1) NULL
) ON [PRIMARY]