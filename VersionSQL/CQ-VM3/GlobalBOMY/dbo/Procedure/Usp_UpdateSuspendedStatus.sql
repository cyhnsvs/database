/****** Object:  Procedure [dbo].[Usp_UpdateSuspendedStatus]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_UpdateSuspendedStatus]
Created By        : Fadlin    
Created Date      : 20/01/2021
Used by           : Dealer Market Form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to update status to Suspend
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_UpdateSuspendedStatus] 'BRK','A'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_UpdateSuspendedStatus] 
	@istrDealerCode varchar(50),
	@istrStatus varchar(50)
AS
BEGIN
	BEGIN TRY 

		IF (@istrStatus <> 'S')
		BEGIN
			SET @istrStatus = 'R'
		END

		UPDATE CQBuilder.form.Tb_FormData_1379
			SET FormDetails = JSON_MODIFY(
								JSON_MODIFY(
									JSON_MODIFY(
										JSON_MODIFY(
											JSON_MODIFY(
												JSON_MODIFY(
													FormDetails, 
													'$[0].multipleradiosinline3', @istrStatus), 
													'$[1].multipleradiosinline3', @istrStatus), 
													'$[0].multipleradiosinline4', @istrStatus), 
													'$[1].multipleradiosinline4', @istrStatus),
													'$[0].multipleradiosinline5', @istrStatus), 
													'$[1].multipleradiosinline5', @istrStatus)
			WHERE [selectsource-14] = @istrDealerCode;

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END