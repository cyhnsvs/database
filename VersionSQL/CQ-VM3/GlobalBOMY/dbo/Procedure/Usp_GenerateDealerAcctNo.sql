/****** Object:  Procedure [dbo].[Usp_GenerateDealerAcctNo]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GenerateDealerAcctNo]
Created By        : Fadlin    
Created Date      : 02/12/2020
Used by           : Dealer Form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to generate dealer account no
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GenerateDealerAcctNo] 'D','001','532';
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GenerateDealerAcctNo] 
	@istrDealerType varchar(50)
	,@istrBranchID varchar(5)
	,@istrBfeCode varchar(3)
AS
BEGIN
	BEGIN TRY 

		DECLARE @currRunNo bigint, @length int, @newDealerAcctNo varchar(7), @currDealerAcctNo varchar(7),@region varchar(1);

		SELECT @currRunNo = [textinput-4], @length = [textinput-6]
		FROM CQBuilder.form.Tb_FormData_5 WHERE [textinput-3] = 'MsecDealerAcctNo' and Status = 'Active'

		SELECT @currDealerAcctNo = REPLACE(STR(@currRunNo,@length),' ','0');

		IF EXISTS (SELECT 1 FROM CQBuilder.form.Tb_FormData_1377 WHERE SUBSTRING([textinput-37], 3, 4) = @currDealerAcctNo) OR @currRunNo = '0'
		BEGIN
			SET @currRunNo = @currRunNo + 1
			SELECT @newDealerAcctNo = REPLACE(STR(@currRunNo,@length),' ','0');

			UPDATE CQBuilder.form.Tb_FormData_5
			SET FormDetails = JSON_MODIFY(JSON_MODIFY(FormDetails, '$[0].textinput4', @currRunNo), '$[1].textinput4', @currRunNo)
			WHERE [textinput-3] = 'MsecDealerAcctNo' and Status = 'Active';

			IF EXISTS (SELECT 1 FROM CQBuilder.form.Tb_FormData_1377 WHERE SUBSTRING([textinput-37], 3, 4) = @newDealerAcctNo)
			BEGIN
				EXEC [dbo].[Usp_GenerateDealerAcctNo] @istrDealerType,@istrBranchID,@istrBfeCode;
			END

			SELECT @istrDealerType + @newDealerAcctNo + @istrBfeCode as NewDealerAcctNo;

			--SELECT @region = SUBSTRING([selectsource-10], 1, 1) FROM CQBuilder.form.Tb_FormData_1374 WHERE [textinput-1] = @istrBranchID
			--SELECT @istrDealerType + ISNULL(@region,'') + @newDealerAcctNo + @istrBfeCode as NewDealerAcctNo;
		END
		ELSE
		BEGIN
			SELECT @istrDealerType + @currDealerAcctNo + @istrBfeCode as NewDealerAcctNo;
			--SELECT @region = SUBSTRING([selectsource-10], 1, 1) FROM CQBuilder.form.Tb_FormData_1374 WHERE [textinput-1] = @istrBranchID
			--SELECT @istrDealerType + ISNULL(@region,'') + @currDealerAcctNo + @istrBfeCode as NewDealerAcctNo;
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