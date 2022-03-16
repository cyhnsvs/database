/****** Object:  Table [import].[Tb_RebateRate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_RebateRate](
	[REBATECD] [char](2) NOT NULL,
	[EFFECTDT] [char](10) NOT NULL,
	[DESCRIPTN] [varchar](30) NOT NULL,
	[REBATERT] [decimal](24, 9) NOT NULL,
	[MINREBTAMT] [decimal](24, 9) NOT NULL,
	[MAXREBTAMT] [decimal](24, 9) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]