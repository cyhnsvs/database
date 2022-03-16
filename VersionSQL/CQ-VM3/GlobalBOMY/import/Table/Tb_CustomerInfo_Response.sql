/****** Object:  Table [import].[Tb_CustomerInfo_Response]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CustomerInfo_Response](
	[UniqueID] [int] NULL,
	[IDNumber] [varchar](50) NULL,
	[CustomerID] [varchar](max) NULL,
	[AccountNo] [varchar](max) NULL,
	[CDSNo] [varchar](max) NULL,
	[Status] [varchar](max) NULL,
	[Remarks] [varchar](max) NULL,
	[BursaAnywhere] [varchar](1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]