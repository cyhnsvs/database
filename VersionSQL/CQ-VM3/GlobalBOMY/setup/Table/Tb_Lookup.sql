/****** Object:  Table [setup].[Tb_Lookup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [setup].[Tb_Lookup](
	[LookupID] [int] NOT NULL,
	[CodeType] [varchar](20) NOT NULL,
	[CodeName] [varchar](20) NOT NULL,
	[Value1] [varchar](50) NULL,
	[Value2] [varchar](50) NULL,
	[Value3] [varchar](50) NULL,
	[Value4] [varchar](50) NULL,
	[Value5] [varchar](50) NULL,
	[Remarks] [varchar](100) NOT NULL,
	[SequenceNo] [int] NOT NULL,
	[ActionInd] [char](4) NULL,
	[RecordID] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[ModifiedBy] [varchar](64) NULL,
	[ModifiedDateTime] [datetime] NULL,
 CONSTRAINT [PK_Tb_Lookup] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [setup].[Tb_Lookup] ADD  DEFAULT (newsequentialid()) FOR [RecordID]