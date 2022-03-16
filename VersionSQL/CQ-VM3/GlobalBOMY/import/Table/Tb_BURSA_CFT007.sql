/****** Object:  Table [import].[Tb_BURSA_CFT007]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BURSA_CFT007](
	[RecordType] [int] NULL,
	[AccountNumber] [varchar](9) NULL,
	[Action-status] [varchar](1) NULL,
	[Filler] [varchar](35) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]