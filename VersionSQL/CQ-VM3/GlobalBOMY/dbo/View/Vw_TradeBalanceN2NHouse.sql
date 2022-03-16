/****** Object:  View [dbo].[Vw_TradeBalanceN2NHouse]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Vw_TradeBalanceN2NHouse]
AS
SELECT
	CompanyId,
	CDSNo,
	OrderType,
	DealerCode,
	BursaStockCode,
	TradeOrderNo,
	TransQty = ISNULL(TransQty,0),
	TradePrice
FROM 
	GlobalBOMY.import.Tb_TradeDone