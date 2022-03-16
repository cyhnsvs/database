/****** Object:  Procedure [reports].[Usp_InitialiseReportsData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_InitialiseReportsData]

AS
BEGIN
	SET NOCOUNT ON;
	EXEC [reports].[Usp_PopulateReportsData] @iMode ='initial'
	SET NOCOUNT OFF;
end