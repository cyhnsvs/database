/****** Object:  Procedure [dbo].[Usp_GetAcctLimitInfo]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetAcctLimitInfo]
Created By        : Kristine
Created Date      : 15/07/2021
Used by           : Account Limit Maintenance Form
					http://128.1.17.102/cqbuilder/formdata/createdata/3663 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used in form 3663 to get the Account limit maintenance 
					info from Account Info Updated (CQBuilder.form.Tb_FormData_1409)
Table(s) Used     : CQBuilder.form.Tb_FormData_1409

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 

 EXEC [dbo].[Usp_GetAcctInfo] 1, '011434001'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetAcctLimitInfo]
	@iintCompanyId bigint,
	@sAcctNo varchar(50)
AS
BEGIN
	BEGIN TRY

		SELECT a.[textinput-5] AcctNo
			,a.[selectsource-2] AcctGroup
			,a.[selectsource-3] ParentGrop
			,c.[textinput-3] CustomerName
			,a.[textinput-68] MaxBuyLimit
			,a.[textinput-69] MaxSellLimit
			,a.[textinput-70] MaxNetLmt
			,a.[textinput-56] MultplrCashDeposit
			,a.[textinput-57] MultplrSharePledged
			,a.[textinput-58] MultplrNonShare
			,a.[textinput-59] AvCleanLineLimit
			,a.[dateinput-9] StartDate
			,a.[dateinput-10] EndDate
		FROM CQBuilder.form.Tb_FormData_1409 a
			LEFT JOIN CQBuilder.form.Tb_FormData_1410 c
				ON a.[selectsource-1] = c.[textinput-1]
		WHERE a.[textinput-5] = @sAcctNo


	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END