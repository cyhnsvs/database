/****** Object:  Table [import].[Tb_Score]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Score](
	[MarketCode] [char](4) NOT NULL,
	[RuleCode] [char](5) NOT NULL,
	[CombinationCode] [varchar](10) NOT NULL,
	[SCLevyChargeRate] [decimal](24, 9) NOT NULL,
	[SCOREFeeChargeRate] [decimal](24, 9) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]