/****** Object:  Procedure [import].[Usp_99_ccTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [import].[Usp_99_ccTemplate]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 05/03/2022
Last Updated Date :             
Description       : this sp is used to insert 
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
[import].[Usp_99_ccTemplate]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] 3380;
		
		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_xx01;

		--INSERT INTO CQBTempDB.[import].Tb_FormData_xx01;
	 
		SELECT *
			 
		 FROM import.Tb_AccountGroup_SettlementDay
 		  

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

 

        RAISERROR 
		(
			@ostrReturnMessage
			,@intErrorSeverity
			,@intErrorState
		);

    END CATCH
    
    SET NOCOUNT OFF;
END