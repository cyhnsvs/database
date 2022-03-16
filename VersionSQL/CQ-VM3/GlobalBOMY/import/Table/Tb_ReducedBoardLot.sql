/****** Object:  Table [import].[Tb_ReducedBoardLot]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ReducedBoardLot](
	[ReducedBoardLotCode] [char](1) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[LotSize] [int] NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](50) NOT NULL,
	[TMUPDATED] [varchar](8) NULL
) ON [PRIMARY]