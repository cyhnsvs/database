/****** Object:  Table [dbo].[NakedShortSellDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[NakedShortSellDetails](
	[BusinessDate] [date] NOT NULL,
	[RowNum] [bigint] NOT NULL,
	[ContractNo] [varchar](30) NOT NULL,
	[ContractDate] [date] NULL,
	[AcctNo] [varchar](20) NOT NULL,
	[ClientCd] [varchar](20) NOT NULL,
	[InstrumentId] [bigint] NOT NULL,
	[TransType] [varchar](10) NOT NULL,
	[TradedQty] [decimal](24, 9) NOT NULL,
	[TotQty] [decimal](24, 9) NOT NULL,
	[ShortSellQty] [decimal](24, 9) NOT NULL,
	[Tag4] [varchar](50) NOT NULL,
	[Currcd] [char](3) NOT NULL,
	[FundsourceId] [bigint] NULL,
 CONSTRAINT [PK__NakedSho__BAFEEFFDA269217E] PRIMARY KEY CLUSTERED 
(
	[BusinessDate] ASC,
	[RowNum] ASC,
	[ContractNo] ASC,
	[AcctNo] ASC,
	[InstrumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]