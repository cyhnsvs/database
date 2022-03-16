/****** Object:  Table [margin].[Tb_MarginRptDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [margin].[Tb_MarginRptDetails](
	[IDD] [bigint] IDENTITY(202410,1) NOT NULL,
	[BusinessDate] [date] NULL,
	[AcctNo] [varchar](50) NOT NULL,
	[InstrumentId] [bigint] NULL,
	[FundSourceId] [bigint] NOT NULL,
	[MarginCurrCd] [varchar](3) NOT NULL,
	[IM] [decimal](24, 9) NOT NULL,
	[Balance] [decimal](24, 9) NOT NULL,
	[BalanceCompanyBased] [decimal](24, 9) NOT NULL,
	[MktValue] [decimal](24, 9) NOT NULL,
	[MktValueCompanyBased] [decimal](24, 9) NOT NULL,
	[Loan] [decimal](24, 9) NOT NULL,
	[LoanCompanyBased] [decimal](24, 9) NOT NULL,
	[MarginRequirement] [decimal](24, 9) NOT NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Tb_MarginRptDetails] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [margin].[Tb_MarginRptDetails] ADD  CONSTRAINT [DF_Tb_MarginRptDetails_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]