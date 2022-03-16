/****** Object:  Procedure [export].[USP_MBMS_614_ClientCreditLimit]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_614_ClientCreditLimit]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT 
			'614' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [AccountNumber (textinput-5)]) AS TransactionSequenceNumber,
			CAST([AccountNumber (textinput-5)] as char(09)) AS ClientNumber,
			CAST(D.[BranchID (selectsource-1)] as char(03)) AS BranchID,
			'1' AS WithLimitIndicator,
			CAST(A.[MaxBuyLimit (textinput-68)] as char(12)) AS MaxBuyCreditLimit,
			CAST(A.[MaxSellLimit (textinput-69)] as char(12)) AS MaxSellCreditLimit,
			CAST(A.[MaxNetLimit (textinput-70)] as char(12)) AS MaxNettCreditLimit,
			CAST(A.[MaxNetLimit (textinput-70)] as char(12)) AS MaxTotalCreditLimit,
			CAST(A.[ExceedLimit (textinput-71)] as char(03)) AS ExceedLimit,
			A.[ClearPreviousDayOrder (multipleradiosinline-19)] AS ClearPreviousDayOrder
	FROM 
		CQBTempDB.export.Tb_FormData_1409 AS A
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS C
		ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 AS D
		ON A.[DealerCode (selectsource-21)] = D.[DealerCode (textinput-35)];
	
END