/****** Object:  Table [import].[Tb_Gbo_RelatedDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_RelatedDetails](
	[CustomerUniqueID] [int] NULL,
	[RowIndex] [int] NULL,
	[Action_] [varchar](1) NULL,
	[RelatedAccountName] [varchar](max) NULL,
	[Relationship] [varchar](max) NULL,
	[RelatedAccountNumber] [varchar](max) NULL,
	[ImportStatus] [varchar](1) NULL,
	[ImportRemarks] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]