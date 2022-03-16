/****** Object:  Table [import].[PSPL_PriceInfo_MAN_Archive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_PriceInfo_MAN_Archive](
	[CompanyCode] [nvarchar](255) NULL,
	[Market] [nvarchar](255) NULL,
	[LastDone] [nvarchar](255) NULL,
	[Temp column] [nvarchar](255) NULL,
	[SourceFileName] [nvarchar](255) NULL,
	[ImportedDateTime] [datetime] NULL,
	[ArchiveDateTime] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [import].[PSPL_PriceInfo_MAN_Archive] ADD  CONSTRAINT [DF_PSPL_PriceInfo_MAN_Archive_ArchiveDateTime]  DEFAULT (getdate()) FOR [ArchiveDateTime]