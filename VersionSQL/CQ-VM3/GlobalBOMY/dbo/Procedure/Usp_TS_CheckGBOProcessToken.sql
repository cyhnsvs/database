/****** Object:  Procedure [dbo].[Usp_TS_CheckGBOProcessToken]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_TS_CheckGBOProcessToken](  
	@istrProcessName varchar(200) = NULL,
	@istrProcessType varchar(50) = NULL,
	@istrProcessUpdateID varchar(50) = NULL
  )
AS  
/*
* Created by:      Naveen
* Date:            11 Oct 2016
* Used by:         
* Called by:       
* Project UIN : GBO-SG00001_Phase2 
* RFA No.   : RFA150840   
*
* Purpose: This sp is used to check if token is ready for a particular process.
*
* Input Parameters:
* @istrProcessName - process Name

* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
*  1. Marvin + 2016-10-14 +  GBO-SG00001_Phase2  RFA-150840 - Removed unnecessary Select in line 50
*/
--exec Usp_TS_CheckGBOProcessToken 'GlobalBOSG_DayEndFullRun', 'JOB'

BEGIN  
SET NOCOUNT ON;  
BEGIN TRY
	
	IF OBJECT_ID('#ProcName') IS NOT NULL
		DROP TABLE #ProcName;
	
	CREATE TABLE #ProcName (
		ProcessName varchar(200),
		ProcessUpdateID varchar(50)
	);

	INSERT INTO #ProcName 
		EXEC [dbo].[Usp_SSIS_GBOProcessManager] @iintMode=1, @istrProcessType=@istrProcessType;
	
	IF NOT EXISTS(SELECT 1 FROM #ProcName WHERE ProcessName = @istrProcessName)
		RAISERROR('Token Not Ready', 16, 1);
	

END TRY
BEGIN CATCH 
			      
		IF ERROR_NUMBER() IS NULL
			RETURN;

		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);
		SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
	        
	END CATCH

SET NOCOUNT OFF;
END