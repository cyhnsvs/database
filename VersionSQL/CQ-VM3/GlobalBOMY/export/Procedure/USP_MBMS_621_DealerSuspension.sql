/****** Object:  Procedure [export].[USP_MBMS_621_DealerSuspension]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_621_DealerSuspension]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT 
			'621' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [BFEDealerCode (textinput-26)]) AS TransactionSequenceNumber,
			CAST(RIGHT(REPLICATE('0',5) + D.[BFEDealerCode (textinput-26)],5) as char(05)) AS DealerID,
			CAST(D.[BranchID (selectsource-1)] as char(03)) AS BranchID,
			CAST(DM.[Access (multipleradiosinline-3)] as char(01)) AS AccessSuspendResume,
			CAST(DM.[Buy (multipleradiosinline-4)] as char(01)) AS BuySuspendResume,
			CAST(DM.[Sell (multipleradiosinline-5)] as char(01)) AS SellSuspendResume,
			CAST('' as char(160)) AS Remark
	FROM 
		CQBTempDB.export.Tb_FormData_1377 AS D
	INNER JOIN CQBTempDB.export.Tb_FormData_1379 AS DM
		ON D.[DealerCode (textinput-35)] = DM.[DealerCode (selectsource-14)];

END