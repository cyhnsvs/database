/****** Object:  Procedure [reports].[Usp_GetReportSettingsAndConfigByProcessID]    Committed by VersionSQL https://www.versionsql.com ******/

--EXEC [report].[Usp_GetReportSettingsAndConfigByProcessID] 1
CREATE PROCEDURE [reports].[Usp_GetReportSettingsAndConfigByProcessID] 
	@processId int = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_PADDING ON;    
	BEGIN TRY  

	SELECT 
	   RS.[ReportId]
      ,RS.[ReportName]
      ,RS.[Columns]
      ,RS.[Query]
      ,RS.[JsonQuery]
      ,RS.[GroupBy]
      ,RS.[AggregateBy]
      ,RS.[AggregateType]
      ,RS.[TableId]
	  ,RTC.[TableName]
      ,RTC.[SchemaName]
      ,RTC.[DatabaseName]
      ,RTC.[Connectionstring]
      ,RS.[CreatedBy]
      ,RS.[CreatedTime]
      ,RS.[UpdatedBy]
      ,RS.[UpdatedTime]
      ,RS.[GroupId]
      ,RS.[Status]
      ,RS.[RefId]
      ,RS.[Approver]
      ,RS.[ApprovalTime]
      ,RS.[ReportAccess]
      ,CONVERT(INT, RS.[LockRequired]) AS LockRequired
      ,RS.[ApproverGroupId]
      ,RS.[SourceType]
      ,CONVERT(INT, RS.[MultiLevelGrouping]) AS MultiLevelGrouping
	  FROM [CQBuilder].[report].[Tb_ReportSettings] RS
	LEFT JOIN [CQBuilder].[report].[Tb_ReportTableConfig] RTC on RTC.TableId=RS.TableId
	WHERE RS.ReportId=(
		SELECT SQLStatement FROM [reports].[Tb_ReportSetup] 
		WHERE IDD=(
			SELECT ReportID FROM [reports].[Tb_Process] WHERE IDD=@processId
			))	


	END TRY  
	BEGIN CATCH   
  
        --print 'error'  
        IF ERROR_NUMBER() IS NULL  
            RETURN;  
  
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);  
        SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');  
        SELECT @ErrorMessage = N'Error %d, Level %d, State %d,Procedure %s, Line %d, Message: '+ @ErrorMessage;  
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);  
              
    END CATCH  
  
  
SET NOCOUNT OFF;
END