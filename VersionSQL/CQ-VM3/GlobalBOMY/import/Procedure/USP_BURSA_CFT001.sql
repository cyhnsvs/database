/****** Object:  Procedure [import].[USP_BURSA_CFT001]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[USP_BURSA_CFT001]
	
	
AS
/*********************************************************************************** 

Name              : [Import].[USP_BURSA_CFT001]
Created By        : Akshay
Created Date      : 23/04/2021
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 

	 
		
Used By :

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY

        
			SELECT
				RecordType,
				StockCode,
				ContractDate,
				SellerTRSNo,
				SellerAcctNo,
				TradedQty,
				QtyShortfall
			FROM  [import].[Tb_BURSA_CFT001];

	END TRY		
		
    BEGIN CATCH
    
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
		SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
        
    END CATCH
	SET NOCOUNT OFF;
END