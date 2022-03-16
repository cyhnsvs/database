/****** Object:  Procedure [form].[Usp_Logger]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_Logger]
	@istrMsg nvarchar(4000),
	@idateLastExec datetime = NULL output,
	@istrPrefix varchar(50) = NULL,
	@inumEnabled tinyint = 1
AS
/*
* Created by:      Jemariel Requina
* Date:            13 Dec 2018
* Used by:         CQBuilder     
* Called by:       CQBuilder Migration Process / CQBuilder API
* Project UIN : 196154
* RFA No.   : 198015
*
* Purpose: This is sp is used to log the error messages.
*
* Input Parameters:
	@istrMsg - log message
	@istrPrefix - prefix for the log
	@inumEnabled - enable the log flag

* Output Parameters:
  @idateLastExec - log date
*
* Has been modified by + date + project UIN + note:
*  
*/
BEGIN
SET NOCOUNT ON;

	declare @now datetime;
	declare @timestamp varchar(20);
	
	IF @inumEnabled = 1
	BEGIN 
		set @now = GETDATE();
		if(@idateLastExec is not null)
		begin
			set @timestamp = CONVERT(varchar, DATEADD(ms, datediff(ms, @idateLastExec, @now), 0), 114);
		end
		else
		begin 
			set @timestamp = CONVERT(varchar, DATEADD(ms, 0, 0), 114);
		end
		
		set @istrMsg = '[' + @timestamp + '] ' + @istrMsg;
		
		set @istrPrefix = ISNULL(@istrPrefix, '')
		if(@istrPrefix <> '')
		BEGIN
			SET @istrMsg = '[' + @istrPrefix + ']' + @istrMsg
		END
		RAISERROR (@istrMsg , 0, 1) WITH NOWAIT
		--print @Msg
	END
	
	set @idateLastExec = @now

SET NOCOUNT OFF;
END