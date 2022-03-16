/****** Object:  Table [import].[Tb_CQ_OutStandingContracts]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CQ_OutStandingContracts](
	[REMINo] [char](3) NULL,
	[ClientNo] [char](7) NULL,
	[ClientName] [char](30) NULL,
	[NRIC] [char](14) NULL,
	[SECCode] [char](4) NULL,
	[SECName] [char](16) NULL,
	[ContractNo] [char](13) NULL,
	[RT] [char](5) NULL,
	[CurrCode] [char](3) NULL,
	[Price] [decimal](11, 5) NULL,
	[Quantity] [decimal](11, 0) NULL,
	[Proceeds] [decimal](15, 2) NULL,
	[NetAmt] [decimal](15, 2) NULL,
	[ConDate] [char](6) NULL,
	[DueDate] [char](6) NULL,
	[SpelCd] [char](3) NULL,
	[BrokAmt] [decimal](13, 2) NULL,
	[BrokGST] [decimal](9, 2) NULL,
	[ClrFee] [decimal](11, 2) NULL,
	[ClrGST] [decimal](9, 2) NULL,
	[AfmFee] [decimal](7, 2) NULL,
	[AfmGST] [decimal](9, 2) NULL,
	[SettleExchRate] [decimal](11, 6) NULL,
	[FCNAmount] [decimal](15, 2) NULL,
	[AFAmt] [decimal](13, 2) NULL,
	[FFP] [decimal](13, 2) NULL,
	[SettleCurrCode] [char](3) NULL,
	[ExchCode] [char](10) NULL,
	[MarketCode] [char](1) NULL,
	[CompanyCode] [char](15) NULL,
	[ISINCode] [char](50) NULL
) ON [PRIMARY]