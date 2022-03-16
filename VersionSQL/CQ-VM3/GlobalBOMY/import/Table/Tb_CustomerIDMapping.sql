/****** Object:  Table [import].[Tb_CustomerIDMapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CustomerIDMapping](
	[SNo] [bigint] IDENTITY(0,1) NOT NULL,
	[OldCustomerID] [varchar](50) NOT NULL,
	[NewCustomerID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Tb_CustomerIDMapping] PRIMARY KEY CLUSTERED 
(
	[OldCustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]