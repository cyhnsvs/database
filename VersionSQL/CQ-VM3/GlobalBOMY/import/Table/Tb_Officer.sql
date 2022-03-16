/****** Object:  Table [import].[Tb_Officer]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Officer](
	[OFFICERCD] [varchar](10) NOT NULL,
	[OFFICERNM] [varchar](30) NOT NULL,
	[AUTHLIMIT1] [decimal](24, 9) NOT NULL,
	[AUTHLIMIT2] [decimal](24, 9) NOT NULL,
	[AUTHLIMIT3] [decimal](24, 9) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]