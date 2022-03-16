/****** Object:  Procedure [import].[Usp_14_Exchange_FileToForm3054]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_14_Exchange_FileToForm3054] 
AS
/***********************************************************************             
            
Created By        : Nathiya
Created Date      : 04/12/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Stock Exchange List file data into CQForm
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_14_Exchange_FileToForm3054] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		EXEC CQBTempDB.form.[Usp_CreateImportTable] 3054;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3054;

		INSERT INTO CQBTempDB.[import].Tb_FormData_3054
		(
			 RecordID
			,Action
			,[ExchangeCode (selectsource-1)]
		)    
		SELECT
			null as [RecordID],
			'I' as [Action],
			ExchCd
		FROM GlobalBO.setup.Tb_Exchange;

		-- UPDATE Limit Info From Sample File
		UPDATE 
			 CQBTempDB.[import].Tb_FormData_3054
		SET		
			 [MaxBuyLimit (textinput-1)] = 0
			,[MaxSellLimit (textinput-2)] = 0
			,[MaxNetLimit (textinput-3)] = 0
			,[MaxTotalLimit (textinput-4)] = 0

		UPDATE 
			 CQBTempDB.[import].Tb_FormData_3054
		SET		
			 [WithLimit (multipleradiosinline-1)] = 1
			,[MaxBuyLimit (textinput-1)] = 12000000000
			,[MaxSellLimit (textinput-2)] = 15000000000
			,[MaxNetLimit (textinput-3)] = 6000000000
			,[MaxTotalLimit (textinput-4)] = 0
			,[BuyTopUp (textinput-5)] = 0
			,[SellTopUp (textinput-6)] = 0
			,[NetTopUp (textinput-7)] = 0
			,[TotalTopUp (textinput-8)] = 0
		WHERE
			 [ExchangeCode (selectsource-1)] = 'XKLS';
			

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