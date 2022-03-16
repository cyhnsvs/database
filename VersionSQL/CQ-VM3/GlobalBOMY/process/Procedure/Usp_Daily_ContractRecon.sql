/****** Object:  Procedure [process].[Usp_Daily_ContractRecon]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_Daily_ContractRecon]
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
			DROP TABLE IF EXISTS #MatchResult;

			DECLARE @dteTradeDate1 date = '2020-12-31';

			SELECT TRADEACKEY, ACCTNO AS EAcctNo, PRODCD, CAST(TRXDT as date) AS TRXDT, TRXCD, REMARKCD AS Intraday, REMARKCD2 AS InternetTrade, BRKGCD, CURRCODE,
					CAST(TRXQTY as bigint) AS TRXQTY, CAST(TRDPRICE as decimal(24,9)) AS TRDPRICE, CAST(TRXAMT as decimal(24,9)) as TRXAMT, CAST(BRKGAMT as decimal(24,9)) as BRKGAMT,
					CAST(CLRFEEAMT as decimal(24,9)) as CLRFEEAMT, CAST(SALESTAX as decimal(24,9)) as SALESTAX, CAST(DOCSTMAMT as decimal(24,9)) as DOCSTMAMT, 
					CAST(AMOUNT1 as decimal(24,9)) as SCORE, CAST(AMOUNT2 as decimal(24,9)) as SCLEVY
			INTO #MSECContracts
			FROM import.Tb_EBO_TRADEAC_DAY
			WHERE TRXCD IN ('TP','TS') AND LEN(ACCTNO) > 3
			AND (RIGHT(ACCTNO,1) NOT IN ('K','S','X') OR ACCTNO='WKL014S') AND ACCTNO <> 'PAETFA' -- <> 'AVG001K' 
			AND TRXDT = @dteTradeDate1;

			SELECT C.ContractNo, AcctNo, AN.OldAccountNo, I.InstrumentCd, TradeDate, C.TransType, C.TradeType, C.Channel, C.BrokerageGroupId, TG.TierGroupCd, C.TradedCurrCd,
					TradedQty AS TransQty, TradedPrice, NetAmountSetl AS NetAmountSetl, ClientBrokerageSetl AS ClientBrokerageSetl,
					ExchFeeSetl AS ExchFeeSetl, ClientBrokerageSetlTax AS ClientBrokerageSetlTax, 
					CAST(0.00 as decimal(24,9)) AS ExchFeeSetlClearingFee, CAST(0.00 as decimal(24,9)) AS ExchFeeSetlContractStamp,
					CAST(0.00 as decimal(24,9)) AS ExchFeeSetlScore, CAST(0.00 as decimal(24,9)) AS ExchFeeSetlSCLevy
			INTO #GBOContracts
			FROM GlobalBO.contracts.Tb_Contract AS C
			INNER JOIN GlobalBO.setup.Tb_Instrument AS I
			ON C.InstrumentId = I.InstrumentId
			INNER JOIN GlobalBO.setup.Tb_BrokerageGroup AS BG
			ON C.BrokerageGroupId = BG.BrokerageGroupId
			INNER JOIN GlobalBO.setup.Tb_TierGroup AS TG
			ON BG.TierGroupId = TG.TierGroupId
			LEFT JOIN import.Tb_AccountNoMapping AS AN
			ON C.AcctNo = AN.NewAccountNo AND AN.AccountStatus<>'C'
			WHERE LEN(AcctNo) > 3 AND AcctNo<>'CPBURSA001' AND TradeDate = @dteTradeDate1
			AND AcctNo <> CustodianAcctNo;

			UPDATE C
			SET ExchFeeSetlClearingFee = CFD.FeeAmount*-1
			FROM #GBOContracts AS C
			INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails AS CFD
			ON C.ContractNo = CFD.ContractNo
			WHERE CFD.FeeId = 1;

			UPDATE C
			SET ExchFeeSetlContractStamp = CFD.FeeAmount*-1
			FROM #GBOContracts AS C
			INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails AS CFD
			ON C.ContractNo = CFD.ContractNo
			WHERE CFD.FeeId = 2;

			UPDATE C
			SET ExchFeeSetlScore = CFD.FeeAmount*-1
			FROM #GBOContracts AS C
			INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails AS CFD
			ON C.ContractNo = CFD.ContractNo
			WHERE CFD.FeeId = 4;

			UPDATE C
			SET ExchFeeSetlSCLevy = CFD.FeeAmount*-1
			FROM #GBOContracts AS C
			INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails AS CFD
			ON C.ContractNo = CFD.ContractNo
			WHERE CFD.FeeId = 5;
			
			--select * from #MSECContracts
			--select * from #GBOContracts

			CREATE TABLE #MatchResult (
				TradeAcKey VARCHAR(20) NULL,
				EAcctNo varchar(20) NULL,
				PRODCD varchar(20) NULL,
				TRXDT Date NULL,
				TRXCD varchar(20) NULL,
				Intraday varchar(20) NULL,
				InternetTrade varchar(20) NULL,
				BRKGCD varchar(20) NULL,
				CURRCODE varchar(20) NULL,
				TRXQty decimal(24,9) NULL,
				trdprice decimal(24,9) NULL,
				trxamount decimal(24,9) NULL,
				brkgamt decimal(24,9) NULL,
				clrfeeamt decimal(24,9) NULL,
				salestax decimal(24,9) NULL,
				docstmamt decimal(24,9) NULL,
				ScoreAmt decimal(24,9) NULL,
				SCLevyAmt decimal(24,9) NULL,

				ContractNo VARCHAR(20) NULL,
				AcctNo varchar(20) NULL,
				OldAcctNo varchar(20) NULL,
				InstrumentCd varchar(20) NULL,
				TradeDate Date NULL,
				TransType varchar(20) NULL,
				TradeType varchar(20) NULL,
				Channel varchar(20) NULL,
				BrokerageGroupId BIGINT NULL,
				TierGroupCd VARCHAR(50) NULL,
				TradedCurrCd VARCHAR(50) NULL,
				TransQty decimal(24,9) NULL,
				TradedPrice decimal(24,9) NULL,
				NetAmountSetl decimal(24,9) NULL,
				ClientBrokerageSetl decimal(24,9) NULL,
				ExchFeeSetl decimal(24,9) NULL,
				ClientBrokerageSetlTax decimal(24,9) NULL,
				ExchFeeSetlClearingFee decimal(24,9) NULL,
				ExchFeeSetlContractStamp decimal(24,9) NULL,
				ExchFeeSetlScore decimal(24,9) NULL,
				ExchFeeSetlSCLevy decimal(24,9) NULL,
				NetDiff decimal(24,9) NULL,
				IsMatched varchar(500) NULL
			);
			
			INSERT INTO #MatchResult
			SELECT *, ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) AS NetDiff,
							CAST(CASE WHEN ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) > 10 THEN 'No - Net Amount Mismatch (More Than 10 MYR)' 
							   WHEN ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) > 1 THEN 'No - Net Amount Mismatch (More Than 1 MYR)' 
							   --WHEN ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) > 0 THEN 'No - Net Amount Mismatch (More Than 0.01 MYR)' 
							   WHEN CAST(M.TRXQTY as bigint) <> G.TransQty THEN 'No - Quantity Mismatch' 
							   ELSE 'Yes - Match'
							   END as varchar(500)) AS IsMatched
			--INTO #MatchResult
			FROM #MSECContracts AS M
			INNER JOIN #GBOContracts AS G
			ON M.EAcctNo = G.OldAccountNo AND M.PRODCD + '.XKLS' = G.InstrumentCd AND M.TRXDT = G.TradeDate AND M.CURRCODE = G.TradedCurrCd
				AND ((M.TRXCD='TP' AND G.TransType = 'TRBUY') OR (M.TRXCD='TS' AND G.TransType = 'TRSELL')) AND M.TRXQTY = G.TransQty AND M.TRDPRICE = G.TradedPrice
				AND ((M.Intraday = 'ITRD' AND G.TradeType LIKE '%Intraday%') OR (M.Intraday='' AND G.TradeType NOT LIKE '%Intraday%'))
				AND ((M.InternetTrade = 'INET' AND G.Channel = 'Online') OR (M.InternetTrade <> 'INET' AND G.Channel = 'Offline'))
			ORDER BY IsMatched;

			INSERT INTO #MatchResult
			SELECT M.*,G.*, ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) AS NetDiff, 'No - Intraday Mismatch & ' + 
							CASE WHEN ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) > 10 THEN 'Net Amount Mismatch (More Than 10 MYR)' 
							   WHEN ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) > 1 THEN 'Net Amount Mismatch (More Than 1 MYR)' 
							   --WHEN ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) > 0 THEN 'No - Net Amount Mismatch (More Than 0.01 MYR)' 
							   ELSE 'Yes - Match'
							   END AS IsMatched
			FROM #MSECContracts AS M
			INNER JOIN #GBOContracts AS G
			ON M.EAcctNo = G.OldAccountNo AND M.PRODCD + '.XKLS' = G.InstrumentCd AND M.TRXDT = G.TradeDate AND M.CURRCODE = G.TradedCurrCd 
				AND ((M.TRXCD='TP' AND G.TransType = 'TRBUY') OR (M.TRXCD='TS' AND G.TransType = 'TRSELL')) AND M.TRXQTY = G.TransQty AND M.TRDPRICE = G.TradedPrice
				AND ((M.Intraday = 'ITRD' AND G.TradeType NOT LIKE '%Intraday%') OR (M.Intraday='' AND G.TradeType LIKE '%Intraday%'))
				AND ((M.InternetTrade = 'INET' AND G.Channel = 'Online') OR (M.InternetTrade <> 'INET' AND G.Channel = 'Offline'))
			LEFT JOIN #MatchResult AS MR
			ON M.TRADEACKEY = MR.TradeAcKey
			WHERE MR.TradeAcKey IS NULL
			ORDER BY IsMatched;

			INSERT INTO #MatchResult
			SELECT M.*,G.*, ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) AS NetDiff, 
							CASE WHEN CAST(M.TRDPRICE as decimal(24,9)) <> G.TradedPrice THEN 'No - Traded Price Mismatch' 
							   END AS IsMatched
			FROM #MSECContracts AS M
			INNER JOIN #GBOContracts AS G
			ON M.EAcctNo = G.OldAccountNo AND M.PRODCD + '.XKLS' = G.InstrumentCd AND M.TRXDT = G.TradeDate AND M.CURRCODE = G.TradedCurrCd 
				AND ((M.TRXCD='TP' AND G.TransType = 'TRBUY') OR (M.TRXCD='TS' AND G.TransType = 'TRSELL')) AND M.TRDPRICE <> G.TradedPrice AND M.TRXQTY = G.TransQty
			LEFT JOIN #MatchResult AS MR
			ON M.TRADEACKEY = MR.TradeAcKey --AND G.ContractNo = MR.ContractNo
			WHERE MR.TradeAcKey IS NULL
			ORDER BY IsMatched;

			INSERT INTO #MatchResult
			SELECT M.*,G.*, ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) AS NetDiff, 
							CASE WHEN CAST(M.TRXQTY as bigint) <> G.TransQty THEN 'No - Quantity Mismatch' 
							   END AS IsMatched
			FROM #MSECContracts AS M
			INNER JOIN #GBOContracts AS G
			ON M.EAcctNo = G.OldAccountNo AND M.PRODCD + '.XKLS' = G.InstrumentCd AND M.TRXDT = G.TradeDate AND M.CURRCODE = G.TradedCurrCd 
				AND ((M.TRXCD='TP' AND G.TransType = 'TRBUY') OR (M.TRXCD='TS' AND G.TransType = 'TRSELL')) AND M.TRDPRICE = G.TradedPrice AND M.TRXQTY <> G.TransQty
			LEFT JOIN #MatchResult AS MR
			ON M.TRADEACKEY = MR.TradeAcKey --AND G.ContractNo = MR.ContractNo
			WHERE MR.TradeAcKey IS NULL
			ORDER BY IsMatched;
			
			INSERT INTO #MatchResult
			SELECT M.*, G.*, ABS(ABS(M.TRXAMT) - ABS(G.NetAmountSetl)) AS NetDiff, 
							CASE WHEN M.EAcctNo IS NULL THEN 'No - MSEC Contract Missing'
							   WHEN G.AcctNo IS NULL THEN 'No - GBO Contract Missing'
							   END AS IsMatched
			FROM #MSECContracts AS M
			FULL OUTER JOIN #GBOContracts AS G
			ON M.EAcctNo = G.OldAccountNo AND M.PRODCD + '.XKLS' = G.InstrumentCd AND M.TRXDT = G.TradeDate AND M.CURRCODE = G.TradedCurrCd 
				AND ((M.TRXCD='TP' AND G.TransType = 'TRBUY') OR (M.TRXCD='TS' AND G.TransType = 'TRSELL'))
			LEFT JOIN #MatchResult AS MR
			ON M.TRADEACKEY = MR.TradeAcKey --AND G.ContractNo = MR.ContractNo
			WHERE (M.EAcctNo IS NULL OR G.AcctNo IS NULL) AND MR.TradeAcKey IS NULL
			ORDER BY IsMatched;
			
			select distinct TradeAcKey from #MatchResult where IsMatched not like 'yes%'
			--select 223.0000/44265*100

			--select * from GlobalBO.holdings.Tb_Cash where AcctNo='010066904'
			--select * from import.Tb_Cash_ACBAL where ACCTNO='AAM012U'

			select TradeAcKey, EAcctNo, PRODCD, TRXDT, TRXCD, Intraday, InternetTrade, BRKGCD, TRXQty, trdprice, trxamount, brkgamt, clrfeeamt, salestax, docstmamt,
				   ContractNo, AcctNo, InstrumentCd, TRXDT AS TradeDate, TransType, TradeType, Channel, TierGroupCd, TransQty, TradedPrice, NetAmountSetl, ClientBrokerageSetl, ExchFeeSetlClearingFee, ClientBrokerageSetlTax, ExchFeeSetlContractStamp,
				   NetDiff, IsMatched
			from #MatchResult where IsMatched not like 'yes%' --and ABS(NetDiff) > 0 --and EAcctNo='MSK061J'
			ORDER BY AcctNo, InstrumentCd, ContractNo, EAcctNo, PRODCD, TradeAcKey, IsMatched

			SELECT C.ContractNo, AcctNo, I.InstrumentCd, ContractDate, TransType, Channel, TradedQty, TradedPrice, TradeSetlExchRate,
					C.TradedCurrCd, GrossAmountTrade, ClientBrokerageTrade, ClientBrokerageTradeTax, CF.FeeAmount, CF2.FeeAmount, ExchFeeTradeTax, NetAmountTrade,
					C.SetlCurrCd, GrossAmountClientBased, ClientBrokerageClientBased, ClientBrokerageClientBased, CF.FeeAmountBased, CF2.FeeAmountBased, ExchFeeClientBasedTax, NetAmountClientBased,
					C.SetlCurrCd, GrossAmountCompanyBased, ClientBrokerageCompanyBased, ClientBrokerageCompanyBased, CF.FeeAmountBased, CF2.FeeAmountBased, ExchFeeCompanyBasedTax, NetAmountCompanyBased,
					C.SetlCurrCd, GrossAmountSetl, ClientBrokerageSetl, ClientBrokerageSetlTax, CF.FeeAmountBased, CF2.FeeAmountBased, ExchFeeSetlTax, NetAmountSetl
			FROM GlobalBO.contracts.Tb_Contract AS C
			INNER JOIN GlobalBO.setup.Tb_Instrument AS I
			ON C.InstrumentId = I.InstrumentId
			INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails AS CF
			ON C.ContractNo = CF.ContractNo AND CF.FeeId = 1
			INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails AS CF2
			ON C.ContractNo = CF2.ContractNo AND CF2.FeeId = 2
			WHERE C.TradedCurrCd<>'MYR' AND C.CPartyInd='N'

			--SELECT * FROM import.Tb_EBO_TRADEAC_DAY where ORGCURR<>'MYR' AND ORGCURR<>'' AND LEN(ACCTNO)>3 AND ACCTNO<>'AVG001K'

			--COMPARE SCORE & SC LEVY
			select TradeAcKey, EAcctNo, PRODCD, TRXDT, TRXCD, Intraday, BRKGCD, TRXQty, trdprice, trxamount, brkgamt, clrfeeamt, salestax, docstmamt, ScoreAmt, SCLevyAmt,
				   ContractNo, AcctNo, InstrumentCd, TRXDT AS TradeDate, TransType, TradeType, TierGroupCd, TransQty, TradedPrice, NetAmountSetl, ClientBrokerageSetl, ExchFeeSetlClearingFee, ClientBrokerageSetlTax, ExchFeeSetlContractStamp, ExchFeeSetlScore, ExchFeeSetlSCLevy,
				   NetDiff, IsMatched, TransQty * TradedPrice AS GrossAmountTrade, TransQty * TradedPrice * 0.000025 AS ScoreCalc, TransQty * TradedPrice * 0.000075 AS SCLevyCalc
			from #MatchResult where IsMatched like 'yes%' and (ABS(ScoreAmt - ABS(ExchFeeSetlScore)) > 0.01 or ABS(SCLevyAmt - ABS(ExchFeeSetlSCLevy)) > 0.01)
			ORDER BY AcctNo, InstrumentCd, ContractNo, EAcctNo, PRODCD, TradeAcKey, IsMatched
			
			--select * from #MatchResult where EAcctNo='NAA215C' and PRODCD='0128' order by TransType,TradeAcKey
			--select * from #MSECContracts where EAcctNo='ASL003L' order by TRADEACKEY
			--select * from #GBOContracts where AcctNo='011066203' order by ContractNo
			--select * from import.Tb_TradeDone where AcctNo='CKK076Z' and BursaStockCode='0176' and MessageCode='703' ORDER BY CAST(SeqNo as bigint)
			--select * FROM GlobalBO.contracts.Tb_OrderManualLiveBackup O where AcctNo='CKK076Z' and InstrumentCd='0176.XKLS' ORDER BY LEN(O.OrderNo), O.OrderNo
			--select * FROM GlobalBOLocal.import.Tb_OrderManualLiveBackup O where AcctNo='CKK076Z' and InstrumentCd='0176.XKLS' ORDER BY LEN(O.OrderNo), O.OrderNo
			--select * FROM GlobalBOLocal.import.Tb_OrderManualLive O where AcctNo='CKK076Z' and InstrumentCd='0176.XKLS' ORDER BY LEN(O.OrderNo), O.OrderNo
			--select * FROM GlobalBO.contracts.Tb_OrderManualLive O where AcctNo='CKK076Z' and InstrumentCd='0176.XKLS' ORDER BY LEN(O.OrderNo), O.OrderNo

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
				SELECT *, ABS(ABS(TRXAMT) - ABS(NetAmountSetl)) AS NetDiff,
							CASE WHEN ABS(ABS(TRXAMT) - ABS(NetAmountSetl)) > 10 THEN 'No - Net Amount Mismatch (More Than 10 MYR)' 
							   WHEN ABS(ABS(TRXAMT) - ABS(NetAmountSetl)) > 1 THEN 'No - Net Amount Mismatch (More Than 1 MYR)' 
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