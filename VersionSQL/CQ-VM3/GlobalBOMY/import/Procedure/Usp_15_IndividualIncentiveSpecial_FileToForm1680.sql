/****** Object:  Procedure [import].[Usp_15_IndividualIncentiveSpecial_FileToForm1680]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_15_IndividualIncentiveSpecial_FileToForm1680] 
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 12/01/2021
Last Updated Date :             
Description       : this sp is used to insert 
					
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_15_IndividualIncentiveSpecial_FileToForm1680] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DEPENDENCY ON TIER GROUP MIGRATION FOR COMMMISSION SHARING SETUPS

		EXEC CQBTempDB.form.[Usp_CreateImportTable] 1680;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1680;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1680 ([RecordID], [Action], [AccountNo (selectsourcemultiple-1)], 
			[SpecialRateTierType (selectbasic-3)], [SpecialRateforSharing (selectbasic-2)]) 
		SELECT
			null as [RecordID],
			'I' as [Action],
			A.NewAccountNo,
			'Fixed',
			''
		--select A.NewAccountNo
		FROM import.Tb_TradeCharge AS TC
		INNER JOIN import.Tb_AccountNoMapping AS A
			ON RTRIM(REPLACE(REPLACE(combination,'1001 000',''),' 0000','')) = A.OldAccountNo
		WHERE BrokerageCode ='G1' AND TradeChargesKey='ACCOUNT' AND A.NewAccountNo IS NOT NULL
		
		UPDATE I 
		SET [SpecialRateforSharing (selectbasic-2)] = CAST(TG.TierGroupId as varchar(20))+'-'+TierGroupCd
		FROM CQBTempDB.[import].Tb_FormData_1680 AS I, GlobalBO.setup.Tb_TierGroup AS TG
		INNER JOIN GlobalBO.setup.Tb_Tier AS T
			ON TG.TierGroupCd='Brokerage-Flat-50' AND T.TierGroupId=TG.TierGroupId;

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