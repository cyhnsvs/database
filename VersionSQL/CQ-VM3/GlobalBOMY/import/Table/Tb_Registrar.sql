/****** Object:  Table [import].[Tb_Registrar]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Registrar](
	[REGISTRCD] [char](5) NOT NULL,
	[REGISTRNM] [varchar](60) NOT NULL,
	[CORRADDR1] [varchar](40) NOT NULL,
	[CORRADDR2] [varchar](40) NOT NULL,
	[CORRADDR3] [varchar](40) NOT NULL,
	[CORRADDR4] [varchar](40) NOT NULL,
	[CORRPOSTCD] [varchar](10) NOT NULL,
	[COUNTRYCD] [char](3) NOT NULL,
	[PHONE] [varchar](15) NOT NULL,
	[FAX] [varchar](15) NOT NULL,
	[INETMAIL] [varchar](50) NOT NULL,
	[TELEX] [varchar](10) NOT NULL,
	[SWIFTADD] [varchar](15) NOT NULL,
	[ACCTNO] [varchar](10) NOT NULL,
	[CHRGCD] [char](3) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]