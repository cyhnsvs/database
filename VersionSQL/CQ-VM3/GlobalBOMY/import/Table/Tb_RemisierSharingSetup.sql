/****** Object:  Table [import].[Tb_RemisierSharingSetup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_RemisierSharingSetup](
	[No ] [varchar](50) NULL,
	[Remisier Name] [varchar](50) NULL,
	[All codes under remisier name] [varchar](50) NULL,
	[Remisier Code key in EO] [varchar](50) NULL,
	[Individual performance incentive TYPE] [varchar](50) NULL,
	[Individual performance Incentive (%)] [varchar](50) NULL,
	[Kiosk Incentive TYPE] [varchar](50) NULL,
	[Kiosk Incentive (%)] [varchar](50) NULL,
	[Branch] [varchar](50) NULL,
	[Total Brokerage (RM)] [varchar](50) NULL,
	[Individual Performance Incentive (RM)] [varchar](50) NULL,
	[Kiosk Incentive] [varchar](50) NULL,
	[Add Incentive (RM)] [varchar](50) NULL,
	[Total Incentive (RM)] [varchar](50) NULL,
	[CN No ] [varchar](50) NULL
) ON [PRIMARY]