/****** Object:  Table [margin].[Tb_MarginRptSummary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [margin].[Tb_MarginRptSummary](
	[IDD] [bigint] IDENTITY(45899,1) NOT NULL,
	[BusinessDate] [date] NOT NULL,
	[AcctNo] [varchar](50) NOT NULL,
	[MarginCurrCd] [varchar](3) NOT NULL,
	[ShareholdingCount] [int] NOT NULL,
	[NParameterValue] [decimal](24, 9) NOT NULL,
	[Balance] [decimal](24, 9) NOT NULL,
	[BalanceCompanyBased] [decimal](24, 9) NOT NULL,
	[Loan] [decimal](24, 9) NOT NULL,
	[LoanCompanyBased] [decimal](24, 9) NOT NULL,
	[CashDeposit] [decimal](24, 9) NOT NULL,
	[ContractOSValue] [decimal](24, 9) NOT NULL,
	[CappedMktValue] [decimal](24, 9) NOT NULL,
	[Equity] [decimal](24, 9) NOT NULL,
	[OutstandingAmount] [decimal](24, 9) NOT NULL,
	[MarginRatio] [decimal](24, 9) NOT NULL,
	[CallShortage] [decimal](24, 9) NOT NULL,
	[Action] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ApprovedMarginRatio] [decimal](24, 9) NOT NULL,
 CONSTRAINT [PK_Tb_MarginRptSummary] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [margin].[Tb_MarginRptSummary] ADD  CONSTRAINT [DF_Tb_MarginRptSummary_ShareholdingCount]  DEFAULT ((0)) FOR [ShareholdingCount]
ALTER TABLE [margin].[Tb_MarginRptSummary] ADD  CONSTRAINT [DF_Tb_MarginRptSummary_NParameterValue]  DEFAULT ((0)) FOR [NParameterValue]
ALTER TABLE [margin].[Tb_MarginRptSummary] ADD  CONSTRAINT [DF_Tb_MarginRptSummary_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
ALTER TABLE [margin].[Tb_MarginRptSummary] ADD  CONSTRAINT [DF_Tb_MarginRptSummary_ApprovedMarginRatio]  DEFAULT ((0)) FOR [ApprovedMarginRatio]