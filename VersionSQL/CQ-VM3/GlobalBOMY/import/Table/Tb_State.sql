/****** Object:  Table [import].[Tb_State]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_State](
	[StateName] [varchar](50) NOT NULL,
	[StateValue] [varchar](3) NOT NULL,
	[UserCreated] [varchar](5) NOT NULL,
	[DateCreated] [varchar](10) NOT NULL,
	[TimeCreated] [varchar](8) NOT NULL,
	[UserUpdated] [varchar](1) NOT NULL,
	[DateUpdated] [varchar](1) NOT NULL,
	[TimeUpdated] [varchar](1) NOT NULL
) ON [PRIMARY]