/****** Object:  Procedure [import].[Usp_11_RiskProfileRating_FileToForm1425]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_11_RiskProfileRating_FileToForm1425] 
AS
/***********************************************************************             
            
Created By        : Fadlin
Created Date      : 01/09/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Risk Profile Rating file data into CQForm
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_11_RiskProfileRating_FileToForm1425] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		EXEC CQBTempDB.form.Usp_CreateImportTable 1425;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1425;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1425
		(
			[RecordID],
			[Action],
			[RiskProfileType (selectbasic-1)],
			[RiskValue (textinput-2)],
			[RiskScoring (textinput-3)]
		)    
		SELECT
			null as [RecordID],
			'I' as [Action],
			ProfileType,
			RiskValue,
			RiskScore
		FROM import.Tb_RiskProfileRating;

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