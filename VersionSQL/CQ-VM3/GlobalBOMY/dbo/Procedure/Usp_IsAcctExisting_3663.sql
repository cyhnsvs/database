/****** Object:  Procedure [dbo].[Usp_IsAcctExisting_3663]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_IsAcctExisting_3663]
Created By        : Kristine
Created Date      : 15/07/2021
Used by           : Account Limit Maintenance Form
					http://128.1.17.102/cqbuilder/formdata/createdata/3663 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used in form 3663 to check if Acct limit is already created here 
Table(s) Used     : CQBuilder.form.Tb_FormData_3663

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 

 EXEC [dbo].[Usp_GetAcctInfo] 1, '011434001'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_IsAcctExisting_3663]
	@iintCompanyId bigint,
	@sAcctNo varchar(50)
AS
BEGIN
	BEGIN TRY

		SELECT [textinput-4] AcctNo
			,[Status]
		FROM CQBuilder.form.Tb_FormData_3663
		WHERE [textinput-4] = @sAcctNo

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END