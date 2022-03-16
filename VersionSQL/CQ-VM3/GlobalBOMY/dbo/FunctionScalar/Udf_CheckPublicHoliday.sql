/****** Object:  Function [dbo].[Udf_CheckPublicHoliday]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[Udf_CheckPublicHoliday] 
(
@dtDateInput Date  
)  
RETURNS BIT
AS 
/*
	Author:		Nishanth
	Created Date: 	02-05-2018

	Called BY:
	
	Purpose:	To check if the given date is a public holiday
					
	Tables Used:	Tb_Setup_Calendar
	
	Input Parameters:
		@strDateInput - Input date	

	Return Value:
		1 - public holiday
		0 - Not a public holiday
	
	Has been modified by + date + note:
 	1. dd MMM yyyy by xxx, desc xxxxxxxxxxxxxxx 

*/
BEGIN
	
	DECLARE @bitResult BIT;	
	SET @bitResult = 0; --by default set to non-public holiday
	
	DECLARE @istrCalendarType VARCHAR(30) = NULL;
	DECLARE @intCalendarId INT;
	Set @istrCalendarType = ISNULL(@istrCalendarType,'DefaultCalendar');
	
	SELECT @intCalendarId = GlValue 
	FROM GlobalBO.setup.Tb_GlobalValues
	WHERE CompanyId = (SELECT GlValue FROM GlobalBO.setup.Tb_GlobalValues WHERE GlType = 'DefaultCompany') AND GLType = @istrCalendarType;

	--if public holiday set the value to 1
	IF EXISTS (SELECT 1 FROM GlobalBO.setup.TB_CalendarDate WHERE CalendarId=@intCalendarId AND TradingInd='F' AND CalendarDate = @dtDateInput)	
		SET @bitResult = 1;
	
	RETURN @bitResult;
END 