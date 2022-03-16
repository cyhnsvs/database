/****** Object:  Table [import].[Tb_N2N_Trade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_N2N_Trade](
	[DefaultValue] [char](1) NULL,
	[ClientName] [char](30) NULL,
	[AccountNumber] [char](9) NULL,
	[DealerCode] [char](5) NULL,
	[GroupID] [char](8) NULL,
	[StockCode] [char](6) NULL,
	[OrderType] [char](1) NULL,
	[OrderForm] [char](1) NULL,
	[OrderSource] [char](1) NULL,
	[ExchangeOrderNumber] [char](11) NULL,
	[OrderNumber] [char](12) NULL,
	[QuantityMatch] [numeric](9, 0) NULL,
	[AveragePrice] [numeric](9, 0) NULL,
	[Created] [datetime] NULL,
	[SourceFileName] [char](50) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]