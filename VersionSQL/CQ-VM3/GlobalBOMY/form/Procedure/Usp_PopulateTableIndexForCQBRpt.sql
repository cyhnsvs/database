/****** Object:  Procedure [form].[Usp_PopulateTableIndexForCQBRpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_PopulateTableIndexForCQBRpt]
    @inumFormId int,
    @iExportFormName VARCHAR(50) = 'GlobalBORpt.form.Tb_FormData_'
AS
/*
* Created by:      Jemariel Requina
* Date:            13 Dec 2018
* Used by:         CQBuilder     
* Called by:       
* Project UIN : 196154
* RFA No.   : 198015
*
* Purpose: This is sp is used to populate table index for export tables.
*
* Input Parameters:
    @inumFormId - form ID

 

* Output Parameters:
*
* Has been modified by + date + project UIN + note:
*  
*/
BEGIN
    SET NOCOUNT ON;
    SET ANSI_PADDING ON;

 

    BEGIN TRY
        DECLARE @tblName varchar(100) = @iExportFormName + cast(@inumFormId as varchar);
        DECLARE @query nvarchar(max) = '';

 

        -- DECLARE settings for the logging
        DECLARE @LogMsg varchar(8000) = '',
                @LastExec datetime = null,
                @Prefix varchar(50) = 'form.Usp_PopulateTableIndexForCQBRpt',
                @Enabled tinyint = 1;
    
        drop table if exists #fields;

 

        create table #fields
        ( 
          ComponentIndex int,
          ComponentTitle nvarchar(4000),
          ComponentID nvarchar(4000),
          ComponentLabel nvarchar(4000),
          Done tinyint
        )

 

        insert into #fields
        select ComponentIndex, ComponentTitle,ComponentID, ComponentLabel, 0 from [CQBuilder].[form].Udf_GetFields(@inumFormId, 1) order by ComponentIndex

 

        declare @fieldId varchar(4000)
        declare @fieldLabel varchar(4000)
		declare @fieldTitle varchar(4000)
 

        SET @LogMsg = 'Adding index';
        EXEC [CQBuilder].[form].[Usp_Logger] @LogMsg, @LastExec OUTPUT, @Prefix, @Enabled;

 

        while(exists(select 1 from #fields where [Done] = 0))
        begin
            select top 1 @fieldId = ComponentID, @fieldLabel = case when isnull(ComponentLabel,'') <> '' then ComponentLabel else ComponentID end,
						@fieldTitle = ComponentTitle			
			from #fields where [Done] = 0 order by ComponentIndex

 
            set @query = 'ALTER TABLE '+ @tblName + '
                            ADD ['+ [CQBuilder].[form].Udf_FilterStr(@fieldLabel) + ' (' + @fieldId +  ')] ' + (CASE WHEN @fieldTitle = 'Grid' THEN 'NVARCHAR(max)' ELSE 'NVARCHAR(4000)' END);
			--END
 
			--print @query;
            EXEC sp_executesql @query;

 

            update #fields set [Done] = 1 where ComponentID = @fieldId
        end

 

        SET @LogMsg = 'Index added.';
        EXEC [CQBuilder].[form].[Usp_Logger] @LogMsg, @LastExec OUTPUT, @Prefix, @Enabled;
    END TRY
    BEGIN CATCH 
        --print 'error'
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