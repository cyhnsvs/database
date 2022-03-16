/****** Object:  Procedure [import].[Usp_4_Account_FileToForm1409_20210819]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_4_Account_FileToForm1409]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 06/04/2020
Last Updated Date :             
Description       : this sp is used to insert Account file data into CQForm Account
            i
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_4_Account_FileToForm1409];
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DEPENDENCY ON CUSTOMER & ACCOUNT MAPPING SCRIPT


		--Use CQBTempDB
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1409;
		--Select * from CQBTempDB.[import].[Tb_FormData_1409]
		
		TRUNCATE TABLE CQBTempDB.[import].[Tb_FormData_1409];

		--DELETE FROM import.Tb_FO_Users where [ACCOUNT NUMBER]='IVT019V' AND [FRONT OFFICE USER ID]='DEMO2'

		INSERT INTO CQBTempDB.[import].Tb_FormData_1409(
			[RecordID],
			[Action],
			[AccountGroup (selectsource-2)],
			[ParentGroup (selectsource-3)],
			[MRIndicator (multipleradiosinline-4)],
			[AccountType (selectsource-7)],
			[ALGOIndicator (selectbasic-26)],
			[CustomerID (selectsource-1)],
			[AccountNumber (textinput-5)],
			[AccountSubCode (textinput-6)],
			[NomineesName1 (selectsource-20)],
			[NomineesName2 (textinput-7)],
			[NomineesName3 (textinput-8)],
			[NomineesName4 (textinput-9)],
			[AbbreviatedName (textinput-10)],
			[ContraforShortSelling (selectbasic-28)],
			[CADEntityType1 (selectsource-18)],
			[AveragingOption (multipleradiosinline-1)],
			[OddLotAveragingOption (selectbasic-4)],
			[DealerCode (selectsource-21)],
			[SendClientInfotoBFE (selectbasic-27)],
			[AccountStatus (selectsource-9)],
			[MRReference (selectsource-22)],
			[ContraforOddLots (selectbasic-15)],
			[ReferenceSource (selectsource-23)],
			[CDSNo (textinput-19)],
			[CDSACOpenBranch (selectsource-4)],
			[NomineeInd (selectsource-5)],
			[StructureWarrant (selectbasic-7)],
			[ShortSellInd (selectsource-19)],
			[IDSSInd (multipleradiosinline-10)],
			[PSSInd (multipleradiosinline-11)],
			[IslamicTradeInd (selectbasic-9)],
			[IntraDayInd (selectbasic-12)],
			[SettlementCurrency (selectsource-6)],
			[ContraInd (selectbasic-13)],
			[ContraforIntraday (selectbasic-29)],
			[DesignatedCounterInd (selectbasic-16)],
			[ImmediateBasisInd (selectbasic-19)],
			[SetoffInd (selectbasic-30)],
			[SetoffContraGainDebitAmount (selectbasic-31)],
			[SetoffSalesPurchasesReport (selectbasic-32)],
			[SetoffTrustDebitTransactions (selectbasic-33)],
			[SetoffTrustContraLoss (selectbasic-34)],
			[TransferCreditTransactiontoTrust (selectbasic-35)],
			[UserID (textinput-52)],
			[OnlineSystemIndicator (multiplecheckboxesinline-1)],
			[VBIP (selectbasic-39)],
			[ApproveTradingLimit (textinput-54)],
			[AvailableTradingLimit (textinput-55)],
			[BFEACType (selectsource-29)],
			[ClientAssoallowed (multipleradiosinline-13)],
			[ClientReassignallowed (multipleradiosinline-14)],
			[ClientCrossamend (multipleradiosinline-15)],
			[MultiplierforCashDeposit (textinput-56)],
			[Multiplierforsharepledged (textinput-57)],
			[MultiplierforNonShare (textinput-58)],
			[AvailableCleanLineLimit (textinput-59)],
			[StartDate (dateinput-9)],
			[EndDate (dateinput-10)],
			[TemporaryLimit (textinput-60)],
			[StartDate (dateinput-11)],
			[EndDate (dateinput-12)],
			[LegalStatus (selectsource-24)],
			[BankruptcyorWindingupstatus (multipleradiosinline-12)],
			[BankruptcyorWindingupreason (textinput-61)],
			[DatedeclaredbankruptcyorWindingup (dateinput-13)],
			[DatedischargedbankruptcyorWindingup (dateinput-14)],
			[Remark1 (textinput-62)],
			[Remark2 (textinput-63)],
			[Financier (selectsource-25)],
			[MarginCode (textinput-39)],
			[CommencementDate (dateinput-4)],
			[ExclusionforAutoRenewal (selectbasic-40)],
			[TenorExpiryDate (dateinput-5)],
			[LetterofOfferdate (dateinput-15)],
			[FacilityAgreementDate (dateinput-16)],
			[MortgageAgreementDate (dateinput-17)],
			[ApprovedLimit (textinput-64)],
			[ApprovedMargin (textinput-65)],
			[ApprovedRSV (textinput-43)],
			[PriceCapMOF (textinput-44)],
			[MarginCallInterval (selectbasic-38)],
			[AuthorisedRepresentative (textinput-66)],
			[CurrentMargin (textinput-47)],
			[CurrentRSV (textinput-48)],
			[CommitmentFeeCode (selectsource-26)])
		SELECT DISTINCT 
			null as [RecordID],
			'I' as [Action],
			CASE WHEN A.AccountGroup ='G' AND Financier='ALB' THEN 'GA' 
					WHEN A.AccountGroup ='G' AND Financier='CIMB' THEN 'GC' 
					WHEN A.AccountGroup ='G' AND Financier='HLB' THEN 'GH' 
					ELSE A.AccountGroup END as  [AccountGroup (selectsource-2)],
			ParentGroup as  [ParentGroup (selectsource-3)],
			CASE WHEN A.IntroducerIndicatorInternal = '' THEN 'N' ELSE A.IntroducerIndicatorInternal END as  [MRIndicator (multipleradiosinline-4)],
			AccountType as  [AccountType (selectsource-7)],
			CASE WHEN A.AccountGroup IN ('QC1','QJ1','QL1') THEN 'Y' ELSE 'N' END as  [ALGOIndicator (selectbasic-26)],
			ISNULL(D.NewCustomerID,E.CustomerID) as  [CustomerID (selectsource-1)],
			ISNULL(D.NewAccountNo,A.AccountNumber) as  [AccountNumber (textinput-5)],
			AccountSubCode as  [AccountSubCode (textinput-6)],
			NomineesName1 as  [NomineesName1 (selectsource-20)],
			NomineesName2 as  [NomineesName2 (textinput-7)],
			NomineesName3 as  [NomineesName3 (textinput-8)],
			NomineesName4 as  [NomineesName4 (textinput-9)],
			AbbreviatedName as  [AbbreviatedName (textinput-10)],
			B.ShortSellInd2 as  [ContraforShortSelling (selectbasic-28)],
			CADEntityType1 as  [CADEntityType1 (selectsource-18)],
			CASE WHEN ISNULL(A.AveragingOption,'') IN ('0','') THEN '0' ELSE '1' END As [AveragingOption (multipleradiosinline-1)],
			CASE WHEN ISNULL(A.OddLotAveragingOption,'') IN ('0','') THEN 'N' ELSE 'Y' END as [OddLotAveragingOption (selectbasic-4)],
			BrokerCodeDealerEAFIDDealerCode as  [DealerCode (selectsource-21)],
			CASE WHEN SendClientInfoToBFE = '' THEN 'Y' ELSE SendClientInfoToBFE END as  [SendClientInfotoBFE (selectbasic-27)],
			A.AccountStatus as  [AccountStatus (selectsource-9)],
			--A.IntroducerCode as  [MRReference (selectsource-22)],
			MR.[MRCode (textinput-17)] as  [MRReference (selectsource-22)],
			B.OddLotsInd as  [ContraforOddLots (selectbasic-15)],
			'' as  [ReferenceSource (selectsource-23)],
			B.CDSNo as  [CDSNo (textinput-19)],
			B.CDSACOpenBranch as  [CDSACOpenBranch (selectsource-4)],
			B.NomineeInd as  [NomineeInd (selectsource-5)],
			B.CallWarrantInd as  [StructureWarrant (selectbasic-7)],
			B.ShortSellInd as  [ShortSellInd (selectsource-19)],
			CASE WHEN A.ReferredByKYC LIKE '%IDSS%' THEN 'Y' ELSE 'N' END as  [IDSSInd (multipleradiosinline-10)],
			'N' as  [PSSInd (multipleradiosinline-11)],
			B.IslamicTradeInd as  [IslamicTradeInd (selectbasic-9)],
			B.IntraDayInd as  [IntraDayInd (selectbasic-12)],
			CASE WHEN B.SettlementCurrency = '' THEN 'MYR' ELSE B.SettlementCurrency END as  [SettlementCurrency (selectsource-6)],
			CASE WHEN B.ContraInd = 'I' THEN 'N' ELSE B.ContraInd END as  [ContraInd (selectbasic-13)],
			CASE WHEN B.ContraInd = 'I' THEN 'Y' ELSE B.ContraInd END as  [ContraforIntraday (selectbasic-29)],
			B.DesignatedCounterInd as  [DesignatedCounterInd (selectbasic-16)],
			B.ImmediateBasisInd as  [ImmediateBasisInd (selectbasic-19)],
			B.SetoffInd as  [SetoffInd (selectbasic-30)],
			B.SetoffContraGainDebitAmt as  [SetoffContraGainDebitAmount (selectbasic-31)],
			B.SetoffSalesPurchases as  [SetoffSalesPurchasesReport (selectbasic-32)],
			B.SetoffTrustDebitTrans as  [SetoffTrustDebitTransactions (selectbasic-33)],
			B.SetoffTrustContraLoss as  [SetoffTrustContraLoss (selectbasic-34)],
			B.TransferCreditTransToTrust as  [TransferCreditTransactiontoTrust (selectbasic-35)],
			--B.MainACForSSO as  [UserID (textinput-52)],
			u.[FRONT OFFICE USER ID] as  [UserID (textinput-52)],
			CASE WHEN A.AccountStatus='S' THEN ''
				 WHEN OldAccountNo IN ('ADQ001A','OEL007A','IVT201V') THEN 'N2' 
				 WHEN isnull(u.[FRONT OFFICE USER ID],'') <> '' THEN 'M+' END as [OnlineSystemIndicator (multiplecheckboxesinline-1)],
				 --WHEN B.N2NClientInd = 'E' THEN 'N2' ELSE '' END as  [OnlineSystemIndicator (multiplecheckboxesinline-1)],
			CASE WHEN A.ReferredByKYC LIKE '%VBIP%' THEN 'Y' ELSE 'N' END as  [VBIP (selectbasic-39)],
			B.TradingLimit as  [ApproveTradingLimit (textinput-54)],
			B.AvailableTradingLimit as  [AvailableTradingLimit (textinput-55)],
			B.BFEACType as  [BFEACType (selectsource-29)],
			B.ClientAssoAllowed as  [ClientAssoallowed (multipleradiosinline-13)],
			B.ClientReassignAllowed as  [ClientReassignallowed (multipleradiosinline-14)],
			B.ClientCrossAmend as  [ClientCrossamend (multipleradiosinline-15)],
			B.MultiplierForCashDeposit as  [MultiplierforCashDeposit (textinput-56)],
			B.MultiplierForSharePledged as  [Multiplierforsharepledged (textinput-57)],
			B.MultiplierForNonShare as  [MultiplierforNonShare (textinput-58)],
			B.AvailableCleanLineLimit as  [AvailableCleanLineLimit (textinput-59)],
			'' as  [StartDate (dateinput-9)],
			'' as  [EndDate (dateinput-10)],
			B.TemporaryLimit as  [TemporaryLimit (textinput-60)],
			B.StartDate as  [StartDate (dateinput-11)],
			B.EndDate as  [EndDate (dateinput-12)],
			E.LegalStatus as  [LegalStatus (selectsource-24)],
			CASE WHEN E.BankruptcyOrWindingUpStatus = '' THEN 'N' ELSE E.BankruptcyOrWindingUpStatus END as  [BankruptcyorWindingupstatus (multipleradiosinline-12)],
			E.BankruptcyOrWindingUpReason as  [BankruptcyorWindingupreason (textinput-61)],
			E.DateDeclaredBankruptcyOrWindingUp as  [DatedeclaredbankruptcyorWindingup (dateinput-13)],
			E.DateDischargedBankruptcyOrWindingUp as  [DatedischargedbankruptcyorWindingup (dateinput-14)],
			E.Remarks1 as  [Remark1 (textinput-62)],
			E.Remarks2 as  [Remark2 (textinput-63)],
			A.Financier as  [Financier (selectsource-25)],
			CASE WHEN C.MarginCode IS NULL THEN 'MARGIN' Else C.MarginCode END as  [MarginCodeMARGIN (textinput-39)],
			C.CommencementDate as  [CommencementDate (dateinput-4)],
			'N' as  [ExclusionforAutoRenewal (selectbasic-40)],
			C.TenorExpiryDate as  [TenorExpiryDate (dateinput-5)],
			C.LetterOfOfferDate as  [LetterofOfferdate (dateinput-15)],
			C.FacilityAgreementDate as  [FacilityAgreementDate (dateinput-16)],
			C.MortgageAgreementDate as  [MortgageAgreementDate (dateinput-17)],
			C.ApprovedLimit as  [ApprovedLimit (textinput-64)],
			CASE WHEN C.ApprovedMargin IS NULL THEN '66.67' ELSE C.ApprovedMargin END as  [ApprovedMargin (textinput-65)],
			CASE WHEN C.ApprovedRSV  IS NULL THEN '150.00' ELSE C.ApprovedRSV END as  [ApprovedRSV (textinput-43)],
			CASE WHEN C.PriceCapMOF  IS NULL THEN '100.00' ELSE C.PriceCapMOF END as  [PriceCapMOF (textinput-44)],
			CASE WHEN C.MarginCallInterval  IS NULL THEN '3' ELSE C.MarginCallInterval END as  [MarginCallInterval (selectbasic-38)],
			A.AuthorisedRepresentive as  [AuthorisedRepresentative (textinput-66)],
			C.CurrentMargin as  [CurrentMargin (textinput-47)],
			C.CurrentRSV as  [CurrentRSV (textinput-48)],
			C.CommitmentFeeCode as  [CommitmentFeeCode (selectsource-26)]
		FROM import.TB_Account As A
		INNER JOIN import.Tb_AccountNoMapping As D
		ON A.AccountNumber= D.OldAccountNo
		LEFT JOIN CQBTempDB.export.Tb_FormData_1575 as MR
		on a.IntroducerCode = MR.[RegistrationNo (textinput-2)]
		LEFT JOIN import.Tb_AccountMarketInfo As B
		ON A.AccountNumber=B.AccountNo
		LEFT JOIN import.Tb_AccountMargin As C
		ON A.AccountNumber=C.AccountNumber
		INNER JOIN import.Tb_Customer As E
		ON A.CustomerKey = E.CustomerID
		INNER JOIN import.Tb_CustomerIDMapping As F
		ON A.CustomerKey = F.OldCustomerID
		left join import.Tb_FO_Users as u
		on A.AccountNumber = u.[ACCOUNT NUMBER] --AND [FRONT OFFICE STATUS]='ACTIVE'
		WHERE ((A.AccountStatus<>'C' AND A.AccountGroup NOT IN ('B','D','K','X','RMCOL','RMCOM','R','KLSE','SCANS'))
			OR (A.AccountNumber IN ('ALB001C','CKF008A','MBM105C','TBF003A','WSK005A','RSB008A','LWY013C')))
		--AND A.AccountNumber='LOZ002C';
		
		-- UPDATE LIMIT DATE
		UPDATE Form
		SET	
			Form.[MaxBuyLimit (textinput-68)] = ISNULL(Limit.MAXBUYLIM,0),
			Form.[MaxSellLimit (textinput-69)] = ISNULL(Limit.MAXSELLLIM,0),
			Form.[MaxNetLimit (textinput-70)] = ISNULL(Limit.MAXNETLIM,0),
			Form.[ExceedLimit (textinput-71)] = 0
		FROM CQBTempDB.[import].Tb_FormData_1409 Form
		LEFT JOIN import.Tb_AccountNoMapping AS AM ON Form.[AccountNumber (textinput-5)] = AM.NewAccountNo
		LEFT JOIN import.Tb_Limit_Account Limit ON AM.OldAccountNo = Limit.ACCTNO;
				
		--SELECT COUNT(1) FROM CQBTempDB.[import].Tb_FormData_1409 --155700
		
		--select * FROM CQBTempDB.[import].Tb_FormData_1409 as a 
		--inner join CQBTempDB.[import].Tb_FormData_1410 as c
		--on a.[CustomerID (selectsource-1)] = c.[CustomerID (textinput-1)]
		--where [OldCustomerID (textinput-131)] IN ('ALB001','CKF008','MBM105','TBF003','WSK005','RSB008','LWY013')
		--select * FROM CQBTempDB.[import].Tb_FormData_1409 where [AccountNumber (textinput-5)] like '%99'
		--SELECT [AccountNumber (textinput-5)], count(1) 
		--FROM CQBTempDB.[import].Tb_FormData_1409
		--GROUP BY [AccountNumber (textinput-5)]
		--having count(1)>1

        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
	    
	    ROLLBACK TRANSACTION;
	    
        DECLARE @intErrorNumber INT
	        ,@intErrorLine INT
	        ,@intErrorSeverity INT
	        ,@intErrorState INT
	        ,@strObjectName VARCHAR(200)
			,@ostrReturnMessage VARCHAR(4000);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

   --     EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	  --      --,@ostrReturnMessage
			--,''
	  --      ,@intErrorLine
	  --      ,@strObjectName
	  --      ,NULL /*Code Section not available*/
	  --      ,'Process fail.';

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );

    END CATCH
    
    SET NOCOUNT OFF;
END