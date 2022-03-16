/****** Object:  View [dbo].[Vw_StockBalanceN2NHouse]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Vw_StockBalanceN2NHouse]
AS

	SELECT 
		CA.CompanyId,
		CDSNo = A.[CDSNo (textinput-19)],
		StockCode = SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd)),
		Quantity = CA.Balance
	from GlobalBO.holdings.Tb_CustodyAssets CA
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON CA.InstrumentId = I.InstrumentId
	INNER JOIN CQbTempDb.export.Tb_FormData_1409 A 
		ON A.[AccountNumber (textinput-5)] = CA.AcctNo
	INNER JOIN CQbTempDb.export.Tb_FormData_1410 C 
		ON C.[CustomerID (textinput-1)] = CA.AcctNo
	WHERE [OnlineSystemIndicator (multiplecheckboxesinline-2)] LIKE '%N2N%'