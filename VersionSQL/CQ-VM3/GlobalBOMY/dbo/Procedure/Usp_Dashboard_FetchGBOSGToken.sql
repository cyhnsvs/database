/****** Object:  Procedure [dbo].[Usp_Dashboard_FetchGBOSGToken]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_Dashboard_FetchGBOSGToken]
AS
/*
* Created by: Nishanth Chowdhary
* Date		: 23 SEP 2016
* Used by	: GBOSG Dashboard
* Called by	: GBOSG Dashboard Application
*
* Purpose: This sp is used to fetch the status of the data download and processing packages, jobs and other processes.
*
* Input Parameters:
* NONE
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* Marvin 2017-08-22 + RFA 175656 + Combined the tabs to 1 select only
*/
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CurrentHour CHAR(5);
	SET @CurrentHour = CONVERT(CHAR(5),GETDATE(),114);

	--Summary
	SELECT [ProcessName] AS [Name]
		  ,[IDD] AS [ID]
		  ,[ProcessType] AS [Process Type]
		  ,[TokenType] AS [Token Type]
		  ,[InputProcID] AS [Input Process ID]
		  ,[OutputProcID] AS [Output Process ID]
		  ,[ProcStartTime] AS [Start Time]
		  ,[ProcEndTime] AS [End Time]
		  ,[UpdatedDateTime] AS [Updated Time]
		  ,[IsInputReady] AS [Is Input Ready]
		  ,CASE WHEN [ProcessStatus] = 0 AND @CurrentHour >= ProcEndTime THEN '<font color="red">Process Not Started - Delayed</font>'
				WHEN [ProcessStatus] = 1 AND @CurrentHour >= ProcEndTime THEN '<font color="red">Process Started - Delayed</font>'
				WHEN [ProcessStatus] = 3 THEN '<font color="red">Process failed</font>' END AS [Status]
		  ,[Remarks] AS [Remarks]
		  
	FROM [dbo].[Tb_GBOSGProcessToken]
	--WHERE ((([ProcessStatus] ='1' OR ([ProcessStatus] ='0' AND UpdatedDateTime < CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(ProcStartTime AS DATETIME))) 
	--		AND @CurrentHour >= ProcEndTime) 
	--		OR ProcessStatus='3')
	--		AND IsEnabled=1
	ORDER BY [Status], [ProcessType], [Updated Time] DESC;

	--SSIS
	SELECT 
		   [ProcessName] AS [Name]
		  ,[IDD] AS [ID]
		  ,ProcessType AS [TYPE]
		  ,ProcessDesc AS [Process Desc]
		  ,[TokenType] AS [Token Type]
		  ,[InputProcID] AS [Input Process ID]
		  ,[OutputProcID] AS [Output Process ID]
		  ,[ProcStartTime] AS [Start Time]
		  ,[ProcEndTime] AS [End Time]
		  ,[UpdatedDateTime] AS [Updated Time]
		  ,[IsInputReady] AS [Input Ready]
		  ,@CurrentHour AS [Current Time]
		  ,CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(ProcStartTime AS DATETIME) AS [Process Start Time]
		  ,CASE WHEN [ProcessStatus] = 0 AND @CurrentHour >= ProcEndTime AND (UpdatedDateTime IS NULL OR UpdatedDateTime < CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST(ProcStartTime AS DATETIME))
				THEN '<font color="red">Process Not Started - Delayed</font>'
				WHEN [ProcessStatus] = 0 AND @CurrentHour >= ProcEndTime THEN '<font color="red">Process Not Started - In Queue</font>'
				WHEN [ProcessStatus] = 0 AND @CurrentHour >= ProcStartTime AND @CurrentHour < ProcEndTime THEN '<font color="red">Data Not Ready</font>'
				WHEN [ProcessStatus] = 0 THEN '<font color="black">Scheduled to download @ ' + ProcStartTime + '</font>'
				WHEN [ProcessStatus] = 1 AND @CurrentHour >= ProcEndTime THEN '<font color="red">Process Started - Delayed</font>'
				WHEN [ProcessStatus] = 1 THEN '<font color="blue">Process started</font>'
			    WHEN [ProcessStatus] = 2 THEN '<font color="green">Process successful</font>'
			    WHEN [ProcessStatus] = 3 THEN '<font color="red">Process failed</font>' END AS [Status]
		  ,[Remarks] AS [Remarks]
		  ,[UITriggerInd] AS [UITriggerInd]
		  ,[IsTriggered] AS [Triggered]
		  ,UpdatedBy AS [Updated By]
	FROM [dbo].[Tb_GBOSGProcessToken] 
	WHERE IsEnabled = 1
	ORDER BY [Status], [Updated Time] DESC;
	

	SET NOCOUNT OFF;
END