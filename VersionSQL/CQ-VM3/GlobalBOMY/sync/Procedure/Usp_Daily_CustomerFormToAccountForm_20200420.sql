/****** Object:  Procedure [sync].[Usp_Daily_CustomerFormToAccountForm_20200420]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_CustomerFormToAccountForm_20200420]
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
            [EAFID (textinput-4)],
			[AccountSubCode (textinput-6)],
            [NomineesName1 (selectbasic-1)],
            [NomineesName2 (textinput-7)],
            [NomineesName3 (textinput-8)],
			[NomineesName4 (textinput-9)],
            [AbbreviatedName (textinput-10)],
			[AccountGroup (selectsource-2)],
			[ParentGroup (selectsource-3)],
			[ReferredbyKYC (textinput-11)],
			[AccountType (selectsource-7)],
			[CADEntityType1 (selectbasic-3)],
			[AveragingOption (multipleradiosinline-1)],
			[OddLotAveragingOption (selectbasic-4)],
			[ApplicationStatus (selectsource-8)],
            [IntroducerIndicatorInternal (multipleradiosinline-2)],
            [IntroducerCode (textinput-12)],
			[DateJoined (dateinput-1)],
            [BrokerageSharingFeeCode (textinput-13)],
            [AuthorisedRepresentative (textinput-14)],
            [BrokerCodeDealerEAFIDDealerCode (textinput-15)],
			[SendClientInfotoBFE (multipleradiosinline-3)],
			[AccountStatus (selectsource-9)],
			[MRIndicatorNEW (multipleradiosinline-4)],
			[MRReferenceNEW (textinput-16)],
			[ReferenceSourceNEW (textinput-17)],
            [MarketCode (textinput-18)],
            [CDSNo (textinput-19)],
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
			[CDSACOpenBranch (selectsource-4)],
			[DesignatedCounterInd (selectbasic-16)],
			[ApprovedTradingLimit (textinput-20)],
			[PN17CounterInd (selectbasic-17)],
			[GN3CounterInd (selectbasic-18)],
			[ImmediateBasisInd (selectbasic-19)],
			[ComputeServiceCharges (selectbasic-20)],
			[PrintContraStatement (selectbasic-21)],
			[MainAcforSingleSignOn (textinput-21)],
            [N2NClientIndicator (selectbasic-22)],
			[NonFaceToFaceIndicatorNEW (selectbasic-23)],
			[VBIPNEW (selectbasic-24)],
			[PROMO16IndicatorNEW (selectbasic-25)],
			[ALGOIndicatorNEW (selectbasic-26)]
		FROM CQBTempDB.import.Tb_FormData_1409 with (nolock)
		WHERE [CustomerKey (selectsource-1)] = 'DEFAULT'
		)-- Select * from cteDefaultAccountCode;
		,
		cteAcctTypeList As (
			SELECT 
				A.[textinput-1] As CustomerID,
				B.Idx As SeqNo,
				B.Data As AccountTypesProductInfo
			FROM CQBuilder.form.Tb_FormData_1410 As A with (nolock) -- FROM INSERTED As A
			CROSS APPLY GlobalBO.[global].[Udf_SplitWithIndex](A.[multiplecheckboxes-1],',') As B
			WHERE RecordID = 1554581
		),
		cteCustomerFormDetail As (
			SELECT 
				[AccountTypeProductInfo],
				[CutomerID],
				[AccountNo],
				'CQBuilder AdSync' as CreatedBy, 
				getdate() as CreatedTime, 
				'Active' as [Status]
			FROM CQBuilder.form.Tb_FormData_1410 As A -- INSERTED ins
			CROSS APPLY OpenJSON(a.FormDetails,'$[0]') WITH (
			[AccountTypeProductInfo] varchar(64) '$.multiplecheckboxes1',
			[CutomerID] varchar(64) '$.textinput1',
			[AccountNo] varchar(64) '$.textinput120') As B
		)
       

		 SELECT 
           A.[CustomerID (textinput-1)] -- CustomerKey not avail
           ,1 As CompanyID
           ,'' As BranchID
           ,DAC.[EAFID (textinput-4)]
           ,A.[CustomerID (textinput-1)] + A.[AccountTypesProductInfo (multiplecheckboxes-1)] As AcctNo
           --,[OldAccountNumber (textinput-22)]
           ,DAC.[AccountSubCode (textinput-6)]
           ,DAC.[NomineesName1 (selectbasic-1)]
           ,DAC.[NomineesName2 (textinput-7)]
           ,DAC.[NomineesName3 (textinput-8)]
           ,DAC.[NomineesName4 (textinput-9)]
           ,DAC.[AbbreviatedName (textinput-10)]
           ,DAC.[AccountGroup (selectsource-2)]
           ,DAC.[OddLotAveragingOption (selectbasic-4)]
           ,DAC.[ParentGroup (selectsource-3)]
           ,DAC.[ReferredbyKYC (textinput-11)]
           ,A.[AccountTypesProductInfo (multiplecheckboxes-1)]
           ,DAC.[CADEntityType1 (selectbasic-3)]
           ,DAC.[AveragingOption (multipleradiosinline-1)]
           ,DAC.[ApplicationStatus (selectsource-8)]
           ,DAC.[IntroducerIndicatorInternal (multipleradiosinline-2)]
           ,DAC.[IntroducerCode (textinput-12)]
           ,DAC.[DateJoined (dateinput-1)]
           ,DAC.[BrokerageSharingFeeCode (textinput-13)]
           ,DAC.[AuthorisedRepresentative (textinput-14)]
           ,DAC.[BrokerCodeDealerEAFIDDealerCode (textinput-15)]
           ,DAC.[SendClientInfotoBFE (multipleradiosinline-3)]
           ,DAC.[StructureWarrant (selectbasic-7)]
           ,DAC.[AccountStatus (selectsource-9)]
           ,DAC.[MRIndicatorNEW (multipleradiosinline-4)]
           ,DAC.[MRReferenceNEW (textinput-16)]
           ,DAC.[ReferenceSourceNEW (textinput-17)]
           ,DAC.[MarketCode (textinput-18)]
           ,DAC.[CDSNo (textinput-19)]
           ,DAC.[ShortSellInd (selectbasic-8)]
           ,DAC.[OddLotsInd (selectbasic-15)]
           ,DAC.[CDSACOpenBranch (selectsource-4)]
           ,DAC.[NomineeInd (selectsource-5)]
           ,DAC.[ApprovedTradingLimit (textinput-20)]
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
           ,DAC.[MainAcforSingleSignOn (textinput-21)]
           ,DAC.[N2NClientIndicator (selectbasic-22)]
           ,DAC.[NonFaceToFaceIndicatorNEW (selectbasic-23)]
           ,DAC.[VBIPNEW (selectbasic-24)]
           ,DAC.[PROMO16IndicatorNEW (selectbasic-25)]
           ,DAC.[ALGOIndicatorNEW (selectbasic-26)]
		 FROM CQBTempDB.export.Tb_FormData_1410 As A
		 INNER JOIN cteAcctTypeList As ATL
		 ON A.[CustomerID (textinput-1)] = ATL.CustomerID
		 INNER JOIN cteDefaultAccountCode As DAC
		 ON ATL.AccountTypesProductInfo = DAC.[BranchID (textinput-3)]

		 
--Select '[{"selectsource1":"CustomerKey","textinput2":"CompanyID","textinput3":"BranchID","textinput4":"EAFID",
--	"textinput5":"AccountNumber","textinput6":"AccountSubCode","selectbasic1":"NomineesName1","textinput7":"NomineesName2",
--	"textinput8":"NomineesName3","textinput9":"NomineesName4","textinput10":"AbbreviatedName","selectsource2":"AccountGroup",
--	"selectsource3":"ParentGroup","AccountType":"selectsource7","selectbasic3":"CADEntityType1","multipleradiosinline1":"AveragingOption",
--	"selectbasic4":"OddLotAveragingOption","textinput11":"ReferredbyKYC","selectsource8":"ApplicationStatus","multipleradiosinline2":"IntroducerIndicatorInternal",
--	"textinput12":"IntroducerCode","dateinput-1":"DateJoined",
--	"textinput13":"BrokerageSharingFeeCode",
--	"textinput14":"AuthorisedRepresentative",
--	"textinput15":"BrokerCodeDealerEAFIDDealerCode",
--	"multipleradiosinline3":"SendClientInfotoBFE",
--	"selectsource9":"AccountStatus",
--	"multipleradiosinline4":"MRIndicatorNEW",
--	"textinput16":"MRReferenceNEW",
--	"textinput17":"ReferenceSourceNEW",
--	"textinput18":"MarketCode",
--	"textinput19":"CDSNo",
--	"selectsource4":"CDSACOpenBranch",
--	"selectsource5":"NomineeInd",
--	"textinput20":"ApprovedTradingLimit",
--	"selectbasic7":"StructureWarrant",
--	"selectbasic8":"ShortSellInd",
--	"selectbasic10":"IDSSInd",
--	"selectbasic11":"PSSInd",
--	"selectbasic9":"IslamicTradeInd",
--	"selectbasic12":"IntraDayInd",
--	"selectsource6":"SettlementCurrency",
--	"selectbasic13":"ContraInd",
--	"selectbasic14":"ShortSellInd",
--	"selectbasic15":"OddLotsInd",
--	"selectbasic16":"DesignatedCounterInd",
--	"selectbasic17":"PN17CounterInd",
--	"selectbasic18":"GN3CounterInd",
--	"selectbasic19":"ImmediateBasisInd",
--	"selectbasic20":"ComputeServiceCharges",
--	"selectbasic21":"PrintContraStatement",
--	"textinput21":"MainAcforSingleSignOn",
--	"selectbasic22":"N2NClientIndicator",
--	"selectbasic23":"NonFaceToFaceIndicatorNEW",
--	"selectbasic24":"VBIPNEW",
--	"selectbasic25":"PROMO16IndicatorNEW",
--	"selectbasic26":"ALGOIndicatorNEW"}]' as FormDetails,
--	'CQBuilder AdSync' as CreatedBy, getdate() as CreatedTime, 'Active' as [Status]

		
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