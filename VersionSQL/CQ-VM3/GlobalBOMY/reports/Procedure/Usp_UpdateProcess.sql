/****** Object:  Procedure [reports].[Usp_UpdateProcess]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_UpdateProcess]
	@processID bigint,
	@status tinyint,
	@updatedBy varchar(100),
	@remarks varchar(4000) = NULL
AS
BEGIN
	update reports.Tb_Process
	set [Status] = @status,
		Remarks = ISNULL(@remarks, ''),
		UpdatedBy = @updatedBy,
		UpdatedDate = getdate()
	where IDD = @processID

	update a
	set a.LastExecutionDate = getdate()
	from reports.Tb_ReportSetup a
	join reports.Tb_Process as b
	on a.IDD = b.ReportID
	where b.IDD = @processID
END