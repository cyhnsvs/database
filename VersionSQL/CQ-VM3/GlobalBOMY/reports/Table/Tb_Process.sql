/****** Object:  Table [reports].[Tb_Process]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [reports].[Tb_Process](
	[IDD] [bigint] NOT NULL,
	[ReportID] [bigint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[RetryCount] [int] NULL,
	[MaxRetry] [int] NULL,
	[ScheduleDate] [varchar](50) NULL,
	[ProcessByIP] [varchar](50) NULL,
	[ProcessByInstanceName] [varchar](50) NULL,
	[ProcessByThread] [varchar](50) NULL,
	[ProcessStarted] [datetime] NULL,
	[DependencyReportID] [varchar](100) NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[Remarks] [varchar](4000) NULL,
 CONSTRAINT [PK_Tb_Process] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]