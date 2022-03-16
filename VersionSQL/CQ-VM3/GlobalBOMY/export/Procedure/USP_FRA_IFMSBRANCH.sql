/****** Object:  Procedure [export].[USP_FRA_IFMSBRANCH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFMSBRANCH] 

AS
BEGIN

	SET NOCOUNT ON;

	CREATE TABLE #IFMSBRANCH
	(
		DEALERCD CHAR(4),
		SBRANCH CHAR(10)
	)

	INSERT INTO #IFMSBRANCH
	(
		DEALERCD,
		SBRANCH
	)
	SELECT
	DELAR.[DealerCode (textinput-35)],
	DELAR.[Name (textinput-3)]
	FROM 
		CQBTempDB.export.Tb_FormData_1377 DELAR
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1374 BRANCH ON DELAR.[BranchID (selectsource-1)] = BRANCH.[BranchID (textinput-1)]


	--RESULT SET

	SELECT 
	DEALERCD + SBRANCH
	FROM #IFMSBRANCH	

	DROP TABLE #IFMSBRANCH

END