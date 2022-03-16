﻿/****** Object:  Table [gbomockup].[Tb_Transactions]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [gbomockup].[Tb_Transactions](
	[CompanyId] [bigint] NOT NULL,
	[TransNo] [varchar](30) NOT NULL,
	[TransGroupType] [varchar](5) NULL,
	[TransGroupNo] [varchar](30) NOT NULL,
	[ReversalRefNo] [varchar](30) NULL,
	[TransDate] [date] NOT NULL,
	[BusinessDate] [date] NOT NULL,
	[SetlDate] [date] NULL,
	[InterestSetlDate] [date] NULL,
	[AcctNo] [varchar](20) NOT NULL,
	[FundSourceId] [bigint] NULL,
	[TransType] [varchar](10) NOT NULL,
	[SubTransType] [varchar](10) NULL,
	[Channel] [varchar](10) NULL,
	[CurrCd] [char](3) NULL,
	[Amount] [decimal](24, 9) NULL,
	[AmountBased] [decimal](24, 9) NULL,
	[AmountClientBased] [decimal](24, 9) NULL,
	[Commision] [decimal](24, 9) NULL,
	[CommissionBased] [decimal](24, 9) NULL,
	[CommissionClientBased] [decimal](24, 9) NULL,
	[Fee] [decimal](24, 9) NULL,
	[FeeBased] [decimal](24, 9) NULL,
	[FeeClientBased] [decimal](24, 9) NULL,
	[ProductId] [bigint] NULL,
	[InstrumentId] [bigint] NULL,
	[TradedPrice] [decimal](24, 9) NULL,
	[TradedQty] [decimal](24, 9) NULL,
	[TransDesc] [nvarchar](400) NULL,
	[ReferenceNo] [varchar](50) NOT NULL,
	[GLAccount] [varchar](50) NULL,
	[CustodianId] [bigint] NULL,
	[CustodianAcctNo] [varchar](20) NULL,
	[TaxAmount] [decimal](24, 9) NOT NULL,
	[TaxAmountBased] [decimal](24, 9) NOT NULL,
	[TaxAmountClientBased] [decimal](24, 9) NOT NULL,
	[ExchRateBased] [decimal](24, 9) NOT NULL,
	[ExchRateClientBased] [decimal](24, 9) NOT NULL,
	[RealisedPLTrade] [decimal](24, 9) NULL,
	[RealisedPLBased] [decimal](24, 9) NULL,
	[RealisedPLClientBased] [decimal](24, 9) NULL,
	[ProcessInfo] [varchar](40) NOT NULL,
	[CapitalInd] [bit] NULL,
	[CapitalAmount] [decimal](24, 9) NULL,
	[CapitalAmountBased] [decimal](24, 9) NULL,
	[CapitalAmountClientBased] [decimal](24, 9) NULL,
	[CostTrade] [decimal](24, 9) NULL,
	[CostBased] [decimal](24, 9) NULL,
	[CostClientBased] [decimal](24, 9) NULL,
	[Tag1] [varchar](200) NULL,
	[Tag2] [varchar](200) NULL,
	[Tag3] [varchar](200) NULL,
	[Tag4] [varchar](200) NULL,
	[Tag5] [varchar](200) NULL,
	[RecordId] [uniqueidentifier] NOT NULL,
	[ActionInd] [char](1) NOT NULL,
	[CurrentUser] [varchar](64) NOT NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDate] [datetime2](0) NOT NULL,
	[ModifiedBy] [varchar](64) NULL,
	[ModifiedDate] [datetime2](0) NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC,
	[TransNo] ASC,
	[TransGroupNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [gbomockup].[Tb_Transactions] ADD  CONSTRAINT [DF_Tb_Transactions_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]