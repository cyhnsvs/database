/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX31]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [import].[Usp_99_Trades_FileToFormXX31]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 11/03/2022
Last Updated Date :             
Description       : import BTX EFSGSTOCKINFO    File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
         BEGIN TRANSACTION;
 		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX31;
 	    --TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX31;
 		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX31;
 SELECT [StockCode]
      ,[StockName]
      ,[StockChineseName]
      ,[MinQuantity]
      ,[CurrencyCode]
      ,[SecurityID]
      ,[SecurityCode]
      ,[Market]
      ,[ExchangeCode]
      ,[Symbol]
      ,[SymbolSuffix]
      ,[StartDate]
      ,[ExpiryDate]
      ,[CounterStatus]
      ,[SecurityType]
      ,[ISINCode]
      ,[PrimaryTradingCounter]
      ,[BoardCode]
      ,[SectorCode]
      ,[IssuedShares]
      ,[LastDonePrice]
      ,[StockShortName]
      ,[ReferencePrice]
  FROM [import].[tb_BTX_EFSGSTOCKINFO]
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