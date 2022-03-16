/****** Object:  Procedure [reports].[Usp_DequeueReports]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_DequeueReports]
	@batchSize int,
	@ip varchar(50),
	@instanceName varchar(50),
	@thread varchar(50)
--exec [reports].[Usp_DequeueReports]@batchSize =1,	@ip='134.34.3.9',	@instanceName ='Instance09',	@thread='2'
AS
BEGIN
	SET NOCOUNT ON;

	declare @retryAfterSeconds int = 120;
	declare @process table (processId bigint);
	
	declare @isHoliday tinyint = (select [dbo].[Udf_CheckPublicHoliday](getdate()));
	--RESET TIMEOUT REPORTS
	UPDATE reports.Tb_Process
	SET Status=0, RetryCount=0
	WHERE Remarks='The operation has timed out' AND Status = 3 AND RetryCount = 3;

    UPDATE TOP (@batchSize) a
	WITH (
			UPDLOCK
			,READPAST
			)
	SET STATUS = 1,
	a.ProcessByIP = @ip,
	a.ProcessByInstanceName = @instanceName,
	a.ProcessByThread = @thread,
	a.ProcessStarted = getdate(),
	a.RetryCount = RetryCount + 1
	OUTPUT inserted.IDD into @process
	FROM (SELECT TOP 1000000000 * FROM reports.Tb_Process ORDER BY ReportID) AS a
	WHERE 
	--RetryCount < MaxRetry
	ISNULL(RetryCount,0) < ISNULL(MaxRetry ,3)
	 and Getdate() >= ScheduleDate and
	       -- filter the report with status = 0 or all failed report after 2 minutes
		  ([Status] = 0 or ([Status] = 3 and DATEDIFF(SECOND, UpdatedDate, GETDATE()) >= @retryAfterSeconds)) and 
		  -- check if there is no dependency report before this report is executed
		  --not exists(select 1 from reports.Tb_Process as p where p.ReportID = isnull(a.DependencyReportID,0) and Status <> 2)
		  not exists(
			select 1 from 
			reports.Tb_Process as p 
			cross apply string_split(ISNULL(a.DependencyReportID,''), ',') as d
			where p.ReportID = ISNULL(d.value,0) and Status <> 2
		)  
		  -- --token checking
		  and not exists (select 1 from reports.Tb_Process as p
				         join reports.Tb_ReportSetup as r
						  on p.ReportID = r.IDD
						  cross apply string_split(ISNULL(r.ProcessTokenID,''), ',') as d
						  left join dbo.Tb_GBOSGProcessToken as pro
						  on d.Value = pro.IDD
						   where r.IDD = a.ReportID and ((isnull(pro.ProcessStatus,2) <> 2 and @isHoliday=0) or (isnull(pro.ProcessStatus,2) = 0 and @isHoliday=1 AND pro.PHIndicator='Y')))--and isnull(pro.ProcessStatus,2) <> 2)

	--DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');
		drop table if exists #Tb_Report

		CREATE TABLE #Tb_Report(
		ProcessID [bigint],
		ReportID [bigint],
		ReportName [varchar](100) ,
		ReportType [varchar](50),
		[SSRSPath] [varchar](500) ,
		[SQLStatement] [varchar](max) ,
		[DestinationPath] [varchar](500) ,
		[FileType] [varchar](20) ,
		[FileNameSetup] [varchar](100) ,
		[IncludeHeader] [tinyint] ,
		[SendEmail] [tinyint] ,
		[Archive] [tinyint] ,
		[FileDelimiter] [varchar](10) ,
		[EOLStr] [varchar](20) ,
		[CodePage] [int]	
		,RecipientId varchar(500)
		,RecipientType varchar(8000))
	
	insert into #Tb_Report ([ProcessID], [ReportID], [ReportName],[ReportType], [SSRSPath], [SQLStatement], [DestinationPath], [FileType], [FileNameSetup], [IncludeHeader], [SendEmail],[Archive] , [FileDelimiter], [EOLStr], [CodePage], RecipientId ,RecipientType)
	select
		 qm.IDD as ProcessID
		,qm.ReportID
		,rs.Name as ReportName
		,rs.ReportType
		,rs.SSRSPath
		,rs.SQLStatement
		,rs.DestinationPath as DestinationPath
		--,rs.DestinationPath + CAST(@dteBusinessDate as varchar) + '\' as DestinationPath
		,rs.FileType
		,rs.FileNameSetup
		,rs.IncludeHeader
		,rs.SendEmail
		,rs.Archive
		,rs.FileDelimiter
		,rs.EOLStr
		,rs.[Encoding] as [CodePage]
		, ISNULL(PrP.ParamValue,'') RecipientId 
		, ISNULL(prp.ParamName,'') RecipientType
	FROM reports.Tb_Process AS qm
	INNER JOIN reports.Tb_ReportSetup as rs on qm.ReportID = rs.IDD
	left join reports.Tb_ProcessParam PrP on qm.IDD=PrP.ProcessID and PrP.ParamName in ('istrAcctNo','istrMRCode')
	WHERE qm.IDD in (select processId from @process); 
 
		drop table if exists #temp;

		select 
			T.*,  
			'{' + ISNULL(prp.ParamName,'') + '}' ParamName, ISNULL(PrP.ParamValue,'') ParamValue , ISNULL(PrP.IDD,'') IDD  ,ROW_NUMBER() OVER(PARTITION BY ISNULL(PrP.ProcessID,t.ProcessID) ORDER BY ISNULL(PrP.IDD,1) desc) AS RowNo 
		into 
			#temp
		from 
			#Tb_Report T
			left join reports.Tb_ProcessParam as PrP on t.ProcessID=PrP.ProcessID

		order by 
			PrP.ProcessID,PrP.IDD asc
		 
		 declare @AttachReport varchar(4000) = null,
				@ProcessID bigint= null;
				;with A as 
				(     select top 1000000 * From #temp order by Processid, IDD)
		UPDATE A set
            @AttachReport = A.FileNameSetup = CASE WHEN @ProcessID = A.ProcessID THEN REPLACE (@AttachReport,  A.ParamName,A.ParamValue) ELSE  REPLACE (A.FileNameSetup,  A.ParamName,A.ParamValue) END,
			@ProcessID = A.ProcessID;        

	  -- update #temp set 
		--	FileNameSetup =  REPLACE (FileNameSetup,'{BranchCd}',ISNULL(NULLIF((select top 1 [Branch (selectsource-0)] From form.Tb_ExportFormData_674 where [MarketingID (textinput-0)]=RecipientId and [IsActive (textinput-17)]='Y'),''),'NoBranch'))
			
		--where 
			--RecipientType='AECode' and  RowNo=1;
		
		select 
		[ProcessID], [ReportID], [ReportName],[ReportType], [SSRSPath], [SQLStatement], [DestinationPath], [FileType], [FileNameSetup], [IncludeHeader], [SendEmail],[Archive] , [FileDelimiter], [EOLStr], [CodePage] From #temp where RowNo=1;
		
	select
	     rp.ProcessID 
	    ,rp.ParamName
		,rp.ParamValue
	 from reports.Tb_ProcessParam AS rp
	 where rp.ProcessID in (select processId from @process);
END