/****** Object:  Table [report].[Tb_DailyStmtAcctDetails_Archive]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [report].[Tb_DailyStmtAcctDetails_Archive](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoicePartNo] [bigint] NOT NULL,
	[AcctNo] [varchar](50) NOT NULL,
	[CustNo] [varchar](50) NOT NULL,
	[TransDate] [date] NULL,
	[TradeDate] [date] NOT NULL,
	[SetlDate] [date] NOT NULL,
	[Amt] [decimal](38, 9) NOT NULL,
	[ATSFeeAmount] [decimal](24, 9) NULL,
	[ATSFeeTaxAmount] [decimal](24, 9) NULL,
	[Refno] [varchar](100) NOT NULL,
	[InvoiceNo] [varchar](100) NULL,
	[Branch] [varchar](500) NULL,
	[Line1] [varchar](500) NULL,
	[Line2] [varchar](500) NULL,
	[Line21] [varchar](500) NULL,
	[Line22] [varchar](500) NULL,
	[Line3] [varchar](500) NULL,
	[Line4] [varchar](500) NULL,
	[Barcode] [varchar](500) NULL,
	[Location] [varchar](500) NULL,
	[ClientTaxID] [varchar](500) NULL,
	[settlementRoute] [varchar](500) NULL,
	[UpdatedDate] [date] NOT NULL,
	[ArchivedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Tb_DailyStmtAcctDetails_Archive] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [report].[Tb_DailyStmtAcctDetails_Archive] ADD  CONSTRAINT [DF_Tb_DailyStmtAcctDetails_Archive_ATSFeeAmount]  DEFAULT ((0)) FOR [ATSFeeAmount]
ALTER TABLE [report].[Tb_DailyStmtAcctDetails_Archive] ADD  CONSTRAINT [DF_Tb_DailyStmtAcctDetails_Archive_ATSFeeTaxAmount]  DEFAULT ((0)) FOR [ATSFeeTaxAmount]
ALTER TABLE [report].[Tb_DailyStmtAcctDetails_Archive] ADD  CONSTRAINT [DF_Tb_DailyStmtAcctDetails_Archive_ArchivedDate]  DEFAULT (getdate()) FOR [ArchivedDate]