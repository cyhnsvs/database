/****** Object:  Procedure [process].[Usp_Daily_TradeContractRecon]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_Daily_TradeContractRecon]
(
	@dteTradeDate date
)
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 20/04/2020
Last Updated Date :             
Description       : this sp is used to reconcile FO 703 message (Trade Done) vs TRADEAC TPTS file
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_Daily_TradeContractRecon] '2020-03-23'

************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
			
			--SELECT CONVERT(date,LEFT(DateTime,10),103) ,*,CAST(LEFT(MatchPrice,3)+'.'+RIGHT(MatchPrice,6) as decimal(24,9)) FROM import.Tb_ECOS_EFMACS WHERE  StockCode='5109  '
			
			--select ACCTNO,PRODCD,TRXQTY,TRDPRICE,CAST(TRXQTY as bigint)*CAST(TRDPRICE as decimal(24,9)) AS GrossQtyTimesPrice,TRXAMT,BRKGAMT,CLRFEEAMT,SALESTAX,* 
			--from import.Tb_EBO_Contract_TRADEAC_TPTS where ACCTNO='SAM073U  ' and PRODCD='0195  '
			
			--SELECT * FROM GlobalBOLocal.import.Tb_OrderManualLive 
			--WHERE AcctNo='SAM073U' and InstrumentCd='0195.XKLS' and OrderStatus='A'
			
			--SELECT * FROM GlobalBO.contracts.Tb_OrderManualLive 
			--WHERE AcctNo='SAM073U' and InstrumentCd='0195.XKLS' and OrderStatus='A'
			
			--SELECT * FROM import.Tb_TradeDone WHERE AcctNo='SAM073U  ' and BursaStockCode='0195  ' order by TradeType

			--SELECT AcctNo, BursaStockCode, TradeType, BFE.ContractTypeCode, SUM(CAST(TransQty as bigint)) as TransQty
			--FROM import.Tb_TradeDone AS T
			--LEFT JOIN import.Tb_BFEOrderType As BFE
			--ON BFE.BFEOrderType = T.OrderType
			--WHERE ACCTNO='SAM073U  ' and BursaStockCode='0195  '
			--group by AcctNo, BursaStockCode, TradeType, BFE.ContractTypeCode
			
			--select * 
			--from import.Tb_TradeCharge as t
			--inner join import.Tb_BrokerageRate as br
			--on t.BrokerageCode = br.BRKGCD
			--where BrokerageCode IN ('SA','R5')

			--SELECT * FROM import.Tb_TradeDone WHERE AcctNo='CTH032C  ' and BursaStockCode='06518M  ' order by TradeType
			--SELECT * FROM import.Tb_TradeDone WHERE AcctNo='PHC003I  ' and BursaStockCode='5109'
			
			--SELECT * FROM import.Tb_TradeDone WHERE InternetInd='P'
			--SELECT * FROM import.Tb_TradeDone WHERE InternetInd='I'
			--select * FROM import.Tb_TradeDone

			SELECT *
			FROM (
				SELECT E.*, TD.AcctNo AS TAcctNo, TD.BursaStockCode,  CASE WHEN ABS(CAST(E.TRXQTY as bigint)) <> TransQty THEN 'No - Quantity Mismatch' 
							   WHEN E.ACCTNO IS NULL THEN 'No - Contract Missing'
							   WHEN TD.AcctNo IS NULL THEN 'No - FO Missing'
							   ELSE 'Yes - Match'
							   END AS IsMatched
				FROM 
					(SELECT ACCTNO, PRODCD, TRXDT, SUM(ABS(CAST(TRXQTY as bigint))) AS TRXQTY
					 FROM import.Tb_EBO_Contract_TRADEAC_TPTS
					 GROUP BY ACCTNO, PRODCD, TRXDT) as E
				FULL OUTER JOIN 
					(SELECT AcctNo, BursaStockCode, TransactionDate, SUM(CAST(TransQty as bigint)) AS TransQty
							--ROUND(SUM(CAST(TradePrice as decimal(24,9)) * CAST(TransQty as bigint)) / SUM(CAST(TransQty as bigint)), 5) AS TradedPrice
					 FROM import.Tb_TradeDone AS T
					 LEFT JOIN import.Tb_BFEOrderType As BFE
					 ON BFE.BFEOrderType = T.OrderType
					 WHERE TransactionDate = '2020-03-23'--@dteTradeDate
					 GROUP BY AcctNo, BursaStockCode, TransactionDate
					) AS TD
				ON E.ACCTNO = TD.AcctNo AND E.PRODCD = TD.BursaStockCode AND CAST(TRXDT as date) = TD.TransactionDate
				--WHERE CAST(E.MatchQuantity as bigint) <> TransQty
			) AS R
			WHERE TRXQTY <> 0 AND LEN(ACCTNO) > 3
			ORDER BY IsMatched, ACCTNO, PRODCD

    END TRY
    BEGIN CATCH
	    	    
        DECLARE @intErrorNumber INT
	        ,@intErrorLine INT
	        ,@intErrorSeverity INT
	        ,@intErrorState INT
	        ,@strObjectName VARCHAR(200)
			,@ostrReturnMessage VARCHAR(4000);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

   --     EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	  --      --,@ostrReturnMessage
			--,''
	  --      ,@intErrorLine
	  --      ,@strObjectName
	  --      ,NULL /*Code Section not available*/
	  --      ,'Process fail.';

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );

    END CATCH
    
    SET NOCOUNT OFF;
END