/****** Object:  Table [dbo].[Tb_GBOSGProcessToken_AuditLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog](
	[RunningNo] [bigint] IDENTITY(1,1) NOT NULL,
	[AuditAction] [char](1) NOT NULL,
	[AuditDateTime] [datetime] NOT NULL,
	[IPAddress] [varchar](15) NOT NULL,
	[DBUser] [varchar](64) NOT NULL,
	[IDD] [int] NOT NULL,
	[TokenType] [char](1) NOT NULL,
	[InputProcID] [varchar](100) NOT NULL,
	[OutputProcID] [varchar](100) NOT NULL,
	[ProcessType] [varchar](50) NULL,
	[ProcessFolder] [varchar](200) NULL,
	[ProcessName] [varchar](200) NULL,
	[ProcessUpdateID] [varchar](50) NULL,
	[IsInputReady] [char](1) NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[PHIndicator] [char](1) NOT NULL,
	[FrequencyType] [char](1) NOT NULL,
	[FrequencyValue] [varchar](20) NOT NULL,
	[ProcStartTime] [char](5) NOT NULL,
	[ProcEndTime] [char](5) NOT NULL,
	[ReRunDuration] [char](5) NOT NULL,
	[ProcessStatus] [char](1) NOT NULL,
	[Remarks] [varchar](4000) NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [varchar](64) NULL,
	[UpdatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_Tb_GBOSGProcessToken_AuditLog] PRIMARY KEY CLUSTERED 
(
	[RunningNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_AuditDateTime]  DEFAULT (getdate()) FOR [AuditDateTime]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_IPAddress]  DEFAULT ('') FOR [IPAddress]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_DBUser]  DEFAULT ('') FOR [DBUser]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_TokenType]  DEFAULT ('T') FOR [TokenType]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_IsInputReady]  DEFAULT ('N') FOR [IsInputReady]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_IsEnabled]  DEFAULT ((1)) FOR [IsEnabled]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_PHIndicator]  DEFAULT ('N') FOR [PHIndicator]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_ReRunDuration]  DEFAULT ('00:00') FOR [ReRunDuration]
ALTER TABLE [dbo].[Tb_GBOSGProcessToken_AuditLog] ADD  CONSTRAINT [DF_Tb_GBOSGProcessToken_AuditLog_ProcessStatus]  DEFAULT ('0') FOR [ProcessStatus]