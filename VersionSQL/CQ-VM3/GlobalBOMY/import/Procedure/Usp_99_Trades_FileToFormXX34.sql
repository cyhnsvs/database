/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX34]    Committed by VersionSQL https://www.versionsql.com ******/

create  PROCEDURE [import].[Usp_99_Trades_FileToFormXX34]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 11/03/2022
Last Updated Date :             
Description       : import BTX TRADEDONE      File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
         BEGIN TRANSACTION;
 		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX34;
 	    --TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX343;
 		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX34;
		SELECT [OrderNo]
      ,[RefNo]
      ,[OrderID]
      ,[Status]
      ,[OrderStatus]
      ,[AccountNo]
      ,[CompanyCode]
      ,[Side]
      ,[OrderTime]
      ,[Price]
      ,[OrderQty]
      ,[ExecutedQty]
      ,[ExecutedPrice]
      ,[Market]
      ,[RemisierCode]
      ,[Symbol]
      ,[SymbolSfx]
      ,[ExecutedTime]
      ,[CustomerRef]
      ,[TradedCurr]
      ,[SettlementCurr]
      ,[ExchangeRate]
      ,[ClientSettCurr]
      ,[Originator]
      ,[OriginatorUT]
      ,[LastModified]
      ,[LastModifiedUT]
      ,[InverseExchangeRate]
      ,[ExchangeCode]
		FROM [import].[tb_BTX_TRADEDONE]
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