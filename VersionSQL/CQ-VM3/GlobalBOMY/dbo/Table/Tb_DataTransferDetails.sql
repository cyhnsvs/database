/****** Object:  Table [dbo].[Tb_DataTransferDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tb_DataTransferDetails](
	[DBName] [varchar](30) NOT NULL,
	[TbSchema] [varchar](15) NOT NULL,
	[TableName] [varchar](100) NOT NULL,
	[TransferType] [tinyint] NOT NULL,
	[JobName] [varchar](100) NOT NULL,
	[BatchNo] [tinyint] NOT NULL,
	[OrderSequence] [int] NOT NULL,
	[EnableArchive] [bit] NOT NULL,
	[EnableDestTruncate] [bit] NOT NULL,
	[EnableCount] [bit] NOT NULL,
	[CommandExtension] [varchar](500) NOT NULL,
	[ExecuteSP] [varchar](8000) NOT NULL,
	[DateType] [char](1) NOT NULL,
	[DateValue] [int] NOT NULL,
	[ArchiveDate] [date] NULL,
	[SourceRowCount] [int] NOT NULL,
	[DestRowCount] [int] NOT NULL,
	[LastSuccessRun] [datetime] NULL,
	[LastFailedRun] [datetime] NULL,
	[Remarks] [varchar](4000) NOT NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Tb_DataTransferDetails] PRIMARY KEY CLUSTERED 
(
	[TableName] ASC,
	[DBName] ASC,
	[TbSchema] ASC,
	[TransferType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_TbSchema]  DEFAULT ('dbo') FOR [TbSchema]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_TransferType]  DEFAULT ((1)) FOR [TransferType]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_BatchNo]  DEFAULT ((1)) FOR [BatchNo]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_EnableArchive]  DEFAULT ((0)) FOR [EnableArchive]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_EnableDestTruncate]  DEFAULT ((0)) FOR [EnableDestTruncate]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_EnableCount]  DEFAULT ((1)) FOR [EnableCount]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_CommandExtension]  DEFAULT ('') FOR [CommandExtension]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_ExecuteSP]  DEFAULT ('') FOR [ExecuteSP]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_FrequencyType]  DEFAULT ('A') FOR [DateType]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_SourceRowCount]  DEFAULT ((0)) FOR [SourceRowCount]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_DestRowCount]  DEFAULT ((0)) FOR [DestRowCount]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_Remarks]  DEFAULT ('') FOR [Remarks]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_CreatedBy]  DEFAULT ('') FOR [CreatedBy]
ALTER TABLE [dbo].[Tb_DataTransferDetails] ADD  CONSTRAINT [DF_Tb_DataTransferDetails_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDateTime]