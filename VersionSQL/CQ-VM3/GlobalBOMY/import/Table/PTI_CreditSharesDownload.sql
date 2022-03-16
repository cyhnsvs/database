/****** Object:  Table [import].[PTI_CreditSharesDownload]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[PTI_CreditSharesDownload](
	[PtiCreditShareId] [bigint] IDENTITY(1,1) NOT NULL,
	[ParticipantID] [char](3) NOT NULL,
	[TradingFlag] [char](1) NOT NULL,
	[TransactionDateOfCorporateAction] [char](10) NOT NULL,
	[TransactionTypeOfCorporateAction] [char](2) NOT NULL,
	[TransactionNumberOfCorporateAction] [numeric](12, 0) NOT NULL,
	[MarketID] [char](1) NOT NULL,
	[CreditedSecuritySymbol] [char](20) NOT NULL,
	[CreditedISINCode] [char](12) NOT NULL,
	[QuantityOfSecurities] [numeric](24, 6) NOT NULL,
	[UnderlyingSecuritySymbol] [char](20) NOT NULL,
	[UnderlyingISINCode] [char](12) NOT NULL,
	[ReferenceType] [char](1) NOT NULL,
	[ReferenceNumber] [char](13) NOT NULL,
	[BrokerageAccountID] [char](15) NOT NULL,
	[NationalityCode] [char](3) NOT NULL,
	[ShareholderType] [char](1) NOT NULL,
	[DistributionType] [char](1) NOT NULL,
	[Sex] [char](1) NOT NULL,
	[OfficialPrefixCode] [char](3) NOT NULL,
	[OfficialPrefixDescription] [char](30) NOT NULL,
	[OfficialFirstName] [char](40) NOT NULL,
	[OfficialLastName] [char](110) NOT NULL,
	[OptionalPrefixCode] [char](3) NOT NULL,
	[OptionalPrefixDescription] [char](30) NOT NULL,
	[OptionalFirstName] [char](40) NOT NULL,
	[OptionalLastName] [char](110) NOT NULL,
	[HomePhone] [char](30) NOT NULL,
	[WorkPhone] [char](30) NOT NULL,
	[MobilePhone] [char](30) NOT NULL,
	[Fax] [char](20) NOT NULL,
	[BirthDate] [char](10) NOT NULL,
	[CareerCode] [char](3) NOT NULL,
	[TaxID] [char](13) NOT NULL,
	[Email] [char](60) NOT NULL,
	[Address] [char](140) NOT NULL,
	[PostalCode] [char](5) NOT NULL,
	[AccountNumber] [char](13) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[CreatedBy] [varchar](64) NOT NULL,
	[UpdatedTime] [datetime] NULL,
	[UpdatedBy] [varchar](64) NULL,
	[RecordStatus] [char](1) NULL,
	[GBOAccountNo] [varchar](20) NULL,
	[GBOAccountName] [nvarchar](150) NULL,
 CONSTRAINT [PK_PTI_CreditSharesDownload] PRIMARY KEY CLUSTERED 
(
	[PtiCreditShareId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [import].[PTI_CreditSharesDownload] ADD  CONSTRAINT [DF_PTI_CreditSharesDownload_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]