/****** Object:  Procedure [dbo].[Usp_SSIS_GBOProcessManager]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_SSIS_GBOProcessManager] (  
	@iintMode TINYINT,  
	@istrProcessName varchar(200) = NULL,
	@istrProcessType varchar(50) = NULL,
	@istrProcessUpdateID varchar(50) = NULL,
	@istrProcessStatus char(1) = NULL,
	@istrRemarks varchar(200) = ''
  )
AS  
/*
* Created by:      Nishanth
* Date:            12/03/2020
* Used by:         GBO Process 
* Called by:       GBO Batch Process Manager

* Purpose: This sp is used to fetch and update the status for the data generation (file).
*
* Input Parameters:
*	@iintMode - input mode 
			1 - fetch the Package to executed
			2 - Update the process result 
			3 - Update the process status to 0 for next day run
*
*	@istrProcessName - process Name
*	@istrProcessStatus - process status
*	@istrRemarks  - remarks 
* Output Parameters:
* NONE
*
*	Modification History :
*	ModifiedBy :      Project UIN :        ModifiedDate :    Reason :
*	
*	Has been modified by [who] + [date] + [Project UIN] + [notes]:

EXEC [dbo].[Usp_SSIS_GBOProcessManager] 1, '', 'EXE-CQB', '', ''
PARAMETERS 

*/

