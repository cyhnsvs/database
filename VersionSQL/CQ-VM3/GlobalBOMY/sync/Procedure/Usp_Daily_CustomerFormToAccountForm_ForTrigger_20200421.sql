/****** Object:  Procedure [sync].[Usp_Daily_CustomerFormToAccountForm_ForTrigger_20200421]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_CustomerFormToAccountForm_ForTrigger_20200421]
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
			[IDSSInd (multipleradiosinline-10)],
			[PSSInd (multipleradiosinline-11)],
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
		) 
		,
		cteAcctTypeList As (
			SELECT 
				A.[textinput-1] As CustomerID,
				B.Idx As SeqNo,
				B.Data As AccountTypesProductInfo,
				A.[textinput-1] + B.Data As AccountNo
			FROM CQBuilder.form.Tb_FormData_1410 As A with (nolock) -- FROM INSERTED As A
			CROSS APPLY GlobalBO.[global].[Udf_SplitWithIndex](A.[multiplecheckboxes-1],',') As B
			WHERE RecordID = 116736
		) --Select * from cteAcctTypeList
		--cteCustomerFormDetail As (
		--	SELECT 
		--		[AccountTypeProductInfo],
		--		[CutomerID],
		--		[AccountNo],
		--		'CQBuilder AdSync' as CreatedBy, 
		--		getdate() as CreatedTime, 
		--		'Active' as [Status]
		--	FROM CQBuilder.form.Tb_FormData_1410 As A -- INSERTED ins
		--	CROSS APPLY OpenJSON(a.FormDetails,'$[0]') WITH (
		--	[AccountTypeProductInfo] varchar(64) '$.multiplecheckboxes1',
		--	[CutomerID] varchar(64) '$.textinput1',
		--	[AccountNo] varchar(64) '$.textinput120') As B
		--)
		
		INSERT INTO CQBuilder.[form].[Tb_FormData_1409]
           ([FormDetails]
           ,[CreatedBy]
           ,[CreatedTime]
           ,[ApprovalStatus]
           ,[Status]
           ,[RefRecordID])

SELECT 
'[{"selectsource1":"'+A.CustomerID+'",
"textinput2":"1",
"textinput3":"",
"textinput4":"'+ISNULL(DAC.[EAFID (textinput-4)],'')+'",
"textinput5":"'+A.AccountNo+'",
"textinput6":"'+ISNULL(DAC.[AccountSubCode (textinput-6)],'')+'",
"selectbasic1":"'+ISNULL(DAC.[NomineesName1 (selectbasic-1)],'')+'",
"textinput7":"'+ISNULL(DAC.[NomineesName2 (textinput-7)],'')+'",
"textinput8":"'+ISNULL(DAC.[NomineesName3 (textinput-8)],'')+'",
"textinput9":"'+ISNULL(DAC.[NomineesName4 (textinput-9)],'')+'",
"textinput10":"'+ISNULL(DAC.[AbbreviatedName (textinput-10)],'')+'",
"selectsource2":"'+ISNULL(DAC.[AccountGroup (selectsource-2)],'')+'",
"selectsource3":"'+ISNULL(DAC.[ParentGroup (selectsource-3)],'')+'",
"selectsource7":"'+ISNULL(DAC.[AccountType (selectsource-7)],'')+'",
"selectbasic3":"'+ISNULL(DAC.[CADEntityType1 (selectbasic-3)],'')+'",
"multipleradiosinline1":"'+ISNULL(DAC.[AveragingOption (multipleradiosinline-1)],'')+'",
"selectbasic4":"'+ISNULL(DAC.[OddLotAveragingOption (selectbasic-4)],'')+'",
"textinput11":"'+ISNULL(DAC.[ReferredbyKYC (textinput-11)],'')+'",
"selectsource8":"'+ISNULL(DAC.[ApplicationStatus (selectsource-8)],'')+'",
"multipleradiosinline2":"'+ISNULL(DAC.[IntroducerIndicatorInternal (multipleradiosinline-2)],'')+'",
"textinput12":"'+ISNULL(DAC.[IntroducerCode (textinput-12)],'')+'",
"dateinput-1":"'+ISNULL(DAC.[DateJoined (dateinput-1)],'')+'",
"textinput13":"'+ISNULL(DAC.[BrokerageSharingFeeCode (textinput-13)],'')+'",
"textinput14":"'+ISNULL(DAC.[AuthorisedRepresentative (textinput-14)],'')+'",
"textinput15":"'+ISNULL(DAC.[BrokerCodeDealerEAFIDDealerCode (textinput-15)],'')+'",
"multipleradiosinline3":"'+ISNULL(DAC.[SendClientInfotoBFE (multipleradiosinline-3)],'')+'",
"selectsource9":"'+ISNULL(DAC.[AccountStatus (selectsource-9)],'')+'",
"multipleradiosinline4":"'+ISNULL(DAC.[MRIndicatorNEW (multipleradiosinline-4)],'')+'",
"textinput16":"'+ISNULL(DAC.[MRReferenceNEW (textinput-16)],'')+'",
"textinput17":"'+ISNULL(DAC.[ReferenceSourceNEW (textinput-17)],'')+'",
"textinput18":"'+ISNULL(DAC.[MarketCode (textinput-18)],'')+'",
"textinput19":"'+ISNULL(DAC.[CDSNo (textinput-19)],'')+'",
"selectsource4":"'+ISNULL(DAC.[CDSACOpenBranch (selectsource-4)],'')+'",
"selectsource5":"'+ISNULL(DAC.[NomineeInd (selectsource-5)],'')+'",
"textinput20":"'+ISNULL(DAC.[ApprovedTradingLimit (textinput-20)],'')+'",
"selectbasic7":"'+ISNULL(DAC.[StructureWarrant (selectbasic-7)],'')+'",
"selectbasic8":"'+ISNULL(DAC.[ShortSellInd (selectbasic-8)],'')+'",
"selectbasic10":"'+ISNULL(DAC.[IDSSInd (multipleradiosinline-10)],'')+'",
"selectbasic11":"'+ISNULL(DAC.[PSSInd (multipleradiosinline-11)],'')+'",
"selectbasic9":"'+ISNULL(DAC.[IslamicTradeInd (selectbasic-9)],'')+'",
"selectbasic12":"'+ISNULL(DAC.[IntraDayInd (selectbasic-12)],'')+'",
"selectsource6":"'+ISNULL(DAC.[SettlementCurrency (selectsource-6)],'')+'",
"selectbasic13":"'+ISNULL(DAC.[ContraInd (selectbasic-13)],'')+'",
"selectbasic14":"'+ISNULL(DAC.[ShortSellInd (selectbasic-14)],'')+'",
"selectbasic15":"'+ISNULL(DAC.[OddLotsInd (selectbasic-15)],'')+'",
"selectbasic16":"'+ISNULL(DAC.[DesignatedCounterInd (selectbasic-16)],'')+'",
"selectbasic17":"'+ISNULL(DAC.[PN17CounterInd (selectbasic-17)],'')+'",
"selectbasic18":"'+ISNULL(DAC.[GN3CounterInd (selectbasic-18)],'')+'",
"selectbasic19":"'+ISNULL(DAC.[ImmediateBasisInd (selectbasic-19)],'')+'",
"selectbasic20":"'+ISNULL(DAC.[ComputeServiceCharges (selectbasic-20)],'')+'",
"selectbasic21":"'+ISNULL(DAC.[PrintContraStatement (selectbasic-21)],'')+'",
"textinput21":"'+ISNULL(DAC.[MainAcforSingleSignOn (textinput-21)],'')+'",
"selectbasic22":"'+ISNULL(DAC.[N2NClientIndicator (selectbasic-22)],'')+'",
"selectbasic23":"'+ISNULL(DAC.[NonFaceToFaceIndicatorNEW (selectbasic-23)],'')+'",
"selectbasic24":"'+ISNULL(DAC.[VBIPNEW (selectbasic-24)],'')+'",
"selectbasic25":"'+ISNULL(DAC.[PROMO16IndicatorNEW (selectbasic-25)],'')+'",
"selectbasic26":"'+ISNULL(DAC.[ALGOIndicatorNEW (selectbasic-26)],'')+'"}]' as FormDetails,
			'CQBuilder Trigger' as CreatedBy,
			getdate() as CreatedTime,
			Null As ApprovalStatus,
			'Active' as [Status],
			Null As RefRecordID
		FROM cteAcctTypeList As A
		INNER JOIN cteDefaultAccountCode As DAC
		ON A.AccountTypesProductInfo = DAC.[BranchID (textinput-3)]
		
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