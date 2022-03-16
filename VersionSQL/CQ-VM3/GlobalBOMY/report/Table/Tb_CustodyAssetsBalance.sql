/****** Object:  Table [report].[Tb_CustodyAssetsBalance]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [report].[Tb_CustodyAssetsBalance](
	[BusinessDate] [date] NOT NULL,
	[AcctNo] [varchar](50) NOT NULL,
	[InstrumentId] [bigint] NOT NULL,
	[ChequeName] [varchar](200) NOT NULL,
	[FundSourceId] [bigint] NOT NULL,
	[FundSourceDesc] [varchar](50) NOT NULL,
	[InstrCode] [varchar](50) NOT NULL,
	[InstrName] [varchar](200) NOT NULL,
	[SettledBalance] [decimal](24, 9) NOT NULL,
	[UnavailableBalance] [decimal](24, 9) NOT NULL,
	[RPBalance] [decimal](24, 9) NOT NULL,
	[TotTradedQty] [decimal](24, 9) NOT NULL,
	[TotTradedQty1] [decimal](24, 9) NOT NULL,
	[TotTradedQty2] [decimal](24, 9) NOT NULL,
	[FinalBalance] [decimal](24, 9) NOT NULL,
	[T] [date] NULL,
	[T1] [date] NULL,
	[T2] [date] NULL,
	[Cost] [decimal](24, 9) NULL,
	[CostAmount] [decimal](24, 9) NULL,
	[ClosingPrice] [decimal](24, 9) NULL,
	[MarketValue] [decimal](24, 9) NULL
) ON [PRIMARY]