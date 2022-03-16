/****** Object:  Table [import].[Tb_SAP_RemisierExpensesORE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_SAP_RemisierExpensesORE](
	[RecordType] [char](1) NULL,
	[CompanyCode] [char](4) NULL,
	[BranchID] [char](3) NULL,
	[TraderNo] [char](5) NULL,
	[DocumentNumber] [char](10) NULL,
	[GLAccount] [char](6) NULL,
	[CostCenter] [char](10) NULL,
	[ProfitCenter] [char](10) NULL,
	[InternalOrder] [char](12) NULL,
	[AmountDebit] [char](22) NULL,
	[AmountCredit] [char](22) NULL,
	[ItemText] [char](50) NULL,
	[PostingDate] [char](8) NULL,
	[ValueDate] [char](8) NULL,
	[LongText] [char](180) NULL,
	[RunningNumber] [char](5) NULL
) ON [PRIMARY]