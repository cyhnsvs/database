/****** Object:  Procedure [import].[Usp_9_DealerEffortSharing_FileToForm1710]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_9_DealerEffortSharing_FileToForm1710] 
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 15/09/2020
Last Updated Date :             
Description       : this sp is used to insert 
					effort sharing file data into CQForm
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_9_DealerEffortSharing_FileToForm1710] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DEPENDENCY ON TIER GROUP MIGRATION FOR COMMMISSION SHARING SETUPS

		--IF OBJECT_ID('tempdb..#FinancialDetail') IS NOT NULL DROP TABLE #EffortSharing;

		--CREATE TABLE #EffortSharing ( 
		--	RowIndex BIGINT, 
		--	[Branch Region] Varchar(50), 
		--	[Dealer Name] Varchar(200), 
		--	DealerCode Varchar(50), 
		--	[Quarter] Varchar(50),
		--	[Percentage Sharing] Varchar(50)
		--);

		--INSERT INTO #EffortSharing
		--SELECT 
		--	ROW_NUMBER() over (partition by [Branch Region] order by D.DealerCode) As rowIndex,
		--	R.[Branch Region],
		--	R.[Dealer Name],
		--	D.DealerCode,
		--	R.[Quarter],
		--	R.[Percentage Sharing]
		--FROM [import].Tb_RemisierDealerSharingSetup as R
		--LEFT JOIN import.Tb_Dealer as D
		--ON R.[Dealer Name] = D.Name

		Exec CQBTempDB.form.[Usp_CreateImportTable] 1710;
		
		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1710;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1710
			([RecordID], 
			 [Action],     
			 [TeamGroupName (textinput-5)],
			 [TeamLeader (selectsource-3)],
			 [AnnualBudget (textinput-2)],    
			 [Salary (textinput-3)],    
			 [Factor (textinput-4)],    
			 [TierType (selectbasic-2)],    
			 [IncentiveRate (selectbasic-3)],    
			 [IncentiveContributors (selectsourcemultiple-2)])
		SELECT null as [RecordID], 'I' as [Action], 'Ipoh' as  [TeamGroupName (textinput-5)], '' as  [TeamLeader (selectsource-3)],     
			'542000' as  [AnnualBudget (textinput-2)], '18140' as  [Salary (textinput-3)], '2.0' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
			(SELECT CAST(TierGroupId as varchar(20))+'-'+TierGroupCd FROM GlobalBO.setup.Tb_TierGroup where TierGroupCd='Dealer-IP-Tiered') as  [IncentiveRate (selectbasic-3)], 
			'D500,D501,D502' as  [IncentiveContributors (selectsourcemultiple-1)] 
		UNION ALL
		SELECT null as [RecordID], 'I' as [Action], 'Johor Bahru' as  [TeamGroupName (textinput-5)], '' as  [TeamLeader (selectsource-3)],     
			'890000' as  [AnnualBudget (textinput-2)], '19190' as  [Salary (textinput-3)], '2.5' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
			(SELECT CAST(TierGroupId as varchar(20))+'-'+TierGroupCd FROM GlobalBO.setup.Tb_TierGroup where TierGroupCd='Dealer-JB-Tiered') as  [IncentiveRate (selectbasic-3)],
			'D700,D701,D702,D710,D723' as  [IncentiveContributors (selectsourcemultiple-1)] 
		UNION ALL
		SELECT null as [RecordID], 'I' as [Action], 'Klang Valley' as  [TeamGroupName (textinput-5)], '' as  [TeamLeader (selectsource-3)],     
			'4740000' as  [AnnualBudget (textinput-2)], '43570' as  [Salary (textinput-3)], '3.0' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
			(SELECT CAST(TierGroupId as varchar(20))+'-'+TierGroupCd FROM GlobalBO.setup.Tb_TierGroup where TierGroupCd='Dealer-KV-Tiered') as  [IncentiveRate (selectbasic-3)],
			'D200,D201,D220,D221,D260,D300,D312,D314,D316,D350' as  [IncentiveContributors (selectsourcemultiple-1)] 
		UNION ALL
		SELECT null as [RecordID], 'I' as [Action], 'Melaka' as  [TeamGroupName (textinput-5)], '' as  [TeamLeader (selectsource-3)],     
			'960000' as  [AnnualBudget (textinput-2)], '17830' as  [Salary (textinput-3)], '2.5' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
			(SELECT CAST(TierGroupId as varchar(20))+'-'+TierGroupCd FROM GlobalBO.setup.Tb_TierGroup where TierGroupCd='Dealer-MK-Tiered') as  [IncentiveRate (selectbasic-3)],
			'D036,D037,D092,D100,D102,D103' as  [IncentiveContributors (selectsourcemultiple-1)]
		UNION ALL
		SELECT null as [RecordID], 'I' as [Action], 'Melaka Mazdee' as  [TeamGroupName (textinput-5)], '' as  [TeamLeader (selectsource-3)],     
			'180000' as  [AnnualBudget (textinput-2)], '14120' as  [Salary (textinput-3)], '2.0' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],    
			(SELECT CAST(TierGroupId as varchar(20))+'-'+TierGroupCd FROM GlobalBO.setup.Tb_TierGroup where TierGroupCd='Dealer-MK-Mazdee-Tiered') as  [IncentiveRate (selectbasic-3)],
			'D066,D090,D091,D096' as  [IncentiveContributors (selectsourcemultiple-1)]
		UNION ALL
		SELECT null as [RecordID], 'I' as [Action], 'Penang' as  [TeamGroupName (textinput-5)], '' as  [TeamLeader (selectsource-3)],     
			'720000' as  [AnnualBudget (textinput-2)], '20920' as  [Salary (textinput-3)], '2.0' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
			(SELECT CAST(TierGroupId as varchar(20))+'-'+TierGroupCd FROM GlobalBO.setup.Tb_TierGroup where TierGroupCd='Dealer-PG-Tiered') as  [IncentiveRate (selectbasic-3)],
			'D800,D810,D813,D815' as  [IncentiveContributors (selectsourcemultiple-1)]

		--select * from CQBTempDB.[import].Tb_FormData_1710
		
		--select * from import.Tb_RemisierDealerSharingSetup
		--select * from import.Tb_RemisierSharingMarginSetup

		--select * from CQBTempDB.[import].Tb_FormData_1377 where [DealerCode (selectsource-14)] = 'D037'
		--select * from GlobalBO.setup.Tb_TierGroup where TierCategory='aesharing'

		Exec CQBTempDB.form.[Usp_CreateImportTable] 1740;
		
		INSERT INTO CQBTempDB.[import].Tb_FormData_1740
			([RecordID], [Action], [DealerCode (selectsource-1)], [AccountNumber (selectbasic-2)], [IncentiveTierRate (selectbasic-1)])    
		SELECT null as [RecordID],'I' as [Action],
			[Remisier Code] as  [DealerCode (selectsource-1)],     
			AM.NewAccountNo as [AccountNumber (selectbasic-2)],     
			CAST(TierGroupId as varchar(20))+'-'+TierGroupCd as  [IncentiveTierRate (selectbasic-1)]
		FROM import.Tb_RemisierSharingMarginSetup AS RS
		INNER JOIN import.Tb_AccountNoMapping AS AM
		ON RS.[Client Code] = AM.OldAccountNo
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS TG
		ON TG.TierGroupCd='Margin-Flat-1'
		WHERE AM.AccountStatus <> 'C';
		
		--select * from CQBTempDB.[export].Tb_FormData_1740

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