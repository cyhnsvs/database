/****** Object:  Table [import].[PSPL_ExchangeRate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_ExchangeRate](
	[RecordDate] [nvarchar](255) NULL,
	[BaseCurrencyCode] [nvarchar](255) NULL,
	[OtherCurrencyCode] [nvarchar](255) NULL,
	[BidRate] [nvarchar](255) NULL,
	[OfferRate] [nvarchar](255) NULL,
	[AverageRate] [nvarchar](255) NULL,
	[SourceFileName] [nvarchar](255) NULL,
	[ImportedDateTime] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [import].[PSPL_ExchangeRate] ADD  CONSTRAINT [DF_PSPL_ExchangeRate_ImportedDateTime]  DEFAULT (getdate()) FOR [ImportedDateTime]