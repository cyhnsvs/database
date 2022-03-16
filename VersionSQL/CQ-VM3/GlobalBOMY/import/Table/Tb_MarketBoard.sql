/****** Object:  Table [import].[Tb_MarketBoard]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_MarketBoard](
	[MarketBoardCode] [varchar](4) NULL,
	[MarketCode] [varchar](10) NULL,
	[Description] [varchar](30) NULL,
	[MultiplierForSharePledged] [varchar](50) NULL,
	[DiscountFactor] [varchar](50) NULL,
	[UserCreated] [varchar](50) NULL,
	[DateCreated] [varchar](50) NULL,
	[TimeCreated] [varchar](50) NULL,
	[UserUdated] [varchar](50) NULL,
	[DateUpdated] [varchar](50) NULL,
	[TimeUpdated] [varchar](50) NULL
) ON [PRIMARY]