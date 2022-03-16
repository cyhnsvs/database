/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX11]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [import].[Usp_99_Trades_FileToFormXX11]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 06/03/2022
Last Updated Date :             
Description       : import  CQ Stock Info JP   File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
         BEGIN TRANSACTION;
 		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX11;
 	    --TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX11;
 		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX11;
		SELECT [CompanyCode]
			,[CompanyName]
			,[ChineseName]
			,[MinQty]
			,[CurrencyCode]
			,[SecurityID]
			,[SecurityCode]
			,[Market]
			,[Exchange]
			,[Symbol]
			,[Symbolsfx]
			,[StartDate]
			,[ExpiryDate]
			,[CounterStatus]
			,[SecurityType]
			,[ISINCode]
			,[PrimaryTradingCounter]
		FROM [import].[Tb_CQ_StockInfoJP]
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