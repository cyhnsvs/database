/****** Object:  Procedure [form].[Usp_PopulateAccount1409Rpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_PopulateAccount1409Rpt]        
 @iintCompanyId BIGINT,        
 @ostrReturnMessage VARCHAR(400) OUTPUT        
AS        
/***********************************************************************************         
        
Name              : [form].[Usp_PopulateCustomer1409Rpt]        
Created By        : Fadlin        
Created Date      : 09/12/2020
Last Updated Date :         
Description       : this sp transfers the account from main CQB database to the reporting database        
					uses a same server/different server switch to determine which source database to use        
Table(s) Used     :         
        
Modification History :        
 ModifiedBy :   Project UIN:		ModifiedDate :  Reason :        
 
 
													
PARAMETERS         
 @iintCompanyId - the company id        
 @ostrReturnMessage - output any info/error message generated        
        
Used By :        
        EXEC [form].[Usp_PopulateAccount1409Rpt]  1, ''
************************************************************************************/        
BEGIN        
        
 SET NOCOUNT ON;        
        
 BEGIN TRY        
     BEGIN TRANSACTION        
                
		DECLARE @dteBusinessDate DATE;       
		    
		SELECT @dteBusinessDate = DateValue        
		FROM GlobalBORpt.setup.Tb_Date        
		WHERE CompanyId = @iintCompanyId AND  DateCd = 'BusDate' ;              
		
		--SET @dteBusinessDate = '2020-12-08';

		DELETE FROM GlobalBORpt.form.Tb_FormData_1409  
		WHERE ReportDate = @dteBusinessDate;   

		INSERT INTO GlobalBORpt.[form].[Tb_FormData_1409]
		(
			[ReportDate]
			,RecordID
			,CreatedBy
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
			,[AccountGroup (selectsource-2)]
			,[ParentGroup (selectsource-3)]
			,[AccountType (selectsource-7)]
			,[ALGOIndicator (selectbasic-26)]
			,[CustomerID (selectsource-1)]
			,[AccountNumber (textinput-5)]
			,[AccountSubCode (textinput-6)]
			,[NomineesName1 (selectsource-20)]
			,[NomineesName2 (textinput-7)]
			,[NomineesName3 (textinput-8)]
			,[NomineesName4 (textinput-9)]
			,[AbbreviatedName (textinput-10)]
			,[CADEntityType1 (selectsource-18)]
			,[AveragingOption (multipleradiosinline-1)]
			,[OddLotAveragingOption (selectbasic-4)]
			,[DealerCode (selectsource-21)]
			,[SendClientInfotoBFE (selectbasic-27)]
			,[AccountStatus (selectsource-9)]
			,[MRIndicator (multipleradiosinline-4)]
			,[MRReference (selectsource-22)]
			,[ReferenceSource (selectsource-23)]
			,[CDSNo (textinput-19)]
			,[CDSACOpenBranch (selectsource-4)]
			,[NomineeInd (selectsource-5)]
			,[StructureWarrant (selectbasic-7)]
			,[ShortSellInd (selectsource-19)]
			,[IDSSInd (multipleradiosinline-10)]
			,[PSSInd (multipleradiosinline-11)]
			,[IslamicTradeInd (selectbasic-9)]
			,[IntraDayInd (selectbasic-12)]
			,[SettlementCurrency (selectsource-6)]
			,[ContraInd (selectbasic-13)]
			,[ContraforShortSelling (selectbasic-28)]
			,[ContraforOddLots (selectbasic-15)]
			,[ContraforIntraday (selectbasic-29)]
			,[DesignatedCounterInd (selectbasic-16)]
			,[ImmediateBasisInd (selectbasic-19)]
			,[SetoffInd (selectbasic-30)]
			,[SetoffContraGainDebitAmount (selectbasic-31)]
			,[SetoffSalesPurchasesReport (selectbasic-32)]
			,[SetoffTrustDebitTransactions (selectbasic-33)]
			,[SetoffTrustContraLoss (selectbasic-34)]
			,[TransferCreditTransactiontoTrust (selectbasic-35)]
			,[UserID (textinput-52)]
			,[OnlineSystemIndicator (multiplecheckboxesinline-1)]
			,[VBIP (selectbasic-39)]
			,[WithLimit (multipleradiosinline-18)]
			,[ClearPreviousDayOrder (multipleradiosinline-19)]
			,[Access (multipleradiosinline-20)]
			,[Buy (multipleradiosinline-21)]
			,[Sell (multipleradiosinline-22)]
			,[SuspensionReason (selectsource-30)]
			,[Remarks (textinput-72)]
			,[MaxBuyLimit (textinput-68)]
			,[MaxSellLimit (textinput-69)]
			,[MaxNetLimit (textinput-70)]
			,[ExceedLimit (textinput-71)]
			,[ApproveTradingLimit (textinput-54)]
			,[AvailableTradingLimit (textinput-55)]
			,[BFEACType (selectsource-29)]
			,[ClientAssoallowed (multipleradiosinline-13)]
			,[ClientReassignallowed (multipleradiosinline-14)]
			,[ClientCrossamend (multipleradiosinline-15)]
			,[MultiplierforCashDeposit (textinput-56)]
			,[MultiplierforSharePledged (textinput-57)]
			,[MultiplierforNonShare (textinput-58)]
			,[AvailableCleanLineLimit (textinput-59)]
			,[StartDate (dateinput-9)]
			,[EndDate (dateinput-10)]
			,[TemporaryLimit (textinput-60)]
			,[StartDate (dateinput-11)]
			,[EndDate (dateinput-12)]
			,[LegalStatus (selectsource-24)]
			,[BankruptcyorWindingupstatus (multipleradiosinline-12)]
			,[BankruptcyorWindingupreason (textinput-61)]
			,[DatedeclaredbankruptcyorWindingup (dateinput-13)]
			,[DatedischargedbankruptcyorWindingup (dateinput-14)]
			,[Remark1 (textinput-62)]
			,[Remark2 (textinput-63)]
			,[Financier (selectsource-25)]
			,[MarginCode (textinput-39)]
			,[CommencementDate (dateinput-4)]
			,[ExclusionforAutoRenewal (selectbasic-40)]
			,[TenorExpiryDate (dateinput-5)]
			,[LetterofOfferdate (dateinput-15)]
			,[FacilityAgreementDate (dateinput-16)]
			,[MortgageAgreementDate (dateinput-17)]
			,[ApprovedLimit (textinput-64)]
			,[ApprovedMargin (textinput-65)]
			,[ApprovedRSV (textinput-43)]
			,[PriceCapMOF (textinput-44)]
			,[MarginCallInterval (selectbasic-38)]
			,[AuthorisedRepresentative (textinput-66)]
			,[CurrentMargin (textinput-47)]
			,[CurrentRSV (textinput-48)]
			,[CommitmentFeeCode (selectsource-26)]
        )
		SELECT
			@dteBusinessDate
			,RecordID
			,CreatedBy
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
		   ,[AccountGroup (selectsource-2)]
           ,[ParentGroup (selectsource-3)]
           ,[AccountType (selectsource-7)]
           ,[ALGOIndicator (selectbasic-26)]
           ,[CustomerID (selectsource-1)]
           ,[AccountNumber (textinput-5)]
           ,[AccountSubCode (textinput-6)]
           ,[NomineesName1 (selectsource-20)]
           ,[NomineesName2 (textinput-7)]
           ,[NomineesName3 (textinput-8)]
           ,[NomineesName4 (textinput-9)]
           ,[AbbreviatedName (textinput-10)]
           ,[CADEntityType1 (selectsource-18)]
           ,[AveragingOption (multipleradiosinline-1)]
           ,[OddLotAveragingOption (selectbasic-4)]
           ,[DealerCode (selectsource-21)]
           ,[SendClientInfotoBFE (selectbasic-27)]
           ,[AccountStatus (selectsource-9)]
           ,[MRIndicator (multipleradiosinline-4)]
           ,[MRReference (selectsource-22)]
           ,[ReferenceSource (selectsource-23)]
           ,[CDSNo (textinput-19)]
           ,[CDSACOpenBranch (selectsource-4)]
           ,[NomineeInd (selectsource-5)]
           ,[StructureWarrant (selectbasic-7)]
           ,[ShortSellInd (selectsource-19)]
           ,[IDSSInd (multipleradiosinline-10)]
           ,[PSSInd (multipleradiosinline-11)]
           ,[IslamicTradeInd (selectbasic-9)]
           ,[IntraDayInd (selectbasic-12)]
           ,[SettlementCurrency (selectsource-6)]
           ,[ContraInd (selectbasic-13)]
           ,[ContraforShortSelling (selectbasic-28)]
           ,[ContraforOddLots (selectbasic-15)]
           ,[ContraforIntraday (selectbasic-29)]
           ,[DesignatedCounterInd (selectbasic-16)]
           ,[ImmediateBasisInd (selectbasic-19)]
           ,[SetoffInd (selectbasic-30)]
           ,[SetoffContraGainDebitAmount (selectbasic-31)]
           ,[SetoffSalesPurchasesReport (selectbasic-32)]
           ,[SetoffTrustDebitTransactions (selectbasic-33)]
           ,[SetoffTrustContraLoss (selectbasic-34)]
           ,[TransferCreditTransactiontoTrust (selectbasic-35)]
           ,[UserID (textinput-52)]
           ,[OnlineSystemIndicator (multiplecheckboxesinline-1)]
           ,[VBIP (selectbasic-39)]
           ,[WithLimit (multipleradiosinline-18)]
           ,[ClearPreviousDayOrder (multipleradiosinline-19)]
           ,[Access (multipleradiosinline-20)]
           ,[Buy (multipleradiosinline-21)]
           ,[Sell (multipleradiosinline-22)]
           ,[SuspensionReason (selectsource-30)]
           ,[Remarks (textinput-72)]
           ,[MaxBuyLimit (textinput-68)]
           ,[MaxSellLimit (textinput-69)]
           ,[MaxNetLimit (textinput-70)]
           ,[ExceedLimit (textinput-71)]
           ,[ApproveTradingLimit (textinput-54)]
           ,[AvailableTradingLimit (textinput-55)]
           ,[BFEACType (selectsource-29)]
           ,[ClientAssoallowed (multipleradiosinline-13)]
           ,[ClientReassignallowed (multipleradiosinline-14)]
           ,[ClientCrossamend (multipleradiosinline-15)]
           ,[MultiplierforCashDeposit (textinput-56)]
           ,[MultiplierforSharePledged (textinput-57)]
           ,[MultiplierforNonShare (textinput-58)]
           ,[AvailableCleanLineLimit (textinput-59)]
           ,[StartDate (dateinput-9)]
           ,[EndDate (dateinput-10)]
           ,[TemporaryLimit (textinput-60)]
           ,[StartDate (dateinput-11)]
           ,[EndDate (dateinput-12)]
           ,[LegalStatus (selectsource-24)]
           ,[BankruptcyorWindingupstatus (multipleradiosinline-12)]
           ,[BankruptcyorWindingupreason (textinput-61)]
           ,[DatedeclaredbankruptcyorWindingup (dateinput-13)]
           ,[DatedischargedbankruptcyorWindingup (dateinput-14)]
           ,[Remark1 (textinput-62)]
           ,[Remark2 (textinput-63)]
           ,[Financier (selectsource-25)]
           ,[MarginCode (textinput-39)]
           ,[CommencementDate (dateinput-4)]
           ,[ExclusionforAutoRenewal (selectbasic-40)]
           ,[TenorExpiryDate (dateinput-5)]
           ,[LetterofOfferdate (dateinput-15)]
           ,[FacilityAgreementDate (dateinput-16)]
           ,[MortgageAgreementDate (dateinput-17)]
           ,[ApprovedLimit (textinput-64)]
           ,[ApprovedMargin (textinput-65)]
           ,[ApprovedRSV (textinput-43)]
           ,[PriceCapMOF (textinput-44)]
           ,[MarginCallInterval (selectbasic-38)]
           ,[AuthorisedRepresentative (textinput-66)]
           ,[CurrentMargin (textinput-47)]
           ,[CurrentRSV (textinput-48)]
           ,[CommitmentFeeCode (selectsource-26)]
		FROM CQBTempDB.export.Tb_FormData_1409;

		--DELETE FROM form.Tb_FormData_1409 WHERE ReportDate <= DATEADD(day, -7, GETDATE());
    COMMIT TRANSACTION        
    END TRY        
    BEGIN CATCH     
    
		ROLLBACK TRANSACTION;     
		
		SELECT @ostrReturnMessage = ERROR_MESSAGE();        
        EXECUTE GlobalBORpt.utilities.usp_RethrowError ',[form].[Usp_PopulateAccount1409Rpt] '; 
   
    END CATCH        
            
    SET NOCOUNT OFF;         
        
END 