/****** Object:  Table [report].[Tb_DailyStmtAcctDetails]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [report].[Tb_DailyStmtAcctDetails](
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
	[UpdatedDate] [date] NOT NULL
) ON [PRIMARY]

ALTER TABLE [report].[Tb_DailyStmtAcctDetails] ADD  CONSTRAINT [DF_Tb_DailyStmtAcctDetails_ATSFeeAmount]  DEFAULT ((0)) FOR [ATSFeeAmount]
ALTER TABLE [report].[Tb_DailyStmtAcctDetails] ADD  CONSTRAINT [DF_Tb_DailyStmtAcctDetails_ATSFeeTaxAmount]  DEFAULT ((0)) FOR [ATSFeeTaxAmount]