/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX03]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [import].[Usp_99_Trades_FileToFormXX03]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 05/03/2022
Last Updated Date :             
Description       : import  Finevo Trade   File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX03;
		
	--	TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX03;

		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX03;
	 SELECT [CTR_Date]
      ,[CDSNo]
      ,[StockCode]
      ,[BuySell]
      ,[Price]
      ,[OrderNo]
      ,[TerminalId]
      ,[Qty]
      ,[ClientRef]
      ,[Ack]
      ,[Memo]
      ,[PrevOrderNo]
  FROM [import].[Tb_FIN_Trades]	  

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