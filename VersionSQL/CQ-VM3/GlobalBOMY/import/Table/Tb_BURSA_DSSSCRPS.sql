/****** Object:  Table [import].[Tb_BURSA_DSSSCRPS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_BURSA_DSSSCRPS](
	[RecordType] [varchar](1) NULL,
	[BrokerNo] [varchar](3) NULL,
	[BrokerBranchNo] [varchar](3) NULL,
	[ContractDate] [varchar](8) NULL,
	[TRSNumber] [varchar](8) NULL,
	[StockCode] [varchar](6) NULL,
	[ClientAccountNo] [varchar](9) NULL,
	[TradedQty] [varchar](9) NULL,
	[TradedPrice] [varchar](6) NULL,
	[DeductionAmount] [varchar](9) NULL,
	[BuyingInRemarks] [varchar](1) NULL,
	[DeductionRemarks] [varchar](3) NULL,
	[Seller/BuyerNumber] [varchar](3) NULL,
	[FileName] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]