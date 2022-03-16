/****** Object:  Procedure [import].[USP_BURSA_CFT002_Shareholding_Reconcilation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[USP_BURSA_CFT002_Shareholding_Reconcilation]
AS
BEGIN
SET NOCOUNT ON;

SELECT  
		C.AcctNo,
		C.StockCode,
		C.ShareQty,
		(CASE WHEN CA.CustodianAcctNo IS NULL THEN 'corporateaction Shareholding not matching' 
			  WHEN C.AcctNo IS NULL THEN 'Bursa Shareholding not matching' END)
		
	FROM 
		GlobalBOMY.import.Tb_BURSA_CFT002	C
	FULL OUTER JOIN
		GlobalBO.corporateaction.Tb_CorporateActionList	CA	ON C.AcctNo = CA.CustodianAcctNo
	WHERE
		CA.CustodianAcctNo IS NULL
END