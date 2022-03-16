/****** Object:  Procedure [import].[Usp_20_ReasonCode_ToForm3974]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_20_ReasonCode_ToForm3974] 
AS
/*********************************************************************************** 

Name              : import.[Usp_20_ReasonCode_ToForm3974]
Created By        : Nathiya
Created Date      : 02/09/2021
Last Updated Date : 
Description       : this sp is used to import the Reason Code to Reason code form
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_20_ReasonCode_ToForm3974] 

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 3974

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3974;
				
		INSERT INTO CQBTempDB.[import].Tb_FormData_3974
			([RecordID], [Action], [ReasonCode (textinput-1)], [ReasonDescription (textinput-2)], [ExcludefromAutoSuspension (multiplecheckboxesinline-2)])    
		SELECT null as [RecordID],
			   'I' as [Action],
			   ReasonCd,
			   [Description],
			   0
		FROM 
			GlobalBOMY.import.Tb_Reason

		-- UPDATE Exclude from Auto Suspension
		UPDATE	F
		SET		[ExcludefromAutoSuspension (multiplecheckboxesinline-2)] = 1
		FROM	CQBTempDB.import.Tb_FormData_3974 F
		WHERE	[ReasonCode (textinput-1)] IN ('BD','CTOS','DC','DCA','CLO','MS','MR','M2','M3','M4','RAMC','RS','SLM');
		
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