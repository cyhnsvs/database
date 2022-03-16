/****** Object:  Table [import].[PSPL_TradeDone_MAN]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_TradeDone_MAN](
	[order_no] [nvarchar](255) NULL,
	[ref_no] [nvarchar](255) NULL,
	[OrderID] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[OrdStatus] [nvarchar](255) NULL,
	[Acct_no] [nvarchar](255) NULL,
	[Company_code] [nvarchar](255) NULL,
	[Side] [nvarchar](255) NULL,
	[Order_time] [nvarchar](255) NULL,
	[Price] [nvarchar](255) NULL,
	[OrderQty] [nvarchar](255) NULL,
	[ExecutedQty] [nvarchar](255) NULL,
	[Executed_Price] [nvarchar](255) NULL,
	[Market] [nvarchar](255) NULL,
	[Remisier_code] [nvarchar](255) NULL,
	[Symbol] [nvarchar](255) NULL,
	[SymbolSfx] [nvarchar](255) NULL,
	[Executed_time] [nvarchar](255) NULL,
	[CustomerRef] [nvarchar](255) NULL,
	[TradedCurr] [nvarchar](255) NULL,
	[SettlementCurr] [nvarchar](255) NULL,
	[ExchangeRate] [nvarchar](255) NULL,
	[ClientSettCurr] [nvarchar](255) NULL,
	[Originator] [nvarchar](255) NULL,
	[OriginatorUT] [nvarchar](255) NULL,
	[LastModified] [nvarchar](255) NULL,
	[LastModifiedUT] [nvarchar](255) NULL,
	[InverseExchangeRate] [nvarchar](255) NULL,
	[SourceFileName] [nvarchar](255) NULL,
	[ImportedDateTime] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [import].[PSPL_TradeDone_MAN] ADD  CONSTRAINT [DF_PSPL_TradeDone_MAN_ImportedDateTime]  DEFAULT (getdate()) FOR [ImportedDateTime]