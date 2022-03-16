/****** Object:  Table [import].[Tb_CQ_ExchangeRateAM]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CQ_ExchangeRateAM](
	[RecordDate] [char](8) NULL,
	[BaseCurrencyCode] [char](15) NULL,
	[OtherCurrencyCode] [char](15) NULL,
	[BidRate] [decimal](24, 0) NULL,
	[OfferRate] [decimal](24, 0) NULL,
	[AverageRate] [decimal](24, 0) NULL
) ON [PRIMARY]