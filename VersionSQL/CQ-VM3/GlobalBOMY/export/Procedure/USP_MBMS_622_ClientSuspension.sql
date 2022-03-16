/****** Object:  Procedure [export].[USP_MBMS_622_ClientSuspension]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_622_ClientSuspension]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT 
			'622' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [AccountNumber (textinput-5)]) AS TransactionSequenceNumber,
			CAST([AccountNumber (textinput-5)] as char(09)) AS ClientNumber,
			CAST(D.[BranchID (selectsource-1)] as char(03)) AS BranchID,
			CAST(A.[Access (multipleradiosinline-20)] as char(01)) AS AccessSuspendResume,
			CAST(A.[Buy (multipleradiosinline-21)] as char(01)) AS BuySuspendResume,
			CAST(A.[Sell (multipleradiosinline-22)] as char(01)) AS SellSuspendResume,
			CAST('' as char(160)) AS Remark
	FROM 
		CQBTempDB.export.Tb_FormData_1409 AS A
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS C
		ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 AS D
		ON A.[DealerCode (selectsource-21)] = D.[DealerCode (textinput-35)];
	
END