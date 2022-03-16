/****** Object:  Procedure [import].[Usp_5_Stock_FileToForm1345]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_5_Stock_FileToForm1345]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 19/05/2020
Last Updated Date :             
Description       : this sp is used to insert Stock file into CQForm Product
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_5_Stock_FileToForm1345]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1345;
		--Select * from CQBTempDB.[import].[Tb_FormData_1345]

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1345;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1345
		(
			[RecordID],
			[Action],
			[InstrumentCode (textinput-49)],
			[Premiumprice (textinput-15)],
			[Maturitydate (dateinput-6)],
			[Exercisedate (dateinput-7)],
			[Exerciseprice (textinput-16)],
			[Remarkcode (textinput-17)],
			[ProductStatus (selectbasic-3)],
			[Datesuspended (dateinput-8)],
			[SuspensionType (multipleradiosinline-9)],
			[SuspensionReason (selectsource-10)],
			[Daterelisted (dateinput-9)],
			[Closingprice (textinput-18)],
			[Closingpricedate (dateinput-10)],
			[TradedVolume (textinput-20)],
			[HighPrice (textinput-21)],
			[LowPrice (textinput-22)],
			[VolumeWeightedAvgPrice (textinput-23)],
			[CounterMergingDateFrom (dateinput-11)],
			[MotherShare (textinput-24)],
			[Category (selectbasic-4)],
			[Issuedate (dateinput-12)],
			[Maturitydate (dateinput-13)],
			[ConvStartdate (dateinput-14)],
			[Conversionprice (textinput-25)],
			[Nominalprice (textinput-26)],
			[TopUpprice (textinput-27)],
			[ForShare (textinput-28)],
			[ConvMonths (textinput-29)],
			[OtherconvPeriod (textinput-30)],
			[Interestrate (textinput-31)],
			[Calculationmethod (multipleradiosinline-15)],
			[Periodtype (multipleradiosinline-10)],
			[Startdate (dateinput-15)],
			[Enddate (dateinput-16)],
			[LastInterestdate (dateinput-17)],
			[NextInterestdate (dateinput-18)],
			[AutoGenerateCA (multipleradiosinline-11)],
			[PriceLimitCheckMin (textinput-33)],
			[PriceLimitCheckMax (textinput-34)],
			[ProductIssuer (textinput-35)],
			[Currency (selectsource-12)],
			[Pricetype (multipleradiosinline-12)],
			[Multiplier (textinput-37)],
			[Depositreceipt (textinput-38)],
			[Dateissue (dateinput-19)],
			[Lastcoupdate (dateinput-20)],
			[Nextcoupdate (dateinput-21)],
			[Nextexercisedate (dateinput-22)],
			[Underlying (textinput-39)],
			[Guarantor (textinput-40)],
			[MarketCode (selectsource-11)],
			[Description (textinput-2)],
			[CounterShortName (textinput-3)],
			[PreviousName (textinput-4)],
			[CARFlag (selectbasic-1)],
			[Board (selectsource-1)],
			[Sector (selectsource-2)],
			[ProductClass (selectsource-3)],
			[ShareGrade (selectsource-4)],
			[BasisCode (selectsource-5)],
			[DateListed (dateinput-1)],
			[MarketSymbol (textinput-5)],
			[ISIN (textinput-6)],
			[SecuritiesType (selectsource-6)],
			[IndexCode (selectsource-7)],
			[KLCI (multipleradiosinline-1)],
			[CDSshare (multipleradiosinline-2)],
			[Syariahshare (multipleradiosinline-3)],
			[Oddlot (multipleradiosinline-4)],
			[StructuredWarrant (multipleradiosinline-5)],
			[Shortsell (multipleradiosinline-6)],
			[IDSS (textinput-7)],
			[PDT (textinput-8)],
			[MarginableInd (selectbasic-2)],
			[GN3Indicator (multipleradiosinline-7)],
			[PN17Indicator (multipleradiosinline-8)],
			[Registrarcode (selectsource-8)],
			[PrescribePeriodFrom (dateinput-2)],
			[PrescribePeriodTo (dateinput-3)],
			[PaidUpCapital (textinput-9)],
			[Issuedquantity (textinput-10)],
			[RBLCode (selectsource-9)],
			[Lotsize (textinput-11)],
			[From (dateinput-4)],
			[To (dateinput-5)],
			[MotherShare (textinput-12)],
			[Convratio (textinput-13)],
			--[Convratio (textinput-14)],
			[Accrualbasis (textinput-41)],
			[Interestrate (textinput-42)],
			[Interestfreq (textinput-43)],
			[Exchangerate (textinput-44)],
			[Maturitydate (dateinput-23)],
			[Exerciseprice (textinput-45)],
			[IPOPrice (textinput-46)],
			[IPOCapIndicator (multipleradiosinline-13)],
			[IPOCapExpiryDate (dateinput-24)])    
		SELECT 
				null as [RecordID],
				'I' as [Action],
				ProductCd + '.' + CASE 
					WHEN MarketCd = 'AUSE' THEN 'XASX'
					WHEN MarketCd = 'BMSB' THEN 'XKLS'
					WHEN MarketCd = 'HKSE' THEN 'XHKG'
					WHEN MarketCd = 'IDX' THEN 'XIDX'
					WHEN MarketCd = 'LSE' THEN 'XLON'
					WHEN MarketCd = 'NASD' THEN 'XNAS'
					WHEN MarketCd = 'OTC' THEN 'UOTC'
					WHEN MarketCd = 'SGX' THEN 'XSES'
					WHEN MarketCd = 'SSE' THEN 'XSHG'
					WHEN MarketCd = 'TH' THEN 'XBKK'
					WHEN MarketCd = 'TKY' THEN 'XIST'
					WHEN MarketCd = 'TWSE' THEN 'XTAI'
					WHEN MarketCd = 'TO' THEN 'XTSE'
					WHEN MarketCd = 'UNTR' THEN 'XJNB'
					WHEN MarketCd = 'US' THEN 'ARCX'
					--WHEN MarketCd = 'US' THEN 'XNYS'
					ELSE MarketCd END,
				PremiumPrice,
				WarrantMaturityDate,
				ExerciseDate,
				ExercisePrice,
				RemarkCode,
				CASE WHEN [Status]='' THEN 'A' ELSE [Status] END,
				DateSuspended,
				SuspensionType,
				SuspensionType,
				DateRelisted,
				ClosingPrice,
				ClosingPriceDate,
				TradedVolume,
				HighPrice,
				LowPrice,
				VolumeWeightedAvgPrice,
				CounterMergingDateFrom,
				LoanStockMotherShare,
				Category,
				IssueDate,
				LoanStockMaturityDate,
				LoanStockConvStartDate,
				ConversionPrice,
				NominalPrice,
				TopUpPrice,
				ForShare,
				ConversonMonths,
				OtherConvPeriod,
				InterestRate,
				CalculationMethod,
				PeriodType,
				RBLCodeStartDate,
				RBLCodeEndDate,
				InterestLastDate,
				InterestNextDate,
				AutoGenerateCA,
				PriceLimitCheckMin,
				PriceLimitCheckMax,
				CADProductIssuer,
				CADCurrency,
				CADPriceType,
				CADMultiplier,
				CADDepositReceipt,
				CADDateIssue,
				CADLastCoupDate,
				CADNextCoupDate,
				CADNextExerciseDate,
				CADUnderlying,
				BondGuarantor,
				CASE 
					WHEN MarketCd = 'AUSE' THEN 'XASX'
					WHEN MarketCd = 'BMSB' THEN 'XKLS'
					WHEN MarketCd = 'HKSE' THEN 'XHKG'
					WHEN MarketCd = 'IDX' THEN 'XIDX'
					WHEN MarketCd = 'LSE' THEN 'XLON'
					WHEN MarketCd = 'NASD' THEN 'XNAS'
					WHEN MarketCd = 'OTC' THEN 'UOTC'
					WHEN MarketCd = 'SGX' THEN 'XSES'
					WHEN MarketCd = 'SSE' THEN 'XSHG'
					WHEN MarketCd = 'TH' THEN 'XBKK'
					WHEN MarketCd = 'TKY' THEN 'XIST'
					WHEN MarketCd = 'TWSE' THEN 'XTAI'
					WHEN MarketCd = 'TO' THEN 'XTSE'
					WHEN MarketCd = 'UNTR' THEN 'XJNB'
					WHEN MarketCd = 'US' THEN 'ARCX'
					--WHEN MarketCd = 'US' THEN 'XNYS'
					ELSE MarketCd END AS MarketCd,
				[Description],
				ShortName,
				PreviousName,
				CarFlag,
				Board,
				Sector,
				ProductClass,
				ShareGrade,
				BasisCode,
				DateListed,
				MarketSymbol,
				ISIN,
				SecuritiesType,
				IndexCode,
				KLCI,
				CDSShare,
				SyariahShare,
				OddLot,
				'' as  [StructuredWarrant (multipleradiosinline-5)],
				ShortSell,
				'' as  [IDSS (textinput-7)],
				'' as  [PDT (textinput-8)],
				MarginableInd,
				'' as  [GN3Indicator (multipleradiosinline-7)],
				PN17Ind,
				RegistrarCode,
				PrescribeFromDate,
				PrescribeToDate,
				PaidUpCapital,
				IssuedQty,
				RBLCode,
				LotSize,
				RBLCodeStartDate,
				RBLCodeEndDate,
				WarrantMotherShare,
				ConvRatioNumerator+'/'+ConvRatioDenominator,
				--ConvRatioDenominator,
				BondAccrualBasis,
				BondInterestRate,
				BondInterestFrequency,
				BondExchangeRate,
				LoanStockMaturityDate,
				ExercisePrice,
				IPOPrice,
				IPOCapInd,
				IPOCapExpiryDate
			FROM import.Tb_Stock
			WHERE ProductCd NOT IN ('CTTN','TRTG','U06');

			-- UPDATE LIMIT
			UPDATE Form
			SET [NetLimit (textinput-47)] = ISNULL(CASE WHEN S.NetLimit = '.00' THEN '0.00' ELSE S.NetLimit END,'0.00')
			FROM CQBTempDB.import.tb_FormData_1345 Form
			LEFT JOIN GlobalBO.setup.Tb_Instrument I ON Form.[CounterShortName (textinput-3)] = I.ShortName
			LEFT JOIN import.Tb_Limit_Stock S ON S.Stock = I.InstrumentId;
			
			--SELECT COUNT(1) FROM CQBTempDB.import.tb_FormData_1345;

			--Update RestrictedList And DisclosureofDealingtoSCTOM
			
			UPDATE Form
			SET [RestrictedList (multiplecheckboxes-1)] = CASE WHEN (ISNULL(R.PRODCD,'') = '' AND ISNULL(R.MRKTCD,'') = '') THEN  '' ELSE 'R' END
			FROM CQBTempDB.import.tb_FormData_1345 Form
			LEFT JOIN GlobalBOMY.import.Tb_Stock_Restricted R  
			ON  R.PRODCD  = SUBSTRING(Form.[InstrumentCode (textinput-49)],0,CHARINDEX('.',Form.[InstrumentCode (textinput-49)]))
				AND Form.[MarketCode (selectsource-11)] = 	CASE 
																WHEN MRKTCD = 'AUSE' THEN 'XASX'
																WHEN MRKTCD = 'BMSB' THEN 'XKLS'
																WHEN MRKTCD = 'HKSE' THEN 'XHKG'
																WHEN MRKTCD = 'IDX' THEN 'XIDX'
																WHEN MRKTCD = 'LSE' THEN 'XLON'
																WHEN MRKTCD = 'NASD' THEN 'XNAS'
																WHEN MRKTCD = 'OTC' THEN 'UOTC'
																WHEN MRKTCD = 'SGX' THEN 'XSES'
																WHEN MRKTCD = 'SSE' THEN 'XSHG'
																WHEN MRKTCD = 'TH' THEN 'XBKK'
																WHEN MRKTCD = 'TKY' THEN 'XIST'
																WHEN MRKTCD = 'TWSE' THEN 'XTAI'
																WHEN MRKTCD = 'TO' THEN 'XTSE'
																WHEN MRKTCD = 'UNTR' THEN 'XJNB'
																WHEN MRKTCD = 'US' THEN 'ARCX'
															ELSE MRKTCD END


			UPDATE Form
			SET [DisclosureofDealingtoSCTOM (multiplecheckboxes-2)]  = CASE WHEN ISNULL(D.PRODCD,'') = '' AND ISNULL(D.MRKTCD,'') = '' THEN '' ELSE 'D' END 
			FROM CQBTempDB.import.tb_FormData_1345 Form
			LEFT JOIN GlobalBOMY.import.Tb_Stock_DisclosureDC D
			ON  D.PRODCD  = SUBSTRING(Form.[InstrumentCode (textinput-49)],0,CHARINDEX('.',Form.[InstrumentCode (textinput-49)]))
				AND Form.[MarketCode (selectsource-11)] = 	CASE 
																WHEN MRKTCD = 'AUSE' THEN 'XASX'
																WHEN MRKTCD = 'BMSB' THEN 'XKLS'
																WHEN MRKTCD = 'HKSE' THEN 'XHKG'
																WHEN MRKTCD = 'IDX' THEN 'XIDX'
																WHEN MRKTCD = 'LSE' THEN 'XLON'
																WHEN MRKTCD = 'NASD' THEN 'XNAS'
																WHEN MRKTCD = 'OTC' THEN 'UOTC'
																WHEN MRKTCD = 'SGX' THEN 'XSES'
																WHEN MRKTCD = 'SSE' THEN 'XSHG'
																WHEN MRKTCD = 'TH' THEN 'XBKK'
																WHEN MRKTCD = 'TKY' THEN 'XIST'
																WHEN MRKTCD = 'TWSE' THEN 'XTAI'
																WHEN MRKTCD = 'TO' THEN 'XTSE'
																WHEN MRKTCD = 'UNTR' THEN 'XJNB'
																WHEN MRKTCD = 'US' THEN 'ARCX'
															ELSE MRKTCD END

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