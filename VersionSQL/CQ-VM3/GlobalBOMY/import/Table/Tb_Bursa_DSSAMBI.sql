/****** Object:  Table [import].[Tb_Bursa_DSSAMBI]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_Bursa_DSSAMBI](
	[Recordtype] [varchar](1) NULL,
	[Newsellernumber] [varchar](3) NULL,
	[Newsellerbranch] [varchar](3) NULL,
	[Newselleraccountnumber] [varchar](9) NULL,
	[Stockcode] [varchar](6) NULL,
	[Newprice] [varchar](6) NULL,
	[Basiscode] [varchar](1) NULL,
	[Lotcode] [varchar](1) NULL,
	[Boughtinquantity] [varchar](9) NULL,
	[Defaultingseller] [varchar](3) NULL,
	[Defaultingsellerbranch] [varchar](3) NULL,
	[DefaultingTRSdate] [varchar](8) NULL,
	[DefaultingTRSnumber] [varchar](8) NULL,
	[Defaultselleraccountnumber] [varchar](9) NULL,
	[CreatedOn] [datetime] NULL,
	[SourceFileName] [varchar](200) NULL
) ON [PRIMARY]