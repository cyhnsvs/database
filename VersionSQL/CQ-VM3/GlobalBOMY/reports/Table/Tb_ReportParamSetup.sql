/****** Object:  Table [reports].[Tb_ReportParamSetup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [reports].[Tb_ReportParamSetup](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[RptIDD] [bigint] NOT NULL,
	[ParamName] [varchar](50) NOT NULL,
	[ParamValueIsDerived] [varchar](500) NULL,
	[ParamValue] [varchar](500) NULL,
	[SQLStatement] [varchar](max) NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_Tb_ReportParamSetup] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]