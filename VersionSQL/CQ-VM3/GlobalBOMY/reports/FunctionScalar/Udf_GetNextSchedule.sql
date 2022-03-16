/****** Object:  Function [reports].[Udf_GetNextSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jemariel Requina
-- Create date: 2018-05-04
-- Description:	Parse the schedule config of report generator tool.

-- Param:
-- @xml xml - schedule config of the report
-- @lastExecutionDate datetime - last execution date of the report
-- @isHoliday tinyint - flag if current day is a holiday or not

-- Returns: Next Schedule Date or null if config doesn't meet the criteria
-- =============================================
CREATE FUNCTION [reports].[Udf_GetNextSchedule]
(
	@xml xml,
	@lastExecutionDate datetime,
	@isHoliday tinyint = 0
)
RETURNS datetime
AS
BEGIN
	
	declare @currentDay date = GETDATE();
	--MY CHANGES
	--declare @nextRunDate datetime = null
      declare @nextRunDate VARCHAR(50);

	--declare @lastDayOfMonth datetime = EOMONTH(getdate());
	declare @lastDayOfMonth datetime = (select convert(datetime,convert(date,dateadd(dd,-(day(dateadd(mm,1,@currentDay))),dateadd(mm,1,@currentDay)),100),100))
	declare @lastWeek int = (select datediff(week, dateadd(week, datediff(week, 0, dateadd(month, datediff(month, 0, @lastDayOfMonth), 0)), 0), @lastDayOfMonth - 1) + 1)
	declare @currentWeek int = (select datediff(week, dateadd(week, datediff(week, 0, dateadd(month, datediff(month, 0, @currentDay), 0)), 0), getdate() - 1) + 1)
	
	declare @lastWorkingDayOfMonth datetime = (SELECT CASE WHEN DATENAME(dw,@lastDayOfMonth) IN ('Saturday','Sunday') THEN (SELECT PreviousBusinessDate FROM GlobalBO.[global].[Udf_GetPreviousBusinessDate](@lastDayOfMonth)) ELSE @lastDayOfMonth END)

	declare @Results table 
		(Frequency nvarchar(max),
		 RunOnPublicHoliday nvarchar(max),
		 StartDate date,
		 EndDate date,
		 StartTime nvarchar(max),
		 EstimatedDuration nvarchar(max),
		 NoOfRetry nvarchar(max),
		 DailyReoccurInterval int,
		 WeeklyDaysTriggeredOn nvarchar(max),
		 MonthlyMonthsTriggeredOn nvarchar(max),
		 MonthlyConfig1DaysTriggeredOn nvarchar(max),
		 MonthlyConfig2WeeksTriggeredOn nvarchar(max),
		 MonthlyConfig2DaysTriggeredOn nvarchar(max)
	)

	insert into @Results
	select 
	  xmlData.a.value('(Frequency/@value)[1]', 'nvarchar(max)') AS Frequency,
	  xmlData.a.value('(RunOnPublicHoliday/@value)[1]', 'tinyint') AS RunOnPublicHoliday,
	  xmlData.a.value('(StartDate/@value)[1]', 'date') AS StartDate,
	  case 
		when xmlData.a.value('(EndDate/@value)[1]', 'date') = '1900-01-01' then @currentDay
		else xmlData.a.value('(EndDate/@value)[1]', 'date')
	  end as EndDate,
	  xmlData.a.value('(StartTime/@value)[1]', 'nvarchar(max)') AS StartTime,
	  xmlData.a.value('(EstimatedDuration/@value)[1]', 'nvarchar(max)') AS EstimatedDuration,
	  xmlData.a.value('(NoOfRetry/@value)[1]', 'nvarchar(max)') AS NoOfRetry,
	  xmlData.a.value('(Daily/ReoccurInterval/@value)[1]', 'int') AS DailyReoccurInterval,
	  xmlData.a.value('(Weekly/DaysTriggeredOn/@value)[1]', 'nvarchar(max)') AS WeeklyDaysTriggeredOn,
	  ',' + xmlData.a.value('(Monthly/MonthsTriggeredOn/@value)[1]', 'nvarchar(max)') + ',' AS MonthlyMonthsTriggeredOn,
	  --REPLACE(',' + xmlData.a.value('(Monthly/config1/DaysTriggeredOn/@value)[1]', 'nvarchar(max)') + ',', 'Last', cast(DATEPART(dd,@lastDayOfMonth) as varchar)) AS MonthlyConfig1DaysTriggeredOn,
	  --REPLACE(REPLACE(',' + xmlData.a.value('(Monthly/config1/DaysTriggeredOn/@value)[1]', 'nvarchar(max)') + ',', 'Last', cast(DATEPART(dd,@lastDayOfMonth) as varchar)), 'LastBus', cast(DATEPART(dd,@lastWorkingDayOfMonth) as varchar)) AS MonthlyConfig1DaysTriggeredOn,
	  REPLACE(REPLACE(',' + xmlData.a.value('(Monthly/config1/DaysTriggeredOn/@value)[1]', 'nvarchar(max)') + ',', 'LastBus', cast(DATEPART(dd,@lastWorkingDayOfMonth) as varchar)), 'Last', cast(DATEPART(dd,@lastDayOfMonth) as varchar)) AS MonthlyConfig1DaysTriggeredOn,
	  REPLACE(',' + xmlData.a.value('(Monthly/config2/WeeksTriggeredOn/@value)[1]', 'nvarchar(max)') + ',', 'Last',@lastWeek) AS MonthlyConfig2TriggerOn,
	  ',' + xmlData.a.value('(Monthly/config2/DaysTriggeredOn/@value)[1]', 'nvarchar(max)') + ',' AS MonthlyConfig2DaysTriggeredOn
	from @xml.nodes('config') xmlData(a)

	-- set the default value of nextRunDate
	select @nextRunDate = cast(@currentDay as varchar) + ' ' +  LEFT(StartTime,2) + ':' + right(StartTime, 2) + ':00'
	from @Results where @currentDay between StartDate and EndDate and ((RunOnPublicHoliday = 1 and @isHoliday = 1) or @isHoliday = 0)

	IF(EXISTS(SELECT 1 FROM @Results where Frequency = 'OneTime'))
	BEGIN
		-- set the nextRunDate to null if LastExecutionDate is not null
		select @nextRunDate = null from @Results
		where @lastExecutionDate is not null
	END
	ELSE IF(EXISTS(SELECT 1 FROM @Results where Frequency = 'Daily'))
	BEGIN
		-- set the nextRunDate to null if lastRunDate + DailyReoccurInterval is not equal to current date
		select @nextRunDate = null from @Results
		where @nextRunDate is not null and CAST(DATEADD(DAY, DailyReoccurInterval, CAST(ISNULL(@lastExecutionDate, DATEADD(DAY,-1, cast(@lastExecutionDate as date))) AS DATE)) AS DATE) <> @currentDay 
	END
	ELSE IF(EXISTS(SELECT 1 FROM @Results where Frequency = 'Weekly'))
	BEGIN
		-- set the nextRunDate to null if Current Day is not included in the WeeklyDaysTriggeredOn
		select @nextRunDate = null from @Results
		where @nextRunDate is not null and charindex(cast(datepart(dw, @currentDay) as varchar), WeeklyDaysTriggeredOn) = 0
	END
	ELSE IF(EXISTS(SELECT 1 FROM @Results where Frequency = 'Monthly'))
	BEGIN
		select @nextRunDate = null from @Results
		where @nextRunDate is not null and 
		(
			-- check if Current Month is excluded in MonthlyMonthsTriggeredOn
			charindex(',' + cast(datepart(mm, @currentDay) as varchar) + ',', MonthlyMonthsTriggeredOn) = 0
			or
			(
			 -- check if Current Month is included in MonthlyMonthsTriggeredOn
			 charindex(',' + cast(datepart(mm, @currentDay) as varchar) + ',', MonthlyMonthsTriggeredOn) <> 0 and 
			 (
				-- check if Current Day is excluded in MonthlyConfig1DaysTriggeredOn
				charindex(',' + cast(datepart(dd, @currentDay) as varchar) + ',', MonthlyConfig1DaysTriggeredOn) = 0 and
				(
					-- check if Current Day is excluded in MonthlyConfig1DaysTriggeredOn
					charindex(',' + cast(@currentWeek as varchar) + ',', MonthlyConfig2WeeksTriggeredOn) = 0 or 
					( 
					-- check if Current Day is included in MonthlyConfig1DaysTriggeredOn and CurrentDay is excluded in MonthlyConfig2DaysTriggeredOn
					charindex(',' + cast(@currentWeek as varchar) + ',', MonthlyConfig2WeeksTriggeredOn) <> 0 and
					charindex(',' + cast(datepart(dw, @currentDay) as varchar) + ',', MonthlyConfig2DaysTriggeredOn) = 0
					)
			   )
			 )
			)
		 )
	END

	return @nextRunDate;
	--select datepart(dw, getdate()) as CurrentDay, datediff(week, dateadd(week, datediff(week, 0, dateadd(month, datediff(month, 0, getdate()), 0)), 0), getdate() - 1) + 1 as CurrentWeek, @nextRunDate as NextRunDate, * from #Results
END