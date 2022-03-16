/****** Object:  Table [margin].[Tb_MarginRptDetails_Archive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [margin].[Tb_MarginRptDetails_Archive](
	[IDDArchive] [bigint] IDENTITY(1,1) NOT NULL,
	[IDD] [bigint] NOT NULL,
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
	[ArchivedDate] [datetime] NULL,
 CONSTRAINT [PK_Tb_MarginRptDetails_Archive] PRIMARY KEY CLUSTERED 
(
	[IDDArchive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]