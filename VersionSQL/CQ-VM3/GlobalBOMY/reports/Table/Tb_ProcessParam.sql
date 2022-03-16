/****** Object:  Table [reports].[Tb_ProcessParam]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [reports].[Tb_ProcessParam](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[ProcessID] [bigint] NOT NULL,
	[ParamName] [varchar](50) NOT NULL,
	[ParamValue] [varchar](500) NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [varchar](50) NULL,
 CONSTRAINT [PK_Tb_ProcessParam] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]