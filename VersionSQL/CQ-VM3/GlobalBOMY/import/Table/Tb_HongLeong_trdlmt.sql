/****** Object:  Table [import].[Tb_HongLeong_trdlmt]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_HongLeong_trdlmt](
	[BrokerCode] [varchar](6) NULL,
	[FICode] [varchar](4) NULL,
	[ClientCDSNo] [varchar](20) NULL,
	[TradingLine] [decimal](15, 2) NULL,
	[EntryDate] [varchar](6) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]