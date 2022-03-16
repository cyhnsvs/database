/****** Object:  Procedure [import].[Usp_6_AccountTypeList_FileToForm1457]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_6_AccountTypeList_FileToForm1457] 
AS
/***********************************************************************             
            
Created By        : Fadlin
Created Date      : 03/07/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Account Type List file data into CQForm Dealer
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_6_AccountTypeList_FileToForm1457] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1457;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1457;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1457
		(
			[RecordID],
			[Action],
			[2DigitCode (textinput-1)],
			[Description (textinput-2)],
			[CharCode (textinput-3)],
			[AlgoSystem (selectsource-1)],
			[ExternalMarginFinancier (selectsource-2)],
			[NomineesInd (selectbasic-2)]
		)    
		SELECT 
			null as [RecordID],
			'I' as [Action],
			DigitCode,
			[Description],
			CharCode,
			AlgoSystem,
			ExternalMarginFinancier,
			NomineesInd
		FROM import.Tb_AccountTypeList2;

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