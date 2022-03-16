/****** Object:  Procedure [form].[Usp_CreateExportTable]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_CreateExportTable](  
	@inumFormId int,
	@iExportFormName VARCHAR(50) = 'form.Tb_ExportFormData_'
  )
AS  
/*
* Created by:      Jemariel Requina
* Date:            04 Sep 2017
* Used by:         GBO Form Builder     
* Called by:       
* Project UIN : 
* RFA No.   : 
*
* Purpose: This sp is used to create temp table for the form builder. This is usually called upon import of data to formbuilder.
*
* Input Parameters:
* @inumFormID - Form id
* @type - 0 : Import tables
*         1 : Storage tables

* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
*  
*/

BEGIN  
SET NOCOUNT ON;
SET ANSI_PADDING ON;

BEGIN TRY

	DECLARE @tblName varchar(100) = @iExportFormName + cast(@inumFormId as varchar);
	declare @query nvarchar(max) = '';

	-- DECLARE settings for the logging
	DECLARE @LogMsg varchar(8000) = '',
			@LastExec datetime = null,
			@Prefix varchar(50) = 'form.Usp_CreateExportTable',
			@Enabled tinyint = 1;
	
	IF OBJECT_ID (@tblName, N'U') IS NOT NULL
	BEGIN
		SET @query = 'DROP TABLE ' + @tblName;
		EXEC sp_executesql @query;

		SET @LogMsg = 'Dropped existing table - ' + @tblName;
		EXEC [CQBuilder].[form].[Usp_Logger] @LogMsg, @LastExec OUTPUT, @Prefix, @Enabled;
	END

	SET @LogMsg = 'Creating table - ' + @tblName;
	EXEC [CQBuilder].[form].[Usp_Logger] @LogMsg, @LastExec OUTPUT, @Prefix, @Enabled;



	SET @query = '
		CREATE TABLE ' + @tblName + '(
			[RecordID] [bigint] PRIMARY KEY,
			[CreatedBy] [varchar](50) NOT NULL,
			[CreatedTime] [datetime] NOT NULL,
			[UpdatedBy] [varchar](50) NULL,
			[UpdatedTime] [datetime] NULL
	   ) ON [PRIMARY]'	
	EXEC sp_executesql @query;

	SET @LogMsg = 'Table created - ' + @tblName;
	EXEC [CQBuilder].[form].[Usp_Logger] @LogMsg, @LastExec OUTPUT, @Prefix, @Enabled;

	--populate table index
	EXEC form.Usp_PopulateTableIndexForExport @inumFormId, @iExportFormName;

END TRY

BEGIN CATCH 

    print 'error'
	IF ERROR_NUMBER() IS NULL
		RETURN;

	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);
	SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');
	SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
	RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
	        
END CATCH

SET NOCOUNT OFF;
SET ANSI_PADDING OFF;
END