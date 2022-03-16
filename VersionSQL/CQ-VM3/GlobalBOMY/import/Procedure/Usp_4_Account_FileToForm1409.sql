/****** Object:  Procedure [import].[Usp_4_Account_FileToForm1409]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_4_Account_FileToForm1409]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 06/04/2020
Last Updated Date :             
Description       : this sp is used to insert Account file data into CQForm Account
        
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
 Kristine				28/7/2021				Add import for Account Limit Maintenance Form

PARAMETERS
EXEC [import].[Usp_4_Account_DefaultDataToForm1409]
EXEC [import].[Usp_4_Account_FileToForm1409];
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DEPENDENCY ON CUSTOMER & ACCOUNT MAPPING SCRIPT
		
		--Below step already run in Previous step
		--Exec CQBTempDB.form.[Usp_CreateImportTable] 1409;
		--Select * from CQBTempDB.[import].[Tb_FormData_1409]
		
		--TRUNCATE TABLE CQBTempDB.[import].[Tb_FormData_1409];

		--DELETE FROM import.Tb_FO_Users where [ACCOUNT NUMBER]='IVT019V' AND [FRONT OFFICE USER ID]='DEMO2'

		INSERT INTO CQBTempDB.[import].Tb_FormData_1409 (
			[RecordID]
           ,[Action]
           ,[CustomerID (selectsource-1)]
		   ,[CustomerName (textinput-76)]
           ,[AccountGroup (selectsource-2)]
           ,[ParentGroup (selectsource-3)]
           ,[AccountType (selectsource-7)]
           ,[ALGOIndicator (selectbasic-26)]
           ,[AccountNumber (textinput-5)]
           ,[IDSSInd (multipleradiosinline-10)]
           ,[OldAccountNo (textinput-73)]
           --,[AccountSubCode (textinput-6)]
           ,[NomineesName1 (selectsource-20)]
           ,[NomineesName2 (textinput-7)]
           ,[NomineesName3 (textinput-8)]
           ,[NomineesName4 (textinput-9)]
           ,[AbbreviatedName (textinput-10)]
           ,[CADEntityType1 (selectsource-18)]
           --,[AccountOpenedDate (dateinput-19)]
		   ,[FirstTradingDate (dateinput-25)]
		   ,[LastTransactionDate (dateinput-22)]
		   ,[LastTradingDate (dateinput-23)]
		   ,[Dormant (multipleradiosinline-26)]
           ,[AveragingOption (multipleradiosinline-1)]
           ,[OddLotAveragingOption (selectbasic-4)]
           ,[PSSInd (multipleradiosinline-11)]
           ,[DealerCode (selectsource-21)]
           ,[SendClientInfotoBFE (selectbasic-27)]
           ,[MRIndicator (multipleradiosinline-4)]
           ,[VBIP (selectbasic-39)]
           ,[RASTagging (grid-1)]
           ,[MRCode (selectsource-22)]
           ,[StartDate (dateinput-9)]
           ,[EndDate (dateinput-10)]
           ,[ReferenceCode (selectsource-23)]
           ,[CDSNo (textinput-19)]
           ,[CDSACOpenBranch (selectsource-4)]
           --,[CDSAccountOpenedDate (dateinput-18)]
           ,[NomineeInd (selectsource-5)]
           ,[StructureWarrant (selectbasic-7)]
		   ,[ShortSellRSSInd (selectbasic-42)]
		   ,[ShortSellPDTInd (selectbasic-43)]
		   ,[MarketMaker (multipleradiosinline-27)]
		   ,[MarketPSS (multipleradiosinline-28)]
		   ,[ShareCheck (multipleradiosinline-29)]
           ,[IslamicTradeInd (selectbasic-9)]
           ,[IntraDayInd (selectbasic-12)]
           ,[SettlementCurrency (selectsource-6)]
           ,[ContraInd (selectbasic-13)]
           ,[ContraforShortSelling (selectbasic-28)]
           ,[ContraforOddLots (selectbasic-15)]
           ,[ContraforIntraday (selectbasic-29)]
           ,[DesignatedCounterInd (selectbasic-16)]
           ,[ImmediateBasisInd (selectbasic-19)]
           ,[SettlementMode (selectbasic-41)]
           ,[TransferCreditTransToTrust (multipleradiosinline-23)]
           ,[DeductTrustToSettlePurchase (multipleradiosinline-24)]
           ,[DeductTrustToSettleNonTradeDebitTrans (multipleradiosinline-25)]
           ,[Tradingaccount (selectsource-31)]
           ,[DateofTradingAccountOpened (dateinput-20)]
           ,[CDSAccount (selectsource-32)]
           ,[DateofCDSOpened (dateinput-21)]
           ,[AccountOpenedBy (textinput-74)]
           ,[WithLimit (multipleradiosinline-18)]
           ,[ClearPreviousDayOrder (multipleradiosinline-19)]
           ,[Access (multipleradiosinline-20)]
           ,[Buy (multipleradiosinline-21)]
           ,[Sell (multipleradiosinline-22)]
           ,[SuspensionCloseReason (selectsource-30)]
           ,[Remarks (textinput-72)]
		   ,[MaxBuyLimit (textinput-68)]
           ,[MaxSellLimit (textinput-69)]
           ,[MaxNetLimit (textinput-70)]
           ,[ExceedLimit (textinput-71)]
           ,[ApproveTradingLimit (textinput-54)]
           ,[AvailableTradingLimit (textinput-55)]
           ,[BFEACType (selectsource-29)]
           ,[ClientAssoAllowed (multipleradiosinline-13)]
           ,[ClientReassignAllowed (multipleradiosinline-14)]
           ,[ClientCrossAmend (multipleradiosinline-15)]
           ,[MultiplierforCashDeposit (textinput-56)]
           ,[MultiplierforSharePledged (textinput-57)]
           ,[MultiplierforNonShare (textinput-58)]
           ,[AvailableCleanLineLimit (textinput-59)]
           ,[TemporaryLimit (textinput-60)]
           ,[StartDate (dateinput-11)]
           ,[EndDate (dateinput-12)]
           ,[MarginCode (textinput-39)]
           ,[CommencementDate (dateinput-4)]
           ,[ExclusionforAutoRenewal (selectbasic-40)]
           ,[Financier (selectsource-25)]
           ,[TenorExpiryDate (dateinput-5)]
           ,[LetterofOfferDate (dateinput-15)]
           ,[FacilityAgreementDate (dateinput-16)]
           ,[MortgageAgreementDate (dateinput-17)]
           --,[ApprovedLimit (textinput-64)]
           ,[ApprovedMargin (textinput-65)]
           ,[ApprovedRSV (textinput-43)]
           ,[PriceCapMOF (textinput-44)]
           ,[MarginCallInterval (selectbasic-38)]
           ,[AuthorisedRepresentative (textinput-66)]
           ,[CurrentMargin (textinput-47)]
           ,[CurrentRSV (textinput-48)]
           ,[CommitmentFeeCode (selectsource-26)])
		SELECT DISTINCT 
			null as [RecordID],
			'I' as [Action],
			ISNULL(D.NewCustomerID,E.CustomerID) as  [CustomerID (selectsource-1)],
			E.CustomerName as  [CustomerName (textinput-76)],
			CASE WHEN A.AccountGroup ='G' AND Financier='ALB' THEN 'GA' 
					WHEN A.AccountGroup ='G' AND Financier='CIMB' THEN 'GC' 
					WHEN A.AccountGroup ='G' AND Financier='HLB' THEN 'GH' 
					ELSE A.AccountGroup END as  [AccountGroup (selectsource-2)],
			ParentGroup as  [ParentGroup (selectsource-3)],
			AccountType as  [AccountType (selectsource-7)],
			CASE WHEN A.AccountGroup IN ('QC1','QJ1','QL1') THEN 'Y' ELSE 'N' END as  [ALGOIndicator (selectbasic-26)],
			ISNULL(D.NewAccountNo,A.AccountNumber) as  [AccountNumber (textinput-5)],
			CASE WHEN A.ReferredByKYC LIKE '%IDSS%' THEN 'Y' ELSE 'N' END as  [IDSSInd (multipleradiosinline-10)],
			A.AccountNumber as [OldAccountNo (textinput-73)],
			--AccountSubCode as  [AccountSubCode (textinput-6)],
			CASE WHEN NomineesName1 LIKE '%ALLIANCEGROUP%' THEN 'ALLIANCEGROUP NOMINEES (TEMPATAN) SDN BHD'
				 WHEN NomineesName1 LIKE '%HLB %' THEN 'HLB NOMINEES (TEMPATAN) SDN BHD'
				 WHEN NomineesName1 LIKE '%KUMPULAN SENTIASA%' THEN 'KUMPULAN SENTIASA CEMERLANG SDN BHD'
				 WHEN NomineesName1 LIKE '%MALACCA EQUITY%' AND NomineesName1 LIKE '%TEMP%' THEN 'MALACCA EQUITY NOMINEES (TEMPATAN) SDN BHD'
				 ELSE NomineesName1
				 END as  [NomineesName1 (selectsource-20)],
			NomineesName2 as  [NomineesName2 (textinput-7)],
			NomineesName3 as  [NomineesName3 (textinput-8)],
			NomineesName4 as  [NomineesName4 (textinput-9)],
			AbbreviatedName as  [AbbreviatedName (textinput-10)],
			CADEntityType1 as  [CADEntityType1 (selectsource-18)],
			--ISNULL(NULLIF(A.DateAccountOpened,'0001-01-01'),'1900-01-01') as  [AccountOpenedDate (dateinput-19)],
			ISNULL(NULLIF(A.FirstTradeDate,'0001-01-01'),'1900-01-01') AS [FirstTradingDate (dateinput-25)],
			ISNULL(NULLIF(A.LastTransactionDate,'0001-01-01'),'1900-01-01') AS [LastTransactionDate (dateinput-22)],
			ISNULL(NULLIF(A.LastTradeDate,'0001-01-01'),'1900-01-01') AS [LastTradingDate (dateinput-23)],
			'N' AS [Dormant (multipleradiosinline-26)],
			CASE WHEN ISNULL(A.AveragingOption,'') IN ('0','') THEN '0' ELSE '1' END As [AveragingOption (multipleradiosinline-1)],
			CASE WHEN ISNULL(A.OddLotAveragingOption,'') IN ('0','') THEN 'N' ELSE 'Y' END as [OddLotAveragingOption (selectbasic-4)],
			'N' as  [PSSInd (multipleradiosinline-11)],
			BrokerCodeDealerEAFIDDealerCode as  [DealerCode (selectsource-21)],
			CASE WHEN SendClientInfoToBFE = '' THEN 'Y' ELSE SendClientInfoToBFE END as  [SendClientInfotoBFE (selectbasic-27)],
			CASE WHEN A.IntroducerIndicatorInternal = '' THEN 'N' ELSE A.IntroducerIndicatorInternal END as  [MRIndicator (multipleradiosinline-4)],
			CASE WHEN A.ReferredByKYC LIKE '%VBIP%' THEN 'Y' ELSE 'N' END as  [VBIP (selectbasic-39)],
			'' as [RASTagging (grid-1)],
			MR.[MRCode (textinput-17)] as [MRCode (selectsource-22)],
			'' as  [StartDate (dateinput-9)],
			'' as  [EndDate (dateinput-10)],
			'' as [ReferenceCode (selectsource-23)],
			B.CDSNo as  [CDSNo (textinput-19)],
			B.CDSACOpenBranch as  [CDSACOpenBranch (selectsource-4)],
			--'' as  [CDSAccountOpenedDate (dateinput-18)],
			B.NomineeInd as  [NomineeInd (selectsource-5)],
			B.CallWarrantInd as  [StructureWarrant (selectbasic-7)],
			''  AS [ShortSellRSSInd (selectbasic-42)],
			''  as [ShortSellPDTInd (selectbasic-43)],
			'' AS [MarketMaker (multipleradiosinline-27)],
		    '' AS [MarketPSS (multipleradiosinline-28)],
			'' AS [ShareCheck (multipleradiosinline-29)],
			B.IslamicTradeInd as  [IslamicTradeInd (selectbasic-9)],
			B.IntraDayInd as  [IntraDayInd (selectbasic-12)],
			CASE WHEN B.SettlementCurrency = '' THEN 'MYR' ELSE B.SettlementCurrency END as  [SettlementCurrency (selectsource-6)],
			CASE WHEN B.ContraInd = 'I' THEN 'N' ELSE B.ContraInd END as  [ContraInd (selectbasic-13)],
			B.ShortSellInd2 as  [ContraforShortSelling (selectbasic-28)],
			B.OddLotsInd as  [ContraforOddLots (selectbasic-15)],
			CASE WHEN B.ContraInd = 'I' THEN 'Y' ELSE B.ContraInd END as  [ContraforIntraday (selectbasic-29)],
			B.DesignatedCounterInd as  [DesignatedCounterInd (selectbasic-16)],
			B.ImmediateBasisInd as  [ImmediateBasisInd (selectbasic-19)],
			'' as [SettlementMode (selectbasic-41)],
			B.TransferCreditTransToTrust as [TransferCreditTransToTrust (multipleradiosinline-23)],
			B.SetoffTrustDebitTrans as [DeductTrustToSettlePurchase (multipleradiosinline-24)],
			B.SetoffTrustDebitTrans as [DeductTrustToSettleNonTradeDebitTrans (multipleradiosinline-25)],
			A.AccountStatus as [Tradingaccount (selectsource-31)],
			A.DateAccountOpened as [DateofTradingAccountOpened (dateinput-20)],
			'' as [CDSAccount (selectsource-32)],
			'' as [DateofCDSOpened (dateinput-21)],
			'' as [AccountOpenedBy (textinput-74)],
			'' as [WithLimit (multipleradiosinline-18)],
			'' as [ClearPreviousDayOrder (multipleradiosinline-19)],
			'' as [Access (multipleradiosinline-20)],
			'' as [Buy (multipleradiosinline-21)],
			'' as [Sell (multipleradiosinline-22)],
			'' as [SuspensionCloseReason (selectsource-30)],
			'' as [Remarks (textinput-72)],
			'' as [MaxBuyLimit (textinput-68)],
			'' as [MaxSellLimit (textinput-69)],
			'' as [MaxNetLimit (textinput-70)],
			'' as [ExceedLimit (textinput-71)],
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
			B.TemporaryLimit as  [TemporaryLimit (textinput-60)],
			B.StartDate as  [StartDate (dateinput-11)],
			B.EndDate as  [EndDate (dateinput-12)],
			CASE WHEN C.MarginCode IS NULL THEN 'MARGIN' Else C.MarginCode END as [MarginCode (textinput-39)],
			C.CommencementDate as  [CommencementDate (dateinput-4)],
			'N' as  [ExclusionforAutoRenewal (selectbasic-40)],
			A.Financier as  [Financier (selectsource-25)],
			C.TenorExpiryDate as  [TenorExpiryDate (dateinput-5)],
			C.LetterOfOfferDate as  [LetterofOfferdate (dateinput-15)],
			C.FacilityAgreementDate as  [FacilityAgreementDate (dateinput-16)],
			C.MortgageAgreementDate as  [MortgageAgreementDate (dateinput-17)],
			--C.ApprovedLimit as  [ApprovedLimit (textinput-64)],
			CASE WHEN C.ApprovedMargin IS NULL THEN '66.67' ELSE C.ApprovedMargin END as  [ApprovedMargin (textinput-65)],
			CASE WHEN C.ApprovedRSV  IS NULL THEN '150.00' ELSE C.ApprovedRSV END as  [ApprovedRSV (textinput-43)],
			CASE WHEN C.PriceCapMOF  IS NULL THEN '100.00' ELSE C.PriceCapMOF END as  [PriceCapMOF (textinput-44)],
			CASE WHEN C.MarginCallInterval  IS NULL THEN '3' ELSE C.MarginCallInterval END as  [MarginCallInterval (selectbasic-38)],
			A.AuthorisedRepresentive as  [AuthorisedRepresentative (textinput-66)],
			C.CurrentMargin as  [CurrentMargin (textinput-47)],
			C.CurrentRSV as  [CurrentRSV (textinput-48)],
			C.CommitmentFeeCode as  [CommitmentFeeCode (selectsource-26)]
			--u.[FRONT OFFICE USER ID] as  [UserID (textinput-52)],
			--CASE WHEN A.AccountStatus='S' THEN ''
			--	 WHEN OldAccountNo IN ('ADQ001A','OEL007A','IVT201V') THEN 'N2' 
			--	 WHEN isnull(u.[FRONT OFFICE USER ID],'') <> '' THEN 'M+' END as [OnlineSystemIndicator (multiplecheckboxesinline-1)],
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
		--left join import.Tb_FO_Users as u
		--on A.AccountNumber = u.[ACCOUNT NUMBER] --AND [FRONT OFFICE STATUS]='ACTIVE'
		--LEFT JOIN CQBTempDB.export.Tb_FormData_1409 AS AFE
		--ON D.NewAccountNo = AFE.[AccountNumber (textinput-5)]
		WHERE --AFE.[AccountNumber (textinput-5)] IS NULL AND
			(((A.AccountStatus<>'C' OR (A.AccountStatus='C' AND A.DateClosed>='2021-01-01')) 
			AND A.AccountGroup NOT IN ('B','D','K','X','RMCOL','RMCOM','R','KLSE','SCANS'))
			OR (A.AccountNumber IN ('FNL003A'))) --'ALB001C','CKF008A','MBM105C','TBF003A','WSK005A','RSB008A','LWY013C'
		--AND A.AccountNumber='LOZ002C';
		
		-- UPDATE LIMIT DATE
		UPDATE Form
		SET	
			Form.[MaxBuyLimit (textinput-68)] = ISNULL(CASE WHEN Limit.MAXBUYLIM = '.00' THEN '0.00' ELSE Limit.MAXBUYLIM END,'0.00'),
			Form.[MaxSellLimit (textinput-69)] = ISNULL(CASE WHEN Limit.MAXSELLLIM = '.00' THEN '0.00' ELSE Limit.MAXBUYLIM END,'0.00'),
			Form.[MaxNetLimit (textinput-70)] = ISNULL(CASE WHEN Limit.MAXNETLIM = '.00' THEN '0.00' ELSE Limit.MAXBUYLIM END,'0.00'),
			Form.[ExceedLimit (textinput-71)] = 0
		FROM CQBTempDB.[import].Tb_FormData_1409 Form
		LEFT JOIN import.Tb_AccountNoMapping AS AM ON Form.[AccountNumber (textinput-5)] = AM.NewAccountNo
		LEFT JOIN import.Tb_Limit_Account Limit ON AM.OldAccountNo = Limit.ACCTNO;
		
		INSERT INTO CQBTempDB.[import].Tb_FormData_1409_grid1
			(RecordID, Action, RowIndex, [Transaction Type (TextBox)], [Tagging Days (TextBox)])
		SELECT A.IDD, 'I', ROW_NUMBER() over (partition by A.[AccountNumber (textinput-5)] order by [AccountNumber (textinput-5)], TTL.Seq),
				TTL.TransType, CASE WHEN R.AutoRASTagging = 'Y' THEN '60' ELSE '0' END 
		FROM CQBTempDB.[import].Tb_FormData_1409 AS A
		INNER JOIN import.Tb_RASAccount AS R
		ON A.[OldAccountNo (textinput-73)] = R.AccountNumber
		CROSS JOIN 
			(SELECT 'CHLS' AS TransType, 1 AS Seq UNION 
			 SELECT 'SCHLS', 2 AS Seq UNION
			 SELECT 'CHDN', 3 AS Seq UNION
			 SELECT 'CHAO', 4 AS Seq) AS TTL;

		--SELECT COUNT(1) FROM CQBTempDB.[import].Tb_FormData_1409 --220987
		
		--select * FROM CQBTempDB.[import].Tb_FormData_1409 as a 
		--inner join CQBTempDB.[import].Tb_FormData_1410 as c
		--on a.[CustomerID (selectsource-1)] = c.[CustomerID (textinput-1)]
		--where [OldCustomerID (textinput-131)] IN ('ALB001','CKF008','MBM105','TBF003','WSK005','RSB008','LWY013')
		--select * FROM CQBTempDB.[import].Tb_FormData_1409 where [AccountNumber (textinput-5)] like '%99'
		--SELECT [AccountNumber (textinput-5)], count(1) 
		--FROM CQBTempDB.[import].Tb_FormData_1409
		--GROUP BY [AccountNumber (textinput-5)]
		--having count(1)>1

		Exec CQBTempDB.form.[Usp_CreateImportTable] 3663;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3663;

		INSERT INTO CQBTempDB.[import].Tb_FormData_3663 ([RecordID], [Action], 
			 [AccountNumber (textinput-4)],
			 [CustomerName (textinput-9)],
			 [MaxBuyLimit (textinput-1)],
			 [MaxSellLimit (textinput-2)],
			 [MaxNetLimit (textinput-3)],
			 [MultiplierforCashDeposit (textinput-5)],
			 [MultiplierforSharePledged (textinput-6)],
			 [MultiplierforNonShare (textinput-7)],
			 [AvailableCleanLineLimit (textinput-8)],
			 [StartDate (dateinput-1)],
			 [EndDate (dateinput-2)]) 
		SELECT null as [RecordID],'I' as [Action],
		 a.[AccountNumber (textinput-5)] as  [AccountNumber (textinput-4)], 
		 a.[CustomerName (textinput-76)] as  [CustomerName (textinput-9)], 
		 a.[MaxBuyLimit (textinput-68)] as  [MaxBuyLimit (textinput-1)], 
		 a.[MaxSellLimit (textinput-69)] as  [MaxSellLimit (textinput-2)], 
		 a.[MaxNetLimit (textinput-70)] as  [MaxNetLimit (textinput-3)], 
		 a.[MultiplierforCashDeposit (textinput-56)] as  [MultiplierforCashDeposit (textinput-5)], 
		 a.[MultiplierforSharePledged (textinput-57)] as  [MultiplierforSharePledged (textinput-6)], 
		 a.[MultiplierforNonShare (textinput-58)] as  [MultiplierforNonShare (textinput-7)], 
		 a.[AvailableCleanLineLimit (textinput-59)] as  [AvailableCleanLineLimit (textinput-8)], 
		 a.[StartDate (dateinput-9)] as  [StartDate (dateinput-1)], 
		 a.[EndDate (dateinput-10)] as  [EndDate (dateinput-2)]
		FROM CQBTempDB.[import].Tb_FormData_1409 a
		
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