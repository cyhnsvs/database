/****** Object:  Procedure [Queue].[DequeueOutBound]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [Queue].[DequeueOutBound]
AS
/*********************************************************************************** 

Project UIN		  : ITSR 130775
RFA				  : RFA 158339
Created By        : 
Created Date      : 
Last Updated Date : 
Description       : To fetch from outbound queue table

*	Modification History :
*	ModifiedBy :      Project UIN :        ModifiedDate :    Reason :
*	
*	Has been modified by [who] + [date] + [Project UIN] + [notes]:
*     
 	exec [Queue].[DequeueFast]
PARAMETERS 

************************************************************************************/ 
BEGIN
SET NOCOUNT ON;
BEGIN TRY 
 
 UPDATE TOP (1)  Queue.MBMSOutBound
	WITH (
			UPDLOCK
			,READPAST
			)
	SET STATUS = 1
	OUTPUT inserted.QueueID
		,inserted.QueueDateTime
		,inserted.MessageData
	FROM Queue.MBMSOutBound AS qm
		WHERE STATUS IN( 0,1,3);
	
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