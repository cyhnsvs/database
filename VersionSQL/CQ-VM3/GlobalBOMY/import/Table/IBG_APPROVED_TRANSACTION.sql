/****** Object:  Table [import].[IBG_APPROVED_TRANSACTION]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[IBG_APPROVED_TRANSACTION](
	[Id] [int] NULL,
	[DebitAccNo] [varchar](50) NULL,
	[Beneficiary] [varchar](50) NULL,
	[BeneficiaryAcc] [varchar](50) NULL,
	[Amount] [varchar](50) NULL,
	[TransactionStatus] [varchar](15) NULL,
	[Reason] [varchar](50) NULL,
	[SourceFileName] [varchar](500) NULL,
	[CreatedOn] [datetime] NULL,
	[BeneficiaryBank] [varchar](50) NULL
) ON [PRIMARY]