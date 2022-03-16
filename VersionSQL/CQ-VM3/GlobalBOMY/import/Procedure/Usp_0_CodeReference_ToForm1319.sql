/****** Object:  Procedure [import].[Usp_0_CodeReference_ToForm1319]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_0_CodeReference_ToForm1319] 
AS
/*********************************************************************************** 

Name              : import.Usp_OneTime_CodeReference
Created By        : Jansi
Created Date      : 12/05/2020
Last Updated Date : 
Description       : this sp is used to import the code reference to CQ Form Code Reference
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 Kristine									19/08/21				Code Reference update
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_0_CodeReference_ToForm1319] 

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION

			TRUNCATE TABLE import.Tb_CodeReference;
			
			INSERT INTO import.Tb_CodeReference(RefType,RefDesc,RefCd)
			-- Branch
			SELECT 'SetlCurrency' As RefType,[DESCRIPTION],CURRCODE As RefCd FROM import.Tb_Currency
			UNION 
			SELECT  'Calendar' As RefType, [Description],CalendarID As RefCd FROM import.Tb_Calendar
			UNION 
			SELECT 'DayType' As RefType,'WORKING' As [Description],'W' As RefCD
			UNION
			SELECT 'DayType' As RefType,'CALENDAR' As [Description],'C' As RefCD
			UNION 
			SELECT 'DateType' As RefType,'Transaction Date' As [Description],'T' As RefCD
			UNION
			SELECT 'DateType' As RefType,'Payment Due Date' As [Description],'P' As RefCD
			UNION
			SELECT 'DateType' As RefType,'Default to Next Level' As [Description],'' As RefCD
			-- Yes or No for MainBranch,ToDeductOSDebitTrx,EarMarkForOSPurchase
			UNION
			-- Dealer
			SELECT 'DealerType' As RefType,DealerTypeDesc As RefDesc,LTRIM(RTRIM(DealerTypeCd)) As RefCd FROM import.Tb_DealerType
			UNION
 			SELECT  'DealerGradeCode' As CodeType, [Description],LTRIM(RTRIM(DealerGradeCode)) As RefCd FROM import.Tb_DealerGrade
			UNION 
			SELECT 'IDNumberType' As RefType, [DESCRIPTION] As RefCd, LTRIM(RTRIM(IDTYPECD)) As RefCd FROM import.Tb_IDType
			UNION
			SELECT  'Race' As CodeType, [Description] As RefDesc,LTRIM(RTRIM(RACECD)) As RefCd FROM import.Tb_Race WHERE DESCRIPTION NOT IN ('CORPORATE & BROKER','JAPANESE')
			--UNION
			--SELECT  'Race' As CodeType, 'BUMIPUTRA' As RefDesc, 'B' AS RefCd
			UNION
			SELECT  'Ownership' As CodeType, 'Bumi Controlled' As RefDesc, 'BC' AS RefCd
			UNION
			SELECT  'Ownership' As CodeType, 'Non-Bumi Controlled' As RefDesc, 'NBC' AS RefCd
			UNION
			SELECT  'Ownership' As CodeType, 'Foreign Controlled' As RefDesc, 'FC' AS RefCd
			UNION
			SELECT 'MultiplierMethod' As RefType,MultiplierMethodDesc As RefDesc, LTRIM(RTRIM(MultiplierMethodCd)) As RefCD FROM import.Tb_MultiplierMethod
			--UNION
			--SELECT 'ServiceRate' As RefType,[Description] As RefDesc,LTRIM(RTRIM(ServiceRateCode)) As RefCd from import.Tb_ServiceRate
			--UNION
			--SELECT 'BrokerageRate' As RefType,Descriptn As RefDesc,LTRIM(RTRIM(Brkgcd)) As RefCd from import.Tb_BrokerageRate
		    UNION
			SELECT 'DealerStatus' As RefType,'Active' As RefDesc,'A' As RefCd
			UNION
			SELECT 'DealerStatus' As RefType,'Suspended' As RefDesc,'S' As RefCd
			UNION
			SELECT 'DealerStatus' As RefType,'Resigned' As RefDesc,'R' As RefCd
			-- Yes or No for MainDealerCodeInd,BumiputraStatus,
			-- M or F for Gender
			-- Dealer Market Info
			UNION
			SELECT 'ContraInd' As RefType,'Default To Financier' As RefDesc,'' As RefCd
			UNION
			SELECT 'ContraInd' As RefType,'Yes' As RefDesc,'Y' As RefCd
			UNION
			SELECT 'ContraInd' As RefType,'No' As RefDesc,'N' As RefCd
			UNION
			SELECT 'ContraInd' As RefType,'Intraday Only' As RefDesc,'I' As RefCd
			UNION
			SELECT 'ComputeServiceCharge' As RefType,'Default To Next Level' As RefDesc,'' As RefCd
			UNION
			SELECT 'ComputeServiceCharge' As RefType,'Yes Charge To Client' As RefDesc,'C' As RefCd
			UNION
			SELECT 'ComputeServiceCharge' As RefType,'Yes Charge To Dealer' As RefDesc,'D' As RefCd
			UNION
			SELECT 'ComputeServiceCharge' As RefType,'No' As RefDesc,'N' As RefCd
			UNION
			SELECT 'DealerSetOffInd' As RefType,'Default To Next Level' As RefDesc,'' As RefCd
			UNION
			SELECT 'DealerSetOffInd' As RefType,'Yes' As RefDesc,'Y' As RefCd
			UNION
			SELECT 'DealerSetOffInd' As RefType,'No' As RefDesc,'N' As RefCd
			--Customer
			UNION
			SELECT 'CustomerType' As RefType,CustomerTypeDesc As RefDesc,LTRIM(RTRIM(CustomerTypeCd)) As RefCD FROM import.Tb_CustomerType
			UNION
			SELECT 'Gender' As RefType,'Male' As RefDesc,'M' As RefCd -- Default
			UNION
			SELECT 'Gender' As RefType,'Female' As RefDesc,'F' As RefCd
			UNION
			SELECT 'Gender' As RefType,'Not Applicable' As RefDesc,'' As RefCd
			UNION
			SELECT 'MaritalStatus' As RefType,'Single' As RefDesc,'S' As RefCd -- Default
			UNION
			SELECT 'MaritalStatus' As RefType,'Married' As RefDesc,'M' As RefCd
			UNION
			SELECT 'MaritalStatus' As RefType,'Widowed' As RefDesc,'W' As RefCd
			UNION
			SELECT 'MaritalStatus' As RefType,'Divorced' As RefDesc,'D' As RefCd
			UNION
			SELECT 'MaritalStatus' As RefType,'Other' As RefDesc,'O' As RefCd
			UNION
			SELECT 'MaritalStatus' As RefType,'Not Applicable' As RefDesc,'NA' As RefCd
			UNION
			SELECT 'Country' As RefType, DESCRIPTION As RefDesc, LTRIM(RTRIM(COUNTRYCD)) As RefCD FROM import.Tb_Country
			UNION
			SELECT 'BumiputraStatus' As RefType,'Yes' As RefDesc,'Y' As RefCd
			UNION
			SELECT 'BumiputraStatus' As RefType,'No' As RefDesc,'N' As RefCd -- Default
			-- Yes Or No(Default) for BankruptcyorWindingUp,PermanentResident
			UNION
			SELECT 'ContractType' As RefType, Description As RefDesc,LTRIM(RTRIM(ContractTypeCode)) As RefCd FROM import.Tb_ContractType
			UNION
			SELECT 'BFEOrderType' As RefType, Description As RefDesc,LTRIM(RTRIM(BFEOrderType)) As RefCd FROM import.Tb_BFEOrderType
			-- Account
			UNION
			SELECT 'AccountGroup' As RefType,Description As RefDesc,LTRIM(RTRIM(AccountGroupCode)) As RefCd FROM import.Tb_AccountGroup
			--UNION -- Commented because user confirmed to use AccountGroup instead of AccountParentGroup
			--SELECT 'AccountParentGroup' As RefType,Description As RefDesc,LTRIM(RTRIM(ParentGroupCode)) As RefCd FROM import.Tb_ParentGroup
			UNION
			SELECT 'AccountType' As RefType,Description As RefDesc,LTRIM(RTRIM(ACCTTYPECD)) As RefCd FROM import.Tb_AccountType
			UNION
			SELECT 'AccountClass' As RefType,Description As RefDesc,LTRIM(RTRIM(ACCLASSCD)) As RefCd FROM import.Tb_AccountClass
			UNION
			SELECT 'CADEntityType1' As RefType,CADEntityType1Desc As RefDesc,LTRIM(RTRIM(CADEntityType1Cd)) As RefCd FROM import.Tb_CADEntityType1
			UNION
			SELECT 'CADEntityType2' As RefType,CADEntityType2Desc As RefDesc,LTRIM(RTRIM(CADEntityType2Cd)) As RefCd FROM import.Tb_CADEntityType2
			UNION
			SELECT 'AccountOfficer' As RefType,OFFICERNM As RefDesc,LTRIM(RTRIM(OFFICERCD)) As RefCd FROM import.Tb_Officer
			UNION
			SELECT 'AccountFinancier' As RefType,'HONG LEONG BANK BERHAD' As RefDesc,'HLB' As RefCd
			UNION
			SELECT 'AccountFinancier' As RefType,'ALLIANCE BANK' As RefDesc,'ALB' As RefCd
			UNION
			SELECT 'AccountFinancier' As RefType,'CIMB BANK' As RefDesc,'CIMB' As RefCd
			UNION
			SELECT 'CorrespondenceMethod' As RefType,DESCRIPTION As RefDesc,LTRIM(RTRIM(CORRMTHD)) As RefCd FROM import.Tb_CorrespondanceMethod
			UNION
			--SELECT 'Occupation' As RefType,'Not Applicable' As RefDesc,'NA' As RefCd
			--UNION
			--SELECT 'Occupation' As RefType,DESCRIPTION As RefDesc,LTRIM(RTRIM(OCCUPCD)) As RefCd FROM import.Tb_Occupation
			--UNION
			SELECT 'LegalStatus' As RefType,DESCRIPTION As RefDesc,LTRIM(RTRIM(LGLSTAT)) As RefCd FROM import.Tb_LegalStatus
			--UNION
			--SELECT 'AccountIntroducer' As RefType,INTRODCNM1 As RefDesc,LTRIM(RTRIM(INTRODCCD)) As RefCd FROM import.Tb_Introducer
			UNION
			SELECT 'AccountStatus' As RefType,'Active' As RefDesc,'A' As RefCd
			UNION
			SELECT 'AccountStatus' As RefType,'Closed' As RefDesc,'C' As RefCd
			UNION
			SELECT 'AccountStatus' As RefType,'Suspended' As RefDesc,'S' As RefCd
			UNION
			SELECT 'TradingAccountStatus' As RefType,'Active' As RefDesc,'A' As RefCd
			UNION
			SELECT 'TradingAccountStatus' As RefType,'Inactive' As RefDesc,'I' As RefCd
			UNION
			SELECT 'TradingAccountStatus' As RefType,'Suspend' As RefDesc,'S' As RefCd
			UNION
			SELECT 'TradingAccountStatus' As RefType,'Closed' As RefDesc,'C' As RefCd
			UNION
			SELECT 'CDSAccountStatus' As RefType,'Active' As RefDesc,'A' As RefCd
			UNION
			SELECT 'CDSAccountStatus' As RefType,'Inactive' As RefDesc,'I' As RefCd
			UNION
			SELECT 'CDSAccountStatus' As RefType,'Dormant' As RefDesc,'D' As RefCd
			UNION
			SELECT 'CDSAccountStatus' As RefType,'Closed' As RefDesc,'C' As RefCd
			UNION
			SELECT 'NomineeIndicator' As RefType,NOMDESC As RefDesc,LTRIM(RTRIM(NOMININD)) As RefCd FROM import.Tb_NomineeType WHERE NOMININD NOT IN ('Y','Z')
			UNION
			SELECT 'NomineeIndicator' As RefType,'NO' As RefDesc,'N' As RefCd 
			UNION
			SELECT 'RebateCode' As RefType,DESCRIPTN As RefDesc,LTRIM(RTRIM(REBATECD)) As RefCd FROM import.Tb_RebateRate
			UNION
			SELECT 'SettlementMode' As RefType,DESCRIPTION As RefDesc,LTRIM(RTRIM(SETTMODECD)) As RefCd FROM import.Tb_SettlementMode
			--UNION
			--SELECT 'BankCode' As RefType,BANKNAME As RefDesc,LTRIM(RTRIM(BANKCD)) As RefCd FROM import.Tb_Bank
			UNION
			SELECT 'CashBook' As RefType,DESCRIPTN As RefDesc,LTRIM(RTRIM(CASHBKID)) As RefCd FROM import.Tb_CashBook	
			UNION
			SELECT 'ApplicationStatus' As RefType,'Full' As RefDesc,'FLL' As RefCd
			UNION
			SELECT 'ApplicationStatus' As RefType,'No IC' As RefDesc,'NIC' As RefCd
			UNION
			SELECT 'ApplicationStatus' As RefType,'Old Form' As RefDesc,'OFM' As RefCd
			UNION
			SELECT 'ApplicationStatus' As RefType,'No Form' As RefDesc,'NO' As RefCd
			UNION
			SELECT 'ShortSellInd' As RefType,'Default to Next Level' As RefDesc,'' As RefCd
			UNION
			SELECT 'ShortSellInd' As RefType,'RSS & PDT not allowed' As RefDesc,'0' As RefCd
			UNION
			SELECT 'ShortSellInd' As RefType,'RSS allowed, PDT not allowed' As RefDesc,'1' As RefCd
			UNION
			SELECT 'ShortSellInd' As RefType,'RSS not allowed, PDT allowed' As RefDesc,'2' As RefCd
			UNION
			SELECT 'ShortSellInd' As RefType,'RSS & PDT allowed' As RefDesc,'3' As RefCd
			-- State
			UNION
			SELECT 'State' As RefType, StateName As RefDesc, LTRIM(RTRIM(StateValue)) As RefCd FROM import.Tb_State
			-- Delivery
			UNION
			SELECT 'DeliveryType' As RefType,'Post Mail' As RefDesc,'PostMail' As RefCd
			UNION
			SELECT 'DeliveryType' As RefType,'Email' As RefDesc,'Email' As RefCd
			UNION
			SELECT 'DeliveryType' As RefType,'Download from Portal' As RefDesc,'Portal' As RefCd
			UNION
			SELECT 'DeliveryType2' As RefType,'Email' As RefDesc,'Email' As RefCd
			UNION
			SELECT 'DeliveryType2' As RefType,'Post Mail' As RefDesc,'PostMail' As RefCd
			UNION
			SELECT 'DeliveryType2' As RefType,'Download from Portal' As RefDesc,'PostMail' As RefCd
			UNION
			SELECT 'Promo16' As RefType,'Yes' As RefDesc,'Y' As RefCd
			UNION
			SELECT 'Promo16' As RefType,'No' As RefDesc,'N' As RefCd
			-- Stock
			UNION
			SELECT 'MarketBoard' As RefType,[Description] As RefDesc,LTRIM(RTRIM(MarketBoardCode)) As RefCD FROM import.Tb_MarketBoard
			UNION
			SELECT 'MarketSector' As RefType, [Description] As RefDesc, LTRIM(RTRIM(MarketSectorCode)) As RefCd FROM import.Tb_MarketSector
			UNION
			SELECT 'ProductClass' As RefType, [Description] As RefDesc,LTRIM(RTRIM(ProductClassCode)) As RefCd from import.Tb_ProductClass
			--UNION 
			--SELECT 'ShareGrade' As RefType, [Description] As RefDesc, LTRIM(RTRIM(ShareGradeCode)) As RefCd FROM import.Tb_ShareGrade
			UNION 
			SELECT 'BasisCode' As RefType, [Description] As RefDesc, LTRIM(RTRIM(BasisCode)) As RefCd  FROM import.Tb_Basis
			UNION 
			SELECT 'IndexCode' As RefType, [Description] As RefDesc, LTRIM(RTRIM(MarketIndexCode)) As RefCd  FROM import.Tb_MarketIndex
			UNION 
			SELECT 'RegistrarCode' As RefType, REGISTRNM As RefDesc, LTRIM(RTRIM(REGISTRCD)) As RefCd  FROM import.Tb_Registrar
			UNION 
			SELECT 'ReducedBoardLot' As RefType, [Description] As RefDesc, LTRIM(RTRIM(ReducedBoardLotCode)) As RefCd  FROM import.Tb_ReducedBoardLot
			UNION 
			SELECT 'Reason' As RefType, [Description] As RefDesc, LTRIM(RTRIM(ReasonCd)) As RefCd  FROM import.Tb_Reason
			UNION
			SELECT 'SecuritiesType' As RefType,'Share' As RefDesc,'S' As RefCD
			UNION
			SELECT 'SecuritiesType' As RefType,'Bond' As RefDesc,'B' As RefCD
			UNION
			SELECT 'SecuritiesType' As RefType,'Treasury Bill' As RefDesc,'T' As RefCD
			UNION
			SELECT 'SecuritiesType' As RefType,'Warrant' As RefDesc,'W' As RefCD
			UNION
			SELECT 'SecuritiesType' As RefType,'Option' As RefDesc,'O' As RefCD
			UNION
			SELECT 'SecuritiesType' As RefType,'Future' As RefDesc,'F' As RefCD
			UNION
			SELECT 'BFEAcctType' as RefType, BFEAcctTypeDesc as RefDesc, LTRIM(RTRIM(BFEAcctTypeCode)) as RefCd FROM import.Tb_BFEAccountType
			UNION
			SELECT DISTINCT 'NomAcctName' as RefType, 
					CASE WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%ALLIANCEGROUP%' THEN 'ALLIANCEGROUP NOMINEES (TEMPATAN) SDN BHD'
						 WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%HLB %' THEN 'HLB NOMINEES (TEMPATAN) SDN BHD'
						 WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%KUMPULAN SENTIASA%' THEN 'KUMPULAN SENTIASA CEMERLANG SDN BHD'
						 WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%MALACCA EQUITY%' AND LTRIM(RTRIM(NomineesName1)) LIKE '%TEMP%' THEN 'MALACCA EQUITY NOMINEES (TEMPATAN) SDN BHD'
						 ELSE LTRIM(RTRIM(NomineesName1))
					END as RefDesc, 
					CASE WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%ALLIANCEGROUP%' THEN 'ALLIANCEGROUP NOMINEES (TEMPATAN) SDN BHD'
						 WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%HLB %' THEN 'HLB NOMINEES (TEMPATAN) SDN BHD'
						 WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%KUMPULAN SENTIASA%' THEN 'KUMPULAN SENTIASA CEMERLANG SDN BHD'
						 WHEN LTRIM(RTRIM(NomineesName1)) LIKE '%MALACCA EQUITY%' AND LTRIM(RTRIM(NomineesName1)) LIKE '%TEMP%' THEN 'MALACCA EQUITY NOMINEES (TEMPATAN) SDN BHD'
						 ELSE LTRIM(RTRIM(NomineesName1))
					END as RefCd
			FROM import.Tb_Account 
			WHERE NomineesName1 NOT IN ('','`','AS BENEFICIAL OWNER','CIMB BANK BERHAD','CIMB COMMERCE TRUSTEE BERHAD'
				,'CIMB COMMERCE TRUSTEE BERHAD FOR','CIMB GROUP NOMINEES (ASING) SDN BHD','CIMB GROUP NOMINEES (ASING) SDN BHD EXEMPT AN'
				,'CIMB GROUP NOMINEES (TEMPATAN) SDN BHD','CIMB GROUP NOMINEES (TEMPATAN) SDN BHD EXEMPT AN','CIMSEC NOMINEE (ASING) SDN BHD'
				,'CIMSEC NOMINEE (TEMPATAN) SDN BHD','CSL052K','GOH BOY HONG','LIM KIM HENG','SIOW KAH QUN')
			UNION
			SELECT 'DefaulterType' As RefType,'United Nation Security Council Resolution' As RefDesc,'UNSCR' As RefCD
			UNION
			SELECT 'DefaulterType' As RefType,'Political Exposed Persons' As RefDesc,'PEP' As RefCD
			UNION
			SELECT 'DefaulterType' As RefType,'Bursa Defaulter' As RefDesc,'BD' As RefCD
			UNION
			SELECT 'AlgoSystem' As RefType,'Elfstone' As RefDesc,'Elfstone' As RefCD
			UNION
			SELECT 'Region' As RefType,'Central' As RefDesc,'Central' As RefCD
			UNION
			SELECT 'Region' As RefType,'Northern' As RefDesc,'Northern' As RefCD
			UNION
			SELECT 'Region' As RefType,'Southern' As RefDesc,'Southern' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Pay by Remisier' As RefDesc,'PBR' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Pay by Client - Cash/Cheques (go into trust)' As RefDesc,'PBCC' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Pay by Client - Direct Bank in (go into trust)' As RefDesc,'PBCB' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Pay by Company' As RefDesc,'PBC' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Pay by FPX - eAccount Opening' As RefDesc,'PBF' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Pay through Bursa Anywhere' As RefDesc,'PTBA' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Promo - Waived by Bursa' As RefDesc,'PWB' As RefCD
			UNION
			SELECT 'PayType' As RefType,'Others' As RefDesc,'OT' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Broker' As RefDesc,'0' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Administrator' As RefDesc,'1' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Credit Control Manager' As RefDesc,'2' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Credit Control' As RefDesc,'3' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Dealer' As RefDesc,'4' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Order Entry Clerk' As RefDesc,'5' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Remisier' As RefDesc,'6' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Credit Control Officer' As RefDesc,'7' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Director' As RefDesc,'8' As RefCD
			UNION
			SELECT 'BFEUserType' As RefType,'Others' As RefDesc,'9' As RefCD
			UNION 
			SELECT 'BusinessNature' AS RefType, RTRIM(LTRIM(RefDesc)) RefDesc, RTRIM(LTRIM(RefCD)) RefCD FROM import.Tb_BusinessNature
			UNION 
			SELECT 'Occupation' AS RefType, RTRIM(LTRIM(RefDesc)), RTRIM(LTRIM(RefCD)) RefCD FROM import.Tb_Occupation_202107
			UNION 
			SELECT 'EmploymentStatus' AS RefType, 'Employed' AS RefDesc, 'Employed' AS RefCD 
            UNION
			SELECT 'EmploymentStatus' AS RefType, 'Housewife' AS RefDesc, 'Housewife' AS RefCD 
            UNION
			SELECT 'EmploymentStatus' AS RefType, 'Retired' AS RefDesc, 'Retired' AS RefCD 
            UNION
			SELECT 'EmploymentStatus' AS RefType, 'Self-employed' AS RefDesc, 'Self-employed' AS RefCD 
            UNION
			SELECT 'EmploymentStatus' AS RefType, 'Student' AS RefDesc, 'Student' AS RefCD 
            UNION
			SELECT 'EmploymentStatus' AS RefType, 'Unemployed' AS RefDesc, 'Unemployed' AS RefCD ;


			--Use CQBTempDB
			Exec CQBTempDB.form.[Usp_CreateImportTable] 1319
			--Select * from CQBTempDB.[import].[Tb_FormData_1319]

			TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1319;
			
			INSERT INTO CQBTempDB.[import].Tb_FormData_1319
			(
				[RecordID],
				[Action],
				[CodeType (selectbasic-1)],
				[CodeDisplay (textinput-2)],
				[Value (textinput-3)]
			)    
			SELECT 
				null as [RecordID],
				'I' as [Action],
				RefType,
				RefDesc,
				RefCD
			FROM import.Tb_CodeReference;

			--SELECT * FROM CQBTempDB.[import].Tb_FormData_1319
			--SELECT * FROM CQBTempDB.[export].Tb_FormData_1319 Where [CodeType (selectbasic-1)]<>'Occupation'

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