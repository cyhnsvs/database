﻿/****** Object:  Table [SettleInstr].[Tb_SecuritySettInst]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [SettleInstr].[Tb_SecuritySettInst](
	[IDD] [bigint] IDENTITY(1,1) NOT NULL,
	[SettleInstrType] [char](1) NOT NULL,
	[SettleInstrAs] [char](2) NULL,
	[InternalTransId] [varchar](35) NULL,
	[ExternalTransId] [varchar](35) NULL,
	[ContFundSource] [varchar](35) NULL,
	[SecuMoveType] [varchar](4) NOT NULL,
	[PaymentType] [varchar](4) NOT NULL,
	[LinkProcPosiCd] [varchar](4) NULL,
	[LinkInternalTransId] [varchar](35) NULL,
	[LinkExternalTransId] [varchar](35) NULL,
	[CorpActnEvtId] [varchar](35) NULL,
	[AllocId] [varchar](35) NULL,
	[TradedMarketIdCd] [varchar](4) NULL,
	[TradedMarketTypeCd] [varchar](4) NOT NULL,
	[TradeDate] [datetime] NULL,
	[TradeSettDate] [datetime] NOT NULL,
	[PriceAmt] [decimal](18, 5) NULL,
	[PriceAmtCcy] [varchar](3) NULL,
	[PriceRate] [decimal](21, 10) NULL,
	[TransRef] [varchar](16) NULL,
	[ISINcd] [varchar](35) NULL,
	[InstrumentCd] [varchar](35) NULL,
	[InstrumentName] [varchar](150) NULL,
	[SettQty] [decimal](24, 0) NULL,
	[SettFaceAmt] [decimal](24, 2) NULL,
	[AcctOwnerAnyBIC] [varchar](35) NULL,
	[AcctOwnerId] [varchar](35) NULL,
	[SafekeepingAcctId] [varchar](35) NULL,
	[SettHoldInd] [bit] NULL,
	[SecuTransTypeCd] [varchar](35) NULL,
	[SettSysMethodId] [varchar](35) NULL,
	[SettPtyDepositoryId] [varchar](35) NULL,
	[SettPtyAnyBIC] [varchar](35) NULL,
	[SettPtyId] [varchar](35) NULL,
	[SettAmount] [decimal](24, 2) NULL,
	[SettCcy] [varchar](3) NULL,
	[CreditDebitInd] [varchar](4) NULL,
	[AIAmount] [decimal](24, 2) NULL,
	[AICurrency] [varchar](3) NULL,
	[AICreditDebitInd] [varchar](4) NULL,
	[BrokerCommTradedCcy] [varchar](3) NULL,
	[BrokerCommSettlementCcy] [varchar](3) NULL,
	[BrokerCommExchRate] [decimal](24, 6) NULL,
	[BrokerCommResultAmt] [decimal](24, 2) NULL,
	[OtherBizPtySafekeepingAcctId] [varchar](35) NULL,
	[ActualQtySettled] [decimal](24, 0) NULL,
	[RemainingQtyToSettled] [decimal](24, 0) NULL,
	[SettlementStatus] [char](2) NULL,
	[SettlementStatusRemarks] [varchar](max) NULL,
	[ModificationStatus] [char](2) NULL,
	[ModificationStatusRemarks] [varchar](200) NULL,
	[CancelStatus] [char](2) NULL,
	[CancelStatusRemarks] [varchar](200) NULL,
	[EarmarkStatus] [char](2) NULL,
	[EarmarkStatusRemarks] [varchar](200) NULL,
	[ProcessSts] [char](2) NOT NULL,
	[AccNo] [varchar](25) NULL,
	[AccServiceType] [varchar](10) NULL,
	[AeCd] [varchar](15) NULL,
	[AeEmail] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Createdby] [varchar](64) NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](64) NULL,
 CONSTRAINT [PK__Tb_Secur__C4971C2A18CEE6FD] PRIMARY KEY CLUSTERED 
(
	[IDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [SettleInstr].[Tb_SecuritySettInst] ADD  CONSTRAINT [DF_Tb_SecuritySettInst_SettlementStatus1]  DEFAULT ('0') FOR [SettlementStatus]
ALTER TABLE [SettleInstr].[Tb_SecuritySettInst] ADD  CONSTRAINT [DF_Tb_SecuritySettInst_ProcessSts1]  DEFAULT ('0') FOR [SettlementStatusRemarks]
ALTER TABLE [SettleInstr].[Tb_SecuritySettInst] ADD  CONSTRAINT [DF_Tb_SecuritySettInst_ProcessSts1_1]  DEFAULT ('0') FOR [ProcessSts]
ALTER TABLE [SettleInstr].[Tb_SecuritySettInst] ADD  CONSTRAINT [DF_Tb_SecuritySettInst_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]