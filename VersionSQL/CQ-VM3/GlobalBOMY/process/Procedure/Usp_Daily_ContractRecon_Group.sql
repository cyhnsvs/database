/****** Object:  Procedure [process].[Usp_Daily_ContractRecon_Group]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_Daily_ContractRecon_Group]
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
EXEC [import].[Usp_Daily_ContractRecon] '2020-03-23'

************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
			
			DROP TABLE IF EXISTS #MSECContracts;
			DROP TABLE IF EXISTS #GBOContracts;

			SELECT ACCTNO AS EAcctNo, PRODCD, TRXDT, SUM(CAST(TRXQTY as bigint)) AS TRXQTY, SUM(CAST(TRXAMT as decimal(24,9))) as TRXAMT, SUM(CAST(BRKGAMT as decimal(24,9))) as BRKGAMT,
							SUM(CAST(CLRFEEAMT as decimal(24,9))) as CLRFEEAMT, SUM(CAST(SALESTAX as decimal(24,9))) as SALESTAX, SUM(CAST(DOCSTMAMT as decimal(24,9))) as DOCSTMAMT
			INTO #MSECContracts
			--FROM import.Tb_EBO_Contract_TRADEAC_TPTS
			FROM import.Tb_EBO_TRADEAC
			WHERE TRXCD IN ('TP','TS') AND LEN(ACCTNO) > 3
			AND (RIGHT(ACCTNO,1) NOT IN ('K','S','X') OR ACCTNO='WKL014S') AND ACCTNO <> 'PAETFA' -- <> 'AVG001K' 
			AND TRXDT = '2020-06-01'--@dteTradeDate
			GROUP BY ACCTNO, PRODCD, TRXDT;

			SELECT AcctNo, I.InstrumentCd, TradeDate, SUM(TradedQty) AS TransQty, SUM(NetAmountTrade) AS NetAmountTrade, SUM(ClientBrokerageTrade) AS ClientBrokerageTrade,
							SUM(ExchFeeTrade) AS ExchFeeTrade, SUM(ClientBrokerageTradeTax) AS ClientBrokerageTradeTax
			INTO #GBOContracts
			FROM GlobalBO.contracts.Tb_Contract AS C
			INNER JOIN GlobalBO.setup.Tb_Instrument AS I
			ON C.InstrumentId = I.InstrumentId
			WHERE LEN(AcctNo) > 3 AND TradeDate = '2020-06-01'--@dteTradeDate
			AND AcctNo <> CustodianAcctNo
			GROUP BY AcctNo, I.InstrumentCd, TradeDate;

			--SELECT *
			--FROM (
			--	SELECT *, ABS(ABS(TRXAMT) - ABS(NetAmountTrade)) AS NetDiff,
			--				CASE WHEN ABS(ABS(TRXAMT) - ABS(NetAmountTrade)) > 0 THEN 'No - Net Amount Mismatch' 
			--				   WHEN CAST(E.TRXQTY as bigint) <> TransQty THEN 'No - Quantity Mismatch' 
			--				   WHEN E.EAcctNo IS NULL THEN 'No - MSEC Contract Missing'
			--				   WHEN TD.AcctNo IS NULL THEN 'No - GBO Contract Missing'
			--				   ELSE 'Yes - Match'
			--				   END AS IsMatched
			--	FROM #MSECContracts as E
			--	FULL OUTER JOIN #GBOContracts AS TD
			--	ON E.EAcctNo = TD.AcctNo AND E.PRODCD + '.XKLS' = TD.InstrumentCd AND CAST(TRXDT as date) = TD.TradeDate
			--	--WHERE CAST(E.MatchQuantity as bigint) <> TransQty
			--) AS R
			----WHERE TRXQTY <> 0
			--ORDER BY ABS(ABS(TRXAMT) - ABS(NetAmountTrade)) DESC, IsMatched, ACCTNO, PRODCD

			SELECT IsMatched, count(1) as COUNTMatch
			FROM (
				SELECT *, ABS(ABS(TRXAMT) - ABS(NetAmountTrade)) AS NetDiff,
							CASE WHEN ABS(ABS(TRXAMT) - ABS(NetAmountTrade)) > 10 THEN 'No - Net Amount Mismatch (More Than 10 MYR)' 
							   WHEN ABS(ABS(TRXAMT) - ABS(NetAmountTrade)) > 1 THEN 'No - Net Amount Mismatch (More Than 1 MYR)' 
							   WHEN CAST(E.TRXQTY as bigint) <> TransQty THEN 'No - Quantity Mismatch' 
							   WHEN E.EAcctNo IS NULL THEN 'No - MSEC Contract Missing'
							   WHEN TD.AcctNo IS NULL THEN 'No - GBO Contract Missing'
							   ELSE 'Yes - Match'
							   END AS IsMatched
				FROM #MSECContracts as E
				FULL OUTER JOIN #GBOContracts AS TD
				ON E.EAcctNo = TD.AcctNo AND E.PRODCD + '.XKLS' = TD.InstrumentCd AND CAST(TRXDT as date) = TD.TradeDate
				--WHERE CAST(E.MatchQuantity as bigint) <> TransQty
			) AS R
			--WHERE TRXQTY <> 0
			GROUP BY IsMatched
			--ORDER BY ABS(ABS(TRXAMT) - ABS(NetAmountTrade)) DESC, IsMatched, ACCTNO, PRODCD

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