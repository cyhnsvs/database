/****** Object:  Procedure [dbo].[Usp_GenerateMRCode]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GenerateMRCode]
Created By        : Kristine    
Created Date      : 2021-10-07
Used by           : Marketing Representative Form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to generate MR Code. 
					based from [dbo].[Usp_GenerateCustomerID] 
					note: mo error if mag loop 32 times. if naay 32 kabuok ni match ok rana. just run again wala ray issue sa code
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 

 EXEC [dbo].[Usp_GenerateMRCode]
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GenerateMRCode] 
AS
BEGIN
	BEGIN TRY 


		DECLARE @currRunNo bigint, @length int, @currMRCode varchar(20), @prefix varchar(5), @suffix varchar(4);

		SELECT @currRunNo = [textinput-4], @length = [textinput-6], @prefix = [textinput-7], @suffix = [textinput-8]
		FROM CQBuilder.form.Tb_FormData_5 WHERE [textinput-3] = 'MsecMRCode' and Status = 'Active'

		--SELECT @currRunNo, @length, @prefix, @suffix

		IF (@suffix <> YEAR(GETDATE()))
		BEGIN
			SELECT  @currRunNo = '1',
					@suffix = YEAR(GETDATE())
		END

		-- FOR TESTING --SELECT @currRunNo = 89999, @length = 3,@prefix='A'

		SELECT @currMRCode = CONCAT(@prefix
									,REPLACE(STR(@currRunNo, IIF(LEN(@currRunNo) > @length, LEN(@currRunNo), @length)), ' ', '0') 
									,'/'
									,@suffix);

		IF EXISTS (SELECT 1 FROM CQBuilder.form.Tb_FormData_1575 WHERE [textinput-17] = @currMRCode)
		BEGIN

			SET @currRunNo = @currRunNo + 1

			UPDATE CQBuilder.form.Tb_FormData_5
			SET FormDetails = JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(FormDetails
				,'$[0].textinput4', @currRunNo)
				,'$[1].textinput4', @currRunNo)
				,'$[0].textinput8', @suffix)
				,'$[1].textinput8', @suffix)
			WHERE [textinput-3] = 'MsecMRCode' and Status = 'Active';

			EXEC [dbo].[Usp_GenerateMRCode];
		END
		ELSE
		BEGIN
			SELECT @currMRCode as NewCustID;
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