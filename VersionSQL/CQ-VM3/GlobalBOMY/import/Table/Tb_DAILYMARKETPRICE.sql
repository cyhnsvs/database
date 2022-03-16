/****** Object:  Table [import].[Tb_DAILYMARKETPRICE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_DAILYMARKETPRICE](
	[MRKTDATE] [varchar](50) NULL,
	[MRKTCD] [varchar](50) NULL,
	[PRODCD] [varchar](50) NULL,
	[MRKTSYMB] [varchar](50) NULL,
	[CLOSEPRICE] [varchar](50) NULL,
	[VOLUME] [varchar](50) NULL,
	[OPENPRICE] [varchar](50) NULL,
	[HIGHPRICE] [varchar](50) NULL,
	[LOWPRICE] [varchar](50) NULL,
	[BUYPRICE] [varchar](50) NULL,
	[SELLPRICE] [varchar](50) NULL,
	[CHGPRICE] [varchar](50) NULL,
	[USRCREATED] [varchar](50) NULL,
	[DTCREATED] [varchar](50) NULL,
	[TMCREATED] [varchar](50) NULL,
	[USRUPDATED] [varchar](50) NULL,
	[DTUPDATED] [varchar](50) NULL,
	[TMUPDATED] [varchar](50) NULL
) ON [PRIMARY]