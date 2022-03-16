/****** Object:  Table [import].[PSPL_PriceInfo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PSPL_PriceInfo](
	[CompanyCode] [nvarchar](255) NULL,
	[Market] [nvarchar](255) NULL,
	[LastDone] [nvarchar](255) NULL,
	[SourceFileName] [nvarchar](255) NULL,
	[ImportedDateTime] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [import].[PSPL_PriceInfo] ADD  CONSTRAINT [DF_PSPL_PriceInfo_ImportedDateTime]  DEFAULT (getdate()) FOR [ImportedDateTime]