/****** Object:  Procedure [report].[Usp_FetchDailyBusinessDoneSummaryRpt]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [report].[Usp_FetchDailyBusinessDoneSummaryRpt]
Created By        : Fadlin    
Created Date      : 07/01/2021
Used by           : 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : 
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [report].[Usp_FetchDailyBusinessDoneSummaryRpt] '2021-01-05'
**********************************************************************************/   
CREATE PROCEDURE [report].[Usp_FetchDailyBusinessDoneSummaryRpt]
	@idteReportDate date
AS
BEGIN
	BEGIN TRY 

		DROP TABLE IF EXISTS #tmpSummary;
		DROP TABLE IF EXISTS #tmpAcct;
		DROP TABLE IF EXISTS #tmpContractOutstanding;
		DROP TABLE IF EXISTS #Contracts;
		DROP TABLE IF EXISTS #tmpContractDetails;

		CREATE TABLE #tmpSummary
		(
			[Order] BIGINT
			,[Group] BIGINT
			,Parent varchar(150)
			,ParentInd char(1)
			,Mode varchar(150)
			,GrossAmount decimal(24,2)
			,Brokerage decimal(24,2)
			,ClearingFee decimal(24,2)
			,StampDuty decimal(24,2)
			,ScoreFee decimal(24,2)
			,LevyFee decimal(24,2)
			,GST decimal(24,2)
			,NetAmount decimal(24,2)
			,NoofTrades BIGINT
			,NoofContracts BIGINT
			,NoofAcctTraded BIGINT
		)

		SELECT * INTO #tmpAcct 
		FROM GlobalBORpt.form.Tb_FormData_1409 as acct
		WHERE acct.ReportDate = @idteReportDate

		SELECT
			AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,
			TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo,SubContractNo,RowNum
		INTO #tmpContractOutstanding
		FROM
		(
			select AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName,TransType, FundSourceId, Tag1, ContractNo, TradedQty, 
			TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo,SubContractNo, 
			ROW_NUMBER() over (partition by ContractNo, ContractPartNo,ContractAmendNo order by Reportdate desc , ContractAmendNo desc) AS RowNum
			from  GlobalBORpt.contracts.Tb_ContractOutstandingRpt
			WHERE CPartyInd != 'Y' and ContractStatus='O' AND TradeDate = @idteReportDate
		) as Z
		WHERE Z.RowNum = 1;

		select
			AcctNo,TradeDate, Channel, InstrumentCd,InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,
			TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
			ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo
		INTO #Contracts
		from(
			select 
				AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, 
				TradedPrice,TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
				ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo,
				ROW_NUMBER() over (partition by ContractNo, ContractPartNo,ContractAmendNo order by ContractAmendNo desc) AS RowNum
			from ( 
				select
					AcctNo,TradeDate, Channel, InstrumentCd, InstrumentName, TransType, FundSourceId, Tag1, ContractNo, TradedQty, TradedPrice,
					TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
					ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo
				from #tmpContractOutstanding as c

				union all

				select
					AcctNo,TradeDate, Channel, I.InstrumentCd, InstrumentName, TransType, FundSourceId, c.Tag1, ContractNo, TradedQty, TradedPrice,c.TradedCurrCd, ClientBrokerageTrade, GrossAmountTrade, NetAmountTrade, 
					ClientBrokerageTradeTax, ExchFeeTrade, ExchFeeTradeTax, TradeType, ContractPartNo, ContractAmendNo, SubContractNo
				from  GlobalBORpt.transmanagement.Tb_TransactionsSettled as c
				inner join GlobalBO.setup.Tb_Instrument I ON c.InstrumentId = I.InstrumentId
				WHERE TransType IN ('TRBUY','TRSELL') AND CPartyInd != 'Y' and ContractStatus='O' AND TradeDate = @idteReportDate
			)con
		)t
		where t.RowNum = 1;

		SELECT 
			cont.GrossAmountTrade,
			cont.ClientBrokerageTrade,
			tf.FeeDesc,
			cf.FeeAmountSetl,
			cont.ClientBrokerageTradeTax,
			cf.FeeTaxSetl,
			cont.NetAmountTrade,
			cont.AcctNo,
			cont.ContractNo,
			cont.ContractPartNo,
			cont.ContractAmendNo,
			cf.ContractNo as FeeContractNo, 
			cf.ContractPartNo  as FeeContractPartNo, 
			cf.ContractAmendNo  as FeeContractAmendNo, 
			cf.FeeId,
			om.OrderNo,
			om.SubOrderNo,
			om.OrderAmendNo,
			cont.TransType,
			cont.Channel,
			cont.InstrumentCd,
			cont.TradeType
		INTO #tmpContractDetails
		FROM #Contracts as cont
		INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails as cf
		ON cf.ContractNo = cont.ContractNo AND cf.ContractPartNo = cont.ContractPartNo AND cf.ContractAmendNo = cont.ContractAmendNo
		INNER JOIN GlobalBO.setup.Tb_TransactionFee as tf
		ON tf.FeeId = cf.FeeId
		INNER JOIN GlobalBOLocalRpt.contracts.Tb_OrderManualLiveBackupRpt as om
		ON om.Tag1 = cont.Tag1 AND om.AcctNo = cont.AcctNo AND om.ReportDate = cont.TradeDate

		INSERT INTO #tmpSummary
		SELECT 1,1,'Total','Y','Total',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 2,2,'Purchases','Y','Purchases',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 3,2,'- BuyOnline','Y','- BuyOnline',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 4,2,'- BuyOffline','Y','- BuyOffline',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 5,2,'Sales','Y','Sales',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 6,2,'- SellOnline','Y','- SellOnline',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 7,2,'- SellOffline','Y','- SellOffline',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 8,3,'Dealer','Y','Dealer',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 
			9,3,
			'- ' + DealerCode AS parent,
			CASE WHEN MR = '' THEN 'Y' ELSE 'N' END,
			CASE WHEN MR = '' THEN '- ' + DealerCode ELSE '-- ' + MR END,
			0,0,0,0,0,0,0,0,0,0,0
		FROM
		(
			SELECT 
				acct.[DealerCode (selectsource-21)] as DealerCode, '' as MR
			FROM #tmpContractDetails as cont
			INNER JOIN #tmpAcct as acct
			ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @idteReportDate
			WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			GROUP BY acct.[DealerCode (selectsource-21)]

			UNION ALL

			SELECT [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
			FROM #tmpContractDetails as cont
			INNER JOIN #tmpAcct as acct
			ON cont.AcctNo = acct.[AccountNumber (textinput-5)]
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @idteReportDate
			INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
			ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
			AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
			WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			GROUP BY [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
		) as M
		UNION
		SELECT 10,3,'Remisier','Y','Remisier',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 
			11,3,
			'- ' + DealerCode AS parent,
			CASE WHEN MR = '' THEN 'Y' ELSE 'N' END,
			CASE WHEN MR = '' THEN '- ' + DealerCode ELSE '-- ' + MR END,
			0,0,0,0,0,0,0,0,0,0,0
		FROM
		(
			SELECT [DealerCode (selectsource-21)] as DealerCode,'' as MR
			FROM #tmpContractDetails as cont
			INNER JOIN #tmpAcct as acct
			ON cont.AcctNo = acct.[AccountNumber (textinput-5)]
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @idteReportDate
			WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			GROUP BY [DealerCode (selectsource-21)]

			UNION ALL

			SELECT [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
			FROM #tmpContractDetails as cont
			INNER JOIN #tmpAcct as acct
			ON cont.AcctNo = acct.[AccountNumber (textinput-5)]
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @idteReportDate
			INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
			ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
			AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
			WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			GROUP BY [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
		) as N
		UNION
		SELECT 12,4,'Region then Branch','Y','Region then Branch',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 
			13,4,
			Region AS parent,
			CASE WHEN Branch = '' THEN 'Y' ELSE 'N' END,
			CASE WHEN Branch = '' THEN Region ELSE '- ' + Branch END,
			0,0,0,0,0,0,0,0,0,0,0
		FROM
		(
			SELECT branch.[Region (selectsource-10)] as Region, '' as Branch
			FROM #tmpContractDetails as cont
			INNER JOIN #tmpAcct as acct
			ON cont.AcctNo = acct.[AccountNumber (textinput-5)]
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @idteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			AND branch.ReportDate = @idteReportDate
			GROUP BY branch.[Region (selectsource-10)]

			UNION ALL

			SELECT branch.[Region (selectsource-10)],branch.[BranchLocation (textinput-2)]
			FROM #tmpContractDetails as cont
			INNER JOIN #tmpAcct as acct
			ON cont.AcctNo = acct.[AccountNumber (textinput-5)]
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @idteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			AND branch.ReportDate = @idteReportDate
			GROUP BY branch.[Region (selectsource-10)],branch.[BranchLocation (textinput-2)]
		) as T
		UNION
		SELECT 14,5,'Market','Y','Market',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 15,5,'Bursa Malaysia','Y','Bursa Malaysia',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 
			16,5,
			'- ' + Market AS parent,
			'Y',
			'- ' + Market,
			0,0,0,0,0,0,0,0,0,0,0
		FROM
		(
			SELECT SG.[Description (textinput-2)] as Market
			FROM #tmpContractDetails as cont
			INNER JOIN CQBTempDB.export.Tb_FormData_1345 as prod
			ON prod.[InstrumentCode (textinput-49)] = cont.InstrumentCd
			INNER JOIN CQBTempDB.export.Tb_FormData_2866 as SG
			ON SG.[ShareGradeCode (textinput-1)] = prod.[ShareGrade (selectsource-4)]
			GROUP BY SG.[Description (textinput-2)]
		) as K
		UNION
		SELECT 17,5,'Foreign','Y','Foreign',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 19,6,'Trade Type','Y','Trade Type',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 
			20,6,
			'- ' + TradeType AS parent,
			'Y',
			'- ' + TradeType,
			0,0,0,0,0,0,0,0,0,0,0
		FROM
		(
			SELECT cont.TradeType
			FROM #tmpContractDetails as cont
			GROUP BY cont.TradeType
		) as T
		UNION
		SELECT 21,7,'Account Types','Y','Account Types',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 
			22,7,
			'- ' + AcctTypes.[Description (textinput-2)],
			'Y',
			'- ' + AcctTypes.[Description (textinput-2)],
			0,0,0,0,0,0,0,0,0,0,0
		FROM #tmpContractDetails as cont
		INNER JOIN #tmpAcct as acct
		ON cont.AcctNo = acct.[AccountNumber (textinput-5)]
		INNER JOIN GlobalBORpt.form.Tb_FormData_1457 as AcctTypes
		ON AcctTypes.[2DigitCode (textinput-1)] = RIGHT(acct.[AccountNumber (textinput-5)],2)
		AND AcctTypes.ReportDate = @idteReportDate
		GROUP BY AcctTypes.[Description (textinput-2)]
		UNION
		SELECT 23,8,'By acct opening year','Y','By acct opening year',0,0,0,0,0,0,0,0,0,0,0
		UNION
		SELECT 
			24,8,
			'- ' + CAST(YEAR(acct.CreatedTime) as varchar(5)),
			'Y', 
			'- ' + CAST(YEAR(acct.CreatedTime) as varchar(5)),
			0,0,0,0,0,0,0,0,0,0,0
		FROM #tmpContractDetails as cont
		INNER JOIN #tmpAcct as acct
		ON acct.[AccountNumber (textinput-5)] = cont.AcctNo 
		GROUP BY YEAR(acct.CreatedTime)

		UPDATE A SET 
			A.GrossAmount = B.TotalGrossAmount
			,A.Brokerage = B.TotalBrokerage
			,A.ClearingFee = B.TotalClearingFee
			,A.StampDuty = B.TotalStampFee
			,A.ScoreFee = B.TotalScoreFee
			,A.LevyFee = B.TotalLevyFee
			,A.GST = B.GST
			,A.NetAmount = B.TotalNetAmount
			,A.NoofTrades = B.NoofTrades
			,A.NoofContracts = B.NoofContracts
			,A.NoofAcctTraded = B.NoofAccts
		FROM #tmpSummary as A
		INNER JOIN 
		(
			--GET TOTAL
			SELECT
				ISNULL(MAX('Total'),'Total') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
			) as Z

			UNION ALL

			--GET PURCHASES
			SELECT
				ISNULL(MAX('Purchases'),'Purchases') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
				WHERE TransType = 'TRBUY'
			) as Z

			UNION ALL

			--GET PURCHASES ONLINE
			SELECT
				ISNULL(MAX('- BuyOnline'),'- BuyOnline') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
				WHERE TransType = 'TRBUY' AND Channel = 'Online'
			) as Z

			UNION ALL

			--GET PURCHASES OFFLINE
			SELECT
				ISNULL(MAX('- BuyOffline'),'- BuyOffline') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
				WHERE TransType = 'TRBUY' AND Channel = 'Offline'
			) as Z

			UNION ALL

			--GET SALES
			SELECT
				ISNULL(MAX('Sales'),'Sales') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
				WHERE TransType = 'TRSELL'
			) as Z

			UNION ALL

			--GET SALES ONLINE
			SELECT
				ISNULL(MAX('- SellOnline'),'- SellOnline') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
				WHERE TransType = 'TRSELL' AND Channel = 'Online'
			) as Z

			UNION ALL

			--GET SALES OFFLINE
			SELECT
				ISNULL(MAX('- SellOffline'),'- SellOffline') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
				WHERE TransType = 'TRSELL' AND Channel = 'Offline'
			) as Z

			UNION ALL

			--GET TOTAL DEALER
			SELECT 
				ISNULL(MAX('Dealer'),'Dealer') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			) as Z

			UNION ALL

			--GET TOTAL DEALER GROUP BY DEALER CODE
			(SELECT 
				'- ' + DealerCode as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					acct.[DealerCode (selectsource-21)] as DealerCode
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			) as Z
			GROUP BY DealerCode)

			UNION ALL

			--GET TOTAL DEALER GROUP BY MARKETING REPRESENTATIVE (MR)
			(SELECT 
				'-- ' + MR as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					MR.[RegistrationNo (textinput-2)] as MR
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
				ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
				AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
				WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			) as Z
			GROUP BY MR)

			UNION ALL

			--GET TOTAL REMISIER
			SELECT 
				ISNULL(MAX('Remisier'),'Remisier') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			) as Z

			UNION ALL

			--GET TOTAL REMISIER GROUP BY DEALER CODE
			(SELECT 
				'- ' + DealerCode as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					acct.[DealerCode (selectsource-21)] as DealerCode
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			) as Z
			GROUP BY DealerCode)

			UNION ALL

			--GET TOTAL REMISIER GROUP BY MARKETING REPRESENTATIVE (MR)
			(SELECT 
				'-- ' + MR as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					MR.[RegistrationNo (textinput-2)] as MR
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
				ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
				AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
				WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			) as Z
			GROUP BY MR)

			UNION ALL

			--GET TOTAL BY REGION
			SELECT 
				ISNULL(MAX('Region then Branch'),'Region then Branch') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
				ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
				AND branch.ReportDate = @idteReportDate
			) as Z

			UNION ALL

			--GET TOTAL GROUP BY REGION
			(SELECT 
				Region as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					branch.[Region (selectsource-10)] as Region
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
				ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
				AND branch.ReportDate = @idteReportDate
			) as Z
			GROUP BY Region)

			UNION ALL

			--GET TOTAL GROUP BY BRANCH LOCATION
			(SELECT 
				'- ' + Branch as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					branch.[BranchLocation (textinput-2)] as Branch
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @idteReportDate
				INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
				ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
				AND branch.ReportDate = @idteReportDate
			) as Z
			GROUP BY Branch)

			UNION ALL

			--GET TOTAL GROUP BY MARKET
			SELECT 
				ISNULL(MAX('Market'),'Market') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails as cont
				INNER JOIN CQBTempDB.export.Tb_FormData_1345 as prod
				ON prod.[InstrumentCode (textinput-49)] = cont.InstrumentCd
				INNER JOIN CQBTempDB.export.Tb_FormData_2866 as SG
				ON SG.[ShareGradeCode (textinput-1)] = prod.[ShareGrade (selectsource-4)]
			) as Z

			UNION ALL

			--GET TOTAL GROUP BY BM
			SELECT 
				ISNULL(MAX('Bursa Malaysia'),'Bursa Malaysia') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails as cont
				INNER JOIN CQBTempDB.export.Tb_FormData_1345 as prod
				ON prod.[InstrumentCode (textinput-49)] = cont.InstrumentCd
				INNER JOIN CQBTempDB.export.Tb_FormData_2866 as SG
				ON SG.[ShareGradeCode (textinput-1)] = prod.[ShareGrade (selectsource-4)]
			) as Z

			UNION ALL

			--GET TOTAL GROUP BY SHARE GRADE MARKET
			(SELECT 
				'- ' + ShareGrade as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					SG.[Description (textinput-2)] as ShareGrade
				FROM #tmpContractDetails as cont
				INNER JOIN CQBTempDB.export.Tb_FormData_1345 as prod
				ON prod.[InstrumentCode (textinput-49)] = cont.InstrumentCd
				INNER JOIN CQBTempDB.export.Tb_FormData_2866 as SG
				ON SG.[ShareGradeCode (textinput-1)] = prod.[ShareGrade (selectsource-4)]
			) as Z
			GROUP BY ShareGrade)

			UNION ALL

			--GET TOTAL TRADE TYPE
			SELECT 
				ISNULL(MAX('Trade Type'),'Trade Type') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails
			) as Z

			UNION ALL

			--GET TOTAL GROUP BY TRADE TYPE
			(SELECT 
				'- ' + TradeType as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					TradeType
				FROM #tmpContractDetails
			) as Z
			GROUP BY TradeType)

			UNION ALL

			--GET TOTAL BY ACCOUNT TYPES
			SELECT 
				ISNULL(MAX('Account Types'),'Account Types') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1457 as AcctTypes
				ON AcctTypes.[2DigitCode (textinput-1)] = RIGHT(acct.[AccountNumber (textinput-5)],2)
				AND AcctTypes.ReportDate = @idteReportDate
			) as Z

			UNION ALL

			--GET TOTAL GROUP BY ACCOUNT TYPES
			(SELECT 
				'- ' + AcctType as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					AcctTypes.[Description (textinput-2)] as AcctType
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
				INNER JOIN GlobalBORpt.form.Tb_FormData_1457 as AcctTypes
				ON AcctTypes.[2DigitCode (textinput-1)] = RIGHT(acct.[AccountNumber (textinput-5)],2)
				AND AcctTypes.ReportDate = @idteReportDate
			) as Z
			GROUP BY AcctType)

			UNION ALL

			--GET TOTAL BY ACCT OPENING YEAR
			SELECT 
				ISNULL(MAX('By acct opening year'),'By acct opening year') as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
			) as Z

			UNION ALL

			--GET TOTAL GROUP BY ACCT OPENING YEAR
			(SELECT 
				'- ' + CAST(AcctYear as varchar(5)) as Mode,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN GrossAmountTrade END),0) as TotalGrossAmount,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTrade END),0) as TotalBrokerage,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Clearing Fee' THEN FeeAmountSetl END),0) as TotalClearingFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'Contract Stamp Fee' THEN FeeAmountSetl END),0) as TotalStampFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SCORE Fee' THEN FeeAmountSetl END),0) as TotalScoreFee,
				ISNULL(SUM(CASE WHEN FeeRowNum = 1 AND FeeDesc = 'SC Levy' THEN FeeAmountSetl END),0) as TotalLevyFee,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN ClientBrokerageTradeTax END + FeeTaxSetl),0) as GST,
				ISNULL(SUM(CASE WHEN RowNum = 1 THEN NetAmountTrade END),0) as TotalNetAmount,
				COUNT(CASE WHEN TradeRowNum = 1 THEN TradeRowNum END) as NoofTrades,
				COUNT(CASE WHEN RowNum = 1 THEN RowNum END) as NoofContracts,
				COUNT(CASE WHEN AcctRowNum = 1 THEN AcctRowNum END) as NoofAccts
			FROM (
				SELECT 
					GrossAmountTrade,
					ClientBrokerageTrade,
					FeeDesc,
					FeeAmountSetl,
					ClientBrokerageTradeTax,
					FeeTaxSetl,
					NetAmountTrade,
					AcctNo,
					ROW_NUMBER() over (partition by ContractNo, ContractPartNo, ContractAmendNo order by AcctNo) AS RowNum,
					ROW_NUMBER() over (partition by AcctNo order by AcctNo) AS AcctRowNum,
					ROW_NUMBER() over (partition by FeeContractNo, FeeContractPartNo, FeeContractAmendNo, FeeId order by AcctNo) AS FeeRowNum,
					ROW_NUMBER() over (partition by OrderNo, SubOrderNo, OrderAmendNo order by AcctNo) AS TradeRowNum,
					YEAR(acct.CreatedTime) as AcctYear
				FROM #tmpContractDetails as cont
				INNER JOIN #tmpAcct as acct
				ON acct.[AccountNumber (textinput-5)] = cont.AcctNo
			) as Z
			GROUP BY AcctYear)
		) as B
		ON A.Mode = B.Mode

		SELECT 
			[Order], 
			[Group], 
			[Parent],
			CASE 
				WHEN [Mode] = '- BuyOnline' THEN '- Online'
				WHEN [Mode] = '- BuyOffline' THEN '- Offline'
				WHEN [Mode] = '- SellOnline' THEN '- Online'
				WHEN [Mode] = '- SellOffline' THEN '- Offline'
				ELSE [Mode] 
			END as [Mode],
			GrossAmount,
			Brokerage,
			ClearingFee,
			StampDuty,
			ScoreFee,
			LevyFee,
			GST,
			NetAmount,
			NoofTrades,
			NoofContracts,
			NoofAcctTraded
		FROM #tmpSummary 
		order by [Order], Parent, CASE WHEN ParentInd = 'Y' THEN 2 ELSE 3 END

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END