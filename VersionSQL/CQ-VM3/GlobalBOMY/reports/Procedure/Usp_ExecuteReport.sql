/****** Object:  Procedure [reports].[Usp_ExecuteReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_ExecuteReport]
	@processId bigint
AS
BEGIN
	SET NOCOUNT ON;
	declare @query nvarchar(max) = '';

	select @query = @query + '@' + ParamName + ' = N''' + ParamValue + ''',' from reports.Tb_ProcessParam where ProcessID = @processId
	select @query = SQLStatement + ' ' + SUBSTRING(ISNULL(@query,''), 0, len(@query))
	from reports.Tb_ReportSetup as a 
	join reports.Tb_Process as b on 
	a.IDD = b.ReportID where b.IDD = @processId

	print @query
	exec sp_executesql @query
END