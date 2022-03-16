/****** Object:  Table [setup].[Tb_EmailAlert]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [setup].[Tb_EmailAlert](
	[Mode] [int] NOT NULL,
	[ModeDefinition] [varchar](10) NOT NULL,
	[ToEmails] [varchar](500) NOT NULL,
	[CCEmails] [varchar](500) NOT NULL,
	[BCCEmails] [varchar](500) NOT NULL,
	[SubTxt] [varchar](100) NOT NULL,
	[BodyTxt] [varchar](max) NOT NULL,
	[QryTxt] [varchar](500) NOT NULL,
	[SMTPSvr] [varchar](50) NOT NULL,
	[Sendername] [varchar](50) NOT NULL,
	[SrvName] [varchar](50) NOT NULL,
	[ActionInd] [char](4) NULL,
	[RecordID] [uniqueidentifier] NULL,
	[IsActive] [bit] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[ModifiedBy] [varchar](64) NULL,
	[ModifiedDateTime] [datetime] NULL,
 CONSTRAINT [PK_Tb_EmailAlert] PRIMARY KEY CLUSTERED 
(
	[Mode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [setup].[Tb_EmailAlert] ADD  CONSTRAINT [DF_Tb_EmailAlert_RecordID]  DEFAULT (newsequentialid()) FOR [RecordID]
ALTER TABLE [setup].[Tb_EmailAlert] ADD  CONSTRAINT [DF_Tb_EmailAlert_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [setup].[Tb_EmailAlert] ADD  CONSTRAINT [DF_Tb_EmailAlert_IsApproved]  DEFAULT ((0)) FOR [IsApproved]