/****** Object:  Procedure [reports].[Usp_GetConditionsByProcessID]    Committed by VersionSQL https://www.versionsql.com ******/

--EXEC [report].[Usp_GetConditionsByProcessID] 1
CREATE PROCEDURE [reports].[Usp_GetConditionsByProcessID] 
	@processId int = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_PADDING ON;    
	BEGIN TRY  

	DECLARE @query nvarchar(max) = '';

	SELECT @query = @query + ParamName + ' = N'''+ ParamValue+ ''' AND ' FROM [reports].[Tb_ProcessParam] WHERE ProcessID = @processId

	SELECT @query =  ' ' + SUBSTRING(ISNULL(@query,''), -2, len(@query))
		FROM [reports].[Tb_ReportSetup] as RS
	JOIN [reports].[Tb_Process] as P ON RS.IDD = P.ReportID where P.IDD = @processId

	PRINT ''''+@query+''''
	SELECT @query AS Condition


	END TRY  
	BEGIN CATCH   
  
        --print 'error'  
        IF ERROR_NUMBER() IS NULL  
            RETURN;  
  
  
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);  
        SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');  
        SELECT @ErrorMessage = N'Error %d, Level %d, State %d,Procedure %s, Line %d, Message: '+ @ErrorMessage;  
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);  
              
    END CATCH  
  
  
SET NOCOUNT OFF;  

END