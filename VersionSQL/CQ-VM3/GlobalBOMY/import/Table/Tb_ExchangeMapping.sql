/****** Object:  Table [import].[Tb_ExchangeMapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ExchangeMapping](
	[ExchCd] [char](4) NOT NULL,
	[GBOExchCd] [char](4) NOT NULL,
	[Country] [char](2) NOT NULL,
	[ExchDesc] [varchar](200) NULL
) ON [PRIMARY]