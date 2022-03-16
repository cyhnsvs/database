/****** Object:  Table [import].[Tb_ECOS_DepositInfo_Archival]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ECOS_DepositInfo_Archival](
	[AccountNo] [varchar](10) NULL,
	[PaymentType] [varchar](1) NULL,
	[ChequeDate] [varchar](10) NULL,
	[ChequeNo] [varchar](15) NULL,
	[ChequeBank] [varchar](4) NULL,
	[ClientAccountNo] [varchar](20) NULL,
	[RefNo] [varchar](10) NULL,
	[CashBookID] [varchar](3) NULL,
	[Currency] [varchar](3) NULL,
	[ExchRate] [varchar](9) NULL,
	[Amount] [varchar](15) NULL,
	[Commission] [varchar](9) NULL,
	[BankInd] [varchar](1) NULL,
	[Remarks] [varchar](50) NULL,
	[SourceFileName] [varchar](500) NULL,
	[CreatedOn] [datetime] NULL,
	[Status] [varchar](255) NULL,
	[LastUpdated] [varchar](255) NULL,
	[UpdatedBy] [varchar](255) NULL,
	[BusinessDate] [datetime] NULL,
	[ArchivalDate] [datetime] NULL
) ON [PRIMARY]