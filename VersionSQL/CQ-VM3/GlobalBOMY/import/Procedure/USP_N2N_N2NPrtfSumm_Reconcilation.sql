/****** Object:  Procedure [import].[USP_N2N_N2NPrtfSumm_Reconcilation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[USP_N2N_N2NPrtfSumm_Reconcilation]
AS
BEGIN
SET NOCOUNT ON;

	SELECT  
		C.CDSNNo,
		C.StockCode,
		C.Quantity,
		(CASE WHEN C.AccountNumber IS NULL THEN 'Exists only in File'
			  WHEN CA.InstrumentId IS NULL THEN 'Exists only in GBO'
			  WHEN C.Quantity > CA.Balance THEN 'N2N N2NPrtfSumm Quantity is greater then CustodyAssets' 
			  WHEN C.Quantity < CA.Balance THEN 'CustodyAssets Quantity is greater then N2N N2NPrtfSumm' END)
	FROM 
		GlobalBOMY.import.Tb_N2N_N2NPrtfSumm	C
	INNER JOIN 
		CQbTempDb.export.Tb_FormData_1409	A	ON C.CDSNNo = A.[CDSNo (textinput-19)]
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument		I	ON C.StockCode  = SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd))
	FULL OUTER JOIN 
		GlobalBO.holdings.Tb_CustodyAssets	CA	ON A.[AccountNumber (textinput-5)] = CA.AcctNo AND I.InstrumentId = CA.InstrumentId 
	
END