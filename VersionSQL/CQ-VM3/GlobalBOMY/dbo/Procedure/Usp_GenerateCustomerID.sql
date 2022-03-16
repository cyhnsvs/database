/****** Object:  Procedure [dbo].[Usp_GenerateCustomerID]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GenerateCustomerID]
Created By        : Fadlin    
Created Date      : 27/11/2020
Used by           : Customer info form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to generate customer id
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GenerateCustomerID]
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GenerateCustomerID] 
	--@istrDealerCode varchar(50)
AS
BEGIN
	BEGIN TRY 

		DECLARE @currRunNo bigint, @length int, @newCustID varchar(7), @currCustID varchar(7);

		SELECT @currRunNo = [textinput-4], @length = [textinput-6]
		FROM CQBuilder.form.Tb_FormData_5 WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active'

		SELECT @currCustID = REPLACE(STR(@currRunNo,@length),' ','0');

		IF EXISTS (SELECT 1 FROM CQBuilder.form.Tb_FormData_1410 WHERE [textinput-1] = @currCustID)
		BEGIN
			SET @currRunNo = @currRunNo + 1
			SELECT @newCustID = REPLACE(STR(@currRunNo,@length),' ','0');

			UPDATE CQBuilder.form.Tb_FormData_5
			SET FormDetails = JSON_MODIFY(JSON_MODIFY(FormDetails, '$[0].textinput4', @currRunNo), '$[1].textinput4', @currRunNo)
			WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active';

			--UPDATE CQBuilder.form.Tb_FormData_5
			--SET FormDetails = JSON_MODIFY(FormDetails, '$[0].textinput4', @currRunNo)
			--WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active';

			--WAITFOR DELAY '00:00:01';

			--UPDATE CQBuilder.form.Tb_FormData_5
			--SET FormDetails = JSON_MODIFY(FormDetails, '$[1].textinput4', @currRunNo)
			--WHERE [textinput-3] = 'MsecCustomerID' and Status = 'Active';

			IF EXISTS (SELECT 1 FROM CQBuilder.form.Tb_FormData_1410 WHERE [textinput-1] = @newCustID)
			BEGIN
				EXEC [dbo].[Usp_GenerateCustomerID];
			END

			SELECT @newCustID as NewCustID;
		END
		ELSE
		BEGIN
			SELECT @currCustID as NewCustID;
		END

		

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END