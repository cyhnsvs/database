/****** Object:  Table [paynet].[Tb_Transaction_AmbankJompayMsg]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [paynet].[Tb_Transaction_AmbankJompayMsg](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MessageType] [nvarchar](50) NULL,
	[MessageData] [nvarchar](max) NULL,
	[ErrorLog] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_AmbankJompay_Message] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]