/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX27]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_99_Trades_FileToFormXX27]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 10/03/2022
Last Updated Date :             
Description       : import BTX PayTrans File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
         BEGIN TRANSACTION;
 		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX27;
 	    --TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX27;
 		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX27;

SELECT [RecordType]
      ,[ClientCode]
      ,[BranchCode]
      ,[TransactionType]
      ,[TransactionNo]
      ,[BankName]
      ,[BankBranch]
      ,[BankAccount]
      ,[PaymentMethodType]
      ,[TransactionAmount]
      ,[Currency]
      ,[ConvertToMYR]
      ,[Remarks]
      ,[DepositType]
      ,[DepositDate]
      ,[DepositTime]
      ,[ChequeNo]
      ,[ContractContraOthersNo]
      ,[TradeDate]
      ,[Quantity]
      ,[InterestAmountPaid]
      ,[PaymentByTrust]
      ,[PaymentByBank]
      ,[BankRefNo]
      ,[FPXtransactionId]
      ,[Filler]
  FROM [import].[tb_BTX_PayTrans]
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