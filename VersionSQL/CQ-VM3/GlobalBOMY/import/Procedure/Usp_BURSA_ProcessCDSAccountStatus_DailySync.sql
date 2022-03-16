/****** Object:  Procedure [import].[Usp_BURSA_ProcessCDSAccountStatus_DailySync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_BURSA_ProcessCDSAccountStatus_DailySync]
AS
/***********************************************************************************             
            
Name              : import.Usp_BURSA_ProcessCDSAccountStatus_DailySync     
Created By        : Nathiya Palanisamy
Created Date      : 07/06/2021   
Last Updated Date :             
Description       : this sp is used to import CDS Account's Status from BURSA to GBO
            
Table(s) Used     : 
            
Modification History :  											
 
PARAMETERS
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors            
            
Used By : 
EXEC [import].[Usp_BURSA_ProcessCDSAccountStatus_DailySync]
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    DECLARE @ostrReturnMessage VARCHAR(4000);
    BEGIN TRY
    	BEGIN TRANSACTION
        
		-- CREATE IMPORT FORM DATA TABLE	
		--EXEC CQBTempDB.form.USP_CreateImportTable 1409;

		--TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1409;


        IF EXISTS (SELECT 1 FROM [GlobalBOMY].[import].[Tb_BURSA_CFT007]) 
        BEGIN
			DROP TABLE IF EXISTS #formMapping;

			SELECT ComponentID AS VirtualColumnName, ComponentIndex - 1 AS ColumnIndex 
			INTO #FormMapping 
			FROM CQBuilder.form.Udf_GetFields(1409, 1);

			EXEC form.Usp_CreateExportTable 1409, 'form.Tb_ExportFormDataDelta_'

			DECLARE @reftblName varchar(100) = 'CQBTempDB.[import].Tb_FormData_1409'
			declare @numOfCol bigint = (select count(1)  from #FormMapping);
			declare @i bigint = 0;
			declare @fieldId varchar(500);
			declare @query nvarchar(max) = '';

 

			
	set @query = 'insert into form.Tb_ExportFormDataDelta_1409 select DISTINCT RecordID, ''AutoExport'', GETDATE(), NULL, NULL, '
			while(@i < @numOfCol)
			begin
			    set @fieldId = (select VirtualColumnName from #FormMapping where ColumnIndex = @i);
			 
    set @query = @query + '[' + @fieldId +'], ';
			    set @i = @i + 1;
			end
			set @query = SUBSTRING(@query,0,LEN(@query));
			set @query = @query + ' FROM ' + @reftblName + ' AS F';
			set @query = @query + ' INNER JOIN [GlobalBOMY].[import].[Tb_BURSA_CFT007] AS S
			                        ON S.AccountNumber = F.[AccountNumber (textinput-5)]'
									--WHERE S.[Action-status] <> 
			                            
			--PRINT @query
			EXEC sp_executesql @query;

			-- UPDATE Import Form Data Table
			--UPDATE	I
			--SET		I.CDSAcctStatus = A.[Action-status]
			--FROM 
			--	CQBTempDB.[import].Tb_FormData_1409	I
			--INNER JOIN 
			--	[GlobalBOMY].[import].[Tb_BURSA_CFT007]	 A ON I.[CDSNo (textinput-19)] = A.AccountNumber
			--INNER JOIN
			--	form.Tb_ExportFromDataDelta_1409 D  ON D.[CDSNo (textinput-19)] = A.AccountNumber


		END
		
    	COMMIT TRANSACTION
    END TRY
    BEGIN CATCH

		 DECLARE @intErrorNumber INT
        ,@intErrorLine INT
        ,@intErrorSeverity INT
        ,@intErrorState INT
        ,@strObjectName VARCHAR(200)

		SELECT 
                  @intErrorNumber = ERROR_NUMBER(), 
                  @ostrReturnMessage = ERROR_MESSAGE(), 
                  @intErrorLine = ERROR_LINE(), 
                  @intErrorSeverity = ERROR_SEVERITY(), 
                  @intErrorState = ERROR_STATE(), 
                  @strObjectName = ERROR_PROCEDURE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; 

    	EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber, @ostrReturnMessage, @intErrorLine, @strObjectName,NULL, 'Process fail.';

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);           

    END CATCH

	SET NOCOUNT OFF;
END