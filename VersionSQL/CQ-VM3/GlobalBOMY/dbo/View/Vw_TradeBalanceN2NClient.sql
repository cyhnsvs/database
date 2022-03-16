/****** Object:  View [dbo].[Vw_TradeBalanceN2NClient]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Vw_TradeBalanceN2NClient]
AS
SELECT 
	CompanyId = (SELECT G.GlValue FROM GlobalBO.setup.Tb_GlobalValues G WHERE G.GlType = 'DefaultCompany'),
	AccountNumber,
	OrderType,
	DealerCode,
	stockCode,
	ExchangeOrderNumber,
	QuantityMatch =  ISNULL(QuantityMatch,0)
from 
	GlobalBOMY.import.Tb_N2N_Trade