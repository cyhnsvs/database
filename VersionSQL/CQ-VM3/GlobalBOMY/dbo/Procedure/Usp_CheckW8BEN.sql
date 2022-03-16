/****** Object:  Procedure [dbo].[Usp_CheckW8BEN]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_CheckW8BEN]
Created By        : Fadlin    
Created Date      : 03/12/2020
Used by           : Customer info form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to check W8BEN expiry date
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_CheckW8BEN]
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_CheckW8BEN]
	--@istrDealerCode varchar(50)
AS
BEGIN
	BEGIN TRY 

		DECLARE 
			@strName varchar(200)
			,@strExpiryDate varchar(50)
			,@strEmail varchar(150)
			,@intCurrNo INT = 1
			,@intRecordCount INT
			,@strMailBody varchar(250);

		UPDATE CQBuilder.form.Tb_FormData_1410
		SET FormDetails = JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(FormDetails, '$[0].multipleradiosinline21', 'N'), '$[0].dateinput14', ''), '$[0].dateinput18', ''), '$[1].multipleradiosinline21', 'N'), '$[1].dateinput14', ''), '$[1].dateinput18', '')
		WHERE [dateinput-18] = CAST(GETDATE() AS DATE)
	
		SELECT
			ROW_NUMBER() OVER (PARTITION BY [textinput-1] ORDER BY [textinput-1]) as rowNum
			,[textinput-3] as [Name]
			,[dateinput-18] as W8BENExpiryDate
			--,[textinput-58] as Email
			,'fadlin@phillip.com.sg' as Email
		INTO #tmpAccounts
		FROM CQBuilder.form.Tb_FormData_1410 
		WHERE [multipleradiosinline-21] = 'Y' 
		AND [dateinput-18] BETWEEN CAST(GETDATE() AS DATE) AND CAST(DATEADD(day,+30,GETDATE()) AS DATE);

		SET @intRecordCount = (SELECT count(1) FROM #tmpAccounts);
		
		WHILE (@intCurrNo < = @intRecordCount)
		BEGIN
			SELECT
				@strName = [Name]
				,@strExpiryDate = convert(varchar, CAST(W8BENExpiryDate as DATE), 101)
				,@strEmail = Email
			FROM #tmpAccounts WHERE rowNum = @intCurrNo;

			SET @strMailBody = 'Hi '+ @strName +', your W8BEN will expired on '+ @strExpiryDate +'. Please renew it. Thanks.';

			EXEC [master].[dbo].DBA_SendEmail   
			@istrMailTo             = @strEmail,
			@istrMailBody           = @strMailBody,
			@istrMailSubject        = 'Expiration of W8BEN', 
			@istrimportance         = 'high', 
			@istrfrom_address       = 'noreply@mplusonline.com.my', 
			@istrreply_to           = '',   
			@istrbody_format        = 'HTML'; 
			
			SET @intCurrNo = @intCurrNo + 1;                                   
		END

		DROP TABLE #tmpAccounts;

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END