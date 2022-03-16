/****** Object:  Table [import].[Tb_ECOS_EFMACS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ECOS_EFMACS](
	[RecordType] [varchar](1) NULL,
	[ClientName] [varchar](30) NULL,
	[ClientCode] [varchar](9) NULL,
	[BranchID] [varchar](3) NULL,
	[DealerID] [varchar](5) NULL,
	[DealerCode] [varchar](8) NULL,
	[StockCode] [varchar](6) NULL,
	[OrderType] [varchar](1) NULL,
	[SourceID] [varchar](1) NULL,
	[OrderSource] [varchar](1) NULL,
	[SCOREOrderNumber] [varchar](11) NULL,
	[EBCOrderNumber] [varchar](12) NULL,
	[MatchQuantity] [varchar](9) NULL,
	[MatchPrice] [varchar](9) NULL,
	[DateTime] [varchar](19) NULL,
	[CRLF] [varchar](2) NULL,
	[SourceFileName] [varchar](500) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]