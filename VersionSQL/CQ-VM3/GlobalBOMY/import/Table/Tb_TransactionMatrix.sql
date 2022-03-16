/****** Object:  Table [import].[Tb_TransactionMatrix]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_TransactionMatrix](
	[TransactionMatrixCode] [char](2) NOT NULL,
	[Description] [varchar](30) NOT NULL,
	[TransactionReferencePrefix] [char](2) NOT NULL,
	[SequenceCode] [varchar](5) NOT NULL,
	[TransactionReferenceLength] [char](3) NOT NULL,
	[ServiceRateCode] [char](2) NOT NULL,
	[SettlementModeCode] [int] NOT NULL,
	[USRCREATED] [varchar](10) NOT NULL,
	[DTCREATED] [varchar](10) NOT NULL,
	[TMCREATED] [varchar](8) NOT NULL,
	[USRUPDATED] [varchar](10) NOT NULL,
	[DTUPDATED] [varchar](10) NOT NULL,
	[TMUPDATED] [varchar](8) NOT NULL
) ON [PRIMARY]