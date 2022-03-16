/****** Object:  Procedure [reports].[Usp_PopulateReportsDataByReportIDNotUsed]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_PopulateReportsDataByReportIDNotUsed]
(
	@ReportID int
)
AS
BEGIN
	SET NOCOUNT ON;

	
	declare @sql  nvarchar(max),@sql1  nvarchar(max),@sql2  nvarchar(max), @sql3 nvarchar(max)
	declare @rptIDD  bigint=0,@rptIDDMax  bigint=0
	declare @rptParamIDD bigint=0,@rptParamIDDMax bigint=0
	declare @LoopRptIDD  bigint=0;
	declare @isHoliday tinyint = (select [dbo].[Udf_CheckPublicHoliday](getdate()));

    IF OBJECT_ID('tempdb.dbo.#Tb_ReportSetup', 'U') IS NOT NULL
		drop table #Tb_ReportSetup

	CREATE TABLE #Tb_ReportSetup(
		  [IDD] [bigint] IDENTITY(1,1) NOT NULL,
		  [RptIDD] [bigint] NOT NULL,
		  [ScheduleConfig] xml null,
		  [LastExecutionDate] datetime null,
		  [NextScheduleDate] datetime null,
		  [Done] tinyint)

	insert into #Tb_ReportSetup ([RptIDD],[ScheduleConfig], [LastExecutionDate], [Done])
	select IDD, ScheduleConfig, LastExecutionDate, 0 as Done FROM reports.Tb_ReportSetup
	where IDD = @ReportID  --and idd IN(253,254,260)

	--select  [reports].[Udf_GetNextSchedule](ScheduleConfig, LastExecutionDate, 0) as NextSchedule, * from reports.Tb_ReportSetup WHERE idd in (446,447)

	--update reports.Tb_ReportSetup set LastExecutionDate = null where IDD IN (446,447)

	--select * from reports.Tb_ProcessParam

	update #Tb_ReportSetup
	set NextScheduleDate = [reports].[Udf_GetNextSchedule](ScheduleConfig, LastExecutionDate, 0)
	
	--update #Tb_ReportSetup
	--set NextScheduleDate =getdate()

	--select * from #Tb_ReportSetup --where NextScheduleDate is null

	delete from #Tb_ReportSetup where NextScheduleDate is null

	IF OBJECT_ID('tempdb.dbo.#Tb_ReportParamSetup', 'U') IS NOT NULL
		drop table #Tb_ReportParamSetup
	
	CREATE TABLE #Tb_ReportParamSetup(
		  [PIDD] [bigint] IDENTITY(1,1) NOT NULL,
		  [RptIDD] [bigint] NOT NULL,
		  [ParamName] [varchar](50) NOT NULL,
		  [ParamValueIsDerived] [varchar](1) NULL,
		  [ParamValue] [varchar](500) NULL,
		  [SQLStatement] [varchar](max) NULL,
		  [Done] tinyint
		  )
      
	insert into #Tb_ReportParamSetup (RptIDD, ParamName,ParamValueIsDerived,ParamValue, SQLStatement, [Done] )
	SELECT     P.RptIDD, P.ParamName,P.ParamValueIsDerived,P.ParamValue, P.SQLStatement, 0 as Done 
	FROM #Tb_ReportSetup A 
	inner join reports.Tb_ReportParamSetup P on A.[RptIDD]=P.RptIDD

	--SELECT * FROM #Tb_ReportParamSetup

	Select @rptIDDMax=MAX(IDD) from #Tb_ReportSetup

	--SELECT * FROM #Tb_ReportSetup
	--SELECT * FROM #Tb_ReportParamSetup

	WHILE (exists(select 1 from #Tb_ReportSetup where [Done] = 0))
	BEGIN  
		  select TOP 1 @rptIDD = [IDD], @LoopRptIDD = RptIDD FROM #Tb_ReportSetup where [Done] = 0
		  
		  -- CHECK IF REPORT HAS PARAMETERS
		  IF EXISTS(SELECT 1 FROM #Tb_ReportParamSetup WHERE RptIDD = @LoopRptIDD)
		  BEGIN
				set @rptParamIDDMax   = 0 ; 
				SELECT @rptParamIDD = [PIDD] from #Tb_ReportParamSetup
				SELECT @rptParamIDDMax =MAX(PIDD) from #Tb_ReportParamSetup where RptIDD=@LoopRptIDD
				set @sql=''
				set @sql1 = 'select ROW_NUMBER() OVER(ORDER BY @ORDERBY@ ASC) AS ProcID @column@  from @TABLE@'
				set @sql2 = 'declare @rptProcIDDMax bigint =(SELECT ISNULL(MAX(IDD), 0) FROM REPORTS.Tb_Process) INSERT INTO [reports].[Tb_Process] ([IDD], [ReportID], [ScheduleDate], [Status],[CreatedBy],[CreatedDate]) select @rptProcIDDMax  + ProcID, @RptIDD@ ,''@ScheduleDate'', ProcStatus, ''SYSTEM'', getdate() from #Tb_ReportProc  INSERT INTO [reports].[Tb_ProcessParam] ([ProcessID],[ParamName],[ParamValue],[CreatedBy],[CreatedDate]) SELECT @rptProcIDDMax  + ProcID, ParamName, ParamValue, ''System'', getdate()  FROM ( @union@ ) A order by 1,2'
			----------------------------------------------------------------------------------------
			WHILE EXISTS(SELECT 1 FROM #Tb_ReportParamSetup WHERE RptIDD = @LoopRptIDD and [Done] = 0)
			BEGIN  
				select top 1 @rptParamIDD = [PIDD] from #Tb_ReportParamSetup where RptIDD = @LoopRptIDD and [Done] = 0
				
				--SET @rptParamIDD += 1;
				select @sql = @sql + ' IF OBJECT_ID(''tempdb.dbo.#Tb_'+  ParamName + ''', ''U'') IS NOT NULL Drop TABLE #Tb_'+ ParamName from #Tb_ReportParamSetup where RptIDD=@LoopRptIDD AND PIDD=@rptParamIDD
				select @sql = @sql + ' CREATE TABLE #Tb_'+ ParamName + '(RptIDD'+ CAST( PIDD as varchar)  + ' BIGINT DEFAULT ' + CAST(RptIDD As varchar)+ ', ParamName'+ CAST( PIDD as varchar)  + ' varchar(50)  DEFAULT ''' + ParamName + ''','+ ParamName +' varchar(50))' from #Tb_ReportParamSetup where RptIDD=@LoopRptIDD AND PIDD=@rptParamIDD
				select @sql = @sql + ' INSERT INTO #Tb_'+ ParamName + '('+ ParamName +' ) ' + CASE WHEN ParamValueIsDerived='Y' THEN SQLStatement ELSE 'SELECT '+ ParamValue END   from #Tb_ReportParamSetup where RptIDD=@LoopRptIDD AND PIDD=@rptParamIDD
				select @sql1 = REPLACE (REPLACE (REPLACE (@sql1 ,'@column@', ',A'+ CAST( PIDD as varchar) + '.* @column@ ' ) ,'@TABLE@', '#Tb_'+ ParamName + ' A' + CAST( PIDD as varchar)  +', @TABLE@' ) ,'@ORDERBY@', 'RptIDD'+ CAST( PIDD as varchar) )  from #Tb_ReportParamSetup where RptIDD=@LoopRptIDD AND PIDD=@rptParamIDD
				select @sql2 = REPLACE (@sql2 ,'@RptIDD@', 'RptIDD'+ CAST( PIDD as varchar) )  from #Tb_ReportParamSetup where RptIDD=@LoopRptIDD AND PIDD=@rptParamIDD
				select @sql2 = REPLACE (@sql2 ,'@union@', 'Select ProcID, ParamName'+ CAST( PIDD as varchar) +' as ParamName, ['+ ParamName +'] as ParamValue from #Tb_ReportProc UNION ALL @union@ ' )   from #Tb_ReportParamSetup where RptIDD=@LoopRptIDD AND PIDD=@rptParamIDD
                select @sql2 = REPLACE(@sql2, '@ScheduleDate', CONVERT(VARCHAR(50), NextScheduleDate,121)) FROM #Tb_ReportSetup where RptIDD = @LoopRptIDD
				
				UPDATE #Tb_ReportParamSetup SET [Done] = 1 where [PIDD] = @rptParamIDD
				          
				IF NOT EXISTS(SELECT 1 FROM #Tb_ReportParamSetup WHERE RptIDD = @LoopRptIDD and [Done] = 0)
				BEGIN
						SET @sql1 = 'IF OBJECT_ID(''tempdb.dbo.#Tb_ReportProc'', ''U'') IS NOT NULL Drop TABLE #Tb_ReportProc ' + REPLACE (REPLACE (@sql1 ,'@column@', ' ,''0'' AS ProcStatus into #Tb_ReportProc') ,', @TABLE@', '' )
						SET @sql2 = REPLACE (@sql2 ,'UNION ALL @union@','' )
						SET @sql = @sql + ' ' + @sql1 + ' ' + @sql2
						--select @sql
						--print  '2 - '  + CAST(@rptIDD AS VARCHAR) + ' - ' + cast(@LoopRptIDD as varchar)
						--select @sql
						--print @sql
						EXECUTE sp_executesql @sql
				END 
			END
		 END
		 ELSE
		 BEGIN	
			set @sql2 = 'INSERT INTO [reports].[Tb_Process] ([IDD], [ReportID],[ScheduleDate],[Status],[CreatedBy],[CreatedDate]) select (SELECT ISNULL(MAX(IDD),0) + 1 FROM REPORTS.Tb_Process), [RptIDD],''@ScheduleDate'' ,0, ''SYSTEM'', getdate() from #Tb_ReportSetup where [RptIDD] = ''@RptIDD@''';
			set @sql2 = REPLACE(@sql2, '@RptIDD@', @LoopRptIDD)
			select @sql2 = REPLACE(@sql2, '@ScheduleDate', CONVERT(VARCHAR(50), NextScheduleDate,121)) FROM #Tb_ReportSetup where RptIDD = @LoopRptIDD
			--select @sql2
			--print  '3 - '  + CAST(@rptIDD AS VARCHAR) + ' - ' + cast(@LoopRptIDD as varchar)
			EXECUTE sp_executesql @sql2
			----------------------------------------------------------------------------------------
		END	
		  --PRINT @rptIDD;
		 update #Tb_ReportSetup set [Done] = 1 where [IDD] = @rptIDD 
	END
	
	update a
	set a.RetryCount = 0,
		a.MaxRetry = xmlData.a.value('(NoOfRetry/@value)[1]', 'nvarchar(max)'),
		a.DependencyReportID = b.RefIDD
	from reports.Tb_Process as a 
	join reports.Tb_ReportSetup as b on a.ReportID = b.IDD
	cross apply b.ScheduleConfig.nodes('config') xmlData(a) 
END