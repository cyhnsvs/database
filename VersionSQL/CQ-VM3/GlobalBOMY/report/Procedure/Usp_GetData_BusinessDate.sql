/****** Object:  Procedure [report].[Usp_GetData_BusinessDate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_GetData_BusinessDate]
	@iintCompanyId BIGINT,
	@iintDays INT = NULL
AS
/***********************************************************************************             
            
Name              : report.Usp_GetData_BusinessDate    
Created By        : Nishanth Chowdhary
Created Date      : 19/06/2018
Last Updated Date :             
Description       : this sp is used to fetch the business date from GBO
            
Table(s) Used     : 
            
Modification History :  											
 
PARAMETERS
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors            
            
Used By : 
EXEC [report].[Usp_GetData_BusinessDate] 1, 1
************************************************************************************/
BEGIN
	SET NOCOUNT ON;
    
	DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');

	DECLARE @intCalendarID int = (SELECT GlValue FROM GlobalBO.setup.Tb_GlobalValues WHERE GlType = 'DefaultCalendar');

	IF @iintDays > 0
		SELECT @dteBusinessDate = GlobalBO.global.Udf_GetNextBusDateByDaysExcludePH(@dteBusinessDate,@iintDays,@intCalendarID)
	
	IF @iintDays < 0
		SELECT @dteBusinessDate = GlobalBO.global.Udf_GetPrevBusDateByDaysExcludePH(@dteBusinessDate,ABS(@iintDays),NULL)

	SELECT @dteBusinessDate AS BusDate;
	
	SET NOCOUNT OFF;
END