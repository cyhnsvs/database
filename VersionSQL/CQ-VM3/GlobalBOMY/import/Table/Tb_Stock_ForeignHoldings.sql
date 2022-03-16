/****** Object:  Table [import].[Tb_Stock_ForeignHoldings]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Stock_ForeignHoldings](
	[Client Code] [varchar](50) NULL,
	[Exchange] [varchar](50) NULL,
	[Product Code] [varchar](50) NULL,
	[Company Name] [varchar](50) NULL,
	[Buy] [varchar](50) NULL,
	[Capital Reduction] [varchar](50) NULL,
	[Cash Offer] [varchar](50) NULL,
	[Reverse Share Split] [varchar](50) NULL,
	[Sell] [varchar](50) NULL,
	[Balance Qty] [varchar](50) NULL
) ON [PRIMARY]