/****** Object:  Procedure [sync].[Usp_Daily_CustomerFormToAccountForm_20200416]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_CustomerFormToAccountForm]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 14/04/2020
Last Updated Date :             
Description       : this sp is used to insert Customer form data into Account Form 
            
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
		--Exec form.[Usp_CreateImportTable] 1409
		--Select * from CQBTempDB.[import].[Tb_FormData_1409]
		;WITH cteDefaultAccountCode As (
		SELECT 
			[BranchID (textinput-3)],
			[AccountGroup (selectsource-2)],
			[ParentGroup (selectsource-3)],
			[AccountType (selectsource-7)],
			[CADEntityType1 (selectbasic-3)],
			[AveragingOption (multipleradiosinline-1)],
			[OddLotAveragingOption (selectbasic-4)],
			[SendClientInfotoBFE (multipleradiosinline-3)],
			[MRIndicatorNEW (multipleradiosinline-4)],
			[NomineeInd (selectsource-5)],
			[StructureWarrant (selectbasic-7)],
			[ShortSellInd (selectbasic-8)],
			[IDSSInd (selectbasic-10)],
			[PSSInd (selectbasic-11)],
			[IslamicTradeInd (selectbasic-9)],
			[IntraDayInd (selectbasic-12)],
			[SettlementCurrency (selectsource-6)],
			[ContraInd (selectbasic-13)],
			[ShortSellInd (selectbasic-14)],
			[OddLotsInd (selectbasic-15)],
			[DesignatedCounterInd (selectbasic-16)],
			[PN17CounterInd (selectbasic-17)],
			[GN3CounterInd (selectbasic-18)],
			[ImmediateBasisInd (selectbasic-19)],
			[ComputeServiceCharges (selectbasic-20)],
			[PrintContraStatement (selectbasic-21)]
		FROM CQBTempDB.import.Tb_FormData_1409 with (nolock)
		WHERE [CustomerKey (selectsource-1)] = 'DEFAULT'
		),
		cteAcctTypeList As (
			SELECT 
				A.[textinput-1] As CustomerID,
				B.Idx As SeqNo,
				B.Data As AccountTypesProductInfo
			FROM CQBuilder.form.Tb_FormData_1410 As A with (nolock)
			CROSS APPLY GlobalBO.[global].[Udf_SplitWithIndex](A.[multiplecheckboxes-1],',') As B
			WHERE RecordID = 1554581
		)
		--select * from cteAcctTypeList
		
		--INSERT INTO CQBTempDB.[import].[Tb_FormData_1409]
  --         (
  --         [CustomerKey (selectsource-1)]
  --         ,[CompanyID (textinput-2)]
  --         ,[BranchID (textinput-3)]
  --         ,[EAFID (textinput-4)]
  --         ,[AccountNumber (textinput-5)]
  --         --,[OldAccountNumber (textinput-22)]
  --         ,[AccountSubCode (textinput-6)]
  --         ,[NomineesName1 (selectbasic-1)]
  --         ,[NomineesName2 (textinput-7)]
  --         ,[NomineesName3 (textinput-8)]
  --         ,[NomineesName4 (textinput-9)]
  --         ,[AbbreviatedName (textinput-10)]
  --         ,[AccountGroup (selectsource-2)]
  --         ,[OddLotAveragingOption (selectbasic-4)]
  --         ,[ParentGroup (selectsource-3)]
  --         ,[ReferredbyKYC (textinput-11)]
  --         ,[AccountType (selectsource-7)]
  --         ,[CADEntityType1 (selectbasic-3)]
  --         ,[AveragingOption (multipleradiosinline-1)]
  --         ,[ApplicationStatus (selectsource-8)]
  --         ,[IntroducerIndicatorInternal (multipleradiosinline-2)]
  --         ,[IntroducerCode (textinput-12)]
  --         ,[DateJoined (dateinput-1)]
  --         ,[BrokerageSharingFeeCode (textinput-13)]
  --         ,[AuthorisedRepresentative (textinput-14)]
  --         ,[BrokerCodeDealerEAFIDDealerCode (textinput-15)]
  --         ,[SendClientInfotoBFE (multipleradiosinline-3)]
  --         ,[StructureWarrant (selectbasic-7)]
  --         ,[AccountStatus (selectsource-9)]
  --         ,[MRIndicatorNEW (multipleradiosinline-4)]
  --         ,[MRReferenceNEW (textinput-16)]
  --         ,[ReferenceSourceNEW (textinput-17)]
  --         ,[MarketCode (textinput-18)]
  --         ,[CDSNo (textinput-19)]
  --         ,[ShortSellInd (selectbasic-14)]
  --         ,[OddLotsInd (selectbasic-15)]
  --         ,[CDSACOpenBranch (selectsource-4)]
  --         ,[NomineeInd (selectsource-5)]
  --         ,[ApprovedTradingLimit (textinput-20)]
  --         ,[ShortSellInd (selectbasic-8)]
  --         ,[IDSSInd (selectbasic-10)]
  --         ,[PSSInd (selectbasic-11)]
  --         ,[IslamicTradeInd (selectbasic-9)]
  --         ,[IntraDayInd (selectbasic-12)]
  --         ,[SettlementCurrency (selectsource-6)]
  --         ,[ContraInd (selectbasic-13)]
  --         ,[DesignatedCounterInd (selectbasic-16)]
  --         ,[PN17CounterInd (selectbasic-17)]
  --         ,[GN3CounterInd (selectbasic-18)]
  --         ,[ImmediateBasisInd (selectbasic-19)]
  --         ,[ComputeServiceCharges (selectbasic-20)]
  --         ,[PrintContraStatement (selectbasic-21)]
  --         ,[MainAcforSingleSignOn (textinput-21)]
  --         ,[N2NClientIndicator (selectbasic-22)]
  --         ,[NonFaceToFaceIndicatorNEW (selectbasic-23)]
  --         ,[VBIPNEW (selectbasic-24)]
  --         ,[PROMO16IndicatorNEW (selectbasic-25)]
  --         ,[ALGOIndicatorNEW (selectbasic-26)]
		--   )
     
		 SELECT 
           A.[CustomerID (textinput-1)] -- CustomerKey not avail
           ,1 As CompanyID
           ,'' As BranchID
           ,'' As EAFID
           ,A.[AccountNo (textinput-120)] + A.[AccountTypesProductInfo (multiplecheckboxes-1)] As AcctNo
           --,[OldAccountNumber (textinput-22)]
           ,'' As AccountSubCode
           ,'' As NomineesName1
           ,'' As NomineesName2
           ,'' As NomineesName3
           ,'' As NomineesName4
           ,'' As AbbreviatedName
           ,DAC.[AccountGroup (selectsource-2)]
           ,DAC.[OddLotAveragingOption (selectbasic-4)]
           ,DAC.[ParentGroup (selectsource-3)]
           ,'' As ReferredByKYC
           ,A.[AccountTypesProductInfo (multiplecheckboxes-1)]
           ,DAC.[CADEntityType1 (selectbasic-3)]
           ,DAC.[AveragingOption (multipleradiosinline-1)]
           ,'' As ApplicationStatus
           ,'' As IntroducerIndicatorInternal
           ,'' As IntroducerCode
           ,'1900-01-01' As DateJoined
           ,'' As BrokerageSharingFeeCode
           ,'' As AuthorisedRepresentive
           ,'' As BrokerCodeDealerEAFIDDealerCode
           ,DAC.[SendClientInfotoBFE (multipleradiosinline-3)]
           ,DAC.[StructureWarrant (selectbasic-7)]
           ,'' As AccountStatus
           ,'' As [MRIndicatorNEW (multipleradiosinline-4)]
           ,'' As [MRReferenceNEW (textinput-16)]
           ,'' As [ReferenceSourceNEW (textinput-17)]
           ,'' As MarketCode
           ,'' As CDSNo
           ,DAC.[ShortSellInd (selectbasic-8)]
           ,DAC.[OddLotsInd (selectbasic-15)]
           ,'' As CDSACOpenBranch
           ,DAC.[NomineeInd (selectsource-5)]
           ,'' As ApprovedLimit
           ,DAC.[ShortSellInd (selectbasic-14)]
           ,DAC.[IDSSInd (selectbasic-10)]
           ,DAC.[PSSInd (selectbasic-11)]
           ,DAC.[IslamicTradeInd (selectbasic-9)]
           ,DAC.[IntraDayInd (selectbasic-12)]
           ,DAC.[SettlementCurrency (selectsource-6)]
           ,DAC.[ContraInd (selectbasic-13)]
           ,DAC.[DesignatedCounterInd (selectbasic-16)]
           ,DAC.[PN17CounterInd (selectbasic-17)]
           ,DAC.[GN3CounterInd (selectbasic-18)]
           ,DAC.[ImmediateBasisInd (selectbasic-19)]
           ,DAC.[ComputeServiceCharges (selectbasic-20)]
           ,DAC.[PrintContraStatement (selectbasic-21)]
           ,'' As MainACForSSO
           ,'' As N2NClientInd
           ,'' As [NonFaceToFaceIndicatorNEW (selectbasic-23)]
           ,'' As [VBIPNEW (selectbasic-24)]
           ,'' As [PROMO16IndicatorNEW (selectbasic-25)]
           ,'' As [ALGOIndicatorNEW (selectbasic-26)]
		 FROM CQBTempDB.export.Tb_FormData_1410 As A
		 INNER JOIN cteAcctTypeList As ATL
		 ON A.[CustomerID (textinput-1)] = ATL.CustomerID
		 INNER JOIN cteDefaultAccountCode As DAC
		 ON ATL.AccountTypesProductInfo = DAC.[BranchID (textinput-3)]
		
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