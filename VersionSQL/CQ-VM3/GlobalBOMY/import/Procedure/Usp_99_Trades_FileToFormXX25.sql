/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX25]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [import].[Usp_99_Trades_FileToFormXX25]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 10/03/2022
Last Updated Date :             
Description       : import SAP Remisier Expenses MRE File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
         BEGIN TRANSACTION;
 		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX25;
 	    --TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX25;
 		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX25;
		 
SELECT [RecordType]
      ,[CompanyCode]
      ,[BranchID]
      ,[TraderNo]
      ,[DocumentNumber]
      ,[GLAccount]
      ,[CostCenter]
      ,[ProfitCenter]
      ,[InternalOrder]
      ,[AmountDebit]
      ,[AmountCredit]
      ,[ItemText]
      ,[PostingDate]
      ,[ValueDate]
      ,[LongText]
      ,[RunningNumber]
  FROM [import].[Tb_SAP_RemisierExpensesMRE]
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