/****** Object:  Table [dbo].[Tb_ImportFileDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tb_ImportFileDetail](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[File] [varchar](50) NOT NULL,
	[FilePath] [varchar](200) NOT NULL,
	[FileName] [varchar](100) NOT NULL
) ON [PRIMARY]