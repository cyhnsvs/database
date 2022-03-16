/****** Object:  View [dbo].[Vw_TransactionStatusIBGHouse]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Vw_TransactionStatusIBGHouse]
AS
	SELECT 
		A.CompanyId,
		A.AcctNo, 
		A.TransDate, 
		Amount = SUM(A.Amount), 
		A.CurrCd, 
		B.AppStatus
	FROM
		[GlobalBO].[transmanagement].[Tb_Transactions] A
		INNER JOIN [GlobalBO].[transmanagement].[Tb_TransactionApproval] B ON B.CompanyId = A.CompanyId AND B.ReferenceID = A.RecordId
	WHERE
		A.SubTransType = 'IBG'
	GROUP BY 
		A.CompanyId, A.AcctNo, A.TransDate,A.CurrCd, B.AppStatus