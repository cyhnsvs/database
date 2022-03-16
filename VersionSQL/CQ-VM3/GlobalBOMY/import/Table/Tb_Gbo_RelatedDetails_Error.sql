/****** Object:  Table [import].[Tb_Gbo_RelatedDetails_Error]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_RelatedDetails_Error](
	[CustomerUniqueID] [varchar](max) NULL,
	[RowIndex] [varchar](max) NULL,
	[Action_] [varchar](max) NULL,
	[RelatedAccountName] [varchar](max) NULL,
	[Relationship] [varchar](max) NULL,
	[RelatedAccountNumber] [varchar](max) NULL,
	[ImportStatus] [nvarchar](max) NULL,
	[ImportRemarks] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]