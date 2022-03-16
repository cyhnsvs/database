/****** Object:  Procedure [import].[Usp_19_DebitNonTradeTransTypePriority_FileToForm3382]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_19_DebitNonTradeTransTypePriority_FileToForm3382]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 21/06/2021
Last Updated Date :             
Description       : this sp is used to insert 
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_19_DebitNonTradeTransTypePriority_FileToForm3382]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		Exec CQBTempDB.form.[Usp_CreateImportTable] 3382;
		
		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3382;

		INSERT INTO CQBTempDB.[import].Tb_FormData_3382
			([RecordID], [Action], [AccountGroupCode (selectsource-1)], [TransactionType (selectsource-2)], [Priority (textinput-1)]) 
		SELECT null as [RecordID],
				'I' as [Action],
				 AccountGroupCode as  [AccountGroupCode (selectsource-1)], 
				 CASE WHEN TransactionCode = 'JN' THEN 'ANY' ELSE TransactionCode END as  [TransactionType (selectsource-2)], 
				 Sequence as  [Priority (textinput-1)]
		FROM import.Tb_SetoffAcGroupTransType
		WHERE TransactionCode NOT IN ('CR','TS');

		 UPDATE CQBTempDB.[import].Tb_FormData_3382
		 SET [TransactionType (selectsource-2)]=REPLACE([TransactionType (selectsource-2)], 'CT', 'CHLS');
		 
		 UPDATE CQBTempDB.[import].Tb_FormData_3382
		 SET [TransactionType (selectsource-2)]=REPLACE([TransactionType (selectsource-2)], 'TP', 'TRBUY');
		 
		 UPDATE CQBTempDB.[import].Tb_FormData_3382
		 SET [TransactionType (selectsource-2)]=REPLACE([TransactionType (selectsource-2)], 'DR', 'CHDN');

		 UPDATE CQBTempDB.[import].Tb_FormData_3382
		 SET [TransactionType (selectsource-2)]=REPLACE([TransactionType (selectsource-2)], 'CS', 'SCHLS');

		 SELECT * FROM CQBTempDB.[import].Tb_FormData_3382 ORDER BY [AccountGroupCode (selectsource-1)], [Priority (textinput-1)];

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