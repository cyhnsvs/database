/****** Object:  Procedure [utilities].[usp_RethrowError]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [utilities].[usp_RethrowError]
	@istrErrorMessage NVARCHAR(2000) = ''
AS
/*********************************************************************************** 

Name              : utilities.usp_RethrowError
Created By        : Anita Chavan
Created Date      : 15/09/2014
Last Updated Date : 
Description       : Create the stored procedure to generate an error using RAISERROR. 
					The original error information is used to construct the msg_str for RAISERROR.

Table(s) Used     : 

Modification History :
	ModifiedBy :       Project UIN :				ModifiedDate :                      Reason :
	Anita			   GBO-SG00001-6.78				25/02/2016							Implemented.


PARAMETERS 
	@istrErrorMessage : - Append error message 

Used By : 

************************************************************************************/
BEGIN

	SET NOCOUNT ON;

    DECLARE @strErrorMessage	NVARCHAR(4000),
            @intErrorNumber		INT,

		    @intErrorSeverity   INT,
			@intErrorState      INT,
			@intErrorLine       INT,
			@strErrorProcedure  NVARCHAR(200);



	IF ERROR_NUMBER() IS NULL AND @istrErrorMessage = ''
    RETURN;


    SELECT  @intErrorNumber = ERROR_NUMBER(),
			@intErrorSeverity = ERROR_SEVERITY(),
			@intErrorState = ERROR_STATE(),
			@intErrorLine = ERROR_LINE(),
			@strErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

    IF @intErrorNumber IS NOT NULL


    BEGIN
		--SELECT @strErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ ERROR_MESSAGE();
		SELECT @strErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ ERROR_MESSAGE();			
		 
		
		IF @istrErrorMessage <> '' 
		BEGIN
			SET @strErrorMessage = @strErrorMessage + ' ' + @istrErrorMessage;
		END
		
		SET @strErrorMessage =  REPLACE( @strErrorMessage,'Error 50000, Severity 16, State 1, Procedure usp_RethrowError, Line','');	

		RAISERROR(
        @strErrorMessage, 
        @intErrorSeverity, 
        1,               
        @intErrorNumber,    -- parameter: original error number.
        @intErrorSeverity,  -- parameter: original error severity.
        @intErrorState,     -- parameter: original error state.
        @strErrorProcedure, -- parameter: original error procedure name.
        @intErrorLine       -- parameter: original error line number.
        );


    END
	ELSE
	BEGIN
		SET @istrErrorMessage = REPLACE( @istrErrorMessage,'Error 50000, Severity 16, State 1, Procedure usp_RethrowError, Line','');				
		RAISERROR(@istrErrorMessage,16,1)
	END


	SET NOCOUNT OFF;

END