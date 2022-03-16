/****** Object:  Table [import].[Tb_Gbo_IndividualAuthorizatio]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_IndividualAuthorizatio](
	[CustomerUniqueID] [int] NULL,
	[RowIndex] [int] NULL,
	[Action_] [varchar](1) NULL,
	[Name] [varchar](max) NULL,
	[NRICNo] [varchar](12) NULL,
	[ImportStatus] [varchar](1) NULL,
	[ImportRemarks] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]