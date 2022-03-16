/****** Object:  View [dbo].[Vw_TransactionStatusIBGClient]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Vw_TransactionStatusIBGClient]
AS
	SELECT
		CompanyId = (select G.GlValue from GlobalBO.setup.Tb_GlobalValues G where G.GlType = 'DefaultCompany'),
		AcctNo = D.[AccountNumber (textinput-5)],
		TransDate = CAST(A.CreatedOn AS DATE),
		Amount = CAST(REPLACE(SUBSTRING(A.Amount,5, LEN(A.Amount)),',','') AS DECIMAL(24,9)),
		CurrCd = LEFT(A.Amount,3),
		AppStatus = CASE A.TransactionStatus WHEN 'Successful' THEN 'A' WHEN 'Rejected' THEN 'R' END
	FROM 
		[GlobalBOMY].[import].[IBG_APPROVED_TRANSACTION]  A
		INNER JOIN CQBTempDB.export.Tb_FormData_1410_grid6 B ON B.[Account Number (TextBox)] = A.BeneficiaryAcc
		INNER JOIN CQBTempDB.export.Tb_FormData_1410 C ON C.RecordId = B.RecordId
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 D ON D.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]