/****** Object:  Procedure [Queue].[AddMessageToInBoundQueue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [Queue].[AddMessageToInBoundQueue] (
	@MessageData [varchar](max)
	)
AS
/*********************************************************************************** 

Project UIN		  : ITSR 130775
RFA				  : RFA 158339
Created By        : 
Created Date      : 
Last Updated Date : 
Description       : To insert the message to inbound queue table

*	Modification History :
*	ModifiedBy :      Project UIN :        ModifiedDate :    Reason :
*	
*	Has been modified by [who] + [date] + [Project UIN] + [notes]:
*   Marvin + 2017104 + RFA177208 + SGX PTS 2
 	
PARAMETERS 

************************************************************************************/ 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	
	INSERT INTO [Queue].[MBMSInBound] ([MessageData])
	VALUES (@MessageData);
	 
END TRY
BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);
		SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
END CATCH

SET NOCOUNT OFF;
END