/****** Object:  Table [Queue].[MBMSOutBound]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [Queue].[MBMSOutBound](
	[QueueID] [int] IDENTITY(1,1) NOT NULL,
	[MessageData] [varchar](max) NOT NULL,
	[QueueDateTime] [datetime] NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[Remarks] [varchar](max) NULL,
 CONSTRAINT [PK_MBMSOutBound_QueueID] PRIMARY KEY CLUSTERED 
(
	[QueueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [Queue].[MBMSOutBound] ADD  DEFAULT (getdate()) FOR [QueueDateTime]
ALTER TABLE [Queue].[MBMSOutBound] ADD  DEFAULT ((0)) FOR [Priority]
ALTER TABLE [Queue].[MBMSOutBound] ADD  DEFAULT ((0)) FOR [Status]