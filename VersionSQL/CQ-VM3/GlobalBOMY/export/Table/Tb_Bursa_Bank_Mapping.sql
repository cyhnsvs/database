/****** Object:  Table [export].[Tb_Bursa_Bank_Mapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [export].[Tb_Bursa_Bank_Mapping](
	[GBOBankCode] [varchar](20) NULL,
	[BursaBankCode] [varchar](20) NULL,
	[BursaBankDescription] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]