/****** Object:  View [dbo].[Vw_GBOTransactions_Approved]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Vw_GBOTransactions_Approved]
AS

select T.*, A.[CDSNo (textinput-19)] AS CDSNo, TA.AppStatus, 
		CASE WHEN TransType='CHDN' AND SubTransType='CDSAOF' THEN 1
			 WHEN TransType='CHRA' THEN 2
			 WHEN TransType='CHEDV' THEN 3 ELSE 0 END AS CDSFeeType
from GlobalBO.transmanagement.Tb_Transactions AS T
INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
ON T.RecordId = TA.ReferenceID
INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS A
ON T.AcctNo = A.[AccountNumber (textinput-5)] AND A.[Tradingaccount (selectsource-31)] = 'A'
WHERE TA.AppLevel=3 AND TA.AppStatus='A' 
AND (TransType IN ('CHRA','CHEDV') OR (TransType='CHDN' AND SubTransType='CDSAOF'))