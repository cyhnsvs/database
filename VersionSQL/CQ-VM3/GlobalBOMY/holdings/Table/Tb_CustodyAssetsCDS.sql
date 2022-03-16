/****** Object:  Table [holdings].[Tb_CustodyAssetsCDS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [holdings].[Tb_CustodyAssetsCDS](
	[CompanyId] [bigint] NOT NULL,
	[AcctNo] [varchar](20) NOT NULL,
	[FundSourceId] [bigint] NOT NULL,
	[CustodianId] [bigint] NOT NULL,
	[CustodianAcctNo] [varchar](20) NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[InstrumentId] [bigint] NOT NULL,
	[Balance] [decimal](24, 9) NOT NULL,
	[Lent] [decimal](24, 9) NOT NULL,
	[Borrowed] [decimal](24, 9) NOT NULL,
	[RPBalance] [decimal](24, 9) NOT NULL,
	[UnavailableBalance] [decimal](24, 9) NOT NULL,
	[FinalBalance] [decimal](24, 9) NOT NULL,
	[CostTrade] [decimal](24, 9) NOT NULL,
	[CostCompanyBased] [decimal](24, 9) NOT NULL,
	[CostClientBased] [decimal](24, 9) NOT NULL,
	[RecordId] [uniqueidentifier] NOT NULL,
	[ModifiedProcessId] [uniqueidentifier] NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[ModifiedBy] [varchar](64) NULL,
	[ModifiedDate] [datetime2](0) NULL,
 CONSTRAINT [PK_Tb_CustodyAssets] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC,
	[AcctNo] ASC,
	[FundSourceId] ASC,
	[CustodianId] ASC,
	[CustodianAcctNo] ASC,
	[ProductId] ASC,
	[InstrumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [holdings].[Tb_CustodyAssetsCDS] ADD  CONSTRAINT [DF_Tb_CustodyAssetsCDS_Lent]  DEFAULT ((0.0)) FOR [Lent]
ALTER TABLE [holdings].[Tb_CustodyAssetsCDS] ADD  CONSTRAINT [DF_Tb_CustodyAssetsCDS_Borrowed]  DEFAULT ((0.0)) FOR [Borrowed]
ALTER TABLE [holdings].[Tb_CustodyAssetsCDS] ADD  CONSTRAINT [DF_Tb_CustodyAssetsCDS_RPBalance]  DEFAULT ((0)) FOR [RPBalance]
ALTER TABLE [holdings].[Tb_CustodyAssetsCDS] ADD  CONSTRAINT [DF_Tb_CustodyAssetsCDS_UnavailableBalance]  DEFAULT ((0.0)) FOR [UnavailableBalance]
ALTER TABLE [holdings].[Tb_CustodyAssetsCDS] ADD  CONSTRAINT [DF_Tb_CustodyAssetsCDS_FinalBalance]  DEFAULT ((0.0)) FOR [FinalBalance]
ALTER TABLE [holdings].[Tb_CustodyAssetsCDS] ADD  CONSTRAINT [DF_Tb_CustodyAssetsCDS_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]