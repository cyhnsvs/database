/****** Object:  Table [dbo].[Tb_IDSS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tb_IDSS](
	[RowNum] [bigint] IDENTITY(1,1) NOT NULL,
	[BusinessDate] [date] NOT NULL,
	[TransNoOut] [varchar](30) NOT NULL,
	[InstrumentId] [bigint] NOT NULL,
	[TradedQtyOut] [decimal](24, 9) NOT NULL,
	[MatchQty] [decimal](24, 9) NOT NULL,
	[RemaingQty] [decimal](24, 9) NOT NULL,
	[TransNoIn] [varchar](50) NULL,
	[TradedQtyIn] [decimal](24, 9) NOT NULL,
	[ShortSellQty] [decimal](24, 9) NOT NULL,
 CONSTRAINT [PK_FIFOByLot_ProcessOutMatchDetails] PRIMARY KEY CLUSTERED 
(
	[RowNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]