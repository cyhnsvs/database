/****** Object:  Table [import].[Tb_AccountNoMapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_AccountNoMapping](
	[OldCustomerID] [varchar](50) NOT NULL,
	[OldAccountNo] [varchar](50) NOT NULL,
	[AccountType78] [varchar](50) NULL,
	[AccountGroup] [varchar](50) NULL,
	[AccountStatus] [varchar](50) NULL,
	[AccountStatusDate] [varchar](50) NULL,
	[ClientName] [varchar](200) NULL,
	[ClientEmail] [varchar](200) NULL,
	[AccountType2DigitCode] [varchar](50) NULL,
	[NewCustomerID] [varchar](50) NULL,
	[NewAccountNo] [varchar](50) NULL,
	[ForeignIndicator] [varchar](50) NULL,
 CONSTRAINT [PK_Tb_AccountNoMapping] PRIMARY KEY CLUSTERED 
(
	[OldAccountNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]