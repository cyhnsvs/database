/****** Object:  Table [import].[Tb_FOSActiveTradingAccount]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_FOSActiveTradingAccount](
	[CustomerKey] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[CDSNo] [varchar](50) NULL,
	[AccountStatus] [varchar](50) NULL,
	[FRONT OFFICE USER ID] [varchar](50) NULL,
	[BrokerCodeDealerEAFIDDealerCode] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[Trading Acct] [varchar](50) NULL,
	[Remarks] [varchar](200) NULL
) ON [PRIMARY]