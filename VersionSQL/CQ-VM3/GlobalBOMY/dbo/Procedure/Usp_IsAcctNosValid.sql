/****** Object:  Procedure [dbo].[Usp_IsAcctNosValid]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_IsAcctNosValid] 
Created By        : Kristine
Created Date      : 14/07/2021
Used by           : http://128.2.17.181/CQBuilder/FormData/CreateData/3426
					CQForms > GBO Realtime > Cash Transaction					
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to check if a list of AcctNo (separated by comma) is valid
Table(s) Used     : 

Parameters:
	@iintCompanyId  - Company Id
	@sAcctNo		- multiple AcctNos separated by comma
Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 

 EXEC [dbo].[Usp_IsAcctNosValid] 1, '011440702,0114294022,012945202,k'
 EXEC [dbo].[Usp_IsAcctNosValid] 1, '032215802' 
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_IsAcctNosValid] 
	@iintCompanyId bigint,
	@sAcctNo varchar(4000)
AS
BEGIN
	BEGIN TRY
		
		DECLARE @InvalidAcctNos VARCHAR(4000) = ''

		SELECT @InvalidAcctNos  = CONCAT(@InvalidAcctNos,',',P.val)
		FROM GlobalBoLocal.dbo.Udf_Split(@sAcctNo, ',') P
			/*LEFT JOIN CQBTempDB.export.Tb_FormData_1409 A
				ON P.val = A.[AccountNumber (textinput-5)]*/
			LEFT JOIN CQBuilder.form.Tb_FormData_1409 A
				ON P.val = A.[textinput-5]
		WHERE A.RecordID IS NULL

		SELECT IIF(LEN(@InvalidAcctNos) > 2 , SUBSTRING(@InvalidAcctNos,2, LEN(@InvalidAcctNos)),  NULL) [Invalid]

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
END