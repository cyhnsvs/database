/****** Object:  Procedure [report].[Usp_FetchDailyAcctOpeningDetailsRpt]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [report].[Usp_FetchDailyAcctOpeningDetailsRpt]
Created By        : Fadlin    
Created Date      : 18/12/2020
Used by           : 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : 
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [report].[Usp_FetchDailyAcctOpeningDetailsRpt] '2021-01-05'
**********************************************************************************/   
CREATE PROCEDURE [report].[Usp_FetchDailyAcctOpeningDetailsRpt]
	@idteReportDate date
AS
BEGIN
	BEGIN TRY 

		SELECT 
			b.[CustomerName (textinput-3)] as CustName,
			b.[IDNumber (textinput-5)] as IC,
			a.[AccountNumber (textinput-5)] as AcctNo,
			a.[CDSNo (textinput-19)] as CDSNo,
			acctTypes.[Description (textinput-2)] as AcctType, 
			a.[DealerCode (selectsource-21)] as DealerCode
		FROM GlobalBORpt.form.Tb_FormData_1409 as a
		INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as b
		ON a.[CustomerID (selectsource-1)] = b.[CustomerID (textinput-1)]
		AND a.ReportDate = b.ReportDate
		INNER JOIN GlobalBORpt.form.Tb_FormData_1457 as acctTypes
		ON acctTypes.[2DigitCode (textinput-1)] = RIGHT(a.[AccountNumber (textinput-5)],2)
		WHERE CAST(a.CreatedTime as date) = @idteReportDate
		and CAST(a.ReportDate as date) = @idteReportDate;

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END