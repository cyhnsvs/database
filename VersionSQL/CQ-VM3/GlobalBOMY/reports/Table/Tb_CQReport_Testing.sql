/****** Object:  Table [reports].[Tb_CQReport_Testing]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [reports].[Tb_CQReport_Testing](
	[IDD] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [varchar](500) NULL,
	[Remisier] [varchar](100) NULL,
	[BranchStaff] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]