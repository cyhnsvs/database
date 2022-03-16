/****** Object:  Table [reports].[Tb_ReportSetup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [reports].[Tb_ReportSetup](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SSRSPath] [varchar](500) NULL,
	[SQLStatement] [varchar](max) NULL,
	[DestinationPath] [varchar](500) NOT NULL,
	[FileType] [varchar](20) NOT NULL,
	[FileNameSetup] [varchar](100) NOT NULL,
	[FileDelimiter] [varchar](10) NULL,
	[EOLStr] [varchar](20) NULL,
	[IncludeHeader] [tinyint] NULL,
	[Encoding] [int] NULL,
	[SendEmail] [tinyint] NOT NULL,
	[EmailSetup] [xml] NULL,
	[Archive] [tinyint] NOT NULL,
	[Enabled] [tinyint] NOT NULL,
	[ScheduleConfig] [xml] NOT NULL,
	[LastExecutionDate] [datetime] NULL,
	[Remarks] [varchar](500) NULL,
	[RefIDD] [varchar](100) NULL,
	[ProcessTokenID] [varchar](100) NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[ReportType] [varchar](50) NULL,
 CONSTRAINT [PK_Tb_Reports] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [reports].[Tb_ReportSetup] ADD  CONSTRAINT [DF_Tb_ReportSetup_Encoding]  DEFAULT ((1252)) FOR [Encoding]
ALTER TABLE [reports].[Tb_ReportSetup] ADD  CONSTRAINT [DF_Tb_ReportSetup_Archive]  DEFAULT ((1)) FOR [Archive]