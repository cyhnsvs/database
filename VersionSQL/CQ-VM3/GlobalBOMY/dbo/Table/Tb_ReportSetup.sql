/****** Object:  Table [dbo].[Tb_ReportSetup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tb_ReportSetup](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportName] [varchar](200) NOT NULL,
	[ReportCategory] [varchar](200) NULL,
	[ReportServer] [varchar](200) NOT NULL,
	[ReportPath] [varchar](200) NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[Status] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Tb_ReportSetup] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]