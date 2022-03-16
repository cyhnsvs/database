/****** Object:  Procedure [dbo].[Usp_GetExchangeDetails]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetExchangeDetails]
Created By        : Fadlin    
Created Date      : 14/09/2020
Used by           : Dealer Market Form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to get list of exchange details
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GetExchangeDetails]
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetExchangeDetails] 
	@iintCompanyId bigint
AS
BEGIN
	BEGIN TRY 

		SELECT *
		FROM GlobalBO.setup.Tb_Exchange
		WHERE CompanyId = @iintCompanyId

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END