/****** Object:  Procedure [import].[Usp_21_ReferenceCode_ToForm1481]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_21_ReferenceCode_ToForm1481] 
AS
/*********************************************************************************** 

Name              : import.[Usp_21_ReferenceCode_ToForm1481]
Created By        : Nishanth
Created Date      : 27/10/2021
Last Updated Date : 
Description       : this sp is used to import the Ref Code to Ref code form
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_21_ReferenceCode_ToForm1481] 

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1481

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1481;
				
		INSERT INTO CQBTempDB.[import].Tb_FormData_1481
			([RecordID], [Action], [Name (textinput-1)], [Event (textinput-2)], [BranchCode (selectsource-1)]) 
		SELECT DISTINCT null as [RecordID],
			   'I' as [Action],
			   AuthorisedRepresentive,
			   AuthorisedRepresentive,
			   ''
		FROM GlobalBOMY.import.Tb_Account
		WHERE AuthorisedRepresentive <> '';

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