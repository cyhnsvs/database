/****** Object:  Procedure [import].[Usp_16_AccountGroupMarket_FileToForm1437]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_16_AccountGroupMarket_FileToForm1437]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 22/04/2020
Last Updated Date :             
Description       : this sp is used to insert Account Group Market file into CQForm Account Group Market
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_16_AccountGroupMarket_FileToForm1437]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1437
		--Select * from CQBTempDB.[import].[Tb_FormData_1437]
		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1437;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1437
		(
			[AccountGroupCode (textinput-1)],
			[MarketCode (selectsource-6)],
			[ApprovedLimit (textinput-3)],
			[PrintContract (multipleradiosinline-1)],
			[CallWarantIndicator (multipleradiosinline-2)],
			[ShortSellIndicator (multipleradiosinline-3)],
			[IslamicTradeIndicator (multipleradiosinline-4)],
			[IntraDayIndicator (multipleradiosinline-5)],
			[ContraInd (selectbasic-1)],
			[ContraforIntraday (selectbasic-4)],
			[ShortSellInd (multipleradiosinline-7)],
			[OddLotsInd (multipleradiosinline-8)],
			[DesignatedCounterInd (multipleradiosinline-9)],
			[PN4CounterInd (multipleradiosinline-10)],
			[ImmediateBasicInd (multipleradiosinline-11)],
			[PartialPaidTradeInd (multipleradiosinline-12)],
			[ComputeServiceCharges (multipleradiosinline-13)],
			[DayDifferenceBasedOn (textinput-5)],
			[PurchaseDaysCW (selectsource-1)],
			[PurchaseDays (textinput-4)],
			[SalesDays (textinput-6)],
			[SetoffContraGainDebitAmount (selectbasic-6)],
			[SetoffSalesPurchasesReport (selectbasic-7)],
			[SetoffTrustDebitTransactions (selectbasic-8)],
			[SetoffTrustContraLoss (selectbasic-9)],
			[TransferCreditTransactiontoTrust (selectbasic-10)],
			[PrintSetoffStatement (multipleradiosinline-21)],
			[SalesDaysWW (selectsource-2)],
			[PrintContraStatement (multipleradiosinline-14)],
			[SetoffInd (selectbasic-5)],
			[MultiplierforCashDeposit (textinput-7)],
			[MultiplierforNonShare (textinput-8)],
			[MultiplierforavailableLimit (textinput-9)],
			[MaxBuyLimit (textinput-24)],
			[MaxSellLimit (textinput-25)],
			[MaxNetLimit (textinput-26)],
			[AutoSuspensionCriteria1 (textinput-10)],
			[NetContraLossesApprovedLimit (textinput-11)],
			[orAutoSuspensionCriteria2 (textinput-12)],
			[NetContraLosses (textinput-13)],
			[ContraLossesAgingDays (textinput-14)],
			[ContraLossesAgingDayType (multipleradiosinline-23)],
			[orAutoSuspensionCriteria3 (textinput-15)],
			[NetContraLosses (textinput-16)],
			[NetContraLosses (textinput-17)],
			[ContraLossesAgingDays (textinput-18)],
			[ContraLossesAgingDayType (multipleradiosinline-24)],
			[AutoSuspensionCriteria4 (textinput-19)],
			[NetContraLosses (textinput-20)],
			[ContraLossesAgingDays (textinput-23)],
			[ContraLossesAgingDayType (multipleradiosinline-22)])    
		SELECT 
			 A.AccountGroupCode as  [AccountGroupCode (textinput-1)],
			CASE 
				WHEN A.MarketCode = 'AUSE' THEN 'XASX'
				WHEN A.MarketCode = 'BMSB' THEN 'XKLS'
				WHEN A.MarketCode = 'HKSE' THEN 'XHKG'
				WHEN A.MarketCode = 'IDX' THEN 'XIDX'
				WHEN A.MarketCode = 'LSE' THEN 'XLON'
				WHEN A.MarketCode = 'NASD' THEN 'XNAS'
				WHEN A.MarketCode = 'OTC' THEN 'UOTC'
				WHEN A.MarketCode = 'SGX' THEN 'XSES'
				WHEN A.MarketCode = 'SSE' THEN 'XSHG'
				WHEN A.MarketCode = 'TH' THEN 'XBKK'
				WHEN A.MarketCode = 'TKY' THEN 'XTKS'
				WHEN A.MarketCode = 'TO' THEN 'XTSE'
				WHEN A.MarketCode = 'US' THEN 'XNYS'
				ELSE A.MarketCode
			END AS [MarketCode (selectsource-6)],
			 A.ApprovedLimit as  [ApprovedLimit (textinput-3)],
			 A.PrintContract as  [PrintContract (multipleradiosinline-1)],
			 A.CallWarantIndicator as  [CallWarantIndicator (multipleradiosinline-2)],
			 A.ShortSellInd as  [ShortSellIndicator (multipleradiosinline-3)],
			 A.IslamicTradeIndicator as  [IslamicTradeIndicator (multipleradiosinline-4)],
			 A.IntraDayIndicator as  [IntraDayIndicator (multipleradiosinline-5)],
			 CASE WHEN A.ContraInd = 'I' THEN 'N' ELSE ContraInd END AS [ContraInd (selectbasic-1)],
			 CASE WHEN A.ContraInd = 'I' THEN 'Y' ELSE ContraInd END AS [ContraforIntraday (selectbasic-4)],
			 A.ShortSellIndicator as  [ShortSellInd (multipleradiosinline-7)],
			 A.OddLotsInd as  [OddLotsInd (multipleradiosinline-8)],
			 A.DesignatedCounterInd as  [DesignatedCounterInd (multipleradiosinline-9)],
			 A.PN4CounterInd as  [PN4CounterInd (multipleradiosinline-10)],
			 A.ImmediateBasicInd as  [ImmediateBasicInd (multipleradiosinline-11)],
			 A.PartialPaidTradeInd as  [PartialPaidTradeInd (multipleradiosinline-12)],
			 A.ComputeServiceCharges as  [ComputeServiceCharges (multipleradiosinline-13)],
			 A.DayDifferenceBasedOn as  [DayDifferenceBasedOn (textinput-5)],
			 A.PurchaseDaysCW as  [PurchaseDaysCW (selectsource-1)],
			 A.PurchaseDays as  [PurchaseDays (textinput-4)],
			 A.SalesDays as  [SalesDays (textinput-6)],
			 A.SetoffContraGainDebitAmount as  [SetoffContraGainDebitAmount (selectbasic-6)],
			 A.SetoffSalesPurchasesReport as  [SetoffSalesPurchasesReport (selectbasic-7)],
			 A.SetoffTrustDebitTransactions as  [SetoffTrustDebitTransactions (selectbasic-8)],
			 A.SetoffTrustContraLoss as  [SetoffTrustContraLoss (selectbasic-9)],
			 A.TranferCreditTransactionToTrust as  [TransferCreditTransactiontoTrust (selectbasic-10)],
			 A.PrintSetoffStatement as  [PrintSetoffStatement (multipleradiosinline-21)],
			 A.SalesDaysWW as  [SalesDaysWW (selectsource-2)],
			 A.PrintContraStatement as  [PrintContraStatement (multipleradiosinline-14)],
			 A.SetoffInd as  [SetoffInd (selectbasic-5)],
			 A.MultiplierForCashDeposit as  [MultiplierforCashDeposit (textinput-7)],
			 A.MultiplierForNonShare as  [MultiplierforNonShare (textinput-8)],
			 A.MultiplierForAvailableLimit as  [MultiplierforavailableLimit (textinput-9)],
			 '0.00' AS [MaxBuyLimit (textinput-24)],
			 '0.00' AS [MaxSellLimit (textinput-25)],
			 '0.00' AS [MaxNetLimit (textinput-26)],
			 A.AutoSuspensionCriteria1 as  [AutoSuspensionCriteria1 (textinput-10)],
			 A.NetContraLossesApprovedLimit as  [NetContraLossesApprovedLimit (textinput-11)],
			 A.AutoSuspensionCriteria2 as  [orAutoSuspensionCriteria2 (textinput-12)],
			 A.NetContraLossesAND2 as  [NetContraLossesAND (textinput-13)],
			 A.ContraLossesAgingDaysDAYS as  [ContraLossesAgingDaysDAYS (textinput-14)],
			 A.ContraLossesAgingDaysWORKINGCALENDAR as  [ContraLossesAgingDaysWORKINGCALENDAR (selectsource-3)],
			 A.AutoSuspensionCriteria3 as  [orAutoSuspensionCriteria3 (textinput-15)],
			 A.NetContraLossesAND3 as  [NetContraLossesAND (textinput-16)],
			 A.NetContraLossesANDLess3 as  [NetContraLossesAND (textinput-17)],
			 A.ContraLossesAgingDaysDAYS3 as  [ContraLossesAgingDaysDAYS (textinput-18)],
			 A.ContraLossesAgingDaysWORKINGCALENDAR3 as  [ContraLossesAgingDaysWORKINGCALENDAR (selectsource-4)],
			 A.AutoSuspensionCriteria4 as  [AutoSuspensionCriteria4 (textinput-19)],
			 A.NetContraLossesAND4 as  [NetContraLossesAND (textinput-20)],
			 A.ContraLossesAgingDaysDAYS4 as  [ContraLossesAgingDaysDAYS (textinput-21)],
			 A.ContraLossesAgingDaysWORKINGCALENDAR4 as  [ContraLossesAgingDaysWORKINGCALENDAR (selectsource-5)]
		 FROM import.Tb_AccountGroup_MarketInfo As A;
		
		INSERT INTO CQBTempDB.[import].Tb_FormData_1437_grid1
			(RecordID
			, Action
			, RowIndex
			, [Transaction Type (TextBox)]
			, [Tagging Days (TextBox)])
		SELECT AG.IDD
		, 'I'
		, ROW_NUMBER() over (partition by [AccountGroupCode (textinput-1)] order by [AccountGroupCode (textinput-1)], TTL.Seq)
		,TTL.TransType, 
		CASE WHEN RG.AutoRASTagging = 'Y' THEN '60' ELSE '0' END 
		FROM CQBTempDB.[import].Tb_FormData_1437 AS AG
		INNER JOIN import.Tb_RASAccountGroup AS RG
			ON AG.[AccountGroupCode (textinput-1)] = RG.AccountGroup
		CROSS JOIN 
			(SELECT 'CHLS' AS TransType, 1 AS Seq UNION 
			 SELECT 'SCHLS', 2 AS Seq UNION
			 SELECT 'CHDN', 3 AS Seq UNION
			 SELECT 'CHAO', 4 AS Seq) AS TTL;

		Update AG SET 
			AG.[MultiplierforPledgedShares (textinput-22)]= SM.SECSHRMULT
		FROM 
			CQBTempDB.[import].Tb_FormData_1437 AG
		INNER JOIN GlobalBOMY.import.Tb_AccountGroup_ShareMultiplier SM 
			ON SM.ACCTGRPCD = AG.[AccountGroupCode (textinput-1)] AND REPLACE(SM.MRKTCD,'BMSB','XKLS') = AG.[MarketCode (selectsource-6)]

		UPDATE AG
		SET [MaxBuyLimit (textinput-24)] = CASE WHEN L.MAXBUYLIM = '.00' THEN '0.00' ELSE L.MAXBUYLIM END,
			[MaxSellLimit (textinput-25)] = CASE WHEN L.MAXSELLLIM = '.00' THEN '0.00' ELSE L.MAXSELLLIM END,
			[MaxNetLimit (textinput-26)] = CASE WHEN L.MAXNETLIM = '.00' THEN '0.00' ELSE L.MAXNETLIM END
		FROM CQBTempDB.[import].Tb_FormData_1437 AG
		INNER JOIN GlobalBOMY.import.Tb_Limit_AcGroup AS L
			ON AG.[AccountGroupCode (textinput-1)] = L.ACCTGRPCD AND AG.[MarketCode (selectsource-6)]='XKLS';

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

        RAISERROR 
		(
			@ostrReturnMessage
			,@intErrorSeverity
			,@intErrorState
		);

    END CATCH
    
    SET NOCOUNT OFF;
END