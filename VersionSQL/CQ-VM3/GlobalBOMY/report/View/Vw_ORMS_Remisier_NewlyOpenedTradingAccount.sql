/****** Object:  View [report].[Vw_ORMS_Remisier_NewlyOpenedTradingAccount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [report].[VW_NewlyOpenedTradingAccount] AS
SELECT DISTINCT TOP 10000000
	ISNULL([BranchCode (textinput-42)],'') AS [BRANCHSTAFF],
	ISNULL([DealerCode (textinput-35)],'') AS [REMISIER],
	ISNULL([Name (textinput-3)],'') AS [DEALERNAME],
	ISNULL(A.[AccountNumber (textinput-5)],'') AS [ACCOUNTNUMBER],
	ISNULL([CustomerName (textinput-3)],'') AS [ACCOUNTNAME],
	ISNULL(CAST(A.[DateofTradingAccountOpened (dateinput-20)] AS DATE),'') AS [CREATEDDATE],
	ISNULL([PhoneHouse (textinput-55)],'') AS [PHONE2],
	ISNULL([PhoneMobile (textinput-57)],'') AS [PHONE3],
	ISNULL([CDSACOpenBranch (selectsource-4)],'') AS [CDSBRH],
	ISNULL([CDSNo (textinput-19)],'') AS [CDSNUMBER],
	ISNULL([Email (textinput-58)],'') AS [EMAILADDR],
	CAST(CASE WHEN ISNULL([ApprovedLimit (textinput-64)],'') = '' THEN '0.00' ELSE [ApprovedLimit (textinput-64)] END AS DECIMAL(24,2)) AS [APPROVEDLIMIT]
FROM 
	CQBTempDB.export.Tb_FormData_1409 A
INNER JOIN
	CQBTempDB.export.Tb_FormData_1410 C ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
INNER JOIN 
	CQBTempDB.export.Tb_FormData_1377 DLR ON A.[DealerCode (selectsource-21)] = DLR.[DealerCode (textinput-35)]
INNER JOIN 
	CQBTempDB.export.Tb_FormData_1374 B ON DLR.[BranchID (selectsource-1)] = B.[BranchID (textinput-1)]
WHERE CAST(A.[DateofTradingAccountOpened (dateinput-20)] AS DATE) BETWEEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'))-1, 0) AND DATEADD(MONTH, DATEDIFF(MONTH, -1, GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'))-1, -1)
ORDER BY CREATEDDATE