/****** Object:  Table [import].[Tb_RASDealer]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_RASDealer](
	[Broker Code] [varchar](50) NULL,
	[Dealer EAF ID] [varchar](50) NULL,
	[Dealer Code] [varchar](50) NULL,
	[RAS Collateral Account Number*] [varchar](50) NULL,
	[RAS Commission Account Number*] [varchar](50) NULL,
	[Ceiling Amount] [varchar](50) NULL,
	[Equity RAS(%)*] [varchar](50) NULL,
	[Auto Charge Ind] [varchar](50) NULL,
	[Adjustable Ceiling Amount] [varchar](50) NULL,
	[Commision Payable(%)] [varchar](50) NULL,
	[SC Levy receivable(%) ] [varchar](50) NULL,
	[Score Fee receivable(%) ] [varchar](50) NULL,
	[Minimum Amount Before Retention] [varchar](50) NULL,
	[Grace Period for RAS Margin Call(Working Day)] [varchar](50) NULL,
	[Last Commission Payable Date] [varchar](50) NULL,
	[Last RAS Margin Call Date] [varchar](50) NULL
) ON [PRIMARY]