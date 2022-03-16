/****** Object:  Table [import].[Tb_GSTTRX]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_GSTTRX](
	[TransactionCode] [varchar](50) NULL,
	[MarketCode] [varchar](50) NULL,
	[ChargeType] [varchar](50) NULL,
	[ChargeCode] [varchar](50) NULL,
	[CountryOfResidence] [varchar](50) NULL,
	[DebitCredit] [varchar](50) NULL,
	[GSTCode] [varchar](50) NULL,
	[USRCREATED] [varchar](50) NULL,
	[DTCREATED] [varchar](50) NULL,
	[TMCREATED] [varchar](50) NULL
) ON [PRIMARY]