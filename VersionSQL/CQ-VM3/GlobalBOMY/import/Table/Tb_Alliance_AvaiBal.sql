/****** Object:  Table [import].[Tb_Alliance_AvaiBal]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Alliance_AvaiBal](
	[BrokerShortName] [varchar](6) NULL,
	[FileType] [varchar](4) NULL,
	[CDSAcctNo] [varchar](15) NULL,
	[TradingLimit] [varchar](20) NULL,
	[DateOfTradingLimit] [varchar](10) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]