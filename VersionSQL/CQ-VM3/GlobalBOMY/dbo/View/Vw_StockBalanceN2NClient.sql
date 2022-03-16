/****** Object:  View [dbo].[Vw_StockBalanceN2NClient]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Vw_StockBalanceN2NClient]
AS
	SELECT 
		CompanyId = (select G.GlValue from GlobalBO.setup.Tb_GlobalValues G where G.GlType = 'DefaultCompany'),
		CDSNo = A.CDSNNo,
		A.StockCode,
		A.Quantity
	FROM 
	GlobalBOMY.import.Tb_N2N_N2NPrtfSumm A