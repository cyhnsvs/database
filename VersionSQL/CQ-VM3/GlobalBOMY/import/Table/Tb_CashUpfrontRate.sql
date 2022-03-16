/****** Object:  Table [import].[Tb_CashUpfrontRate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CashUpfrontRate](
	[ACCTGRPCD] [char](5) NOT NULL,
	[MRKTCD] [char](4) NOT NULL,
	[TRADETYPE] [varchar](10) NOT NULL,
	[BRKGCD] [char](2) NOT NULL,
	[CLRFEECD] [char](3) NOT NULL,
	[DOCSTMCD] [char](3) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]