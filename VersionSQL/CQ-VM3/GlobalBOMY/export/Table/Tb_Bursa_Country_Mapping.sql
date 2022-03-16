/****** Object:  Table [export].[Tb_Bursa_Country_Mapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [export].[Tb_Bursa_Country_Mapping](
	[GBOCountryCode] [char](2) NULL,
	[BursaCountryCode] [char](3) NULL,
	[BursaDescription] [varchar](100) NULL
) ON [PRIMARY]