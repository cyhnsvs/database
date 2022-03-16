/****** Object:  Procedure [dbo].[Usp_GetSubTransType]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetSubTransType]
Created By        : Kristine
Created Date      : 29/06/2021
Used by           : http://128.2.17.181/CQBuilder/FormData/CreateData/3426
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to generate get gbo subtrans type
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GetSubTransType] 1, 'SETLDP'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetSubTransType] 
	@iintCompanyId bigint,
	@sTransType varchar(50) 
AS
BEGIN
	BEGIN TRY

		SELECT ISNULL(SubTransTypeValue,'') SubTransTypeValue, SubTransTypeId
		FROM GlobalBO.setup.Tb_SubTransactionType a
			INNER JOIN GlobalBO.setup.Tb_TransactionType b
				ON a.TransTypeId = b.TransTypeId
				
		WHERE a.CompanyId = @iintCompanyId
			AND b.TransType = @sTransType

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END