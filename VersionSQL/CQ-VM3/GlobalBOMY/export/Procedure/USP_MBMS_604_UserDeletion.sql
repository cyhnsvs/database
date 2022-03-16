/****** Object:  Procedure [export].[USP_MBMS_604_UserDeletion]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_604_UserDeletion]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT '604' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [DealerCode (textinput-35)]) AS TransactionSequenceNumber,
			CAST(D.[DealerCode (textinput-35)] as char(05)) AS UserID,
			CAST(D.[BranchID (selectsource-1)] as char(03)) AS BranchID,
			1 AS DeleteIndicator
	FROM CQBTempDB.export.Tb_FormData_1377 AS D;
	
END