/****** Object:  Table [reports].[Tb_ProcessParam_Archive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [reports].[Tb_ProcessParam_Archive](
	[IDD] [bigint] NOT NULL,
	[ProcessID] [bigint] NOT NULL,
	[ParamName] [varchar](50) NOT NULL,
	[ParamValue] [varchar](500) NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [varchar](50) NULL,
	[ArchivedTime] [datetime] NOT NULL
) ON [PRIMARY]