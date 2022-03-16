/****** Object:  Table [import].[Tb_TradeCharge]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_TradeCharge](
	[TradeChargesKey] [varchar](10) NOT NULL,
	[combination] [varchar](30) NOT NULL,
	[MarketCode] [varchar](4) NOT NULL,
	[TradeType] [varchar](10) NOT NULL,
	[Sequence] [int] NOT NULL,
	[TransactionCode] [char](2) NOT NULL,
	[TransactionSubCode] [char](1) NOT NULL,
	[TradeSource] [varchar](5) NOT NULL,
	[BrokerageCode] [char](2) NOT NULL,
	[ClearingFeeCode] [char](3) NOT NULL,
	[ContractStamp] [char](3) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]