﻿/****** Object:  Table [import].[Tb_AcctOpening_CFT040]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_AcctOpening_CFT040](
	[RecordType] [varchar](1) NULL,
	[RecordStatus] [varchar](1) NULL,
	[RejectReason] [varchar](30) NULL,
	[ParticiapantCode] [varchar](9) NULL,
	[AcctNo] [varchar](9) NULL,
	[AcctType] [varchar](2) NULL,
	[NRICId] [varchar](14) NULL,
	[OldNRICId] [varchar](14) NULL,
	[InvestorName] [varchar](60) NULL,
	[InvestorType] [varchar](2) NULL,
	[Nationality/POI] [varchar](3) NULL,
	[Race] [varchar](1) NULL,
	[AcctStatus] [varchar](1) NULL,
	[Address1] [varchar](45) NULL,
	[Address2] [varchar](45) NULL,
	[Town] [varchar](25) NULL,
	[State] [varchar](1) NULL,
	[PostalCode] [varchar](5) NULL,
	[Country] [varchar](3) NULL,
	[BeneficialOwner] [varchar](1) NULL,
	[Qualifier1] [varchar](60) NULL,
	[Qualifier2] [varchar](60) NULL,
	[CorrAddress1] [varchar](45) NULL,
	[CorrAddress2] [varchar](45) NULL,
	[CorrTown] [varchar](25) NULL,
	[CorrState] [varchar](1) NULL,
	[CorrPostalCode] [varchar](5) NULL,
	[CorrCountry] [varchar](3) NULL,
	[PhoneIdd] [varchar](3) NULL,
	[PhoneStd] [varchar](5) NULL,
	[PhoneLocal] [varchar](8) NULL,
	[PhoneExt] [varchar](3) NULL,
	[BankAccount] [varchar](20) NULL,
	[BankCode] [varchar](6) NULL,
	[ConsolidateInd] [varchar](1) NULL,
	[JointInd] [varchar](1) NULL,
	[PhoneMobileIdd] [varchar](3) NULL,
	[PhoneMobileCode] [varchar](3) NULL,
	[PhoneMobileNo] [varchar](8) NULL,
	[Email] [varchar](200) NULL,
	[ConsentInd] [varchar](1) NULL,
	[DateConsentEnd] [varchar](8) NULL,
	[Remarks] [varchar](30) NULL,
	[TaggingCode] [varchar](1) NULL,
	[SourceFileName] [nvarchar](500) NULL,
	[CreatedOn] [datetime] NULL,
	[IsImported] [bit] NULL,
	[RecordID] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

ALTER TABLE [import].[Tb_AcctOpening_CFT040] ADD  CONSTRAINT [DF__Tb_AcctOp__IsImp__6E2C3FB6]  DEFAULT ((0)) FOR [IsImported]