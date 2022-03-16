/****** Object:  Table [import].[Tb_BURSA_CFT015]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BURSA_CFT015](
	[RecordType] [varchar](1) NULL,
	[AcctNo] [varchar](9) NULL,
	[NRIC] [varchar](14) NULL,
	[InvestorName] [varchar](60) NULL,
	[OpeningDate] [varchar](8) NULL,
	[LastTransDate] [varchar](8) NULL,
	[GroupId] [varchar](8) NULL,
	[UserId] [varchar](8) NULL,
	[Filler] [varchar](10) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedDate] [date] NULL
) ON [PRIMARY]