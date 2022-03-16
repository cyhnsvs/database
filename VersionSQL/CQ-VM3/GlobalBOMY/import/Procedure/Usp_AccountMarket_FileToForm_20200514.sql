/****** Object:  Procedure [import].[Usp_AccountMarket_FileToForm_20200514]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_3_AccountMarket_FileToForm]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 14/05/2020
Last Updated Date :             
Description       : this sp is used to insert Account Market file into CQForm Account Market
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		--Exec form.[Usp_CreateImportTable] 1336
		--Select * from CQBTempDB.[import].[Tb_FormData_1336]

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1336;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1336
		(
			[RecordID],
			[Action],
			[AccountNo (textinput-1)],
			[MarketCode (textinput-2)],
			[CDSNo (textinput-3)],
			[IDSSInd (textinput-6)],
			[IslamicTradeInd (selectbasic-4)],
			[CDSACOpenBranch (selectsource-1)],
			[NomineeInd (selectsource-2)],
			[ApprovedTradingLimit (textinput-4)],
			[IntraDayInd (selectbasic-5)],
			[RebateCode (selectsource-3)],
			[Structurewarrant (selectbasic-2)],
			[ShortSellInd (selectbasic-3)],
			[SettlementacName (textinput-7)],
			[SettlementBankac (textinput-8)],
			[SettlementModeCode (selectsource-4)],
			[SettlementCurrency (selectsource-5)],
			[BankCode (selectsource-6)],
			[BankBranch (selectsource-7)],
			[CashBook (selectsource-8)],
			[AvailableTradingLimit (textinput-10)],
			[BFEacType (textinput-11)],
			[ClientAssoallowed (multipleradiosinline-1)],
			[ClientReassignallowed (multipleradiosinline-2)],
			[ClientCrossamend (multipleradiosinline-3)],
			[MultiplierforCashDeposit (textinput-12)],
			[Multiplierforsharepledged (textinput-13)],
			[MultiplierforNonShare (textinput-14)],
			[AvailableCleanLineLimit (textinput-15)],
			[TemporaryLimit (textinput-16)],
			[StartDate (dateinput-1)],
			[EndDate (dateinput-2)],
			[ContraInd (selectbasic-8)],
			[ShortSellInd (selectbasic-9)],
			[OddLotsInd (selectbasic-10)],
			[DesignatedCounterInd (selectbasic-11)],
			[ComputeServiceCharges (multipleradiosinline-4)],
			[PrintContraStatement (selectbasic-12)],
			[SetoffInd (selectbasic-13)],
			[SetoffContraGainDebitAmount (selectbasic-14)],
			[SetoffSalesPurchasesReport (selectbasic-15)],
			[SetoffTrustDebitTransactions (selectbasic-16)],
			[SetoffTrustContraLoss (selectbasic-17)],
			[TransferCreditTransactiontoTrust (selectbasic-18)],
			[PrintSetoffStatement (selectbasic-19)],
			[MainAcforSingleSignOn (textinput-17)],
			[ECOSOnlineClientIndicator (multipleradiosinline-5)]
	)
	SELECT 
			null as [RecordID],
			'I' as [Action],
			AccountNo,
			MarketCode,
			CDSNo,
			'' as  [IDSSInd (textinput-6)],
			IslamicTradeInd,
			CDSACOpenBranch,
			NomineeInd,
			TradingLimit,
			IntraDayInd,
			RebateCode,
			 '' as  [Structurewarrant (selectbasic-2)],
			ShortSellInd,
			SettlementACName,
			SettlementBankAC,
			SettlementModeCode,
			SettlementCurrency,
			BankCode,
			BankBranch,
			CashBook,
			AvailableTradingLimit,
			BFEACType,
			ClientAssoAllowed,
			ClientReassignAllowed,
			ClientCrossAmend,
			MultiplierForCashDeposit,
			MultiplierForSharePledged,
			MultiplierForNonShare,
			AvailableCleanLineLimit,
			TemporaryLimit,
			StartDate,
			EndDate,
			ContraInd,
			ShortSellInd2,
			OddLotsInd,
			DesignatedCounterInd,
			ComputeServiceCharges,
			PrintContraStatement,
			SetoffInd,
			SetoffContraGainDebitAmt,
			 SetoffSalesPurchases,
			SetoffTrustDebitTrans,
			SetoffTrustContraLoss,
			TransferCreditTransToTrust,
			PrintSetoffStatement,
			 '' as  [MainAcforSingleSignOn (textinput-17)],
			 '' as  [ECOSOnlineClientIndicator (multipleradiosinline-5)]
		FROM import.Tb_AccountMarketInfo

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