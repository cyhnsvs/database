/****** Object:  Table [form].[Tb_ExportFormDataDelta_1409]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [form].[Tb_ExportFormDataDelta_1409](
	[RecordID] [bigint] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedTime] [datetime] NULL,
	[CustomerID (selectsource-1)] [nvarchar](4000) NULL,
	[CustomerName (textinput-76)] [nvarchar](4000) NULL,
	[AccountGroup (selectsource-2)] [nvarchar](4000) NULL,
	[ParentGroup (selectsource-3)] [nvarchar](4000) NULL,
	[AccountType (selectsource-7)] [nvarchar](4000) NULL,
	[ALGOIndicator (selectbasic-26)] [nvarchar](4000) NULL,
	[AccountNumber (textinput-5)] [nvarchar](4000) NULL,
	[OldAccountNo (textinput-73)] [nvarchar](4000) NULL,
	[NomineesName1 (selectsource-20)] [nvarchar](4000) NULL,
	[NomineesName2 (textinput-7)] [nvarchar](4000) NULL,
	[NomineesName3 (textinput-8)] [nvarchar](4000) NULL,
	[NomineesName4 (textinput-9)] [nvarchar](4000) NULL,
	[AbbreviatedName (textinput-10)] [nvarchar](4000) NULL,
	[CADEntityType1 (selectsource-18)] [nvarchar](4000) NULL,
	[FirstTradingDate (dateinput-25)] [nvarchar](4000) NULL,
	[LastTransactionDate (dateinput-22)] [nvarchar](4000) NULL,
	[LastTradingDate (dateinput-23)] [nvarchar](4000) NULL,
	[Dormant (multipleradiosinline-26)] [nvarchar](4000) NULL,
	[AveragingOption (multipleradiosinline-1)] [nvarchar](4000) NULL,
	[OddLotAveragingOption (selectbasic-4)] [nvarchar](4000) NULL,
	[DealerCode (selectsource-21)] [nvarchar](4000) NULL,
	[SendClientInfotoBFE (selectbasic-27)] [nvarchar](4000) NULL,
	[MRIndicator (multipleradiosinline-4)] [nvarchar](4000) NULL,
	[MarketPSS (multipleradiosinline-28)] [nvarchar](4000) NULL,
	[ShareCheck (multipleradiosinline-29)] [nvarchar](4000) NULL,
	[MRCode (selectsource-22)] [nvarchar](4000) NULL,
	[IDSSInd (multipleradiosinline-10)] [nvarchar](4000) NULL,
	[PSSInd (multipleradiosinline-11)] [nvarchar](4000) NULL,
	[ReferenceCode (selectsource-23)] [nvarchar](4000) NULL,
	[CDSNo (textinput-19)] [nvarchar](4000) NULL,
	[CDSACOpenBranch (selectsource-4)] [nvarchar](4000) NULL,
	[MarketMaker (multipleradiosinline-27)] [nvarchar](4000) NULL,
	[NomineeInd (selectsource-5)] [nvarchar](4000) NULL,
	[StructureWarrant (selectbasic-7)] [nvarchar](4000) NULL,
	[ShortSellRSSInd (selectbasic-42)] [nvarchar](4000) NULL,
	[ShortSellPDTInd (selectbasic-43)] [nvarchar](4000) NULL,
	[IslamicTradeInd (selectbasic-9)] [nvarchar](4000) NULL,
	[IntraDayInd (selectbasic-12)] [nvarchar](4000) NULL,
	[SettlementCurrency (selectsource-6)] [nvarchar](4000) NULL,
	[ContraInd (selectbasic-13)] [nvarchar](4000) NULL,
	[ContraforShortSelling (selectbasic-28)] [nvarchar](4000) NULL,
	[ContraforOddLots (selectbasic-15)] [nvarchar](4000) NULL,
	[ContraforIntraday (selectbasic-29)] [nvarchar](4000) NULL,
	[DesignatedCounterInd (selectbasic-16)] [nvarchar](4000) NULL,
	[ImmediateBasisInd (selectbasic-19)] [nvarchar](4000) NULL,
	[SettlementMode (selectbasic-41)] [nvarchar](4000) NULL,
	[TransferCreditTransToTrust (multipleradiosinline-23)] [nvarchar](4000) NULL,
	[DeductTrustToSettlePurchase (multipleradiosinline-24)] [nvarchar](4000) NULL,
	[DeductTrustToSettleNonTradeDebitTrans (multipleradiosinline-25)] [nvarchar](4000) NULL,
	[VBIP (selectbasic-39)] [nvarchar](4000) NULL,
	[Tradingaccount (selectsource-31)] [nvarchar](4000) NULL,
	[DateofTradingAccountOpened (dateinput-20)] [nvarchar](4000) NULL,
	[CDSAccount (selectsource-32)] [nvarchar](4000) NULL,
	[DateofCDSOpened (dateinput-21)] [nvarchar](4000) NULL,
	[AccountOpenedBy (textinput-74)] [nvarchar](4000) NULL,
	[SuspensionCloseReason (selectsource-30)] [nvarchar](4000) NULL,
	[DateofCDSUpdated (dateinput-24)] [nvarchar](4000) NULL,
	[CDSSuspensionCloseReason (textinput-75)] [nvarchar](4000) NULL,
	[ApproveTradingLimit (textinput-54)] [nvarchar](4000) NULL,
	[AvailableTradingLimit (textinput-55)] [nvarchar](4000) NULL,
	[BFEACType (selectsource-29)] [nvarchar](4000) NULL,
	[ClientAssoAllowed (multipleradiosinline-13)] [nvarchar](4000) NULL,
	[ClientReassignAllowed (multipleradiosinline-14)] [nvarchar](4000) NULL,
	[ClientCrossAmend (multipleradiosinline-15)] [nvarchar](4000) NULL,
	[MultiplierforCashDeposit (textinput-56)] [nvarchar](4000) NULL,
	[MultiplierforSharePledged (textinput-57)] [nvarchar](4000) NULL,
	[MultiplierforNonShare (textinput-58)] [nvarchar](4000) NULL,
	[AvailableCleanLineLimit (textinput-59)] [nvarchar](4000) NULL,
	[StartDate (dateinput-9)] [nvarchar](4000) NULL,
	[EndDate (dateinput-10)] [nvarchar](4000) NULL,
	[TemporaryLimit (textinput-60)] [nvarchar](4000) NULL,
	[StartDate (dateinput-11)] [nvarchar](4000) NULL,
	[EndDate (dateinput-12)] [nvarchar](4000) NULL,
	[Financier (selectsource-25)] [nvarchar](4000) NULL,
	[MarginCode (textinput-39)] [nvarchar](4000) NULL,
	[CommencementDate (dateinput-4)] [nvarchar](4000) NULL,
	[ExclusionforAutoRenewal (selectbasic-40)] [nvarchar](4000) NULL,
	[TenorExpiryDate (dateinput-5)] [nvarchar](4000) NULL,
	[LetterofOfferDate (dateinput-15)] [nvarchar](4000) NULL,
	[FacilityAgreementDate (dateinput-16)] [nvarchar](4000) NULL,
	[MortgageAgreementDate (dateinput-17)] [nvarchar](4000) NULL,
	[ApprovedMargin (textinput-65)] [nvarchar](4000) NULL,
	[ApprovedRSV (textinput-43)] [nvarchar](4000) NULL,
	[PriceCapMOF (textinput-44)] [nvarchar](4000) NULL,
	[MarginCallInterval (selectbasic-38)] [nvarchar](4000) NULL,
	[AuthorisedRepresentative (textinput-66)] [nvarchar](4000) NULL,
	[CurrentMargin (textinput-47)] [nvarchar](4000) NULL,
	[CurrentRSV (textinput-48)] [nvarchar](4000) NULL,
	[ClearPreviousDayOrder (multipleradiosinline-19)] [nvarchar](4000) NULL,
	[Access (multipleradiosinline-20)] [nvarchar](4000) NULL,
	[CommitmentFeeCode (selectsource-26)] [nvarchar](4000) NULL,
	[WithLimit (multipleradiosinline-18)] [nvarchar](4000) NULL,
	[Buy (multipleradiosinline-21)] [nvarchar](4000) NULL,
	[Sell (multipleradiosinline-22)] [nvarchar](4000) NULL,
	[Remarks (textinput-72)] [nvarchar](4000) NULL,
	[MaxBuyLimit (textinput-68)] [nvarchar](4000) NULL,
	[MaxBuyLimitatAccountGroupXKLS (selectsource-33)] [nvarchar](4000) NULL,
	[MaxSellLimit (textinput-69)] [nvarchar](4000) NULL,
	[MaxSellLimitatAccountGroupXKLS (selectsource-34)] [nvarchar](4000) NULL,
	[MaxNetLimit (textinput-70)] [nvarchar](4000) NULL,
	[MaxNetLimitatAccountGroupXKLS (selectsource-35)] [nvarchar](4000) NULL,
	[ExceedLimit (textinput-71)] [nvarchar](4000) NULL,
	[RASTagging (grid-1)] [nvarchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[RecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]