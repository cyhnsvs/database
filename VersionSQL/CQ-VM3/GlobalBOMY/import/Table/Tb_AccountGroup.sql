/****** Object:  Table [import].[Tb_AccountGroup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_AccountGroup](
	[ParentAccountGroup] [char](5) NOT NULL,
	[AccountGroupCode] [char](5) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[StatementPrinting] [char](1) NOT NULL,
	[OddLotAveragingOption] [char](1) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]