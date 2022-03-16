/****** Object:  Procedure [import].[USP_Bursa_CFT003_StockBalance_Reconcilation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[USP_Bursa_CFT003_StockBalance_Reconcilation]
AS
BEGIN
SET NOCOUNT ON;

	SELECT  
		C.AcctNo,
		C.StockCode,
		C.FreeBalance,
		(CASE WHEN C.AcctNo IS NULL THEN 'Exists only in File'
			  WHEN CA.InstrumentId IS NULL THEN 'Exists only in GBO'
		      WHEN C.FreeBalance > CA.Balance THEN 'Bursa CFT003 balance is greater then file' 
			  WHEN C.FreeBalance < CA.Balance THEN 'CustodyAssets balance is greater then Bursa CFT003' END)
	FROM 
		GlobalBOMY.import.Tb_BURSA_CFT003	C
	INNER JOIN 
		CQbTempDb.export.Tb_FormData_1409	A	ON C.AcctNo = A.[CDSNo (textinput-19)]
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument		I	ON C.StockCode  = SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd))
	FULL OUTER JOIN 
		GlobalBO.holdings.Tb_CustodyAssets	CA	ON A.[AccountNumber (textinput-5)] = CA.AcctNo AND I.InstrumentId = CA.InstrumentId 
	WHERE
		CA.AcctNo IS NULL

END