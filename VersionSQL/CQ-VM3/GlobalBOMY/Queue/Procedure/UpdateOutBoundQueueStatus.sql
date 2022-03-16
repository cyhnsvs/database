/****** Object:  Procedure [Queue].[UpdateOutBoundQueueStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [Queue].[UpdateOutBoundQueueStatus] (
	@intQueueID INT
	,@intStatus INT
	,@remarks VARCHAR(max) = NULL
	)
AS
/*********************************************************************************** 

Project UIN		  : ITSR 130775
RFA				  : RFA 158339
Created By        : 
Created Date      : 
Last Updated Date : 
Description       : To update outbound queue table

*	Modification History :
*	ModifiedBy :      Project UIN :        ModifiedDate :    Reason :
*	
*	Has been modified by [who] + [date] + [Project UIN] + [notes]:
*     
 	
PARAMETERS 

************************************************************************************/ 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	UPDATE Queue.MBMSOutBound
	SET STATUS = @intStatus
		,Remarks = CASE 
			WHEN (
					@remarks IS NOT NULL
					AND @remarks <> ''
					)
				THEN @remarks
			ELSE Remarks
			END
	WHERE QueueID = @intQueueID;
END TRY
BEGIN CATCH
		
	DECLARE @strErrMsg Varchar(4000)=''
	DECLARE @ErrorMessage NVARCHAR(4000), 
		@ErrorNumber INT, 
		@ErrorSeverity INT, 
		@ErrorState INT, 
		@ErrorLine INT, 
		@ErrorProcedure NVARCHAR(200);

	SET @ErrorMessage = @ErrorMessage
		+ QUOTENAME(N'ERROR_MESSAGE(): '		+ CAST(ISNULL(ERROR_MESSAGE(), '-') AS NVARCHAR(1000)), N'(')
		+ QUOTENAME(N'ERROR_NUMBER(): '			+ CAST(ISNULL(ERROR_NUMBER(), '-') AS NVARCHAR(10)), N'(')
		+ QUOTENAME(N'ERROR_SEVERITY(): '		+ CAST(ISNULL(ERROR_SEVERITY(), '-') AS NVARCHAR(10)), N'(')
		+ QUOTENAME(N'ERROR_STATE(): '			+ CAST(ISNULL(ERROR_STATE(), '-') AS NVARCHAR(10)), N'(')
		+ QUOTENAME(N'ERROR_PROCEDURE(): '		+ CAST(ISNULL(ERROR_PROCEDURE(), '-') AS NVARCHAR(200)), N'(')
		+ QUOTENAME(N'ERROR_LINE(): '			+ CAST(ISNULL(ERROR_LINE(), '-')AS NVARCHAR(50)), N'(');
								 
		SELECT  @strErrMsg = @ErrorMessage, 
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

		RAISERROR (@strErrMsg,	/* Message text.*/
					@ErrorSeverity,	/* Severity.	*/
					@ErrorState		/* State.		*/
					);
					   
END CATCH

SET NOCOUNT OFF;
END