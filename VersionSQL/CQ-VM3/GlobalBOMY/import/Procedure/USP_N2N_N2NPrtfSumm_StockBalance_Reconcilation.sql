/****** Object:  Procedure [import].[USP_N2N_N2NPrtfSumm_StockBalance_Reconcilation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[USP_N2N_N2NPrtfSumm_StockBalance_Reconcilation]
AS
BEGIN
SET NOCOUNT ON;

	SELECT  
		C.CDSNNO AS CDSNo,
		C.StockCode,
		C.Quantity,
		'Stock Balance not matching'
	FROM 
		GlobalBOMY.import.Tb_N2N_N2NPrtfSumm	C
	INNER JOIN 
		CQbTempDb.export.Tb_FormData_1409	A	ON C.CDSNNo = A.[CDSNo (textinput-19)]
	INNER JOIN
		GlobalBO.setup.Tb_Instrument		I	ON C.StockCode  = SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd))
	INNER JOIN
		GlobalBO.holdings.Tb_CustodyAssets	CA	ON A.[AccountNumber (textinput-5)] = CA.AcctNo AND I.InstrumentId = CA.InstrumentId AND C.Quantity = CA.Balance
	WHERE
		CA.AcctNo IS NULL

END