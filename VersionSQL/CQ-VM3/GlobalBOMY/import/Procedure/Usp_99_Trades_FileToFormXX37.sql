/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX37]    Committed by VersionSQL https://www.versionsql.com ******/

create  PROCEDURE [import].[Usp_99_Trades_FileToFormXX37]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 11/03/2022
Last Updated Date :             
Description       : import BTX ONLINETRADE  File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
         BEGIN TRANSACTION;
 		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX37;
 	    --TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX37;
 		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX37;
		    SELECT [TransactionDate]
      ,[ClientCode]
      ,[StockCode]
      ,[OrderType]
      ,[Price]
      ,[SequenceNo]
      ,[TerminalID]
      ,[MatchedQuantity]
      ,[BranchCode]
      ,[OrderSource]
  FROM [import].[tb_BTX_ONLINETRADE]
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