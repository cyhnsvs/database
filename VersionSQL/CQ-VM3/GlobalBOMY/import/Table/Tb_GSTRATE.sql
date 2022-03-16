/****** Object:  Table [import].[Tb_GSTRATE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_GSTRATE](
	[EOTaxCode] [varchar](50) NULL,
	[EOTaxDescription] [varchar](50) NULL,
	[GSTTaxCode] [varchar](50) NULL,
	[GSTRate] [varchar](50) NULL,
	[EffectiveDate] [varchar](50) NULL,
	[Min] [varchar](50) NULL,
	[Max] [varchar](50) NULL,
	[RoundingMethod] [varchar](50) NULL,
	[SageTaxClassARFile] [varchar](50) NULL,
	[SageTaxClassAPFile] [varchar](50) NULL,
	[USRCREATED] [varchar](50) NULL,
	[DTCREATED] [varchar](50) NULL,
	[TMCREATED] [varchar](50) NULL
) ON [PRIMARY]