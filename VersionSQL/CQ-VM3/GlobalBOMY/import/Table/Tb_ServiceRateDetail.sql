/****** Object:  Table [import].[Tb_ServiceRateDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ServiceRateDetail](
	[ServiceRateCode] [char](3) NOT NULL,
	[ServiceRateEntryNumber] [int] NOT NULL,
	[ServiceRatePercent] [decimal](24, 9) NOT NULL,
	[NextTierRange] [decimal](24, 9) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]