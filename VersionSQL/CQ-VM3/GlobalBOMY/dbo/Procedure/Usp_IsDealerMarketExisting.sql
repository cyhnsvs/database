/****** Object:  Procedure [dbo].[Usp_IsDealerMarketExisting]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_IsDealerMarketExisting]
	@iintCompanyId bigint,
	@sDealerCode varchar(50),
	@sMarketCode varchar(50)
/***********************************************************************************             
Name              : [dbo].[Usp_IsDealerMarketExisting_3676]
Created By        : Kristine
Created Date      : 16/07/2021
Used by           : Dealer Market Limit Maintenance Form
					http://128.1.17.102/cqbuilder/formdata/createdata/3676
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used in form 3676 to check if Dealer Market limit is already created here 
Table(s) Used     : CQBuilder.form.Tb_FormData_3676

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 

 EXEC [dbo].[Usp_GetAcctInfo] 1, '011434001'
**********************************************************************************/   
AS
BEGIN
	BEGIN TRY

		SELECT RecordID,
			[Status]
		FROM CQBuilder.form.Tb_FormData_3676
		WHERE [selectsource-1] = @sDealerCode
			AND [selectsource-2] = @sMarketCode

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END