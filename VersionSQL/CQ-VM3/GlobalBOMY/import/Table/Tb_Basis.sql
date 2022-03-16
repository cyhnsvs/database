/****** Object:  Table [import].[Tb_Basis]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Basis](
	[BasisCode] [char](2) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[DaysToSettlePurchaseQty] [int] NOT NULL,
	[DaysToSettlePurchaseAmt] [int] NOT NULL,
	[DaysToSettleWithExchange] [int] NOT NULL,
	[DaysToSettleSaleQty] [int] NOT NULL,
	[DaysToSettleSaleAmt] [int] NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]