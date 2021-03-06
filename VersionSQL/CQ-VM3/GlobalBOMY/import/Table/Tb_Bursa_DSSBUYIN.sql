/****** Object:  Table [import].[Tb_Bursa_DSSBUYIN]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Bursa_DSSBUYIN](
	[Recordtype] [varchar](1) NULL,
	[Sellernumber] [varchar](3) NULL,
	[Sellerbranch] [varchar](3) NULL,
	[Sellerclientaccount] [varchar](9) NULL,
	[Sellerterminalid] [varchar](9) NULL,
	[Sellerordernumber] [varchar](8) NULL,
	[TRSdate] [varchar](8) NULL,
	[TRSnumber] [varchar](8) NULL,
	[Stockcode] [varchar](6) NULL,
	[Lotcode] [varchar](1) NULL,
	[Basiscode] [varchar](1) NULL,
	[Sellingprice] [varchar](6) NULL,
	[Buyingprice] [varchar](6) NULL,
	[Outstandingquantity] [varchar](9) NULL,
	[Buyernumber] [varchar](3) NULL,
	[Buyerbranch] [varchar](3) NULL,
	[Buyerclientaccount] [varchar](9) NULL,
	[Buyerterminalid] [varchar](3) NULL,
	[Buyerordernumber] [varchar](8) NULL,
	[BuyerTRS] [varchar](8) NULL,
	[Statuscode] [varchar](1) NULL,
	[Filler] [varchar](23) NULL,
	[CreatedOn] [datetime] NULL,
	[SourceFileName] [varchar](200) NULL
) ON [PRIMARY]