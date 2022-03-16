/****** Object:  Procedure [dbo].[Usp_GetRefSourceByDealerCd]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetRefSourceByDealerCd] 
Created By        : Fadlin    
Created Date      :04/02/2021
Used by           : Dealer Effort Sharing Form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to get list of reference source
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GetRefSourceByDealerCd]  'R086'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetRefSourceByDealerCd] 
	@istrDealerCode varchar(50)
AS
BEGIN
	BEGIN TRY 

		SELECT [selectsource-23] as RefSource
		FROM CQBuilder.form.Tb_FormData_1409
		WHERE [selectsource-21] = @istrDealerCode
		GROUP BY [selectsource-23]

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END