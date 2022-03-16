/****** Object:  Table [import].[Tb_CashBook]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CashBook](
	[COMPANYID] [char](1) NOT NULL,
	[BRANCHID] [char](4) NOT NULL,
	[CASHBKID] [char](3) NOT NULL,
	[CURRCODE] [char](3) NOT NULL,
	[BANKCD] [char](4) NOT NULL,
	[BANKBRANCH] [varchar](10) NOT NULL,
	[DESCRIPTN] [varchar](30) NOT NULL,
	[BANKACCTNO] [varchar](15) NOT NULL,
	[BNKACTYPE] [char](1) NOT NULL,
	[DTACCTOPEN] [varchar](10) NOT NULL,
	[ACCTSTAT] [char](2) NOT NULL,
	[CURACBAL] [decimal](24, 9) NOT NULL,
	[AVAILACBAL] [decimal](24, 9) NOT NULL,
	[UNCLRAMT] [decimal](24, 9) NOT NULL,
	[PDCQINCNT] [int] NOT NULL,
	[PDCQOUTCNT] [int] NOT NULL,
	[PDCQINAMT] [decimal](24, 9) NOT NULL,
	[PDCQOUTAMT] [decimal](24, 9) NOT NULL,
	[RTNCQCNT] [int] NOT NULL,
	[RTNCQAMT] [decimal](24, 9) NOT NULL,
	[BNKSTMTBAL] [decimal](24, 9) NOT NULL,
	[BNKSTMTDT] [varchar](10) NOT NULL,
	[ODAMT] [decimal](24, 9) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]