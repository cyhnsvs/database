/****** Object:  Procedure [dbo].[Usp_GetAccountTypeDigitCode]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetAccountTypeDigitCode]
Created By        : Fadlin    
Created Date      : 04/01/2021
Used by           : Customer Form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to get Account Type Digit Code
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GetAccountTypeDigitCode] '01','Elfstone','Y',''
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetAccountTypeDigitCode] 
	@istrAccountType varchar(10)
	,@istrAlgo varchar(150)
	,@istrNomineesInd varchar(1)
	,@istrFinancier varchar(100)
	,@istrDigitCode varchar(2) = NULL OUTPUT 
AS
BEGIN
	BEGIN TRY 

		DECLARE @digitCode varchar(2);
		DECLARE @charCode varchar(1);
		DECLARE @strNominees varchar(10);

		SELECT @charCode = [textinput-3]
		FROM CQBuilder.form.Tb_FormData_1457 
		WHERE [textinput-1] = @istrAccountType;

		IF(@istrNomineesInd = 'N')
		BEGIN
			SELECT @digitCode = [textinput-1]
			FROM CQBuilder.form.Tb_FormData_1457
			WHERE [textinput-3] = @charCode
			AND [selectsource-1] = @istrAlgo
			AND [selectbasic-2] IN ('N','')
			AND [selectsource-2] = @istrFinancier
		END
		ELSE
		BEGIN
			SELECT @digitCode = [textinput-1]
			FROM CQBuilder.form.Tb_FormData_1457
			WHERE [textinput-3] = @charCode
			AND [selectsource-1] = @istrAlgo
			AND [selectbasic-2] = @istrNomineesInd
			AND [selectsource-2] = @istrFinancier
		END
		
		IF(@digitCode IS NULL)
		BEGIN
			SELECT TOP 1 @digitCode = [textinput-1]
			FROM CQBuilder.form.Tb_FormData_1457
			WHERE [textinput-3] = @charCode
			ORDER BY RecordID
		END

		SET @istrDigitCode = @digitCode

		SELECT @digitCode as DigitCode;

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END