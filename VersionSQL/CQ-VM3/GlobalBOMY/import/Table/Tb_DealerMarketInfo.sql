/****** Object:  Table [import].[Tb_DealerMarketInfo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_DealerMarketInfo](
	[DealerCdBranchID] [varchar](50) NULL,
	[DealerCdEAFID] [varchar](50) NULL,
	[DealerCode] [varchar](50) NULL,
	[MarketCode] [varchar](50) NULL,
	[ContraInd] [varchar](50) NULL,
	[ContraOnTDays] [varchar](50) NULL,
	[ContraOnTDaysType] [varchar](50) NULL,
	[ComputeServiceCharge] [varchar](50) NULL,
	[ContraServiceChargeDayDiff] [varchar](50) NULL,
	[PurchaseDays] [varchar](50) NULL,
	[PurchaseDaysType] [varchar](50) NULL,
	[SalesDays] [varchar](50) NULL,
	[SalesDaysType] [varchar](50) NULL,
	[SetOffInd] [varchar](50) NULL,
	[SetOffContraGainDebitAmt] [varchar](50) NULL,
	[SetOffSalesPurchaseReport] [varchar](50) NULL,
	[SetOffTrustDebitTransaction] [varchar](50) NULL,
	[SetOffTrustContraLoss] [varchar](50) NULL,
	[TransferCreditTransToTrust] [varchar](50) NULL
) ON [PRIMARY]