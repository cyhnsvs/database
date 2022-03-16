/****** Object:  Table [import].[Tb_CQ_StockHoldings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CQ_StockHoldings](
	[ClientCode] [char](7) NULL,
	[ClientName] [char](100) NULL,
	[LastUpdate] [char](20) NULL,
	[CompanyCode] [char](10) NULL,
	[ISINCode] [char](12) NULL,
	[SecurityFundName] [char](60) NULL,
	[StockUnitOnHand] [decimal](25, 0) NULL,
	[SuspQty] [decimal](25, 0) NULL,
	[PurchasesDue] [decimal](25, 0) NULL,
	[SalesDue] [decimal](25, 0) NULL,
	[OutstandingPurchases] [decimal](25, 0) NULL,
	[OutstandingSales] [decimal](25, 0) NULL,
	[Total] [decimal](25, 0) NULL,
	[Seccd] [char](15) NULL,
	[Market] [char](10) NULL,
	[LstDonePx] [decimal](25, 0) NULL,
	[Currcd] [char](10) NULL,
	[AverageCost] [decimal](25, 0) NULL,
	[CurrcdAvgCost] [char](10) NULL
) ON [PRIMARY]