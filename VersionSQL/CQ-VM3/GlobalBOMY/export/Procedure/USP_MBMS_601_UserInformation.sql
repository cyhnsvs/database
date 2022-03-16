/****** Object:  Procedure [export].[USP_MBMS_601_UserInformation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MBMS_601_UserInformation]
(
	@idteProcessDate DATE
)
AS
BEGIN

	DECLARE @idtePreviousBusinessDate AS DATE;

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate('2020-09-24'));
	
	SELECT DISTINCT 
			'601' AS TransactionCode,
			ROW_NUMBER() OVER (ORDER BY [BFEDealerCode (textinput-26)], D.[DealerCode (textinput-35)]) AS TransactionSequenceNumber,
			'01' AS ServerID,
			'001' AS BranchID,
			CAST(RIGHT(REPLICATE('0',5) + D.[BFEDealerCode (textinput-26)],5) as char(05)) AS UserID,
			CAST([BFEDealerCode (textinput-26)] as char(10)) AS UserShortName,
			CAST([Name (textinput-3)] as char(30)) AS UserName,
			CAST([Address1 (textinput-11)] + ' ' + [Address2 (textinput-14)] + ' ' + [Address3 (textinput-13)] + ' ' + [Town (textinput-12)] + ' ' + 
				(CASE 
					WHEN [Country (selectsource-15)]='MY' 
					THEN [State (selectsource-14)] 
					ELSE [State (textinput-36)] 
				END) + ' ' +
				[PostCode (textinput-15)] as char(160)) AS UserAddress,
			CAST([IDNumber (textinput-9)] as char(14)) AS UserICNumber,
			D.[BFEUserType (selectsource-16)] AS UserType,
			ISNULL(NULLIF(D.[ShortSellInd (selectsource-17)],''),0) AS ShortSellingTradingAllowed,
			D.[DealerCode (textinput-35)] AS DealerCode
	FROM CQBTempDB.export.Tb_FormData_1377 AS D
	INNER JOIN CQBTempDB.export.Tb_FormData_1379 AS DM
			ON D.[DealerCode (textinput-35)] = DM.[DealerCode (selectsource-14)]
	LEFT JOIN import.Tb_Dealer_BFE_User AS BD
		ON D.[BFEDealerCode (textinput-26)] = BD.BFEUSRID AND D.[DealerCode (textinput-35)] = BD.DEALERCD;

END