/****** Object:  Procedure [process].[Usp_Daily_TradeDoneRecon]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_Daily_TradeDoneRecon]
(
	@dteTradeDate date
)
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 20/04/2020
Last Updated Date :             
Description       : this sp is used to reconcile FO 703 message (Trade Done) vs ECOS EMFCAS OLT file
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [process].[Usp_Daily_TradeDoneRecon] '2020-03-23'

************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
			
			--SELECT CONVERT(date,LEFT(DateTime,10),103) ,*,CAST(LEFT(MatchPrice,3)+'.'+RIGHT(MatchPrice,6) as decimal(24,9)) FROM import.Tb_ECOS_EFMACS WHERE  StockCode='5109  '
			
			--SELECT * FROM import.Tb_TradeDone WHERE AcctNo='CHP029L  ' and BursaStockCode='5109  '
			--SELECT * FROM import.Tb_TradeDone WHERE AcctNo='PHC003I  ' and BursaStockCode='5109'
			
			--SELECT * FROM import.Tb_TradeDone WHERE InternetInd='P'
			--SELECT * FROM import.Tb_TradeDone WHERE InternetInd='I'

			--SELECT AcctNo, BursaStockCode, TradePrice, TradeOrderNo, SUM(CAST(TransQty as bigint)) FROM import.Tb_TradeDone WHERE BursaStockCode='5109  '
			--group by AcctNo, BursaStockCode, TradePrice, TradeOrderNo

			--select * FROM import.Tb_TradeDone

			SELECT *
			FROM (
				SELECT *, CASE WHEN CAST(E.MatchQuantity as bigint) <> TransQty THEN 'No - Quantity Mismatch' 
							   WHEN E.ClientCode IS NULL AND TD.InternetInd = 'P' THEN 'Yes - Non-Internet Trade'
							   WHEN TD.AcctNo IS NULL THEN 'No - FO Missing'
							   ELSE 'Yes - Match'
							   END AS IsMatched
				FROM import.Tb_ECOS_EFMACS as E
				FULL OUTER JOIN 
					(SELECT AcctNo, BursaStockCode, CAST(TradePrice as decimal(24,9)) AS TradePrice, TransactionDate, TradeOrderNo, InternetInd, SUM(CAST(TransQty as bigint)) AS TransQty
					 FROM import.Tb_TradeDone
					 WHERE TransactionDate = @dteTradeDate
					 GROUP BY AcctNo, BursaStockCode, CAST(TradePrice as decimal(24,9)), TransactionDate, TradeOrderNo, InternetInd
					) AS TD
				ON E.ClientCode = TD.AcctNo AND E.StockCode = TD.BursaStockCode AND CONVERT(date,LEFT(E.DateTime,10),103) = TD.TransactionDate
					AND RIGHT(E.SCOREOrderNumber,8) = TD.TradeOrderNo
					AND CAST(LEFT(E.MatchPrice,3)+'.'+RIGHT(E.MatchPrice,6) as decimal(24,9)) = TD.TradePrice
				--WHERE CAST(E.MatchQuantity as bigint) <> TransQty
			) AS R
			ORDER BY IsMatched, ClientCode, StockCode, OrderType

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