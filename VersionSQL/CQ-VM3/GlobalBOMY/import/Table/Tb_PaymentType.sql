/****** Object:  Table [import].[Tb_PaymentType]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_PaymentType](
	[ChequeTypeCode] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[MinimumCharge] [varchar](50) NULL,
	[MaximumCharge] [varchar](50) NULL,
	[ChequeClearanceDays] [varchar](50) NULL,
	[USRCREATED] [varchar](50) NULL,
	[DTCREATED] [varchar](50) NULL,
	[TMCREATED] [varchar](50) NULL,
	[USRUPDATED] [varchar](50) NULL,
	[DTUPDATED] [varchar](50) NULL,
	[TMUPDATED] [varchar](50) NULL
) ON [PRIMARY]