/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX01]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_99_TradeDone_FileToFormXX01]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 05/03/2022
Last Updated Date :             
Description       : import  N2N Trade Done File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX01;
		
	--	TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX01;

		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX01;
	 	SELECT [SequenceNumberOfRecord]
      ,[TransactionDate]
      ,[TradingAccount]
      ,[DealerID]
      ,[CDSNumber]
      ,[ExchangeCode]
      ,[StockCode]
      ,[Side]
      ,[Quantity]
      ,[Price]
      ,[ExchangeOrderNumber]
      ,[BranchID]
      ,[ExecutionReferenceID]
      ,[SubmittedBy]
  FROM [import].[Tb_N2N_TradeDone] 		  

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