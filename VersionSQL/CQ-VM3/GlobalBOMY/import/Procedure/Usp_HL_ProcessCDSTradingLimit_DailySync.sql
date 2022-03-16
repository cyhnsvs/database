/****** Object:  Procedure [import].[Usp_HL_ProcessCDSTradingLimit_DailySync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_HL_ProcessCDSTradingLimit_DailySync]
AS
/***********************************************************************************             
            
Name              : import.Usp_HL_ProcessCDSTradingLimit_DailySync     
Created By        : Nathiya Palanisamy
Created Date      : 28/12/2020    
Last Updated Date :             
Description       : this sp is used to import CDS Account's Trading Limit from Hong Leong to GBO
            
Table(s) Used     : 
            
Modification History :  											
 
PARAMETERS
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors            
            
Used By : 
EXEC [import].[Usp_HL_ProcessCDSTradingLimit_DailySync]
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    DECLARE @ostrReturnMessage VARCHAR(4000);
    BEGIN TRY
    	BEGIN TRANSACTION
        
		-- CREATE IMPORT FORM DATA TABLE	
		EXEC CQBTempDB.form.USP_CreateImportTable 1409;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1409;


        IF EXISTS (SELECT 1 FROM GlobalBOMY.[import].[Tb_HongLeong_trdlmt]) 
        BEGIN
			DROP TABLE IF EXISTS #formMapping;

			SELECT ComponentID AS VirtualColumnName, ComponentIndex - 1 AS ColumnIndex 
			INTO #FormMapping 
			FROM CQBuilder.form.Udf_GetFields(1409, 1);

			EXEC form.Usp_CreateExportTable 1409, 'form.Tb_ExportFormDataDelta_'

			DECLARE @reftblName varchar(100) = 'CQBTempDB.[import].Tb_FormData_1409'
			declare @numOfCol bigint = (select count(1)  from #FormMapping);
			declare @i bigint = 0;
			declare @fieldId varchar(500);
			declare @query nvarchar(max) = '';

 

			set @query = 'insert into form.Tb_ExportFormDataDelta_1409 select DISTINCT RecordID, ''AutoExport'', GETDATE(), NULL, NULL, '
			while(@i < @numOfCol)
			begin
			    set @fieldId = (select VirtualColumnName from #FormMapping where ColumnIndex = @i);
			    set @query = @query + '[' + @fieldId +'], ';
			    set @i = @i + 1;
			end
			set @query = SUBSTRING(@query,0,LEN(@query));
			set @query = @query + ' FROM ' + @reftblName + ' AS F';
			set @query = @query + ' INNER JOIN GlobalBOMY.[import].[Tb_HongLeong_trdlmt] AS S
			                        ON RIGHT(S.ClientCDSNo,9) = F.[AccountNumber (textinput-5)]
									WHERE S.TradingLine <> F.[ApproveTradingLimit (textinput-54)]'
			                            
			--PRINT @query
			EXEC sp_executesql @query;

			-- INSERT INTO IMPORT FORM TABLE FROM DELTA TABLE
			INSERT INTO CQBTempDB.[import].Tb_FormData_1409
			(
				 [AccountGroup (selectsource-2)]
				,[ParentGroup (selectsource-3)]
				,[VBIP (selectbasic-39)]
				,[AccountType (selectsource-7)]
				,[ALGOIndicator (selectbasic-26)]
				,[IDSSInd (multipleradiosinline-10)]
				,[PSSInd (multipleradiosinline-11)]
				,[OnlineSystemIndicator (multiplecheckboxesinline-1)]
				,[CustomerID (selectsource-1)]
				,[AccountNumber (textinput-5)]
				,[AccountSubCode (textinput-6)]
				,[NomineesName1 (selectsource-20)]
				,[Access (multipleradiosinline-20)]
				,[NomineesName2 (textinput-7)]
				,[NomineesName3 (textinput-8)]
				,[NomineesName4 (textinput-9)]
				,[AbbreviatedName (textinput-10)]
				,[CADEntityType1 (selectsource-18)]
				,[AveragingOption (multipleradiosinline-1)]
				,[OddLotAveragingOption (selectbasic-4)]
				,[Buy (multipleradiosinline-21)]
				,[Sell (multipleradiosinline-22)]
				,[DealerCode (selectsource-21)]
				,[SendClientInfotoBFE (selectbasic-27)]
				,[AccountStatus (selectsource-9)]
				,[MRIndicator (multipleradiosinline-4)]
				,[StartDate (dateinput-9)]
				,[EndDate (dateinput-10)]
				,[MRReference (selectsource-22)]
				,[WithLimit (multipleradiosinline-18)]
				,[ClearPreviousDayOrder (multipleradiosinline-19)]
				,[ReferenceSource (selectsource-23)]
				,[CDSNo (textinput-19)]
				,[CDSACOpenBranch (selectsource-4)]
				,[NomineeInd (selectsource-5)]
				,[StructureWarrant (selectbasic-7)]
				,[ShortSellInd (selectsource-19)]
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
				 [AccountGroup (selectsource-2)]
				,[ParentGroup (selectsource-3)]
				,[VBIP (selectbasic-39)]
				,[AccountType (selectsource-7)]
				,[ALGOIndicator (selectbasic-26)]
				,[IDSSInd (multipleradiosinline-10)]
				,[PSSInd (multipleradiosinline-11)]
				,[OnlineSystemIndicator (multiplecheckboxesinline-1)]
				,[CustomerID (selectsource-1)]
				,[AccountNumber (textinput-5)]
				,[AccountSubCode (textinput-6)]
				,[NomineesName1 (selectsource-20)]
				,[Access (multipleradiosinline-20)]
				,[NomineesName2 (textinput-7)]
				,[NomineesName3 (textinput-8)]
				,[NomineesName4 (textinput-9)]
				,[AbbreviatedName (textinput-10)]
				,[CADEntityType1 (selectsource-18)]
				,[AveragingOption (multipleradiosinline-1)]
				,[OddLotAveragingOption (selectbasic-4)]
				,[Buy (multipleradiosinline-21)]
				,[Sell (multipleradiosinline-22)]
				,[DealerCode (selectsource-21)]
				,[SendClientInfotoBFE (selectbasic-27)]
				,[AccountStatus (selectsource-9)]
				,[MRIndicator (multipleradiosinline-4)]
				,[StartDate (dateinput-9)]
				,[EndDate (dateinput-10)]
				,[MRReference (selectsource-22)]
				,[WithLimit (multipleradiosinline-18)]
				,[ClearPreviousDayOrder (multipleradiosinline-19)]
				,[ReferenceSource (selectsource-23)]
				,[CDSNo (textinput-19)]
				,[CDSACOpenBranch (selectsource-4)]
				,[NomineeInd (selectsource-5)]
				,[StructureWarrant (selectbasic-7)]
				,[ShortSellInd (selectsource-19)]
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
			FROM 
				form.Tb_ExportFromDataDelta_1409

			-- UPDATE Import Form Data Table
			UPDATE	I
			SET		I.[ApproveTradingLimit (textinput-54)] = A.TradingLine
			FROM 
				CQBTempDB.[import].Tb_FormData_1409	I
			INNER JOIN 
				[GlobalBOMY].[import].[Tb_HongLeong_trdlmt]	 A ON I.[CDSNo (textinput-19)] = RIGHT(A.ClientCDSNo,9)


		END
		
    	COMMIT TRANSACTION
    END TRY
    BEGIN CATCH

		 DECLARE @intErrorNumber INT
        ,@intErrorLine INT
        ,@intErrorSeverity INT
        ,@intErrorState INT
        ,@strObjectName VARCHAR(200)

		SELECT 
                  @intErrorNumber = ERROR_NUMBER(), 
                  @ostrReturnMessage = ERROR_MESSAGE(), 
                  @intErrorLine = ERROR_LINE(), 
                  @intErrorSeverity = ERROR_SEVERITY(), 
                  @intErrorState = ERROR_STATE(), 
                  @strObjectName = ERROR_PROCEDURE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; 

    	EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber, @ostrReturnMessage, @intErrorLine, @strObjectName,NULL, 'Process fail.';

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);           

    END CATCH

	SET NOCOUNT OFF;
END