/****** Object:  Table [import].[Tb_Gbo_VBIPrebate]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Gbo_VBIPrebate](
	[Recordtype] [varchar](1) NULL,
	[Brokercode] [varchar](3) NULL,
	[CDSNumber] [varchar](9) NULL,
	[Rebate] [varchar](15) NULL,
	[AdjustmentType] [varchar](1) NULL,
	[RebateType] [varchar](1) NULL,
	[SourceFileName] [varchar](500) NULL,
	[Createdon] [datetime] NULL
) ON [PRIMARY]