/****** Object:  Table [import].[PSPL_StockHolding_Archive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_StockHolding_Archive](
	[Client Code] [nvarchar](250) NULL,
	[Client Name] [nvarchar](250) NULL,
	[Last Update] [nvarchar](250) NULL,
	[Company Code] [nvarchar](250) NULL,
	[ISIN code] [nvarchar](250) NULL,
	[Security / Fund Name] [nvarchar](250) NULL,
	[Stock / Unit On Hand] [nvarchar](250) NULL,
	[Susp Qty] [nvarchar](250) NULL,
	[Purchases Due] [nvarchar](250) NULL,
	[Sales Due] [nvarchar](250) NULL,
	[Outstanding Purchases] [nvarchar](250) NULL,
	[Outstanding Sales] [nvarchar](250) NULL,
	[Total] [nvarchar](250) NULL,
	[Seccd] [nvarchar](250) NULL,
	[Market] [nvarchar](250) NULL,
	[LstDonePx] [nvarchar](250) NULL,
	[Currcd] [nvarchar](250) NULL,
	[AverageCost] [nvarchar](250) NULL,
	[CurrcdAvgCost] [nvarchar](250) NULL,
	[sourceFileName] [nvarchar](250) NULL,
	[importDate] [datetime] NULL,
	[ArchiveDateTime] [datetime2](0) NULL
) ON [PRIMARY]