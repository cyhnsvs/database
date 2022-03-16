/****** Object:  Procedure [import].[USP_BTX_SCOTRS_NormalMarket_OddLotTrades]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[USP_BTX_SCOTRS_NormalMarket_OddLotTrades]
AS
BEGIN
SET NOCOUNT ON;

	SELECT  
		C.CDSNo,
		C.TradeOrderNo,
		C.BursaStockCode,
		IIF(CA.SellerCDSAcctNo = '000000000', CA.BuyerCDSAcctNo, CA.SellerCDSAcctNo) AS AcctCDSNo,
		CA.StockCode,
		CA.OrderNo,
		(CASE WHEN  C.CDSNo IS NULL THEN 'Exists only in File'
			  WHEN  CA.SellerCDSAcctNo IS NULL THEN 'Exists only in GBO'
			  WHEN  ISNULL(C.TransQty,0) > ISNULL(CA.Qty,0) THEN 'Trade done Qty is greater than file' 
			  WHEN  ISNULL(C.TransQty,0) < ISNULL(CA.Qty,0) THEN 'BTX quantity is greater than TradeDone' END)
	FROM GlobalBOMY.import.Tb_TradeDone	C
	FULL OUTER JOIN GlobalBOMY.import.Tb_BTX_SCOTRS	CA	
		ON C.CDSNo = IIF(SellerCDSAcctNo = '000000000', BuyerCDSAcctNo, SellerCDSAcctNo)  AND C.BursaStockCode = CA.StockCode AND C.TradeOrderNo = CA.OrderNo AND C.TerminalId= CA.TerminalId  --AND C.TransQty = CA.Qty	
	WHERE MessageCode ='703';
END