/****** Object:  Function [report].[Udf_PrevWorkingDate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [report].[Udf_PrevWorkingDate]
(
	@inputDate date
)
RETURNS date
AS
BEGIN
	declare @checkDate date
	declare @isLoop int = 1

	select @checkDate = @inputDate

	while @isLoop = 1
	begin
		select @checkDate = (select top 1 PreviousBusinessDate from GlobalBO.global.Udf_GetPreviousBusinessDate(@checkDate))
	
		if exists (select 1 from GlobalBO.setup.Tb_CalendarDate where CalendarDate = @checkDate AND TradingInd='F')
		begin
			select @isLoop = 1
		end
		else
		begin
			select @isLoop = 0
		end
	end

	return @checkDate
END