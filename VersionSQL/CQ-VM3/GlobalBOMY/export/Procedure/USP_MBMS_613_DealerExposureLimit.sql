/****** Object:  Procedure [export].[USP_MBMS_613_DealerExposureLimit]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_613_DealerExposureLimit]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT 
			'613' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [BFEDealerCode (textinput-26)]) AS TransactionSequenceNumber,
			CAST('01' as char(02)) AS ServerID,
			CAST(D.[BranchID (selectsource-1)] as char(03)) AS BranchID,
			CAST(D.[BFEDealerCode (textinput-26)] as char(05)) AS DealerID,
			CASE WHEN D.[BranchID (selectsource-1)] = 'Y' THEN 1 ELSE 0 END AS WithLimitIndicator,
			CAST(DM.[MaxBuyLimit (textinput-7)] as char(12)) AS MaxBuyExposureLimit,
			CAST(DM.[MaxSellLimit (textinput-8)] as char(12)) AS MaxSellExposureLimit,
			CAST(DM.[MaxNetLimit (textinput-9)] as char(12)) AS MaxNettExposureLimit,
			CAST(DM.[MaxNetLimit (textinput-9)] as char(12)) AS MaxTotalExposureLimit,
			CAST(DM.[ExceedLimit (textinput-10)] as char(03)) AS ExceedLimit,
			DM.[ClearPreviousDayOrder (multipleradiosinline-2)] AS ClearPreviousDayOrder
	FROM 
		CQBTempDB.export.Tb_FormData_1377 AS D 
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1379 AS DM
	ON D.[DealerCode (textinput-35)] = DM.[DealerCode (selectsource-14)];
	
END