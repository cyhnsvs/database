/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX29]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [import].[Usp_99_Trades_FileToFormXX29]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 11/03/2022
Last Updated Date :             
Description       : import BTX BMStockStatus  File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
         BEGIN TRANSACTION;
 		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX29;
 	    --TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX29;
 		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX29;
 SELECT [StockCode]
      ,[SyariahStockIndicator]
      ,[StockIndexCode]
      ,[ShortSellIndicator]
      ,[StockStatus]
      ,[BoardCode]
      ,[SectorCode]
      ,[MarketCode]
      ,[ParentStockNo]
      ,[SecurityType]
      ,[IssuedShares]
      ,[ISIN]
      ,[SecurityCurrency]
      ,[LastDonePrice]
      ,[ListingDate]
      ,[ExpiryDate]
      ,[PN17GN3Indicator]
      ,[BoardLotSize]
      ,[StockName]
      ,[StockShortName]
      ,[ReferencePrice]
  FROM [import].[tb_BTX_BMStockStatus]
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