BEGIN  
SET NOCOUNT ON;  
/*
--ProcessStatus
-- '0' - Status reset to 0 daily after GBO  Day end
-- '1' - Processing 
-- '2' - Process Completed Successfully
-- '3' - Processing Failed

--TokenType
--'T' Check Only whether the Token is ready
--'S' Check Only whether the Schedule conditions met
--'B' Check both Token is ready & Schedule conditions met
*/
BEGIN TRY

	IF(@iintMode <> 1 AND CHARINDEX('\', @istrProcessName) > 0)
		SET @istrProcessName = SUBSTRING(@istrProcessName, CHARINDEX('\', @istrProcessName)+1, LEN(@istrProcessName));
		
	DECLARE @strCurrentHour CHAR(5);
	SET @strCurrentHour = CONVERT(CHAR(5), GETDATE(), 114);
	
	DECLARE @ProcessFreqTimeType VARCHAR(10) = (SELECT CASE WHEN @strCurrentHour >= '04:00' AND @strCurrentHour < '12:00' THEN '_MORNING' 
											   WHEN @strCurrentHour >= '12:00' AND @strCurrentHour < '17:00' THEN '_NOON'
											   WHEN @strCurrentHour >= '17:00' AND @strCurrentHour < '23:55' THEN '_EVENING'
											   WHEN @strCurrentHour >= '23:55' OR @strCurrentHour < '04:00' THEN '_NIGHT' END);
	--SET @ProcessFreqTimeType = '_EVENING';

	IF(@iintMode = 1)  
	BEGIN
	
		DECLARE @strCurrentDayOfWeek CHAR(1);
		SET @strCurrentDayOfWeek = CONVERT(CHAR(1), DATEPART(WEEKDAY, GETDATE()));
		
		SELECT DISTINCT ISNULL(ProcessFolder, '') + ProcessName AS ProcessName, ProcessUpdateID AS ProcessUpdateID
		FROM dbo.Tb_GBOSGProcessToken
		WHERE ((ProcessStatus = '0' AND TokenType = 'T' AND IsInputReady = 'Y'
				AND OutputProcID NOT IN   
					(SELECT DISTINCT OutputProcID  
					 FROM dbo.Tb_GBOSGProcessToken WITH (NOLOCK)
					 WHERE IsInputReady <> 'Y' AND IsEnabled = 1))
			OR (ProcessStatus = '0' AND TokenType = 'S'
				AND @strCurrentHour >= ProcStartTime
				AND FrequencyValue LIKE '%,' + @strCurrentDayOfWeek + ',%')
			OR (ProcessStatus = '0' AND TokenType = 'B' AND IsInputReady = 'Y'
				AND @strCurrentHour >= ProcStartTime
				AND FrequencyValue LIKE '%,' + @strCurrentDayOfWeek + ',%'
				AND OutputProcID NOT IN   
					(SELECT DISTINCT OutputProcID  
					 FROM dbo.Tb_GBOSGProcessToken WITH (NOLOCK)
					 WHERE IsInputReady <> 'Y' AND IsEnabled = 1))
			OR (ProcessStatus = '3'
				AND ((TokenType IN('B','T') AND IsInputReady = 'Y') OR TokenType = 'S')
				AND @strCurrentHour >= CONVERT(CHAR(5), CAST(ProcStartTime AS DATETIME), 114)
				AND @strCurrentHour <= CONVERT(CHAR(5), CAST(ProcStartTime AS DATETIME) + ReRunDuration, 114)))
		AND ProcessType=@istrProcessType
		AND (PHIndicator = 'Y' OR (PHIndicator = 'N' AND [dbo].[Udf_CheckPublicHoliday](GETDATE()) = 0))
		AND IsEnabled = 1;
		--select '1'

	END
	ELSE IF(@iintMode = 2)  
	BEGIN
		IF(@istrProcessStatus='1')
		BEGIN
			UPDATE dbo.Tb_GBOSGProcessToken 
			SET ProcessStatus=@istrProcessStatus,
				UpdatedBy='GBOSG\Process',
				UpdatedDateTime=GETDATE(),
				Remarks = CASE WHEN @istrRemarks IS NULL OR @istrRemarks ='' THEN Remarks ELSE @istrRemarks END
			WHERE ProcessName=@istrProcessName AND ProcessUpdateID = @istrProcessUpdateID AND IsEnabled = 1
				AND InputProcID LIKE '%' + @ProcessFreqTimeType;
		END
		ELSE IF(@istrProcessStatus='2')
		BEGIN
			--Update the process status
			UPDATE dbo.Tb_GBOSGProcessToken 
			SET ProcessStatus=@istrProcessStatus, 
				Remarks='',
				UpdatedBy='GBOSG\Process',
				UpdatedDateTime=GETDATE()
			WHERE ProcessName=@istrProcessName AND ProcessUpdateID = @istrProcessUpdateID AND IsEnabled = 1
				AND ProcessStatus IN('1','3') AND InputProcID LIKE '%' + @ProcessFreqTimeType; 
			
			--Update the SQL input is ready for generation process 
			UPDATE dbo.Tb_GBOSGProcessToken 
			SET IsInputReady = 'Y',
				UpdatedBy='GBOSG\Process',
				UpdatedDateTime=GETDATE()
			WHERE InputProcID IN (	
					SELECT OutputProcID 
					FROM dbo.Tb_GBOSGProcessToken 
					WHERE ProcessName=@istrProcessName AND ProcessUpdateID = @istrProcessUpdateID AND InputProcID LIKE '%' + @ProcessFreqTimeType) 
			AND (PHIndicator = 'Y' OR (PHIndicator = 'N' AND [dbo].[Udf_CheckPublicHoliday](GETDATE()) = 0)) AND IsEnabled = 1;

		END
		ELSE IF(@istrProcessStatus='3')
		BEGIN
			UPDATE dbo.Tb_GBOSGProcessToken 
			SET ProcessStatus=@istrProcessStatus,
				UpdatedBy='GBOSG\Process',
				UpdatedDateTime=GETDATE(),
				Remarks  = CASE WHEN @istrRemarks IS NULL OR @istrRemarks ='' THEN Remarks ELSE @istrRemarks END
			WHERE ProcessName=@istrProcessName AND ProcessUpdateID = @istrProcessUpdateID AND IsEnabled = 1 AND ProcessStatus IN('0','1') AND InputProcID LIKE '%' + @ProcessFreqTimeType;
		END
	END
	ELSE IF(@iintMode = 3)
	BEGIN
		UPDATE dbo.Tb_GBOSGProcessToken 
		SET ProcessStatus = '0',
			IsInputReady = 'N',
			UpdatedBy='GBOSG\Reset',
			UpdatedDateTime=GETDATE(),
			Remarks = ''
		WHERE ProcessStatus <> 'D';
				
		IF ([dbo].[Udf_CheckPublicHoliday](GETDATE()) = 1)
		BEGIN
			UPDATE dbo.Tb_GBOSGProcessToken 
			SET IsInputReady = 'Y',
				UpdatedBy='GBOSG\PublicHoliday',
				UpdatedDateTime=GETDATE(),
				Remarks = ''
			WHERE PHIndicator = 'Y' AND IsEnabled = 1
			AND InputProcID NOT IN (SELECT OutputProcID FROM dbo.Tb_GBOSGProcessToken WHERE PHIndicator='Y' AND IsEnabled = 1);
		END

	END
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