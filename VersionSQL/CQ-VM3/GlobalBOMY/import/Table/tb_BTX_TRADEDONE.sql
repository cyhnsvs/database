/****** Object:  Table [import].[tb_BTX_TRADEDONE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[tb_BTX_TRADEDONE](
	[OrderNo] [decimal](20, 0) NULL,
	[RefNo] [decimal](20, 0) NULL,
	[OrderID] [decimal](20, 0) NULL,
	[Status] [char](2) NULL,
	[OrderStatus] [char](1) NULL,
	[AccountNo] [char](7) NULL,
	[CompanyCode] [char](10) NULL,
	[Side] [decimal](1, 0) NULL,
	[OrderTime] [char](20) NULL,
	[Price] [decimal](20, 0) NULL,
	[OrderQty] [decimal](10, 0) NULL,
	[ExecutedQty] [decimal](10, 0) NULL,
	[ExecutedPrice] [decimal](20, 4) NULL,
	[Market] [char](2) NULL,
	[RemisierCode] [char](3) NULL,
	[Symbol] [char](12) NULL,
	[SymbolSfx] [char](15) NULL,
	[ExecutedTime] [char](20) NULL,
	[CustomerRef] [char](20) NULL,
	[TradedCurr] [char](20) NULL,
	[SettlementCurr] [char](20) NULL,
	[ExchangeRate] [char](20) NULL,
	[ClientSettCurr] [char](20) NULL,
	[Originator] [char](20) NULL,
	[OriginatorUT] [decimal](1, 0) NULL,
	[LastModified] [char](20) NULL,
	[LastModifiedUT] [decimal](1, 0) NULL,
	[InverseExchangeRate] [char](25) NULL,
	[ExchangeCode] [char](5) NULL
) ON [PRIMARY]