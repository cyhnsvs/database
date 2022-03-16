/****** Object:  Procedure [import].[Usp_2_Introducer_FileToForm1575]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_2_Introducer_FileToForm1575]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 22/06/2020
Last Updated Date :             
Description       : this sp is used to insert Introducer file into CQForm MR
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_2_Introducer_FileToForm1575];
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DEPENDENCY ON TIER GROUP MIGRATION FOR COMMMISSION SHARING SETUPS

		Exec CQBTempDB.form.[Usp_CreateImportTable] 1575;
		--Select * from CQBTempDB.[import].[Tb_FormData_1345]

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1575;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1575
			([RecordID], [Action], [Name (textinput-1)], [MRType (selectbasic-1)], [DealerCode (selectsource-1)], [RegistrationNo (textinput-2)], [MRCode (textinput-17)],
			 [RegistrationSince (dateinput-1)], [AnniversaryDate (dateinput-2)], [CPEPointsAccumulation (grid-4)], [CommissionAccountNo (textinput-3)], 
			 [Address1 (textinput-7)], [Address2 (textinput-8)], [IDType (selectsource-2)], [IDNo (textinput-5)], [AlternateIDType (selectsource-3)], 
			 [AlternateIDNo (textinput-6)], [Race (selectsource-4)], [BumiputraStatus (multipleradiosinline-1)], [Gender (multipleradiosinline-2)], 
			 [Address3 (textinput-9)], [Town (textinput-10)], [State (selectsource-6)], [State (textinput-18)], [Country (selectsource-7)], 
			 [PostCode (textinput-11)], [Phone (textinput-12)], [MobilePhone (textinput-13)], 
			 [WorkEmail (textinput-14)], [PersonalEmail (textinput-15)], [IncomeTaxNo (textinput-16)], [Status (selectsource-5)])    
		SELECT null as [RecordID],
				'I' as [Action],
				INTRODCNM1 as  [Name (textinput-1)],
				LEFT(INTRODCCD,2) as  [MRType (selectbasic-1)],     
				DEALERCD as  [DealerCode (selectsource-1)],     
				INTRODCCD as  [RegistrationNo (textinput-2)],     
				'A' + RIGHT(REPLICATE('0',3)+CAST(ROW_NUMBER() OVER (PARTITION BY LEFT(DTCREATED,4) ORDER BY DTCREATED) as varchar),3)+'/'+LEFT(DTCREATED,4) as [MRCode (textinput-17)],
				'' as  [RegistrationSince (dateinput-1)],     
				'' as  [AnniversaryDate (dateinput-2)],     
				'' as  [CPEPointsAccumulation (grid-4)],     
				'' as  [CommissionAccountNo (textinput-3)],     
				CORRADDR1 as  [Address1 (textinput-7)],     
				CORRADDR2 as  [Address2 (textinput-8)],     
				'' as  [IDType (selectsource-2)],     
				'' as  [IDNo (textinput-5)],     
				'' as  [AlternateIDType (selectsource-3)],     
				'' as  [AlternateIDNo (textinput-6)],     
				'' as  [Race (selectsource-4)],     
				'' as  [BumiputraStatus (multipleradiosinline-1)],     
				'' as  [Gender (multipleradiosinline-2)],     
				CORRADDR3 as  [Address3 (textinput-9)],     
				CORRADDR4 as  [Town (textinput-10)],
				'' AS [State (selectsource-6)],
				'' AS [State (textinput-18)],
				'MY' AS [Country (selectsource-7)],
				CORRPOSTCD as  [PostCode (textinput-11)],     
				PHONE as  [Phone (textinput-12)],     
				PHONE1 as  [AlternativePhone (textinput-13)],     
				'' as  [WorkEmail (textinput-14)],     
				INETMAIL as  [PersonalEmail (textinput-15)],     
				'' as  [IncomeTaxNo (textinput-16)],      
				'' as  [Status (selectsource-5)]
		FROM import.Tb_Introducer;

		UPDATE MR
		SET [MRIncentiveTierType (selectbasic-3)]='Fixed',
			[MRIncentiveRate (selectbasic-2)] = CAST(TierGroupId as varchar(20))+'-'+TierGroupCd
		FROM import.Tb_RemisierSharingMRSetup as R
		INNER JOIN CQBTempDB.[import].Tb_FormData_1575 AS MR
		ON MR.[RegistrationNo (textinput-2)] = R.[MR Code]
		--WHERE MR.[RegistrationNo (textinput-2)] is NULL
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS G
		ON G.TierCategory = 'AESharing' AND LEFT(R.[Incentive rate],2) = REPLACE(G.TierGroupCd,'MR-Flat-','');

		UPDATE MR
		SET FormDetails= JSON_MODIFY(
							JSON_MODIFY(
								JSON_MODIFY(
									JSON_MODIFY(FormDetails, '$[0].selectbasic3', 'Fixed')
								, '$[1].selectbasic3', 'Fixed')
							, '$[0].selectbasic2', CAST(TierGroupId as varchar(20))+'-'+TierGroupCd)
						 , '$[1].selectbasic2', TierGroupCd)
		FROM import.Tb_RemisierSharingMRSetup as R
		INNER JOIN CQBuilder.form.Tb_FormData_1575 AS MR
		ON MR.[textinput-2] = R.[MR Code]
		--WHERE MR.[RegistrationNo (textinput-2)] is NULL
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS G
		ON G.TierCategory = 'AESharing' 
			AND LEFT(R.[Incentive rate],2) = REPLACE(G.TierGroupCd,'MR-Flat-','');

		--select * from CQBuilder.form.Tb_FormData_1575
		--CPEPointsAccumulation (grid-4)
		--Directorship (grid-2)
		--Ownership (grid-3)

		--select * from CQBTempDB.[import].Tb_FormData_1575
		--select I.DEALERCD,*
		--from import.Tb_RemisierSharingMRSetup AS MR
		--FULL JOIN import.Tb_Introducer AS I
		--ON MR.[MR Code] = I.INTRODCCD

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