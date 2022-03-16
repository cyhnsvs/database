/****** Object:  Procedure [import].[USP_N2N_Trade_Reconcilation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[USP_N2N_Trade_Reconcilation]
AS
BEGIN
SET NOCOUNT ON;

	SELECT  
		TD.CDSNo,--C.AcctNo,
		--CA.StockCode,
		TD.TradePrice,
		(CASE WHEN  C.AccountNumber IS NULL THEN 'Exists only in File'
			  WHEN  TD.CDSNo IS NULL THEN 'Exists only in GBO' 
			  WHEN  ISNULL(C.QuantityMatch,0) > ISNULL(TD.TransQty,0) THEN 'N2N Trade quantity is greater then TradeDone' 
			  WHEN  ISNULL(C.QuantityMatch,0) < ISNULL(TD.TransQty,0) THEN 'TradeDone quantity is greater then N2N Trade' END)
		
	FROM 
		GlobalBOMY.import.Tb_N2N_Trade	C
	FULL OUTER JOIN
		GlobalBOMY.import.Tb_TradeDone	TD	ON C.AccountNumber=TD.CDSNo  AND C.OrderType=TD.OrderType AND C.DealerCode = TD.DealerCode AND C.stockCode=TD.BursaStockCode
		AND C.ExchangeOrderNumber = TD.TradeOrderNo
END