/****** Object:  Table [margin].[Tb_MarginRptSummary_Archive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [margin].[Tb_MarginRptSummary_Archive](
	[IDDArchive] [bigint] IDENTITY(1,1) NOT NULL,
	[IDD] [bigint] NOT NULL,
	[BusinessDate] [date] NULL,
	[AcctNo] [varchar](50) NOT NULL,
	[MarginCurrCd] [varchar](3) NOT NULL,
	[MM] [decimal](24, 9) NULL,
	[FS] [decimal](24, 9) NULL,
	[SMM] [decimal](24, 9) NULL,
	[SFS] [decimal](24, 9) NULL,
	[Balance] [decimal](24, 9) NOT NULL,
	[BalanceCompanyBased] [decimal](24, 9) NOT NULL,
	[LongMktValue] [decimal](24, 9) NOT NULL,
	[LongMktValuePledge] [decimal](24, 9) NOT NULL,
	[ShortMktValue] [decimal](24, 9) NOT NULL,
	[Loan] [decimal](24, 9) NOT NULL,
	[LoanCompanyBased] [decimal](24, 9) NOT NULL,
	[Equity] [decimal](24, 9) NOT NULL,
	[MarginRequirement] [decimal](24, 9) NOT NULL,
	[ExcessEquity] [decimal](24, 9) NOT NULL,
	[PurchasePower] [decimal](24, 9) NOT NULL,
	[MarginCall] [decimal](24, 9) NOT NULL,
	[CallShortage] [decimal](24, 9) NOT NULL,
	[MarginForce] [decimal](24, 9) NOT NULL,
	[ForceShortage] [decimal](24, 9) NOT NULL,
	[Action] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ArchivedDate] [datetime] NULL,
 CONSTRAINT [PK_Tb_MarginRptSummary_Archive] PRIMARY KEY CLUSTERED 
(
	[IDDArchive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]