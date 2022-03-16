/****** Object:  Table [import].[PSPL_ManStockInfo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_ManStockInfo](
	[CompanyCode] [nvarchar](255) NULL,
	[CompanyName] [nvarchar](255) NULL,
	[ChineseName] [nvarchar](255) NULL,
	[MinQty] [nvarchar](255) NULL,
	[CurrencyCode] [nvarchar](255) NULL,
	[SecurityID] [nvarchar](255) NULL,
	[SecurityCode] [nvarchar](255) NULL,
	[Market] [nvarchar](255) NULL,
	[Exchange] [nvarchar](255) NULL,
	[Symbol] [nvarchar](255) NULL,
	[Symbolsfx] [nvarchar](255) NULL,
	[StartDate] [nvarchar](255) NULL,
	[ExpiryDate] [nvarchar](255) NULL,
	[CounterStatus] [nvarchar](255) NULL,
	[SecurityType] [nvarchar](255) NULL,
	[ISINCode] [nvarchar](255) NULL,
	[SourceFileName] [nvarchar](255) NULL,
	[ImportedDateTime] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [import].[PSPL_ManStockInfo] ADD  CONSTRAINT [DF_PSPL_ManStockInfo_ImportedDateTime]  DEFAULT (getdate()) FOR [ImportedDateTime]