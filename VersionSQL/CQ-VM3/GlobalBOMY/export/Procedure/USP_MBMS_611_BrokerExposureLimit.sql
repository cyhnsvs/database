/****** Object:  Procedure [export].[USP_MBMS_611_BrokerExposureLimit]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_611_BrokerExposureLimit]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT '611' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [CompanyID (textinput-1)]) AS TransactionSequenceNumber,
			CAST('01' as char(02)) AS ServerID,
			CAST('001' as char(03)) AS BranchID,
			'1' AS WithLimitIndicator,
			CAST(C.[MaxBuyLimit (textinput-7)] as char(12)) AS MaxBuyExposureLimit,
			CAST(C.[MaxSellLimit (textinput-8)] as char(12)) AS MaxSellExposureLimit,
			CAST(C.[MaxNetLimit (textinput-9)] as char(12)) AS MaxNettExposureLimit,
			CAST(C.[MaxNetLimit (textinput-9)] as char(12)) AS MaxTotalExposureLimit,
			CAST('000' as char(03)) AS ExceedLimit,
			'1' AS ClearPreviousDayOrder
	FROM CQBTempDB.export.Tb_FormData_1372 AS C;
	
END