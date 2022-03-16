/****** Object:  Procedure [dbo].[Usp_GetTransType]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetTransType] 
Created By        : Fadlin    
Created Date      : 09/04/2021
Used by           : 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to generate get gbo trans type
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GetTransType] 1, 'cr'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetTransType] 
	@iintCompanyId bigint,
	@istrLedgerCrDr varchar(10) = null
AS
BEGIN
	BEGIN TRY

		SELECT 
			TransTypeId,TransType,TransTypeDesc,TransCategory,LedgerCrDr 
		FROM GlobalBO.setup.Tb_TransactionType 
		WHERE CompanyId = @iintCompanyId
		AND (ISNULL(@istrLedgerCrDr,'All') = 'All' OR LedgerCrDr = @istrLedgerCrDr)
		

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END