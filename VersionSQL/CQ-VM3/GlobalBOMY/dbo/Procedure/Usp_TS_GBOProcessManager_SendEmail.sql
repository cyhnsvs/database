/****** Object:  Procedure [dbo].[Usp_TS_GBOProcessManager_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_TS_GBOProcessManager_SendEmail]
AS  
/*
* Created by:      Nishanth
* Date:            26 Sep 2016
* Used by:         GBO Process 
* Called by:       GBO Batch Process Manager Monitor
* Project UIN:	   ITSR 130775
* RFA:			   RFA 157866
*
* Purpose: This sp is used to send email alert for delayed and failed processes.
*
* Input Parameters:
* NONE
*
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* 1.  
*/

BEGIN  
SET NOCOUNT ON;

DECLARE @strCurrentDayOfWeek CHAR(1);
SET @strCurrentDayOfWeek = CONVERT(CHAR(1), DATEPART(WEEKDAY, GETDATE()));

DECLARE @CurrentHour CHAR(5);
SET @CurrentHour = CONVERT(CHAR(5), GETDATE(), 114);

IF EXISTS (SELECT 1 FROM dbo.Tb_GBOSGProcessToken WITH (NOLOCK) 
		   WHERE (ProcessStatus IN ('1','3') 
					OR (ProcessStatus = '0' AND (UpdatedDateTime IS NULL OR UpdatedDateTime < CAST(CAST(GETDATE() AS DATE) AS VARCHAR) + ' ' + ProcStartTime))
				) 
		 AND @CurrentHour > ProcEndTime AND IsEnabled = 1
		 AND (PHIndicator = 'Y' OR (PHIndicator = 'N' AND [dbo].[Udf_CheckPublicHoliday](GETDATE()) = 0))
		 AND FrequencyValue LIKE '%,' + @strCurrentDayOfWeek + ',%'
	)
	--OR EXISTS (
	--	SELECT 1 FROM reports.Tb_Process AS P
	--	 INNER JOIN reports.Tb_ReportSetup AS RS
	--	 ON P.ReportID = RS.IDD
	--	 WHERE ([Status] IN (0,1) AND ScheduleDate < DATEADD(MINUTE,30,GETDATE()))
	--		OR ([Status] IN (9,3,5) AND RetryCount = MaxRetry)
	--)
