/****** Object:  Table [import].[Tb_NomineeType]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_NomineeType](
	[NOMININD] [char](1) NOT NULL,
	[NOMDESC] [varchar](60) NOT NULL,
	[ACCTNO] [varchar](10) NOT NULL,
	[NOMNAME] [varchar](60) NOT NULL,
	[CORRADDR1] [varchar](40) NOT NULL,
	[CORRADDR2] [varchar](40) NOT NULL,
	[CORRADDR3] [varchar](40) NOT NULL,
	[CORRADDR4] [varchar](40) NOT NULL,
	[CORRADDR5] [varchar](40) NOT NULL,
	[CORRPOSTCD] [varchar](10) NOT NULL,
	[CONNAME1] [varchar](30) NOT NULL,
	[CONNAME2] [varchar](30) NOT NULL,
	[CONPHONE1] [varchar](15) NOT NULL,
	[CONPHONE2] [varchar](15) NOT NULL,
	[FAX] [varchar](15) NOT NULL,
	[BANKCD] [char](4) NOT NULL,
	[BANKBRANCH] [varchar](10) NOT NULL,
	[BANKACNO] [varchar](20) NOT NULL,
	[BANKACNM] [varchar](60) NOT NULL,
	[GLACNO] [varchar](50) NOT NULL,
	[SHRPOOLID] [char](5) NOT NULL,
	[SNPSHOTIND] [char](1) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]