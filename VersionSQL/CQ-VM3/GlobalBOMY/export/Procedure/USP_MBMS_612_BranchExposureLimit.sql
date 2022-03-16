/****** Object:  Procedure [export].[USP_MBMS_612_BranchExposureLimit]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_612_BranchExposureLimit]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT 
			'612' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [BranchID (textinput-1)]) AS TransactionSequenceNumber,
			CAST('01' as char(02)) AS ServerID,
			CAST(B.[BranchID (textinput-1)] as char(03)) AS BranchID,
			'1' AS WithLimitIndicator,
			CAST(B.[MaxBuyLimit (textinput-39)] as char(12)) AS MaxBuyExposureLimit,
			CAST(B.[MaxSellLimit (textinput-40)] as char(12)) AS MaxSellExposureLimit,
			CAST(B.[MaxNetLimit (textinput-41)] as char(12)) AS MaxNettExposureLimit,
			CAST(B.[MaxNetLimit (textinput-41)] as char(12)) AS MaxTotalExposureLimit,
			CAST('000' as char(03)) AS ExceedLimit,
			'1' AS ClearPreviousDayOrder
	FROM CQBTempDB.export.Tb_FormData_1374 AS B;
	
END