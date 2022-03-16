/****** Object:  Table [import].[Tb_N2N_N2NPrtfSumm]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_N2N_N2NPrtfSumm](
	[DefaultValue1] [char](1) NULL,
	[AccountNumber] [char](20) NULL,
	[CDSNNo] [char](20) NULL,
	[StockCode] [char](20) NULL,
	[StockCodeFix] [char](15) NULL,
	[Currency] [char](3) NULL,
	[DealerCode] [char](8) NULL,
	[ExchangeCode] [char](2) NULL,
	[DefaultValue2] [char](8) NULL,
	[Branch] [char](5) NULL,
	[Quantity] [char](21) NULL,
	[APPrice] [char](21) NULL,
	[DefaultValue3] [char](14) NULL,
	[ExchCode] [char](5) NULL,
	[SourceFileName] [char](50) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]