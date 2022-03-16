/****** Object:  Procedure [export].[USP_MBMS_602_ClientInformation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_602_ClientInformation]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate));
	
	SELECT '602' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [AccountNumber (textinput-5)]) AS TransactionSequenceNumber,
			CAST([AccountNumber (textinput-5)] as char(09)) AS ClientNumber,
			CAST(A.[AccountNumber (textinput-5)] as char(10)) AS ClientShortName,
			CAST(C.[CustomerName (textinput-3)] as char(30)) AS ClientName,
			CAST(C.[Address1 (textinput-35)] + ' ' + C.[Address2 (textinput-36)] + ' ' + C.[Address3 (textinput-37)] + ' ' + C.[Town (textinput-38)] + ' ' + 
				C.[State (textinput-39)] + ' ' + C.[Country (selectsource-24)] as char(160)) AS ClientAddress,
			CAST(C.[PhoneHouse (textinput-55)] as char(12)) AS TelephoneNumber,
			CAST(A.[CDSNo (textinput-19)] as char(09)) AS ClientCDSNumber,
			CAST(C.[IDNumber (textinput-5)] as char(14)) AS ClientICNumber,
			CAST(D.[BranchID (selectsource-1)] as char(03)) AS BranchID,
			CAST(RIGHT(REPLICATE('0',5) + D.[BFEDealerCode (textinput-26)],5) as char(05)) AS DealerID,
			CAST(A.[BFEACType (selectsource-29)] as char(02)) AS AccountType,
			CASE WHEN A.[StructureWarrant (selectbasic-7)] = 'Y' THEN 1 ELSE 0 END AS CallWarrantTradingAllowed,
			CASE WHEN A.[ClientAssoallowed (multipleradiosinline-13)] = 'Y' THEN 1 ELSE 0 END AS ClientAssociateAllowedFlag,
			ISNULL(NULLIF(A.[ShortSellInd (selectsource-19)],''),0) AS ShortSellingTradingAllowed
	FROM CQBTempDB.export.Tb_FormData_1409 AS A
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS C
	ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 AS D
	ON A.[DealerCode (selectsource-21)] = D.[DealerCode (textinput-35)];

END