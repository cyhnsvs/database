/****** Object:  Table [import].[PSPL_OSCONTRACTKSP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_OSCONTRACTKSP](
	[REMI NO] [nvarchar](250) NULL,
	[CLIENT NO] [nvarchar](250) NULL,
	[CLIENT NAME] [nvarchar](250) NULL,
	[NRIC] [nvarchar](250) NULL,
	[SEC CODE] [nvarchar](250) NULL,
	[SEC NAME] [nvarchar](250) NULL,
	[CONTRACT NO] [nvarchar](250) NULL,
	[RT] [nvarchar](250) NULL,
	[CURR CODE] [nvarchar](250) NULL,
	[PRICE] [nvarchar](250) NULL,
	[QUANTITY] [nvarchar](250) NULL,
	[PROCEEDS] [nvarchar](250) NULL,
	[NET AMT] [nvarchar](250) NULL,
	[CON DATE] [nvarchar](250) NULL,
	[DUE DATE] [nvarchar](250) NULL,
	[SPELCD] [nvarchar](250) NULL,
	[BROK AMT] [nvarchar](250) NULL,
	[BROK GST] [nvarchar](250) NULL,
	[CLR FEE] [nvarchar](250) NULL,
	[CLR GST] [nvarchar](250) NULL,
	[AFM FEE] [nvarchar](250) NULL,
	[AFM GST] [nvarchar](250) NULL,
	[SETTLE EXCH RATE] [nvarchar](250) NULL,
	[FCN AMOUNT] [nvarchar](250) NULL,
	[AFAMT] [nvarchar](250) NULL,
	[FFP] [nvarchar](250) NULL,
	[SETTLE CURR CODE] [nvarchar](250) NULL,
	[EXCH CODE] [nvarchar](250) NULL,
	[MARKET CODE] [nvarchar](250) NULL,
	[COMPANY CODE] [nvarchar](250) NULL,
	[ISIN CODE] [nvarchar](250) NULL,
	[SourceFileName] [nvarchar](250) NULL,
	[ImportedDateTime] [datetime] NULL
) ON [PRIMARY]