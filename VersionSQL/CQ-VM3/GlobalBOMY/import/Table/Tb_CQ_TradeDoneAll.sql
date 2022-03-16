/****** Object:  Table [import].[Tb_CQ_TradeDoneAll]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CQ_TradeDoneAll](
	[OrderNo] [char](20) NULL,
	[RefNo] [char](20) NULL,
	[OrderID] [char](20) NULL,
	[Status] [char](2) NULL,
	[OrdStatus] [char](1) NULL,
	[AcctN] [char](7) NULL,
	[CompanyCode] [char](10) NULL,
	[Side] [char](1) NULL,
	[OrderTime] [char](20) NULL,
	[Price] [decimal](20, 8) NULL,
	[OrderQty] [decimal](10, 0) NULL,
	[ExecutedQty] [decimal](10, 0) NULL,
	[ExecutedPrice] [decimal](20, 8) NULL,
	[Market] [char](2) NULL,
	[RemisierCode] [char](3) NULL,
	[Symbol] [char](12) NULL,
	[SymbolSfx] [char](15) NULL,
	[ExecutedTime] [char](20) NULL,
	[CustomerRef] [char](20) NULL,
	[TradedCurr] [char](20) NULL,
	[SettlementCurr] [char](20) NULL,
	[ExchangeRate] [decimal](20, 6) NULL,
	[ClientSettCurr] [char](20) NULL,
	[Originator] [char](20) NULL,
	[OriginatorUT] [char](1) NULL,
	[LastModified] [char](20) NULL,
	[LastModifiedUT] [char](1) NULL,
	[InverseExchangeRate] [char](25) NULL
) ON [PRIMARY]