/****** Object:  Procedure [import].[Usp_1_BranchRef_FileToForm1394_NOTUSED]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_1_BranchRef_FileToForm]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 12/05/2020
Last Updated Date :             
Description       : this sp is used to insert Branch Ref file data into CQForm Branch Reference
            
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
		--Exec form.[Usp_CreateImportTable] 1394
		--Select * from CQBTempDB.[import].[Tb_FormData_1394]

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1394;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1394
		(
			[RecordID],
			[Action],
			[BranchCode (textinput-1)],
			[BranchName (textinput-2)],
			[State (textinput-3)],
			[Region (textinput-4)],
			[BursaBranchCode (textinput-5)],
			[EOBranchGroup (textinput-6)]
		)    
		SELECT 
			null as [RecordID],
			'I' as [Action],
			SBranch,
			SBranchName,
			[State],
			Region,
			Group1 as BursaBranchCode,
			Group2 as EOBranchGroup
		FROM import.Tb_BranchRef;
		
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