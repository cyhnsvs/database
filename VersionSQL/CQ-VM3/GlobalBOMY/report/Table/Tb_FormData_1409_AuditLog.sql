/****** Object:  Table [report].[Tb_FormData_1409_AuditLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [report].[Tb_FormData_1409_AuditLog](
	[BusinessDate] [date] NULL,
	[RecordID] [bigint] NULL,
	[AuditDateTime] [datetime] NULL,
	[Mode] [char](1) NULL,
	[FieldName] [varchar](200) NULL,
	[OldValue] [varchar](max) NULL,
	[NewValue] [varchar](max) NULL,
	[Createdby] [varchar](50) NULL,
	[CreatedTime] [datetime] NULL,
	[Updatedby] [varchar](50) NULL,
	[UpdatedTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]