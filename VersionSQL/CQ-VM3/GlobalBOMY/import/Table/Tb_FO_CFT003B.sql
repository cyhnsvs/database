/****** Object:  Table [import].[Tb_FO_CFT003B]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_FO_CFT003B](
	[RecordType] [varchar](1) NULL,
	[AccountNumber] [varchar](9) NULL,
	[StockCode] [varchar](6) NULL,
	[FreeBalance] [varchar](12) NULL,
	[EarmarkedBalance] [varchar](12) NULL,
	[UnclearBalance] [varchar](12) NULL,
	[SuspendedBalance] [varchar](12) NULL,
	[PayableBalance] [varchar](12) NULL,
	[ReceivableBalance] [varchar](12) NULL
) ON [PRIMARY]