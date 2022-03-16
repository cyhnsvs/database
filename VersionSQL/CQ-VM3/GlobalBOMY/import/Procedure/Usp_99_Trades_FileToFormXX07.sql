﻿/****** Object:  Procedure [import].[Usp_99_Trades_FileToFormXX07]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [import].[Usp_99_Trades_FileToFormXX07]
AS
/***********************************************************************             
            
Created By        : Ceyhun
Created Date      : 06/03/2022
Last Updated Date :             
Description       : import  CQ Outstanding Contracts File   File to GBO  
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		--Exec CQBTempDB.form.[Usp_CreateImportTable] XX07;
		
	--	TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_XX07;

		--INSERT INTO CQBTempDB.[import].Tb_FormData_XX07;
	SELECT [REMINo]
      ,[ClientNo]
      ,[ClientName]
      ,[NRIC]
      ,[SECCode]
      ,[SECName]
      ,[ContractNo]
      ,[RT]
      ,[CurrCode]
      ,[Price]
      ,[Quantity]
      ,[Proceeds]
      ,[NetAmt]
      ,[ConDate]
      ,[DueDate]
      ,[SpelCd]
      ,[BrokAmt]
      ,[BrokGST]
      ,[ClrFee]
      ,[ClrGST]
      ,[AfmFee]
      ,[AfmGST]
      ,[SettleExchRate]
      ,[FCNAmount]
      ,[AFAmt]
      ,[FFP]
      ,[SettleCurrCode]
      ,[ExchCode]
      ,[MarketCode]
      ,[CompanyCode]
      ,[ISINCode]
  FROM [import].[Tb_CQ_OutStandingContracts]
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