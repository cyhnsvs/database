/****** Object:  Table [import].[PSPL_StockInfo_Archive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_StockInfo_Archive](
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
	[PrimaryTradingCounter] [nvarchar](255) NULL,
	[SourceFileName] [nvarchar](255) NULL,
	[ImportedDateTime] [datetime] NULL,
	[ArchiveDateTime] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [import].[PSPL_StockInfo_Archive] ADD  CONSTRAINT [DF_PSPL_StockInfo_Archive_ArchiveDateTime]  DEFAULT (getdate()) FOR [ArchiveDateTime]