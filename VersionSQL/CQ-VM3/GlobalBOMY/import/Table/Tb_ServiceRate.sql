/****** Object:  Table [import].[Tb_ServiceRate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ServiceRate](
	[ServiceRateCode] [char](3) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[ServiceRate] [decimal](24, 9) NOT NULL,
	[ServiceGracePeriod] [int] NOT NULL,
	[ServiceDayType] [char](1) NOT NULL,
	[CalculationMethod] [char](1) NOT NULL,
	[BLR] [char](1) NOT NULL,
	[MinimumServiceFee] [decimal](24, 9) NOT NULL,
	[MaximumServiceFee] [decimal](24, 9) NOT NULL,
	[NewRateEffectiveDate] [varchar](10) NOT NULL,
	[NewServiceCode] [char](3) NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]