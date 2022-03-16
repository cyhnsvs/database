/****** Object:  Table [import].[Tb_ForeignExchangeRate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ForeignExchangeRate](
	[CurrencyCode] [varchar](50) NULL,
	[BaseCurrency] [varchar](50) NULL,
	[BuyRate] [varchar](50) NULL,
	[SellRate] [varchar](50) NULL,
	[ForexAsAt] [varchar](50) NULL,
	[UserCreated] [varchar](50) NULL,
	[DateCreated] [varchar](50) NULL,
	[TimeCreated] [varchar](50) NULL,
	[UserUpdated] [varchar](50) NULL,
	[DateUpdated] [varchar](50) NULL,
	[TimeUpdated] [varchar](50) NULL
) ON [PRIMARY]