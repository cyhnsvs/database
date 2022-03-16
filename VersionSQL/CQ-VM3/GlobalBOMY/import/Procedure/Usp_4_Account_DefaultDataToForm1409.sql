/****** Object:  Procedure [import].[Usp_4_Account_DefaultDataToForm1409]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_4_Account_DefaultDataToForm1409]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 08/04/2020
Last Updated Date :             
Description       : this sp is used to insert Account's default data into CQForm Account
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
 Kristine				17/09/2021				1. Updated to latest default spec
												2. To auto create Account Limit Maintenance Forms for the new Account Infos 

PARAMETERS
EXEC [import].[Usp_4_Account_DefaultDataToForm1409]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1409
		-- Select * from CQBTempDB.[import].[Tb_FormData_1409]


		INSERT INTO CQBTempDB.[import].[Tb_FormData_1409]
           ([CustomerID (selectsource-1)],[AccountNumber (textinput-5)], [RecordID], [Action])
		SELECT DISTINCT 'DEFAULT', CharCode + (CASE WHEN NomineesInd = 'Y' THEN '-NomY' ELSE '' END) + 
											  (CASE WHEN ISNULL(AlgoSystem,'') <> '' THEN '-Algo'+ AlgoSystem ELSE '' END) + 
											  (CASE WHEN ISNULL(ExternalMarginFinancier,'') <> '' THEN '-EMF'+ ExternalMarginFinancier ELSE '' END)
				,null as [RecordID]
				,'I' as [Action]
		FROM import.Tb_AccountTypeList2;
		--UNION ALL
		--SELECT 'DEFAULT', 'CAlgo' UNION ALL
		--SELECT 'DEFAULT', 'JAlgo' UNION ALL
		--SELECT 'DEFAULT', 'LAlgo' 
		--SELECT 'DEFAULT', 'LAlgo' 

		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET [AccountGroup (selectsource-2)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'J' THEN 'CI'
								WHEN [AccountNumber (textinput-5)] = 'G' OR LEFT([AccountNumber (textinput-5)],2) = 'G-' THEN 'G' -- handled in trigger with additional logic
								WHEN [AccountNumber (textinput-5)] = 'W' THEN 'CD1'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%Algo%' THEN 'QC1'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%NomY%' THEN 'C'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'J' AND [AccountNumber (textinput-5)] LIKE '%Algo%' THEN 'QJ1'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'L' AND [AccountNumber (textinput-5)] LIKE '%Algo%' THEN 'QL1'
								ELSE [AccountNumber (textinput-5)]
							END
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';
		 
		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET [ParentGroup (selectsource-3)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'E' THEN 'C'
								--WHEN [AccountNumber (textinput-5)] = 'J' THEN 'C' -- [2021-09-08] CHANGED; COMMENTED
								WHEN [AccountNumber (textinput-5)] = 'U' THEN 'L'
								WHEN [AccountNumber (textinput-5)] = 'W' THEN 'C'
								WHEN [AccountNumber (textinput-5)] = 'Z' THEN 'L'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%Algo%' THEN 'C'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%NomY%' THEN 'C'
								WHEN [AccountNumber (textinput-5)] = 'J' 
									OR LEFT([AccountNumber (textinput-5)],1) = 'J' AND [AccountNumber (textinput-5)] LIKE '%Algo%'	THEN 'CI'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'L' AND [AccountNumber (textinput-5)] LIKE '%Algo%' THEN 'L'
								WHEN LEFT([AccountNumber (textinput-5)],2) = 'G-'  THEN 'G'
								ELSE [AccountNumber (textinput-5)]
							END
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';

		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET [AccountType (selectsource-7)] = 
							CASE WHEN [AccountNumber (textinput-5)] IN ('M') THEN 'MG' ELSE 'TA'
							END
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';
		 
		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET [CADEntityType1 (selectsource-18)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'G' OR LEFT([AccountNumber (textinput-5)],2) = 'G-' THEN '7' --'Other'
								WHEN [AccountNumber (textinput-5)] = 'W' THEN '10' --'Nominees'
								WHEN [AccountNumber (textinput-5)] = 'P' THEN '5' --'BROKER'
								WHEN [AccountNumber (textinput-5)] = 'V' THEN '5' --'BROKER'
								ELSE '6' --'Retail(Individual)'
							END,
			[AveragingOption (multipleradiosinline-1)]='1'
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';

		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET 
			[OddLotAveragingOption (selectbasic-4)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'I' THEN 'Y'
								WHEN [AccountNumber (textinput-5)] = 'P' THEN 'Y'
								WHEN [AccountNumber (textinput-5)] = 'V' THEN 'Y'
								ELSE "''" -- DefaulttoAccountGroup
							END,
			[SendClientInfotoBFE (selectbasic-27)] = 'Y',
			[MRIndicator (multipleradiosinline-4)]='N'
			--[MRReference (selectsource-22)]='',
			--[ReferenceSource (selectsource-23)]= '' -- Ops and PH to discuss
			--[AveragingOption (multipleradiosinline-1)]='Y'
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';

		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET [NomineeInd (selectsource-5)] = CASE 
				WHEN [AccountNumber (textinput-5)] LIKE '%NomY%'	THEN 'Y'
				ELSE 'N' END,
			[StructureWarrant (selectbasic-7)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'J' THEN "''" -- DefaultToAccountGroup
								WHEN [AccountNumber (textinput-5)] = 'M' THEN "''" -- DefaultToAccountGroup
								WHEN [AccountNumber (textinput-5)] = 'Z' THEN 'N'
								ELSE 'Y'
							END
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';

		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET 
			[ALGOIndicator (selectbasic-26)] = 'N',
			[IDSSInd (multipleradiosinline-10)] = 'N',
			[PSSInd (multipleradiosinline-11)] = 'N',
			[IslamicTradeInd (selectbasic-9)] = "''",--DefaultToAccountGroup
			[IntraDayInd (selectbasic-12)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'I' THEN 'N'
								WHEN [AccountNumber (textinput-5)] = 'G' OR LEFT([AccountNumber (textinput-5)],2) = 'G-' THEN 'N'  -- [2021-09-08] CHANGED
								ELSE 'Y'
							END,
			[SettlementCurrency (selectsource-6)]='MYR',
			[ContraInd (selectbasic-13)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'I' THEN 'N'
								WHEN [AccountNumber (textinput-5)] = 'G' OR LEFT([AccountNumber (textinput-5)],2) = 'G-' THEN 'N'
								ELSE "''" -- DefaultToAccountGroup
							END,
			[ContraforShortSelling (selectbasic-28)] = 'N',
			[ContraforOddLots (selectbasic-15)] = "''", --DefaultToAccountGroup
			[DesignatedCounterInd (selectbasic-16)] = "''",--DefaultToAccountGroup
			--[PN17CounterInd (selectbasic-17)] = '',--DefaultToAccountGroup
			--[GN3CounterInd (selectbasic-18)] = '',--DefaultToAccountGroup
			--[NonFaceToFaceIndicatorNEW (selectbasic-23)] = 'N',
			[VBIP (selectbasic-39)] = 'N',
			--[PROMO16IndicatorNEW (selectbasic-25)] = 'N',
			[ImmediateBasisInd (selectbasic-19)] = "''"--DefaultToAccountGroup-
			,[SettlementMode (selectbasic-41)] = '1'
			,[TransferCreditTransToTrust (multipleradiosinline-23)] = "''" -- Default to Next Level
			,[DeductTrustToSettlePurchase (multipleradiosinline-24)] = "''"	-- Default to Next Level
			,[DeductTrustToSettleNonTradeDebitTrans (multipleradiosinline-25)] = "''"	-- Default to Next Level
			,[WithLimit (multipleradiosinline-18)] = '1'	-- Yes
			,[ClearPreviousDayOrder (multipleradiosinline-19)] = '1' -- Yes
			,[Access (multipleradiosinline-20)] = 'R' -- Resume
			,[Buy (multipleradiosinline-21)]  = 'R' -- Resume
			,[Sell (multipleradiosinline-22)]  = 'R' -- Resume
			,[NomineesName2 (textinput-7)]= 'PLEDGED SECURITIES ACCOUNT FOR'
			,[Dormant (multipleradiosinline-26)] = 'Y'
			,[CDSACOpenBranch (selectsource-4)] = '001'
			,[MaxBuyLimit (textinput-68)] = '0'
			,[MaxSellLimit (textinput-69)] = '0'
			,[MaxNetLimit (textinput-70)] = '0'
			,[AccountOpenedBy (textinput-74)] = 'CQB-Process'
			,[ContraforIntraday (selectbasic-29)] = "''" 
			,[MarketMaker (multipleradiosinline-27)] = 'N'
			,[MarketPSS (multipleradiosinline-28)] = 'N'
			-- * ShortSell Ind:
			-- (I) RSS allowed, PDT not allowed
			-- (U,Z) RSS & PDT Nt allowed
			,[ShortSellRSSInd (selectbasic-42)] =   CASE 
														WHEN [AccountNumber (textinput-5)] = 'I' THEN 'Y' 
														WHEN [AccountNumber (textinput-5)] IN ('U','Z')  THEN 'N' 
														ELSE "''"
													END -- DEFAULT TO ACCOUNT GROUP
			,[ShortSellPDTInd (selectbasic-43)] =   CASE 
														WHEN [AccountNumber (textinput-5)] IN ('I','U','Z')  THEN 'N'
														ELSE "''"
													END -- DEFAULT TO ACCOUNT GROUP
			,[ShareCheck (multipleradiosinline-29)] = 'Y'
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';
		
		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET 
			[ApproveTradingLimit (textinput-54)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'C' THEN '1.00'
								WHEN [AccountNumber (textinput-5)] = 'E' THEN '1.00'
								WHEN [AccountNumber (textinput-5)] = 'J' THEN '1.00'
								WHEN [AccountNumber (textinput-5)] = 'G' OR LEFT([AccountNumber (textinput-5)],2) = 'G-' THEN '1.00'
								WHEN [AccountNumber (textinput-5)] = 'W' THEN '1.00'
								--WHEN [AccountNumber (textinput-5)] = 'CD2' THEN '1.00'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%Algo%' THEN '1.00'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%NomY%' THEN '1.00'
								WHEN LEFT([AccountNumber (textinput-5)],1) = 'J' AND [AccountNumber (textinput-5)] LIKE '%Algo%' THEN '1.00'
								ELSE ''--DefaultToAccountGroup
							END,
			[BFEACType (selectsource-29)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] IN ('A','E','I','V') THEN '00'
								WHEN [AccountNumber (textinput-5)] IN ('C') 
									OR (LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%Algo%') 
									OR ([AccountNumber (textinput-5)] LIKE 'C-%' AND [AccountNumber (textinput-5)] LIKE '%NomY%')
									THEN '11'
								WHEN [AccountNumber (textinput-5)] IN ('J') 
									OR (LEFT([AccountNumber (textinput-5)],1) = 'J' AND [AccountNumber (textinput-5)] LIKE '%Algo%') THEN '18'
								WHEN [AccountNumber (textinput-5)] IN ('L','U','Z') 
									OR (LEFT([AccountNumber (textinput-5)],1) = 'L' AND [AccountNumber (textinput-5)] LIKE '%Algo%') THEN '10'
								WHEN [AccountNumber (textinput-5)] = 'M' THEN '20'
								--WHEN [AccountNumber (textinput-5)] = 'G' THEN '12' -- handled in trigger with additional logic
								WHEN [AccountNumber (textinput-5)] = 'W' THEN '11'
								WHEN (LEFT([AccountNumber (textinput-5)],2) = 'G-' AND [AccountNumber (textinput-5)] LIKE '%EMFALB%')	THEN '14'
								WHEN (LEFT([AccountNumber (textinput-5)],2) = 'G-' AND [AccountNumber (textinput-5)] LIKE '%EMFHLB%')	THEN '12'
								--WHEN [AccountNumber (textinput-5)] = 'CD2' THEN '11'
								--WHEN [AccountNumber (textinput-5)] = 'JE' THEN '1.00'
								ELSE ''
							END,
			[ClientAssoallowed (multipleradiosinline-13)] = 'Y',
			[ClientReassignallowed (multipleradiosinline-14)] = 'N',
			[ClientCrossamend (multipleradiosinline-15)] = 'N',
			[MultiplierforCashDeposit (textinput-56)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] IN ('A','I','G','W','P','V') 
									OR (LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%Algo%')
									OR (LEFT([AccountNumber (textinput-5)],1) = 'J' AND [AccountNumber (textinput-5)] LIKE '%Algo%') 
									OR (LEFT([AccountNumber (textinput-5)],2) = 'G-' AND [AccountNumber (textinput-5)] LIKE '%EMF%')	 THEN '0.00'
								WHEN [AccountNumber (textinput-5)] IN ('L','U','Z') 
									OR (LEFT([AccountNumber (textinput-5)],1) = 'L' AND [AccountNumber (textinput-5)] LIKE '%Algo%') THEN '2.00'
								ELSE ''
							END,
			[Multiplierforsharepledged (textinput-57)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] IN ('A','C','E','I','J','M','G','W','P','V') 
									OR (LEFT([AccountNumber (textinput-5)],2) = 'C-' )
									OR (LEFT([AccountNumber (textinput-5)],1) = 'C' AND [AccountNumber (textinput-5)] LIKE '%Algo%')
									OR (LEFT([AccountNumber (textinput-5)],2) = 'G-' )
									OR (LEFT([AccountNumber (textinput-5)],1) = 'J' AND [AccountNumber (textinput-5)] LIKE '%Algo%') THEN '0.00'
								WHEN [AccountNumber (textinput-5)] IN ('L','U','Z')
									OR (LEFT([AccountNumber (textinput-5)],1) = 'L' AND [AccountNumber (textinput-5)] LIKE '%Algo%') THEN '1.00'
								ELSE ''--DefaultToAccountGroup
							END
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';

		 UPDATE CQBTempDB.[import].[Tb_FormData_1409]
		 SET [Financier (selectsource-25)] = CASE WHEN [AccountNumber (textinput-5)] LIKE '%EMF%' THEN RIGHT([AccountNumber (textinput-5)],3) ELSE '' END,
							--'ALB', -- handled in trigger with additional logic
			 [MarginCode (textinput-39)] = 
							CASE 
								WHEN [AccountNumber (textinput-5)] = 'G'
									  OR LEFT([AccountNumber (textinput-5)],2) = 'G-'
									  THEN 'EXTERNAL MARGIN'
								WHEN [AccountNumber (textinput-5)] = 'M'		
									  THEN 'INTERNAL MARGIN'
								ELSE ''
							END,
			[ExclusionforAutoRenewal (selectbasic-40)] = IIF([ParentGroup (selectsource-3)] IN ('M','G'), 'N', ''),
			[ApprovedMargin (textinput-65)] = CASE WHEN [AccountNumber (textinput-5)] = 'M' THEN '66.67' ELSE '' END,
			[ApprovedRSV (textinput-43)] = CASE WHEN [AccountNumber (textinput-5)] = 'M' THEN '150.00' ELSE '' END,
			[PriceCapMOF (textinput-44)] = CASE WHEN [AccountNumber (textinput-5)] = 'M' THEN '100.00' ELSE '' END,
			[MarginCallInterval (selectbasic-38)] = CASE WHEN [AccountNumber (textinput-5)] = 'M' THEN '3' ELSE '' END,
			[AuthorisedRepresentative (textinput-66)] =  CASE WHEN [AccountNumber (textinput-5)] = 'M' THEN 'DR' ELSE '' END,
			[CurrentMargin (textinput-47)] = '',
			[CurrentRSV (textinput-48)] = '',
			[CommitmentFeeCode (selectsource-26)] = ''
		 WHERE [CustomerID (selectsource-1)]='DEFAULT';


		 -- == Account Limit Maintenance Form:==
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
		 ISNULL(c.[CustomerName (textinput-3)],'') as  [CustomerName (textinput-9)], 
		 a.[MaxBuyLimit (textinput-68)] as  [MaxBuyLimit (textinput-1)], 
		 a.[MaxSellLimit (textinput-69)] as  [MaxSellLimit (textinput-2)], 
		 a.[MaxNetLimit (textinput-70)] as  [MaxNetLimit (textinput-3)], 
		 a.[MultiplierforCashDeposit (textinput-56)] as  [MultiplierforCashDeposit (textinput-5)], 
		 a.[MultiplierforSharePledged (textinput-57)] as  [MultiplierforSharePledged (textinput-6)], 
		 a.[MultiplierforNonShare (textinput-58)] as  [MultiplierforNonShare (textinput-7)], 
		 a.[AvailableCleanLineLimit (textinput-59)] as  [AvailableCleanLineLimit (textinput-8)], 
		 a.[StartDate (dateinput-9)] as  [StartDate (dateinput-1)], 
		 a.[EndDate (dateinput-10)] as  [EndDate (dateinput-2)]
		FROM CQBTempDB.[import].[Tb_FormData_1409] a
			LEFT JOIN CQBTempDB.[import].Tb_FormData_1410 c
				ON a.[CustomerID (selectsource-1)] = c.[CustomerID (textinput-1)]


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
	  --      ,NULL /*Code Section Nt available*/
	  --      ,'Process fail.';

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );

    END CATCH
    
    SET NOCOUNT OFF;
END