﻿/****** Object:  Table [import].[Tb_AccountGroup_MarketInfo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_AccountGroup_MarketInfo](
	[AccountGroupCode] [varchar](50) NULL,
	[MarketCode] [varchar](50) NULL,
	[ApprovedLimit] [varchar](50) NULL,
	[PrintContract] [varchar](50) NULL,
	[CallWarantIndicator] [varchar](50) NULL,
	[ShortSellIndicator] [varchar](50) NULL,
	[IslamicTradeIndicator] [varchar](50) NULL,
	[IntraDayIndicator] [varchar](50) NULL,
	[ContraInd] [varchar](50) NULL,
	[ShortSellInd] [varchar](50) NULL,
	[OddLotsInd] [varchar](50) NULL,
	[DesignatedCounterInd] [varchar](50) NULL,
	[PN4CounterInd] [varchar](50) NULL,
	[ImmediateBasicInd] [varchar](50) NULL,
	[PartialPaidTradeInd] [varchar](50) NULL,
	[ComputeServiceCharges] [varchar](50) NULL,
	[DayDifferenceBasedOn] [varchar](50) NULL,
	[PurchaseDays] [varchar](50) NULL,
	[PurchaseDaysCW] [varchar](50) NULL,
	[SalesDays] [varchar](50) NULL,
	[SalesDaysWW] [varchar](50) NULL,
	[PrintContraStatement] [varchar](50) NULL,
	[SetoffInd] [varchar](50) NULL,
	[SetoffContraGainDebitAmount] [varchar](50) NULL,
	[SetoffSalesPurchasesReport] [varchar](50) NULL,
	[SetoffTrustDebitTransactions] [varchar](50) NULL,
	[SetoffTrustContraLoss] [varchar](50) NULL,
	[TranferCreditTransactionToTrust] [varchar](50) NULL,
	[PrintSetoffStatement] [varchar](50) NULL,
	[MultiplierForCashDeposit] [varchar](50) NULL,
	[MultiplierForNonShare] [varchar](50) NULL,
	[MultiplierForAvailableLimit] [varchar](50) NULL,
	[AutoSuspensionCriteria1] [varchar](50) NULL,
	[NetContraLossesApprovedLimit] [varchar](50) NULL,
	[AutoSuspensionCriteria2] [varchar](50) NULL,
	[NetContraLossesAND2] [varchar](50) NULL,
	[ContraLossesAgingDaysDAYS] [varchar](50) NULL,
	[ContraLossesAgingDaysWORKINGCALENDAR] [varchar](50) NULL,
	[AutoSuspensionCriteria3] [varchar](50) NULL,
	[NetContraLossesAND3] [varchar](50) NULL,
	[NetContraLossesANDLess3] [varchar](50) NULL,
	[ContraLossesAgingDaysDAYS3] [varchar](50) NULL,
	[ContraLossesAgingDaysWORKINGCALENDAR3] [varchar](50) NULL,
	[AutoSuspensionCriteria4] [varchar](50) NULL,
	[NetContraLossesAND4] [varchar](50) NULL,
	[ContraLossesAgingDaysDAYS4] [varchar](50) NULL,
	[ContraLossesAgingDaysWORKINGCALENDAR4] [varchar](50) NULL
) ON [PRIMARY]