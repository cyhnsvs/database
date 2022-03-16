/****** Object:  Table [import].[Tb_BrokerageRateDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BrokerageRateDetail](
	[BRKGCD] [char](2) NOT NULL,
	[EFFECTDT] [varchar](10) NOT NULL,
	[BKGRTENTNO] [int] NOT NULL,
	[ENDVALUE] [decimal](24, 9) NOT NULL,
	[BRKGRT] [decimal](24, 9) NOT NULL,
	[BRKGAMT] [decimal](24, 9) NOT NULL,
	[DLRCOMMR] [decimal](24, 9) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]