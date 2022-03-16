/****** Object:  Table [import].[Tb_Bank]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Bank](
	[BANKCD] [char](4) NOT NULL,
	[BANKBRANCH] [varchar](10) NOT NULL,
	[COUNTRYCD] [char](3) NOT NULL,
	[CORRMTHD] [char](1) NOT NULL,
	[BANKNAME] [varchar](40) NOT NULL,
	[MAINBRANCH] [char](1) NOT NULL,
	[CORRADDR1] [varchar](40) NOT NULL,
	[CORRADDR2] [varchar](40) NOT NULL,
	[CORRADDR3] [varchar](40) NOT NULL,
	[CORRADDR4] [varchar](40) NOT NULL,
	[CORRNAME] [varchar](40) NOT NULL,
	[CORRPOSTCD] [varchar](10) NOT NULL,
	[PHONE] [varchar](15) NOT NULL,
	[FAX] [varchar](15) NOT NULL,
	[DIALUPNO] [varchar](15) NOT NULL,
	[TELEX] [varchar](10) NOT NULL,
	[SWIFTADD] [varchar](15) NOT NULL,
	[ELECADDR] [varchar](20) NOT NULL,
	[BASELENDRT] [decimal](24, 9) NOT NULL,
	[COMMFEERT] [decimal](24, 9) NOT NULL,
	[SUSPEND] [char](1) NOT NULL,
	[DTSUSPND] [varchar](10) NOT NULL,
	[ISOBNKCD] [varchar](20) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]