/****** Object:  Table [import].[Tb_CTF045]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_CTF045](
	[RecordIndicator] [int] NULL,
	[StockCode] [varchar](6) NULL,
	[StockShortName] [varchar](12) NULL,
	[TypeofCorporateExercise] [char](2) NULL,
	[Ratio] [varchar](35) NULL,
	[SequenceofCorporateExercise] [varchar](2) NULL,
	[Exdate] [date] NULL,
	[BookClosingdate/entitlementdate] [date] NULL,
	[ListingDate] [date] NULL,
	[NewStockCode] [varchar](6) NULL,
	[NewStockName] [varchar](12) NULL,
	[DepositorName] [varchar](60) NULL,
	[AccountQualifier1] [varchar](60) NULL,
	[AccountQualifier2] [varchar](60) NULL,
	[DepositorNRIC/Passport/RegistrationNo] [varchar](14) NULL,
	[DepositorCDSAccountNo] [varchar](9) NULL,
	[FreeBalance] [varchar](18) NULL,
	[NetTradeonExdate-2] [varchar](18) NULL,
	[NetTradeonExdate-1] [varchar](18) NULL,
	[IndicativeBalances] [varchar](18) NULL,
	[SourceFileName] [varchar](50) NULL,
	[CreatedOn] [datetime] NULL
) ON [PRIMARY]