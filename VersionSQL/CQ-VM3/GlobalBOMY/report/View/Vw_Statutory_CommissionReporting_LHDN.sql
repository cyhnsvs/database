/****** Object:  View [report].[Vw_Statutory_CommissionReporting_LHDN]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].Vw_Statutory_CommissionReporting_LHDN
AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY [Name] ASC) AS SNo,
	[Name],
	OldNRIC,
	NEWNRIC,
	Company,
	TaxReg,
	Address1,
	Address2,
	Address3,
	PostCode,
	City,
	[State],
	[LO],
	TelePhone,
	TotalCommission,
	ClosingDate,
	PaymentType,
	CreatedTime
FROM 
(
SELECT 	
	[Name (textinput-3)]				AS [Name],
	[AlternateIDno (textinput-10)]		AS OldNRIC,
	[IDNumber (textinput-9)]			AS NEWNRIC,
	''									AS Company,
	[IncomeTaxNo (textinput-28)]		AS TaxReg,
	[Address1 (textinput-11)]			AS Address1,
	[Address2 (textinput-14)]			AS Address2,
	[Address3 (textinput-13)]			AS Address3,
	[PostCode (textinput-15)]			AS PostCode,
	[Town (textinput-12)]				AS City,
	[State (textinput-36)]				AS [State],
	CASE WHEN [Country (selectsource-15)] = 'MY' THEN 'L' ELSE 'O' END AS [LO], -- L (Local), O (Overseas)
	[TelephoneExtension (textinput-18)] AS TelePhone,
	ISNULL(IndividualIncentiveAmount,0.00) + ISNULL(KioskIncentiveAmount,0.00) + ISNULL(AdditionalKioskIncentiveAmount,0.00)	AS TotalCommission,
	CAST(DATEADD(yy, DATEDIFF(yy, 0, R.CreatedTime) + 1, -1) AS DATE) AS ClosingDate,
	'PEMBAYARAN KEPADA REMISIER'		AS PaymentType,
	CAST(R.CreatedTime AS DATE)			AS CreatedTime
FROM 	 
	CQBTempDB.export.Tb_FormData_1377 AS R 
LEFT JOIN
	GlobalBOMY.dbo.AEIncentive_Remisiers_Summary AS B ON R.[DealerCode (textinput-35)] = B.AcctExecutiveCd
WHERE
	[DealerType (selectsource-3)] = 'R'
UNION
	SELECT 
	[Name (textinput-1)]				AS [Name],
	[AlternateIDNo (textinput-6)]		AS OldNRIC,
	[IDNo (textinput-5)]				AS NEWNRIC,
	''									AS Company,
	[IncomeTaxNo (textinput-16)]		AS TaxReg,
	[Address1 (textinput-7)]			AS Address1,
	[Address2 (textinput-8)]			AS Address2,
	[Address3 (textinput-9)]			AS Address3,
	[PostCode (textinput-11)]			AS PostCode,
	[Town (textinput-10)]				AS City,
	[State (textinput-18)]				AS [State],
	CASE WHEN [Country (selectsource-7)] = 'MY' THEN 'L' ELSE 'O' END AS [LO], -- L (Local), O (Overseas)
	[Phone (textinput-12)]				AS TelePhone,
	ISNULL(IncentiveAmount,0.00)		AS TotalCommission,
	CAST(DATEADD(yy, DATEDIFF(yy, 0, MR.CreatedTime) + 1, -1) AS DATE) AS ClosingDate,
	'PEMBAYARAN KEPADA MARKETING REPRESENTATIVE' AS PaymentType,
	CAST(MR.CreatedTime AS DATE)		AS CreatedTime
FROM 	 
	CQBTempDB.export.Tb_FOrmData_1575 AS MR
LEFT JOIN
	GlobalBOMY.dbo.AEIncentive_Remisiers_MR_Summary AS B ON MR.[RegistrationNo (textinput-2)] = B.AcctExecutiveCdMR
WHERE 
	[MRType (selectbasic-1)] = 'MR'
) AS R