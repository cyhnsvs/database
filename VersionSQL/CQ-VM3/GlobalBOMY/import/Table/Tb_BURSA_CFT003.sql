/****** Object:  Table [import].[Tb_BURSA_CFT003]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BURSA_CFT003](
	[RecordType] [varchar](1) NULL,
	[AcctNo] [varchar](9) NULL,
	[StockCode] [varchar](6) NULL,
	[FreeBalance] [varchar](12) NULL,
	[EarmarkedBalance] [varchar](12) NULL,
	[UnClearBalance] [varchar](12) NULL,
	[SuspendedBalance] [varchar](12) NULL,
	[PayableBalance] [varchar](12) NULL,
	[ReceivableBalance] [varchar](12) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedDate] [date] NULL
) ON [PRIMARY]