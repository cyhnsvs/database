/****** Object:  Procedure [dbo].[Usp_Dashboard_FetchReportToken]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_Dashboard_FetchReportToken]
AS
/*
* Created by: Nishanth Chowdhary
* Date		: 06 NOV 2021
* Used by	: GBOSG Dashboard
* Called by	: GBOSG Dashboard Application
*
* Purpose: This sp is used to fetch the status of the report/file generation
*
* Input Parameters:
* NONE
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:

*/
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CurrentHour CHAR(5);
	SET @CurrentHour = CONVERT(CHAR(5),GETDATE(),114);
	
	--SELECT * FROM [GlobalBOMY].dbo.[Tb_GBOSGProcessToken]

	SELECT RS.Name, RS.FileNameSetup, RS.FileType, RS.DestinationPath, RS.ScheduleConfig, RS.SendEmail AS SendEmailIndicator, RS.EmailSetup AS EmailConfig, RS.ProcessTokenID AS ProcessDependencyIDs, RS.RefIDD AS FileDependencyIDs, 
			CASE WHEN P.[Status] = 0 AND P.ScheduleDate < DATEADD(MINUTE,30,GETDATE()) THEN '<font color="red">File Generation Not Started - Delayed</font>'
				WHEN P.[Status] = 9 AND P.RetryCount = P.MaxRetry THEN '<font color="red">File Generation Started - Issue in Populate Reports SP</font>'
				WHEN P.[Status] = 3 AND P.RetryCount = P.MaxRetry THEN '<font color="red">Process Failed</font>'
				WHEN P.[Status] = 5 AND P.RetryCount = P.MaxRetry THEN '<font color="red">Email Failed</font>'
				WHEN P.[Status] = 1 AND P.ScheduleDate < DATEADD(MINUTE,30,GETDATE()) THEN '<font color="red">Process Started - Delayed</font>' 
				WHEN P.[Status] = 1 THEN '<font color="green">Process In Progress</font>' 
				WHEN P.[Status] IS NULL THEN '<font color="black">Process Scheduled</font>'
				END AS ProcessStatus,
				ISNULL(P.Remarks,'') AS Remarks
	FROM reports.Tb_ReportSetup AS RS
	LEFT JOIN reports.Tb_Process AS P
	ON RS.IDD = P.IDD
	ORDER BY P.ScheduleDate;

	SET NOCOUNT OFF;
END