BEGIN
	DECLARE @strMailBody VARCHAR(MAX);
	DECLARE @strFrom VARCHAR(200);  
	DECLARE @strTo VARCHAR(200);           
	DECLARE @strMailSubject VARCHAR(200); 
	
	SET @strMailBody = '';
	
	SET @strMailBody = '<HTML><HEAD><style type="text/css"> table{ border-collapse:collapse; border:1px solid black; } table td{ border:1px solid black; } table th{ background-color:#BFB6F2;border:1px solid black;} </style> </HEAD>'
	SET @strMailBody = @strMailBody + '<TABLE><TR><th>Process Name</th><th>Process Type</th><th>Start Time</th><th>End Time</th><th>Status</th><th>Remarks</th></TR>'
	SELECT @strMailBody = @strMailBody + '<TR><TD>' 
						+ ProcessName + '</TD><TD>' 
						+ ProcessType + '</TD><TD>' 
						+ ProcStartTime + '</TD><TD>' 
						+ ProcEndTime + '</TD><TD>' 
						+ CASE WHEN [ProcessStatus] = 0 AND @CurrentHour >= ProcEndTime THEN '<font color="red">Process Not Started - Delayed</font>'
							   WHEN [ProcessStatus] = 0 AND @CurrentHour >= ProcStartTime AND @CurrentHour < ProcEndTime THEN '<font color="red">Data Not Ready</font>'
							   WHEN [ProcessStatus] = 0 THEN '<font color="black">Scheduled to download @ ' + ProcStartTime + '</font>'
							   WHEN [ProcessStatus] = 1 AND @CurrentHour >= ProcEndTime THEN '<font color="red">Process Started - Delayed</font>'
							   WHEN [ProcessStatus] = 1 THEN '<font color="blue">Process started</font>'
							   WHEN [ProcessStatus] = 2 THEN '<font color="green">Process successful</font>'
							   WHEN [ProcessStatus] = 3 THEN '<font color="red">Process failed</font>' END + '</TD><TD>'
						+ Remarks +'</TD></TR>'
	FROM dbo.Tb_GBOSGProcessToken WITH(NOLOCK)
	WHERE (
		ProcessStatus IN ('1','3') 
		OR (ProcessStatus = '0' AND (UpdatedDateTime IS NULL OR UpdatedDateTime < CAST(CAST(GETDATE() AS DATE) AS VARCHAR) + ' ' + ProcStartTime))) 
			AND @CurrentHour > ProcEndTime
			AND IsEnabled = 1
			AND (PHIndicator = 'Y' OR (PHIndicator = 'N' AND [dbo].[Udf_CheckPublicHoliday](GETDATE()) = 0))
			AND FrequencyValue LIKE '%,' + @strCurrentDayOfWeek + ',%';

	--SELECT @strMailBody = @strMailBody + '<TR><TD>' 
	--					+ [Name] + '</TD><TD>' 
	--					+ 'EXPORT FILE' + '</TD><TD>' 
	--					+ ScheduleDateTime + '</TD><TD>' 
	--					+ '00:00' + '</TD><TD>' 
	--					+ CASE WHEN [Status] = 0 AND ScheduleDate < DATEADD(MINUTE,30,GETDATE()) THEN '<font color="red">Process Not Started - Delayed</font>'
	--						   WHEN [Status] = 9 AND RetryCount = MaxRetry THEN '<font color="red">Process Not Started - Issue in Populate Reports SP</font>'
	--						   WHEN [Status] = 3 AND RetryCount = MaxRetry THEN '<font color="red">Process failed</font>'
	--						   WHEN [Status] = 5 AND RetryCount = MaxRetry THEN '<font color="red">Email failed</font>'
	--						   WHEN [Status] = 1 AND ScheduleDate < DATEADD(MINUTE,30,GETDATE()) THEN '<font color="red">Process Started - Delayed</font>' END + '</TD><TD>'
	--					+ Remarks +'</TD></TR>'
	--FROM 
	--	(SELECT DISTINCT RS.[Name], ScheduleDate, CAST(CAST(ScheduleDate as time) as varchar) AS ScheduleDateTime, [Status], ISNULL(P.Remarks,'') AS Remarks, RetryCount, MaxRetry
	--	 FROM reports.Tb_Process AS P
	--	 INNER JOIN reports.Tb_ReportSetup AS RS
	--	 ON P.ReportID = RS.IDD
	--	 WHERE ([Status] IN (0,1) AND ScheduleDate < DATEADD(MINUTE,30,GETDATE()))
	--		OR ([Status] IN (9,3,5) AND RetryCount = MaxRetry)) AS P;

	set @strMailBody = @strMailBody +'</TABLE></HTML>';

	SELECT @strTo = ToEmails,
			@strMailSubject = SubTxt,
			@strFrom = Sendername
	FROM Setup.tb_EmailAlert  
	WHERE ModeDefinition = 'GBOMYPrMgr' AND IsActive = 1;
	
	IF ISNULL(@strFrom,'')=''  
	SET   @strFrom='ITDevGBOMY<ITDevGBOMY@cyberquote.com.sg>';  
	IF ISNULL(@strTo,'')=''  
	SET   @strTo='nishanthc@cyberquote.com.sg';     
	IF ISNULL(@strMailSubject,'')=''            
	SET @strMailSubject='GBOSG Process Manager: Process Failed/Delayed';  
		  
	SET @strMailBody = '<b>Hi All, <font color=RED><br><br>The below processes have failed or are delayed.<br> Please inform the necessary parties and monitor the status...<br><br></font>' + @strMailBody +'</b>';

	EXEC [master].[dbo].DBA_SendEmail
	@istrMailTo             = @strTo,
	@istrMailBody           = @strMailBody,
	@istrMailSubject        = @strMailSubject,
	@istrfrom_address       = @strFrom,
	@istrreply_to           = @strFrom,
	@istrbody_format        = 'HTML';

END

SET NOCOUNT OFF;
END