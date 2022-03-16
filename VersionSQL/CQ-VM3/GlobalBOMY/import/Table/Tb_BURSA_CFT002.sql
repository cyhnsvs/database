/****** Object:  Table [import].[Tb_BURSA_CFT002]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BURSA_CFT002](
	[RecordType] [varchar](1) NULL,
	[AcctNo] [varchar](9) NULL,
	[TransType] [varchar](2) NULL,
	[BusinessDate] [varchar](8) NULL,
	[RefNo] [varchar](14) NULL,
	[StockCode] [varchar](6) NULL,
	[ShareQty] [varchar](12) NULL,
	[TransDetail1] [varchar](15) NULL,
	[TransDetail2] [varchar](15) NULL,
	[StatusCode] [varchar](2) NULL,
	[HomeBranch] [varchar](3) NULL,
	[SourceFileName] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]