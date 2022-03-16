/****** Object:  Table [import].[tb_BTX_HKPRICEINFO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[tb_BTX_HKPRICEINFO](
	[SecuritiesCode] [char](10) NULL,
	[Market] [char](2) NULL,
	[LastDone] [decimal](19, 4) NULL
) ON [PRIMARY]