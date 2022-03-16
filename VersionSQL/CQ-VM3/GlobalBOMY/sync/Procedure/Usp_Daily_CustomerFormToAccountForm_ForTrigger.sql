/****** Object:  Procedure [sync].[Usp_Daily_CustomerFormToAccountForm_ForTrigger]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_CustomerFormToAccountForm_ForTrigger]
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
			[CustomerKey],
			[BranchID],
			[EAFID],
			[AccountSubCode],
			[NomineesName1],
			[NomineesName2],
			[NomineesName3],
			[NomineesName4],
			[AbbreviatedName],
			[AccountGroup],
			[ParentGroup],
			[ReferredbyKYC],
			[AccountType],
			[CADEntityType1],
			[AveragingOption],
			[OddLotAveragingOption],
			[ApplicationStatus],
			[IntroducerIndicatorInternal],
			[IntroducerCode],
			'001-01-01' As [DateJoined],
			[BrokerageSharingFeeCode],
			[AuthorisedRepresentative],
			[BrokerCodeDealerEAFIDDealerCode],
			[SendClientInfotoBFE],
			[AccountStatus],
			[MRIndicatorNEW],
			[MRReferenceNEW],
			[ReferenceSourceNEW],
			[MarketCode],
			[CDSNo],
			[NomineeInd],
			[StructureWarrant],
			[ShortSellInd],
			[IDSSInd],
			[PSSInd],
			[IslamicTradeInd],
			[IntraDayInd],
			[SettlementCurrency],
			[ContraInd],
			[ShortSellInd2],
			[OddLotsInd],
			[CDSACOpenBranch],
			[DesignatedCounterInd],
			[ApprovedTradingLimit],
			[PN17CounterInd],
			[GN3CounterInd],
			[ImmediateBasisInd],
			[ComputeServiceCharges],
			[PrintContraStatement],
			[MainAcforSingleSignOn],
			[N2NClientIndicator],
			[NonFaceToFaceIndicatorNEW],
			[VBIPNEW],
			[PROMO16IndicatorNEW],
			[ALGOIndicatorNEW]
		FROM CQBuilder.form.Tb_FormData_1409 As A
		CROSS APPLY OpenJSON(A.FormDetails,'$[0]') WITH (
			[CustomerKey] varchar(50) '$.selectsource1',
			[BranchID] varchar(20) '$.textinput3',
            [EAFID] varchar(20) '$.textinput4',
			[AccountSubCode] varchar(20) '$.textinput6',
            [NomineesName1] varchar(20) '$.selectbasic1',
            [NomineesName2] varchar(20) '$.textinput7',
            [NomineesName3] varchar(20) '$.textinput8',
			[NomineesName4] varchar(20) '$.textinput9',
            [AbbreviatedName] varchar(20) '$.textinput10',
			[AccountGroup] varchar(20) '$.selectsource2',
			[ParentGroup] varchar(20) '$.selectsource3',
			[ReferredbyKYC] varchar(20) '$.textinput11',
			[AccountType] varchar(20) '$.selectsource7',
			[CADEntityType1] varchar(20) '$.selectsource18',
			[AveragingOption] varchar(20) '$.multipleradiosinline1',
			[OddLotAveragingOption] varchar(20) '$.selectbasic4',
			[ApplicationStatus] varchar(20) '$.selectsource8',
            [IntroducerIndicatorInternal] varchar(20) '$.multipleradiosinline2',
            [IntroducerCode] varchar(20) '$.textinput12',
			[DateJoined] varchar(20) '$.dateinput1',
            [BrokerageSharingFeeCode] varchar(20) '$.textinput13',
            [AuthorisedRepresentative] varchar(20) '$.textinput14',
            [BrokerCodeDealerEAFIDDealerCode] varchar(20) '$.textinput15',
			[SendClientInfotoBFE] varchar(20) '$.multipleradiosinline3',
			[AccountStatus] varchar(20) '$.selectsource9',
			[MRIndicatorNEW] varchar(20) '$.multipleradiosinline4',
			[MRReferenceNEW] varchar(20) '$.textinput16',
			[ReferenceSourceNEW] varchar(20) '$.textinput17',
            [MarketCode] varchar(20) '$.textinput18',
            [CDSNo] varchar(20) '$.textinput19',
			[NomineeInd] varchar(20) '$.selectsource5',
			[StructureWarrant] varchar(20) '$.selectbasic7',
			[ShortSellInd] varchar(20) '$.selectbasic8',
			[IDSSInd] varchar(20) '$.multipleradiosinline10',
			[PSSInd] varchar(20) '$.multipleradiosinline11',
			[IslamicTradeInd] varchar(20) '$.selectbasic9',
			[IntraDayInd] varchar(20) '$.selectbasic12',
			[SettlementCurrency] varchar(20) '$.selectsource6',
			[ContraInd] varchar(20) '$.selectbasic13',
			[ShortSellInd2] varchar(20) '$.selectbasic14',
			[OddLotsInd] varchar(20) '$.selectbasic15',
			[CDSACOpenBranch] varchar(20) '$.selectsource4',
			[DesignatedCounterInd] varchar(20) '$.selectbasic16',
			[ApprovedTradingLimit] varchar(20) '$.textinput20',
			[PN17CounterInd] varchar(20) '$.selectbasic17',
			[GN3CounterInd] varchar(20) '$.selectbasic18',
			[ImmediateBasisInd] varchar(20) '$.selectbasic19',
			[ComputeServiceCharges] varchar(20) '$.selectbasic20',
			[PrintContraStatement] varchar(20) '$.selectbasic21',
			[MainAcforSingleSignOn] varchar(20) '$.textinput21',
            [N2NClientIndicator] varchar(20) '$.selectbasic22',
			[NonFaceToFaceIndicatorNEW] varchar(20) '$.selectbasic23',
			[VBIPNEW] varchar(20) '$.selectbasic24',
			[PROMO16IndicatorNEW] varchar(20) '$.selectbasic25',
			[ALGOIndicatorNEW] varchar(20) '$.selectbasic26'
			) As B
		WHERE [selectsource-1] = 'DEFAULT'
		) 
		,
		cteAcctTypeList As (
			select b.AccountNo as CustomerID,
			       d.RowIndex as SeqNo,
				   d.AccountType as AccountTypesProductInfo,
				   b.AccountNo + d.AccountType as AccountNo 
			    from CQBuilder.form.Tb_formData_1410 as a
				cross apply openjson(a.formDetails, '$[0]') with
				(
					AccountTypeData nvarchar(max) '$.grid1',
					AccountNo nvarchar(max) '$.textinput1'
				) as b 
				cross apply openjson(b.AccountTypeData, '$') as c
				cross apply openjson(c.value, '$') with (
					RowIndex nvarchar(max) '$.rowIndex',
					AccountType nvarchar(max) '$.seq1',
					IsForeign nvarchar(max) '$.seq2',
					DealerCode nvarchar(max) '$.seq3',
					Nominees nvarchar(max) '$.seq4',
					CDSNo nvarchar(max) '$.seq5'
				) as d
				where a.RecordID = 116736
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
		----)
		
		INSERT INTO CQBuilder.[form].[Tb_FormData_1409]
           ([FormDetails]
           ,[CreatedBy]
           ,[CreatedTime]
           ,[ApprovalStatus]
           ,[Status]
           ,[RefRecordID])
  
		SELECT
			'[{"selectsource1":"'+A.CustomerID+'","textinput2":"1","textinput3":"","textinput4":"'+DAC.[EAFID]+'","textinput5":"'+A.AccountNo+'","textinput6":"'+DAC.[AccountSubCode]+'","selectbasic1":"'+DAC.[NomineesName1]+'","textinput7":"'+DAC.[NomineesName2]+'","textinput8":"'+DAC.[NomineesName3]+'","textinput9":"'+DAC.[NomineesName4]+'","textinput10":"'+DAC.[AbbreviatedName]+'","selectsource2":"'+DAC.[AccountGroup]+'","selectsource3":"'+DAC.[ParentGroup]+'","selectsource7":"'+DAC.[AccountType]+'","selectsource18":"'+DAC.[CADEntityType1]+'","multipleradiosinline1":"'+DAC.[AveragingOption]+'","selectbasic4":"'+DAC.[OddLotAveragingOption]+'","textinput11":"'+DAC.[ReferredbyKYC]+'","selectsource8":"'+DAC.[ApplicationStatus]+'","multipleradiosinline2":"'+DAC.[IntroducerIndicatorInternal]+'","textinput12":"'+DAC.[IntroducerCode]+'","dateinput-1":"'+DAC.[DateJoined]+'","textinput13":"'+DAC.[BrokerageSharingFeeCode]+'","textinput14":"'+DAC.[AuthorisedRepresentative]+'","textinput15":"'+DAC.[BrokerCodeDealerEAFIDDealerCode]+'","multipleradiosinline3":"'+DAC.[SendClientInfotoBFE]+'","selectsource9":"'+DAC.[AccountStatus]+'","multipleradiosinline4":"'+DAC.[MRIndicatorNEW]+'","textinput16":"'+DAC.[MRReferenceNEW]+'","textinput17":"'+DAC.[ReferenceSourceNEW]+'","textinput18":"'+DAC.[MarketCode]+'","textinput19":"'+DAC.[CDSNo]+'","selectsource4":"'+DAC.[CDSACOpenBranch]+'","selectsource5":"'+DAC.[NomineeInd]+'","textinput20":"'+DAC.[ApprovedTradingLimit]+'","selectbasic7":"'+DAC.[StructureWarrant]+'","selectbasic8":"'+DAC.[ShortSellInd]+'","multipleradiosinline10":"'+DAC.[IDSSInd]+'","multipleradiosinline11":"'+DAC.[PSSInd]+'","selectbasic9":"'+DAC.[IslamicTradeInd]+'","selectbasic12":"'+DAC.[IntraDayInd]+'","selectsource6":"'+DAC.[SettlementCurrency]+'","selectbasic13":"'+DAC.[ContraInd]+'","selectbasic14":"'+DAC.[ShortSellInd2]+'","selectbasic15":"'+DAC.[OddLotsInd]+'","selectbasic16":"'+DAC.[DesignatedCounterInd]+'","selectbasic17":"'+DAC.[PN17CounterInd]+'","selectbasic18":"'+DAC.[GN3CounterInd]+'","selectbasic19":"'+DAC.[ImmediateBasisInd]+'","selectbasic20":"'+DAC.[ComputeServiceCharges]+'","selectbasic21":"'+DAC.[PrintContraStatement]+'","textinput21":"'+DAC.[MainAcforSingleSignOn]+'","selectbasic22":"'+DAC.[N2NClientIndicator]+'","selectbasic23":"'+DAC.[NonFaceToFaceIndicatorNEW]+'","selectbasic24":"'+DAC.[VBIPNEW]+'","selectbasic25":"'+DAC.[PROMO16IndicatorNEW]+'","selectbasic26":"'+DAC.[ALGOIndicatorNEW]+'","textinput22":""},{"selectsource1":"'+A.CustomerID+'","textinput2":"1","textinput3":"","textinput4":"'+DAC.[EAFID]+'","textinput5":"'+A.AccountNo+'","textinput6":"'+DAC.[AccountSubCode]+'","selectbasic1":"'+DAC.[NomineesName1]+'","textinput7":"'+DAC.[NomineesName2]+'","textinput8":"'+DAC.[NomineesName3]+'","textinput9":"'+DAC.[NomineesName4]+'","textinput10":"'+DAC.[AbbreviatedName]+'","selectsource2":"'+DAC.[AccountGroup]+'","selectsource3":"'+DAC.[ParentGroup]+'","selectsource7":"'+DAC.[AccountType]+'","selectsource18":"'+DAC.[CADEntityType1]+'","multipleradiosinline1":"'+DAC.[AveragingOption]+'","selectbasic4":"'+DAC.[OddLotAveragingOption]+'","textinput11":"'+DAC.[ReferredbyKYC]+'","selectsource8":"'+DAC.[ApplicationStatus]+'","multipleradiosinline2":"'+DAC.[IntroducerIndicatorInternal]+'","textinput12":"'+DAC.[IntroducerCode]+'","dateinput-1":"'+DAC.[DateJoined]+'","textinput13":"'+DAC.[BrokerageSharingFeeCode]+'","textinput14":"'+DAC.[AuthorisedRepresentative]+'","textinput15":"'+DAC.[BrokerCodeDealerEAFIDDealerCode]+'","multipleradiosinline3":"'+DAC.[SendClientInfotoBFE]+'","selectsource9":"'+DAC.[AccountStatus]+'","multipleradiosinline4":"'+DAC.[MRIndicatorNEW]+'","textinput16":"'+DAC.[MRReferenceNEW]+'","textinput17":"'+DAC.[ReferenceSourceNEW]+'","textinput18":"'+DAC.[MarketCode]+'","textinput19":"'+DAC.[CDSNo]+'","selectsource4":"'+DAC.[CDSACOpenBranch]+'","selectsource5":"'+DAC.[NomineeInd]+'","textinput20":"'+DAC.[ApprovedTradingLimit]+'","selectbasic7":"'+DAC.[StructureWarrant]+'","selectbasic8":"'+DAC.[ShortSellInd]+'","multipleradiosinline10":"'+DAC.[IDSSInd]+'","multipleradiosinline11":"'+DAC.[PSSInd]+'","selectbasic9":"'+DAC.[IslamicTradeInd]+'","selectbasic12":"'+DAC.[IntraDayInd]+'","selectsource6":"'+DAC.[SettlementCurrency]+'","selectbasic13":"'+DAC.[ContraInd]+'","selectbasic14":"'+DAC.[ShortSellInd2]+'","selectbasic15":"'+DAC.[OddLotsInd]+'","selectbasic16":"'+DAC.[DesignatedCounterInd]+'","selectbasic17":"'+DAC.[PN17CounterInd]+'","selectbasic18":"'+DAC.[GN3CounterInd]+'","selectbasic19":"'+DAC.[ImmediateBasisInd]+'","selectbasic20":"'+DAC.[ComputeServiceCharges]+'","selectbasic21":"'+DAC.[PrintContraStatement]+'","textinput21":"'+DAC.[MainAcforSingleSignOn]+'","selectbasic22":"'+DAC.[N2NClientIndicator]+'","selectbasic23":"'+DAC.[NonFaceToFaceIndicatorNEW]+'","selectbasic24":"'+DAC.[VBIPNEW]+'","selectbasic25":"'+DAC.[PROMO16IndicatorNEW]+'","selectbasic26":"'+DAC.[ALGOIndicatorNEW]+'","textinput22":""}]' as FormDetails,
			'CQBuilder Trigger' as CreatedBy,
			getdate() as CreatedTime,
			Null As ApprovalStatus,
			'Active' as [Status],
			Null As RefRecordID
		FROM cteAcctTypeList As A
		INNER JOIN cteDefaultAccountCode As DAC
		ON A.AccountTypesProductInfo = DAC.BranchID
		
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