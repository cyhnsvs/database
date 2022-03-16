/****** Object:  Procedure [import].[Usp_10_DealerEffortSharing_FileToForm1710_20200928]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_10_DealerEffortSharing_FileToForm1710_20200928] 
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
EXEC [import].[Usp_10_DealerEffortSharing_FileToForm1710_20200928] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;

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

		--INSERT INTO CQBTempDB.[import].Tb_FormData_1710
		--	([RecordID], 
		--	 [Action],     
		--	 [Region (selectsource-2)],    
		--	 [BranchID (selectsource-1)],    
		--	 [TeamLeader (selectbasic-1)],    
		--	 [AnnualBudget (textinput-2)],    
		--	 [Salary (textinput-3)],    
		--	 [Factor (textinput-4)],    
		--	 [TierType (selectbasic-2)],    
		--	 [IncentiveRate (selectbasic-3)],    
		--	 [IncentiveContributors (selectsourcemultiple-1)],    
		--	 [EffortSharing (grid-1)])    
		SELECT 
			null as [RecordID], 'I' as [Action], '' as  [Region (selectsource-2)], '013' as  [BranchID (selectsource-1)], '' as  [TeamLeader (selectbasic-1)],     
			'542000' as  [AnnualBudget (textinput-2)], '' as  [Salary (textinput-3)], '' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
			'212-Dealer-IP-Tiered' as  [IncentiveRate (selectbasic-3)], '' as  [IncentiveContributors (selectsourcemultiple-1)], '' as  [EffortSharing (grid-1)] 
		UNION ALL
		SELECT 
			null as [RecordID], 'I' as [Action], '' as  [Region (selectsource-2)], '005' as  [BranchID (selectsource-1)], '' as  [TeamLeader (selectbasic-1)],     
			'890000' as  [AnnualBudget (textinput-2)], '' as  [Salary (textinput-3)], '' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
			'213-Dealer-JB-Tiered' as  [IncentiveRate (selectbasic-3)], '' as  [IncentiveContributors (selectsourcemultiple-1)], '' as  [EffortSharing (grid-1)] --UNION ALL
		--SELECT 
		--	null as [RecordID], 'I' as [Action], '' as  [Region (selectsource-2)], '005' as  [BranchID (selectsource-1)], '' as  [TeamLeader (selectbasic-1)],     
		--	'960000' as  [AnnualBudget (textinput-2)], '' as  [Salary (textinput-3)], '' as  [Factor (textinput-4)], 'Sliding' as  [TierType (selectbasic-2)],     
		--	'213-Dealer-JB-Tiered' as  [IncentiveRate (selectbasic-3)], '' as  [IncentiveContributors (selectsourcemultiple-1)], '' as  [EffortSharing (grid-1)] UNION ALL
		
		select * from CQBTempDB.[import].Tb_FormData_1710;

		select * from CQBTempDB.[import].Tb_FormData_1374;
		--select * from CQBTempDB.[import].Tb_FormData_1377 where [DealerCode (selectsource-14)] = 'D037'
		select * from GlobalBO.setup.Tb_TierGroup where TierCategory='aesharing';

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
		ON TG.TierGroupCd='Margin-Flat-1';

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