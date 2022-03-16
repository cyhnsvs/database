/****** Object:  Procedure [import].[Usp_2_Dealer_FileToForm1377_1379]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_2_Dealer_FileToForm1377_1379]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 22/06/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Dealer Ref file data into CQForm Dealer
					Dealer file data into CQForm Dealer 
					Dealer Market file data into CQ Form Dealer Market
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
 Kristine				28/7/2021				Add import for Dealer Market Limit Maintenance Form

PARAMETERS
EXEC [import].[Usp_2_Dealer_FileToForm1377_1379]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
		
		--DEPENDENCY ON TIER GROUP MIGRATION FOR COMMMISSION SHARING SETUPS


        BEGIN TRANSACTION;
		-- To Create import table for Dealer Reference in CQTempDB
		--Use CQBTempDB
		--Exec form.[Usp_CreateImportTable] 1401
		--Select * from CQBTempDB.[import].[Tb_FormData_1401]

		--TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1401;

		--INSERT INTO CQBTempDB.[import].Tb_FormData_1401
		--(
		--	[RecordID],
		--	[Action],
		--	[DealerCode (textinput-1)],
		--	[Branch (textinput-2)]
		--) 
		--SELECT 
		--	null as [RecordID],
		--	'I' as [Action], 
		--	DealerCd,
		--	SBranch
		--FROM import.Tb_DealerRef;

		-- To Create import table for Dealer in CQTempDB
		--Use CQBTempDB
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1377;
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1379;
		--Select * from CQBTempDB.[import].[Tb_FormData_1377]

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1377;

		IF EXISTS (
			select DealerCd 
			FROM import.Tb_Dealer AS D
			LEFT JOIN import.Tb_DealerRef AS DR
			ON D.DealerCode = DR.DealerCd
			WHERE DealerCd IS NOT NULL
			group by DealerCd
			having count(1) > 1
		)
			RAISERROR('Dealer Ref file has duplicate values. Check import file',16,1);

		INSERT INTO CQBTempDB.[import].Tb_FormData_1377
		(
			[RecordID],
			[Action],
			[BranchID (selectsource-1)],
			--[DealerCodeBrokercodeDEALERINFO (textinput-1)],
			[DealerCode (textinput-35)],
			[Name (textinput-3)],
			[DealerType (selectsource-3)],
			[LicenseSince (dateinput-1)],
			[LicenseAnniversaryDate (dateinput-2)],
			[DealerGradeCode (selectsource-13)],
			[LicenseNumber (textinput-6)],
			[CPEPointsAccumulation (grid-5)],
			[CollateralAccountNo (textinput-7)],
			[CommissionAccountNo (textinput-8)],
			[Address1 (textinput-11)],
			[Address2 (textinput-14)],
			[IDNumberType (selectsource-2)],
			[IDNumber (textinput-9)],
			[AlternateIDnoType (selectsource-4)],
			[AlternateIDno (textinput-10)],
			[Race (selectsource-5)],
			[BumiputraStatus (multipleradiosinline-1)],
			[Sex (multipleradiosinline-2)],
			[Address3 (textinput-13)],
			[Town (textinput-12)],
			[State (selectsource-14)],
			[State (textinput-36)],
			[Country (selectsource-15)],
			[PostCode (textinput-15)],
			[Phone (textinput-16)],
			[MobilePhone (textinput-17)],
			[TelephoneExtension (textinput-18)],
			[Fax (textinput-19)],
			[WorkEmail (textinput-20)],
			[InitialDeposit (textinput-21)],
			--[TradingLimit (textinput-22)],
			[MultiplierMethod (selectsource-6)],
			[MultiplierMethodValue (textinput-23)],
			[DealerCommissionRate (textinput-24)],
			[DealerRolloverRate (textinput-25)],
			[AssociateDealerCode (textinput-30)],
			[BFEDealerCode (textinput-26)],
			--[IncomeSharingFeeCode (selectsource-8)],
			--[BrokerageSharingFeeCode (selectsource-9)],
			--[ServiceOfficer (textinput-31)],
			[TeamID (textinput-29)],
			[MainDealerCodeIndicator (multipleradiosinline-3)],
			[PersonalEmail (textinput-27)],
			[IncomeTaxNo (textinput-28)],
			[SCLevy (textinput-38)],
			[Status (selectsource-12)],
			[BFEUserType (selectsource-16)],
			[ShortSellInd (selectsource-17)],
			[Directorship (grid-3)],
			[Ownership (grid-4)],
			[DealerAccountNo (textinput-37)]
		)    
		SELECT 
			null as [RecordID],
			'I' as [Action],
			ISNULL(B.BranchID,'001') as  [BranchID (selectsource-1)],
			--DealerCdBrokerCd as  [DealerCodeBrokercodeDEALERINFO (textinput-1)],
			DealerCode as  [DealerCode (textinput-35)],
			[Name] as  [Name (textinput-3)],
			DealerType as  [DealerType (selectsource-3)],
			LicenseSince as  [LicenseSince (dateinput-1)],
			LicenseAnniversaryDate as  [LicenseAnniversaryDate (dateinput-2)],
			DealerGradeCode as  [DealerGradeCode (selectsource-13)],
			LicenseNo,
			'' as [CPEPointsAccumulation (grid-5)],
			CollateralAcctNo,
			CommisionAcctNo,
			Address1,
			Address2,
			IDNumberType,
			D.IDNumber,
			AlternaterIDNumberType,
			AlternateIDNumber,
			Race ,
			BumiputraStatus,
			Sex,
			Address3 ,
			Address4 ,
			CASE WHEN LEN(PostCode)=5 AND ISNUMERIC(PostCode)=1
				THEN CASE WHEN (PostCode>='40000' AND PostCode<='48300') OR (PostCode>='63000' AND PostCode<='68100') THEN 'SGR'
						  WHEN PostCode>='20000' AND PostCode<='24300' THEN 'TRG'
						  WHEN PostCode>='93000' AND PostCode<='98859' THEN 'SRK'
						  WHEN PostCode>='88000' AND PostCode<='91309' THEN 'SBH'
						  WHEN PostCode>='05000' AND PostCode<='09810' THEN 'KDH'
						  WHEN PostCode>='15000' AND PostCode<='18500' THEN 'KLT'
						  WHEN PostCode>='70000' AND PostCode<='73509' THEN 'NSL'
						  WHEN PostCode>='10000' AND PostCode<='14400' THEN 'PNG'
						  WHEN PostCode>='79000' AND PostCode<='86900' THEN 'JHR'
						  WHEN PostCode>='75000' AND PostCode<='78309' THEN 'MLC'
						  WHEN PostCode>='01000' AND PostCode<='02000' THEN 'PRL'
						  WHEN PostCode>='30000' AND PostCode<='36810' THEN 'PRK'
						  WHEN (PostCode>='25000' AND PostCode<='28800') OR (PostCode>='39000' AND PostCode<='39200')
								OR PostCode='49000' OR PostCode='69000'  OR (PostCode>='28000' AND PostCode<='28350')
									THEN 'PHG'  
						  WHEN (PostCode>='50000' AND PostCode<='60000') OR (PostCode>='62300' AND PostCode<='62988') THEN 'WPN' 
						  WHEN PostCode>='87000' AND PostCode<='87033' THEN 'LBN'
						  ELSE '' END
					ELSE '' END,
			'', 
			'MY',
			PostCode ,
			Phone ,
			AlternatePhone ,
			TelephoneExtn,
			Fax,
			WorkEmail,
			InitialDeposit,
			--TradingLimit,
			MultiplierMethod,
			MultplierMethodValue,
			DealerCommisionRate,
			DealerRollOverRate,
			AssociateDealerCode,
			BFEDealerCode,
			--IncomeSharingFeeCode,
			--BrokerageSharingFeeCode,
			--ServiceOfficer,
			TeamID,
			MainDealerCodeInd,
			PersonalEmail,
			IncomeTaxNo,
			'50',
			[Status],
			BFEUSRTYP,
			SHORTSELL,
			'' as [Directorship (grid-3)],
			'' as [Ownership (grid-4)],
			''
		FROM import.Tb_Dealer AS D
		LEFT JOIN import.Tb_DealerRef AS DR
			ON D.DealerCode = DR.DealerCd
		LEFT JOIN import.Tb_BranchMapping AS B
			ON DR.SBranch = B.SBranch
		LEFT JOIN import.Tb_Dealer_BFE_User AS BU
			ON D.BFEDealerCode = BU.BFEUSRID

		UPDATE D
		SET [DealerAccountNo (textinput-37)] = AcctNo
		FROM CQBTempDB.[import].[Tb_FormData_1377] AS D
		INNER JOIN (
			--SELECT [DealerCode (textinput-35)], [DealerType (selectsource-3)] + LEFT(B.[Region (selectsource-10)],1) + RIGHT('0000'+CAST(ROW_NUMBER() OVER (ORDER BY [DealerCode (textinput-35)]) as varchar(10)),4) + [BFEDealerCode (textinput-26)] AS AcctNo
			SELECT [DealerCode (textinput-35)], [DealerType (selectsource-3)] + RIGHT('0000'+CAST(ROW_NUMBER() OVER (ORDER BY [DealerCode (textinput-35)]) as varchar(10)),4) + [BFEDealerCode (textinput-26)] AS AcctNo
			FROM CQBTempDB.[import].[Tb_FormData_1377] AS D
			LEFT JOIN CQBTempDB.export.[Tb_FormData_1374] AS B
				ON D.[BranchID (selectsource-1)] = B.[BranchID (textinput-1)]) AS DB
		ON D.[DealerCode (textinput-35)] = DB.[DealerCode (textinput-35)];

		--INSERT INTO CQBTempDB.[import].[Tb_FormData_1377_grid5] --[CPEPointsAccumulation (grid-5)]
		--INSERT INTO CQBTempDB.[import].[Tb_FormData_1377_grid3] --[Directorship (grid-3)]
		--INSERT INTO CQBTempDB.[import].[Tb_FormData_1377_grid4] --[Ownership (grid-4)]

		INSERT INTO CQBTempDB.[import].[Tb_FormData_1377_grid6] --[FinancialDetails (grid-6)]
			([RecordID],[Action],[RowIndex],[ (Radio Button)],[Account Holder Name (TextBox)],[Account Number (TextBox)]
            ,[Bank (Dropdown)],[Joint Account (Dropdown)])
		SELECT D.IDD, D.Action, ROW_NUMBER() OVER (partition by [DealerCode (textinput-35)] order by SettlementBankAC DESC, SettlementACName DESC, BankCode DESC) As rowIndex, 
				'1', AM.SettlementACName, AM.SettlementBankAC, AM.BankCode, 'N'
		FROM CQBTempDB.[import].[Tb_FormData_1377] AS D
		INNER JOIN GlobalBOMY.import.Tb_AccountMarketInfo AS AM
			ON D.[DealerCode (textinput-35)] = LEFT(AM.AccountNo,4) AND AM.AccountNo LIKE '%COL';

		--select * from import.Tb_RemisierSharingSetup where [Kiosk Incentive TYPE]<>''
		-- To Create import table for Dealer Market in CQTempDB
		--Use CQBTempDB
		--Exec form.[Usp_CreateImportTable] 1379
		--Select * from CQBTempDB.[import].[Tb_FormData_1377] where [DealerAccountNo (textinput-37)]=''

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1379;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1379
		(
			[RecordID],
			[Action],
			[DealerCodeBranchID (selectsource-1)],
			[DealerCodeEAFID (textinput-1)],
			[DealerCode (selectsource-14)],
			[MarketCode (selectsource-15)],
			[ContraInd (selectbasic-1)],
			[ContraForIntraday (selectbasic-4)],
			[ContraOnTDaysDays (textinput-4)],
			[ContraOnTDaysWorkingCalendar (selectsource-3)],
			[ComputeServiceCharges (selectsource-4)],
			[ContraServiceChargesDayDifferenceBasedOn (selectsource-5)],
			[PurchaseDaysDays (textinput-5)],
			[PurchaseDaysWorkingCalendar (selectsource-6)],
			[SalesDaysDays (textinput-6)],
			[SalesDaysWorkingCalendar (selectsource-7)],
			[SetoffInd (selectsource-8)],
			[SetoffContraGainDebitAmount (selectsource-9)],
			[SetoffSalesPurchasesReport (selectsource-10)],
			[SetoffTrustDebitTransactions (selectsource-11)],
			[SetoffTrustContraLoss (selectsource-12)],
			[TransferCreditTransactiontoTrust (selectsource-13)]
		)    
		SELECT 
			null as [RecordID],
			'I' as [Action],
			DealerCdBranchID,
			DealerCdEAFID,
			DealerCode,
			CASE WHEN MarketCode = 'BMSB' THEN 'XKLS' ELSE MarketCode END AS MarketCode,
			CASE WHEN ContraInd = 'I' THEN 'N' ELSE ContraInd END AS ContraInd,
			CASE WHEN ContraInd = 'I' THEN 'Y' ELSE ContraInd END AS ContraForIntraday,
			ContraOnTDays,
			ContraOnTDaysType,
			ComputeServiceCharge,
			ContraServiceChargeDayDiff,
			PurchaseDays,
			PurchaseDaysType,
			SalesDays,
			SalesDaysType,
			SetOffInd,
			SetOffContraGainDebitAmt,
			SetOffSalesPurchaseReport,
			SetOffTrustDebitTransaction,
			SetOffTrustContraLoss,
			TransferCreditTransToTrust
		FROM import.Tb_DealerMarketInfo;
		
		-- UPDATE LIMIT INFO
		UPDATE DM
		SET
			[MaxBuyLimit (textinput-7)] = ISNULL(CASE WHEN L.MAXBUYLMT = '.00' THEN '0.00' ELSE L.MAXBUYLMT END,'0.00'),
			[MaxSellLimit (textinput-8)] = ISNULL(CASE WHEN L.MAXSELLLMT = '.00' THEN '0.00' ELSE L.MAXSELLLMT END,'0.00'),
			[MaxNetLimit (textinput-9)] = ISNULL(CASE WHEN L.MAXNETLIM = '.00' THEN '0.00' ELSE L.MAXNETLIM END,'0.00'),
			[ExceedLimit (textinput-10)] = '0.00',
			[TradingLimit (textinput-12)] = '0.00'
		FROM CQBTempDB.[import].Tb_FormData_1379 DM
		LEFT JOIN CQBTempDB.[import].Tb_FormData_1377 D
		ON DM.[DealerCode (selectsource-14)] = D.[DealerCode (textinput-35)]
		LEFT JOIN import.Tb_Limit_Dealer L 
		ON D.[BFEDealerCode (textinput-26)] = L.DLRBFEID AND DM.[DealerCode (selectsource-14)] = L.DEALERCD;

		UPDATE A
		SET A.[DealerName (textinput-14)] = B.[Name (textinput-3)]
		FROM CQBTempDB.[import].Tb_FormData_1379 as A
		INNER JOIN CQBTempDB.[import].Tb_FormData_1377 as B
		ON A.[DealerCode (selectsource-14)] = B.[DealerCode (textinput-35)];
		
		--Select * from CQBTempDB.[import].[Tb_FormData_1379]
		
		--select distinct [Individual performance incentive TYPE] FROM import.Tb_RemisierSharingSetup as R

		Exec CQBTempDB.form.[Usp_CreateImportTable] 2971;

		INSERT INTO CQBTempDB.import.Tb_FormData_2971
			([RecordID], [Action], [RemisierCode (textinput-1)], [IndividualIncentiveTierType (selectbasic-3)], [IndividualIncentiveRate (selectbasic-1)],    
			 [KioskIncentiveTierType (selectbasic-4)], [KioskIncentiveRate (selectbasic-2)], [AdditionalIncentiveForOtherBranch (grid-2)])    
		SELECT DISTINCT null as [RecordID],
				'I' as [Action],
				D.[BFEDealerCode (textinput-26)]  as  [RemisierCode (textinput-1)],
				--RIGHT(R.[Remisier Code key in EO],4) as  [RemisierCode (selectsource-16)],
				'' as  [IndividualIncentiveTierType (selectbasic-3)],     
				'' as  [IndividualIncentiveRate (selectbasic-1)],     
				'' as  [KioskIncentiveTierType (selectbasic-4)],     
				'' as  [KioskIncentiveRate (selectbasic-2)],     
				'' as  [AdditionalIncentiveForOtherBranch (grid-2)]
		FROM import.Tb_RemisierSharingSetup as R
		INNER JOIN CQBTempDB.import.Tb_FormData_1377 AS D
			ON RIGHT(R.[Remisier Code key in EO],4) = D.[DealerCode (textinput-35)]
		WHERE D.[BFEDealerCode (textinput-26)]<>'0';

		update D
		SET [IndividualIncentiveTierType (selectbasic-3)]='Fixed', 
			[IndividualIncentiveRate (selectbasic-1)] = CAST(TierGroupId as varchar(20))+'-'+TierGroupCd
		FROM CQBTempDB.import.Tb_FormData_2971 as D
		INNER JOIN CQBTempDB.import.Tb_FormData_1377 AS DR
			ON D.[RemisierCode (textinput-1)] = DR.[BFEDealerCode (textinput-26)]
		INNER JOIN import.Tb_RemisierSharingSetup as R
			ON DR.[DealerCode (textinput-35)] = RIGHT(R.[Remisier Code key in EO],4)
		--ON D.[RemisierCode (selectsource-16)] = RIGHT(R.[Remisier Code key in EO],4)
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS G
			ON G.TierCategory = 'AESharing' AND R.[Individual performance incentive TYPE] = LEFT(REPLACE(G.TierGroupCd,'Remisier-',''),1);
		
		update D
		SET [KioskIncentiveTierType (selectbasic-4)]='Fixed', 
			[KioskIncentiveRate (selectbasic-2)] = CAST(TierGroupId as varchar(20))+'-'+TierGroupCd
		FROM CQBTempDB.import.Tb_FormData_2971 as D
		INNER JOIN CQBTempDB.import.Tb_FormData_1377 AS DR
			ON D.[RemisierCode (textinput-1)] = DR.[BFEDealerCode (textinput-26)]
		INNER JOIN import.Tb_RemisierSharingSetup as R
			ON DR.[DealerCode (textinput-35)] = RIGHT(R.[Remisier Code key in EO],4) AND LTRIM(RTRIM([Kiosk Incentive TYPE]))<>'' AND [Individual performance incentive TYPE] <> '-'
		--INNER JOIN import.Tb_RemisierSharingSetup as R
		--ON D.[RemisierCode (textinput-1)] = RIGHT(R.[Remisier Code key in EO],4) AND [Kiosk Incentive TYPE]<>''
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS G
			ON G.TierCategory = 'AESharing' AND G.TierGroupCd LIKE 'Kiosk%' AND R.[Kiosk Incentive TYPE] = LEFT(REPLACE(G.TierGroupCd,'Kiosk-',''),1);
		--WHERE R.[Kiosk Incentive TYPE] IN ('A','C','D','E'); 
		
		--update D
		--SET [AdditionalIncentiveForOtherBranch (grid-2)] = (
		--		SELECT DISTINCT 
		--			1 as rowIndex,
		--			B.BranchID As seq1,
		--			CAST(G.TierGroupId as varchar(20))+'-'+G.TierGroupCd seq2
		--		FROM import.Tb_RemisierSharingSetup as R
		--		WHERE RIGHT(R.[Remisier Code key in EO],4) = D.[RemisierCode (selectsource-16)]
		--		FOR JSON PATH
		--	)
		--FROM CQBTempDB.import.Tb_FormData_2971 as D
		--INNER JOIN import.Tb_RemisierSharingSetup as R
		--ON D.[RemisierCode (selectsource-16)] = RIGHT(R.[Remisier Code key in EO],4) AND [Kiosk Incentive TYPE]<>''
		--INNER JOIN GlobalBO.setup.Tb_TierGroup AS G
		--ON G.TierCategory = 'AESharing' AND G.TierGroupCd LIKE 'Kiosk%' AND R.[Kiosk Incentive TYPE] = LEFT(REPLACE(G.TierGroupCd,'Kiosk-',''),1)
		--LEFT JOIN import.Tb_BranchMapping AS B
		--ON R.Branch = B.SBranch
		--WHERE R.[Kiosk Incentive TYPE] IN ('B'); 

		INSERT INTO CQBTempDB.[import].[Tb_FormData_2971_grid2] --[AdditionalIncentiveForOtherBranch (grid-2)]
           ([RecordID],[Action],[RowIndex],[Branch ID (Dropdown)],[Incentive Rate (Dropdown)])
		SELECT D.IDD, D.Action, 1 as rowIndex, B.BranchID, CAST(G.TierGroupId as varchar(20))+'-'+G.TierGroupCd seq2
		FROM CQBTempDB.import.Tb_FormData_2971 as D
		INNER JOIN CQBTempDB.import.Tb_FormData_1377 AS DR
			ON D.[RemisierCode (textinput-1)] = DR.[BFEDealerCode (textinput-26)]
		INNER JOIN import.Tb_RemisierSharingSetup as R
			ON DR.[DealerCode (textinput-35)] = RIGHT(R.[Remisier Code key in EO],4) AND [Kiosk Incentive TYPE]<>'' AND [Individual performance incentive TYPE]='-'
		--INNER JOIN import.Tb_RemisierSharingSetup as R
		--ON D.[RemisierCode (textinput-1)] = RIGHT(R.[Remisier Code key in EO],4) AND [Kiosk Incentive TYPE]<>''
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS G
			ON G.TierCategory = 'AESharing' AND G.TierGroupCd LIKE 'Kiosk%' AND R.[Kiosk Incentive TYPE] = LEFT(REPLACE(G.TierGroupCd,'Kiosk-',''),1)
		LEFT JOIN import.Tb_BranchMapping AS B
			ON R.Branch = B.SBranch
		WHERE R.[Kiosk Incentive TYPE] IN ('B'); 

		--select * from CQBTempDB.import.Tb_FormData_2971
		--select * from CQBTempDB.import.Tb_FormData_2971_grid2

		Exec CQBTempDB.form.[Usp_CreateImportTable] 3676;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3676;

		INSERT INTO CQBTempDB.[import].Tb_FormData_3676 ([RecordID], [Action], 
			 [DealerCode (selectsource-1)],
			 [MarketCode (selectsource-2)],
			 [DealerName (textinput-2)],
			 [MaxBuyLimit (textinput-4)],
			 [MaxSellLimit (textinput-5)],
			 [MaxNetLimit (textinput-6)],
			 [TradingLimit (textinput-7)],
			 [MultiplierMethod (selectsource-3)],
			 [MultiplierMethodValue (textinput-9)]) 
		SELECT null as [RecordID],'I' as [Action],
			 dMarket.[DealerCode (selectsource-14)] [DealerCode (selectsource-1)]
			,dMarket.[MarketCode (selectsource-15)] [MarketCode (selectsource-2)]
			,dealer.[Name (textinput-3)] [DealerName (textinput-2)]
			,dMarket.[MaxBuyLimit (textinput-7)] [MaxBuyLimit (textinput-4)]
			,dMarket.[MaxSellLimit (textinput-8)] [MaxSellLimit (textinput-5)]
			,dMarket.[MaxNetLimit (textinput-9)] [MaxNetLimit (textinput-6)]
			,dMarket.[TradingLimit (textinput-12)] [TradingLimit (textinput-7)]
			,dealer.[MultiplierMethod (selectsource-6)] [MultiplierMethod (selectsource-3)]
			,dealer.[MultiplierMethodValue (textinput-23)] [MultiplierMethodValue (textinput-9)]
		FROM CQBTempDB.[import].Tb_FormData_1379 dMarket
		INNER JOIN CQBTempDB.[import].Tb_FormData_1377 dealer
			ON dealer.[DealerCode (textinput-35)] = dMarket.[DealerCode (selectsource-14)];


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

        RAISERROR 
		(
			@ostrReturnMessage
			,@intErrorSeverity
			,@intErrorState
		);

    END CATCH
    
    SET NOCOUNT OFF;
END