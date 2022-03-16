/****** Object:  Table [import].[Tb_Country]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Country](
	[COUNTRYCD] [char](3) NOT NULL,
	[CURRCODE] [char](3) NOT NULL,
	[DESCRIPTION] [varchar](30) NOT NULL,
	[ISOCOUNTRY] [char](2) NOT NULL,
	[NATIONLTCD] [char](3) NOT NULL,
	[COUNTRYFAX] [char](2) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]