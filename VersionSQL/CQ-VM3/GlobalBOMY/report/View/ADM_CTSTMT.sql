/****** Object:  View [report].[ADM_CTSTMT]    Committed by VersionSQL https://www.versionsql.com ******/

-- SELECT * FROM [report].[ADM_CTSTMT]

CREATE VIEW [report].[ADM_CTSTMT]

AS
SELECT
ISNULL(ACCOUNT.[CDSNo (textinput-19)],'') AS CDSNumber,
ISNULL(ACCOUNT.[AccountNumber (textinput-5)],'') AS AccountNumber,
ISNULL(CUSTOMER.[CustomerName (textinput-3)],'') AS AccountName,
ISNULL(ACCOUNT.[DealerCode (selectsource-21)],'') AS DealerCode,
'' AS NoofPages,
'' AS [ByHand(H)/ByPost(P)],
'' AS Acknowledgement
FROM [CQBTempDB].[export].Tb_FormData_1409 ACCOUNT 
INNER JOIN [CQBTEMPDB].[EXPORT].TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)]= CUSTOMER.[CustomerID (textinput-1)]
WHERE CONVERT(VARCHAR(10), ACCOUNT.CreatedTime, 111) = CONVERT(VARCHAR(10), GETDATE(), 111)