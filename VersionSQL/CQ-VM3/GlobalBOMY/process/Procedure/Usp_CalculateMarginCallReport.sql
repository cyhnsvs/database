/****** Object:  Procedure [process].[Usp_CalculateMarginCallReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_CalculateMarginCallReport]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_CalculateMarginCallReport]
Created By        : Nishanth Chowdhary
Created Date      : 06/10/2017
Last Updated Date : 
Description       : this sp is used to prepare the margin data on a daily basis
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_CalculateMarginCallReport] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');

		DROP TABLE IF EXISTS #ServiceTypeList_Margin;

		SELECT DISTINCT [AccountGroup (selectsource-2)] AS ServiceType
		INTO #ServiceTypeList_Margin
		FROM CQBTempDB.export.Tb_FormData_1409 
		WHERE [ParentGroup (selectsource-3)] IN ('M','G');

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Archive Tb_MarginRptDetails');

		--INSERT INTO [margin].[Tb_MarginRptDetails_Archive]
		--SELECT *, GETDATE() FROM [margin].[Tb_MarginRptDetails];

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Archive Tb_MarginRptDetails');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Archive Tb_MarginRptSummary');

		--INSERT INTO [margin].[Tb_MarginRptSummary_Archive]
		--SELECT *, GETDATE() FROM [margin].[Tb_MarginRptSummary];

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Archive Tb_MarginRptSummary');

		--IF(GlobalBOTH.dbo.Udf_CheckPublicHoliday(@dteBusinessDate) = 1)
		--BEGIN
		--	--UPDATE [margin].[Tb_MarginRptDetails]
		--	--SET BusinessDate = @dteBusinessDate, CreatedDate = GETDATE();

		--	--UPDATE [margin].[Tb_MarginRptSummary]
		--	--SET BusinessDate = @dteBusinessDate, CreatedDate = GETDATE();

		--	TRUNCATE TABLE [margin].[Tb_MarginRptDetails];
		--	TRUNCATE TABLE [margin].[Tb_MarginRptSummary];
		--END
		--ELSE
		--BEGIN

			TRUNCATE TABLE [margin].[Tb_MarginRptDetails];
		
			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - INSERT INTO [margin].[Tb_MarginRptDetails]');

			INSERT INTO [margin].[Tb_MarginRptDetails]
					   ([BusinessDate],[AcctNo],[InstrumentId],[FundSourceId],[MarginCurrCd],[IM]
					   ,[Balance],[BalanceCompanyBased],[MktValue],[MktValueCompanyBased]
					   ,[Loan],[LoanCompanyBased],[MarginRequirement])
			SELECT DISTINCT @dteBusinessDate, C.AcctNo, NULL, C.FundSourceId, C.CurrCd, 1.0, 
				   CASE WHEN C.CashBalance > 0 --+C.RPCashBalance
						THEN C.CashBalance ELSE 0 END AS [Balance], --+C.RPCashBalance
				   CASE WHEN C.AmountCompanyBased - C.RPCashBalance > 0 
						THEN C.AmountCompanyBased- C.RPCashBalance ELSE 0 END AS [BalanceCompanyBased], 
						0 as [MktValue],
						0 as [MktValueCompanyBased],
						0 as Loan,
						0 as LoanCompanyBased,
				 --  0, 0, CASE WHEN C.CashBalance+C.RPCashBalance+ISNULL(SBLC.CashBalance,0)+ISNULL(SBLC.RPCashBalance,0)-ISNULL(SU.GrossAmountTrade,0) < 0 
					--	 THEN ABS(C.CashBalance+C.RPCashBalance+ISNULL(SBLC.CashBalance,0)+ISNULL(SBLC.RPCashBalance,0)-ISNULL(SU.GrossAmountTrade,0)) ELSE ISNULL(SU.GrossAmountTrade,0) END AS [Loan], 
					--CASE WHEN C.CashBalance+C.RPCashBalance+ISNULL(SBLC.CashBalance,0)+ISNULL(SBLC.RPCashBalance,0)-ISNULL(SU.GrossAmountTrade,0) < 0 
					--	 THEN ABS(C.CashBalance+C.RPCashBalance+ISNULL(SBLC.CashBalance,0)+ISNULL(SBLC.RPCashBalance,0)-ISNULL(SU.GrossAmountTrade,0)) ELSE ISNULL(SU.GrossAmountTrade,0) END AS [LoanCompanyBased], 
				        0
			FROM GlobalBO.valuation.Tb_CashRPValuation C
			INNER JOIN GlobalBO.setup.Tb_Account AS A
			ON C.AcctNo = A.AcctNo
			WHERE A.ServiceType IN (SELECT ServiceType FROM #ServiceTypeList_Margin) 
				AND C.BusinessDate = @dteBusinessDate 
				AND C.FundSourceId = 1 AND A.AcctStatus = 'AA';

			INSERT INTO [margin].[Tb_MarginRptDetails]
					   ([BusinessDate],[AcctNo],[InstrumentId],[FundSourceId],[MarginCurrCd],[IM]
					   ,[Balance],[BalanceCompanyBased],[MktValue],[MktValueCompanyBased]
					   ,[Loan],[LoanCompanyBased],[MarginRequirement])
			SELECT @dteBusinessDate, A.AcctNo, NULL, 1, 'MYR', 1.0, 
				   0 AS [Balance], 
				   0 AS [BalanceCompanyBased], 
				   0 as [MktValue],
				   0 as [MktValueCompanyBased],
				   0 AS [Loan], 
				   0 [LoanCompanyBased], 
				   0
			FROM GlobalBO.setup.Tb_Account AS A
			LEFT JOIN [margin].[Tb_MarginRptDetails] AS C
			ON A.AcctNo = C.AcctNo
			WHERE A.ServiceType IN (SELECT ServiceType FROM #ServiceTypeList_Margin) 
				AND A.AcctStatus = 'AA' AND C.AcctNo IS NULL;

			INSERT INTO [margin].[Tb_MarginRptDetails]
					   ([BusinessDate],[AcctNo],[InstrumentId],[FundSourceId],[MarginCurrCd],[IM]
					   ,[Balance],[BalanceCompanyBased],[MktValue],[MktValueCompanyBased]
					   ,[Loan],[LoanCompanyBased],[MarginRequirement])
			SELECT @dteBusinessDate, CC.AcctNo, CC.InstrumentId, CC.FundSourceId, CV.InstrumentTradedCurrCd, 1.0, 0, 0, 
				   Collateral, CollateralCompanyBased, 0, 0, 0
			FROM GlobalBO.holdings.Tb_CustodyAssetsRPCollateral AS CC
            INNER JOIN GlobalBO.valuation.Tb_CustodyAssetsRPValuation CV 
			ON CV.AcctNo = CC.AcctNo AND CV.InstrumentId = CC.InstrumentId AND CV.CompanyId = CC.CompanyId AND CV.BusinessDate = CC.BusinessDate
			INNER JOIN GlobalBO.setup.Tb_Account AS A
			ON CC.AcctNo = A.AcctNo
			INNER JOIN GlobalBO.setup.Tb_FundSource AS FS
			ON CC.FundSourceId = FS.FundSourceId
			WHERE A.ServiceType IN (SELECT ServiceType FROM #ServiceTypeList_Margin) 
				AND A.AcctStatus = 'AA' AND CC.BusinessDate = @dteBusinessDate;

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - INSERT INTO [margin].[Tb_MarginRptDetails]');

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Margin Call Computation');

			TRUNCATE TABLE [margin].[Tb_MarginRptSummary];

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - INSERT INTO [margin].[Tb_MarginRptSummary] FROM [margin].[Tb_MarginRptDetails]');

			INSERT INTO [margin].[Tb_MarginRptSummary]
					   ([BusinessDate],[AcctNo],[MarginCurrCd],[ShareholdingCount]
					   ,[NParameterValue],[Balance],[BalanceCompanyBased],[Loan]
					   ,[LoanCompanyBased],[CashDeposit],[ContractOSValue],[CappedMktValue]
					   ,[Equity],[OutstandingAmount],[MarginRatio],[ApprovedMarginRatio],[CallShortage],[Action],[CreatedDate])
			select	@dteBusinessDate,[AcctNo],[MarginCurrCd],0,0,SUM([Balance]),SUM([BalanceCompanyBased]),
					SUM([Loan]),SUM([LoanCompanyBased]),0,0,0,0,0,0,0,0, '' AS [Action], GETDATE()
			FROM [margin].[Tb_MarginRptDetails] MD
			GROUP BY [AcctNo],[MarginCurrCd];

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - INSERT INTO [margin].[Tb_MarginRptSummary] FROM [margin].[Tb_MarginRptDetails]');
		
			UPDATE MS
			SET ApprovedMarginRatio = [ApprovedRSV (textinput-43)]
			FROM [margin].[Tb_MarginRptSummary] AS MS
			INNER JOIN 
				(select [AccountNumber (textinput-5)], [ApprovedRSV (textinput-43)]
				 from CQBTempDB.export.Tb_FormData_1409
				 WHERE [ParentGroup (selectsource-3)] = 'M'
				 ) AS A
			ON MS.AcctNo = A.[AccountNumber (textinput-5)];

			UPDATE MS
			SET ShareholdingCount = CntInstrument
			FROM [margin].[Tb_MarginRptSummary] AS MS
			INNER JOIN 
				(select AcctNo, COUNT(DISTINCT InstrumentId) AS CntInstrument
				 from margin.Tb_MarginRptDetails
				 where InstrumentId IS NOT NULL AND MktValue > 0
				 group by AcctNo) AS HC
			ON MS.AcctNo = HC.AcctNo;

			--SELECT * FROM [margin].[Tb_MarginRptDetails] AS MS WHERE AcctNo='011806709'
			--Holding 0 Share , N parameter = 1
			--Holding 1 share , N parameter = 3
			--Holding 2 shares , N parameter = 2
			--Holding > 2 shares, N parameter = 1.5
			UPDATE MS
			SET NParameterValue = CASE WHEN ShareholdingCount = 0 THEN 1
									   WHEN ShareholdingCount = 1 THEN 3
									   WHEN ShareholdingCount = 2 THEN 2
									   ELSE 1.5 END
			FROM [margin].[Tb_MarginRptSummary] AS MS;
			
			--SELECT * FROM [margin].[Tb_MarginRptSummary] AS MS WHERE AcctNo='011806709'

			--UPDATE MS
			--SET CashDeposit = T.Amount
			--FROM [margin].[Tb_MarginRptSummary] AS MS
			--INNER JOIN (SELECT AcctNo, SUM(T.Amount) AS Amount 
			--		   FROM GlobalBO.transmanagement.Tb_Transactions AS T
			--		   INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
			--		   ON T.RecordId = TA.ReferenceID
			--		   INNER JOIN GlobalBO.setup.Tb_TransactionType AS TT
			--		   ON T.TransType = TT.TransType
			--		   WHERE TA.AppLevel = '3' AND TA.AppStatus <> 'R' AND LedgerCrDr = 'Cr' AND T.TransType IN ('CHDP') AND SetlDate > @dteBusinessDate
			--		   GROUP BY AcctNo) AS T
			--ON MS.AcctNo = T.AcctNo;

			-- LMV
			UPDATE MRS
			SET CappedMktValue = MktValue
			FROM [margin].[Tb_MarginRptSummary] AS MRS
			INNER JOIN 
				(SELECT AcctNo, SUM(MktValue) AS MktValue
				 FROM [margin].[Tb_MarginRptDetails] AS M
				INNER JOIN GlobalBO.setup.Tb_FundSource AS FS
				ON M.FundSourceId = FS.FundSourceId
				 --AND FS.FundSourceCd IN ('02','08','12') 
				 GROUP BY AcctNo) AS MRDG
			ON MRS.AcctNo = MRDG.AcctNo
		
			UPDATE MS
			SET ContractOSValue = MRDG.ContractOSCappedMktValue
			FROM [margin].[Tb_MarginRptSummary] AS MS
			INNER JOIN 
				(SELECT CC.AcctNo, SUM(CV.RPCustodianBalance * CC.ClosingPrice) AS ContractOSCappedMktValue
				 FROM GlobalBO.holdings.Tb_CustodyAssetsRPCollateral AS CC
				 INNER JOIN GlobalBO.valuation.Tb_CustodyAssetsRPValuation CV 
				 ON CV.AcctNo = CC.AcctNo AND CV.InstrumentId = CC.InstrumentId AND CV.CompanyId = CC.CompanyId AND CV.BusinessDate = CC.BusinessDate
				 GROUP BY CC.AcctNo) AS MRDG
			ON MS.AcctNo = MRDG.AcctNo;

			--BELOW IS ACTUAL CONTRACT NET AMT, BUT SUPPOSED TO USE MKT VALUE OF OS QTY
			--UPDATE MS
			--SET ContractOSValue = CAL.DrPurchase + CAL.CrSales - CAL.DrOverduePurchase
			--FROM [margin].[Tb_MarginRptSummary] AS MS
			--INNER JOIN CashApprovedLimit AS CAL
			--ON MS.AcctNo = CAL.AcctNo;

			-- Equity
			UPDATE MRS
			SET Equity = CappedMktValue + Balance + ContractOSValue
			FROM [margin].[Tb_MarginRptSummary] AS MRS;
			
			
			--UPDATE CC
			----SET CalBuyLimit = CASE WHEN ((MS.CappedMktValue + MS.ContractOSValue) / NParameterValue) - CC.NetCreditDebit + (MS.CashDeposit * 2) <
			----							(CC.ApprovedLimit - CC.NetCreditDebit + (MS.CashDeposit * 2))
			--SET CalBuyLimit = CASE WHEN MS.Equity <= CC.ApprovedLimit
			--					   THEN ((MS.CappedMktValue + MS.ContractOSValue) / NParameterValue) -
			--					   (CASE WHEN CC.NetCreditDebit < 0 THEN ABS(CC.NetCreditDebit) ELSE 0 END) + (MS.CashDeposit * 2)
			--					   ELSE (CC.ApprovedLimit - (CASE WHEN CC.NetCreditDebit < 0 THEN ABS(CC.NetCreditDebit) ELSE 0 END) + (MS.CashDeposit * 2)) END
			--FROM dbo.CashApprovedLimit AS CC
			--INNER JOIN margin.Tb_MarginRptSummary AS MS
			--ON CC.AcctNo = MS.AcctNo
			--WHERE ShareholdingCount>=2 AND ParentGroup IN ('M');
			--Margin Ratio
			UPDATE MRS
			SET MarginRatio = CASE WHEN CAL.NetCreditDebit = 0 AND Equity <> 0 THEN 999.99 
								   WHEN CAL.NetCreditDebit > 0 THEN 999.99
								   WHEN CAL.NetCreditDebit = 0 AND Equity = 0 AND Balance > 0 THEN 999.99 
								   WHEN CAL.NetCreditDebit = 0 AND Equity = 0 THEN 0
								   ELSE ROUND(Equity / ABS(CAL.NetCreditDebit) * 100.00,2) END
			FROM [margin].[Tb_MarginRptSummary] AS MRS
			INNER JOIN CashApprovedLimit AS CAL
			ON MRS.AcctNo = CAL.AcctNo;

			UPDATE MRS
			SET OutstandingAmount = CAL.NetCreditDebit
			FROM [margin].[Tb_MarginRptSummary] AS MRS
			INNER JOIN  CashApprovedLimit AS CAL
			ON MRS.AcctNo = CAL.AcctNo;

			UPDATE MRS
			SET MarginRatio = 999.99
			FROM [margin].[Tb_MarginRptSummary] AS MRS
			WHERE MarginRatio > 999.99;

			--CallShortage
			UPDATE MRS
			SET CallShortage = (NetCreditDebit * ApprovedMarginRatio/100) - ISNULL(Equity,0)
			FROM [margin].[Tb_MarginRptSummary] AS MRS
			INNER JOIN CashApprovedLimit AS CAL
			ON MRS.AcctNo = CAL.AcctNo
			WHERE MarginRatio < ApprovedMarginRatio;

			UPDATE [margin].[Tb_MarginRptSummary]
			SET [Action] = CASE --WHEN ForceShortage <> 0 THEN 'Forced Sell/Buy'
								WHEN CallShortage <> 0 THEN 'Margin Call'
								ELSE '' END
			WHERE CallShortage <> 0;

			CREATE TABLE #CashCollateral_Margin
			(
				BusinessDate date,
				AcctNo VARCHAR(30),
				FormulaSelected VARCHAR(30),
				AutoOrManual CHAR(1) DEFAULT('A'),
				ApprovedLimit decimal(24,9) DEFAULT (0),
				CalBuyLimit decimal(24,9) NULL,
				RealBuyLimit decimal(24,9) NULL
			);

			--CASE D
			INSERT INTO #CashCollateral_Margin (AcctNo,BusinessDate,FormulaSelected,AutoOrManual,ApprovedLimit,CalBuyLimit)
			SELECT CC.AcctNo, CC.BusinessDate, 1, 
					CASE WHEN ShareholdingCount<2 AND ParentGroup IN ('M','G') THEN 'A' ELSE 'N' END, CC.ApprovedLimit,
					--((MS.CappedMktValue + MS.ContractOSValue) / NParameterValue) -
					--			   (CASE WHEN CC.NetCreditDebit < 0 THEN ABS(CC.NetCreditDebit) ELSE 0 END) + (MS.Balance * 2) --+ (MS.CashDeposit * 2)
					((MS.CappedMktValue + MS.ContractOSValue) / NParameterValue) + CC.NetCreditDebit + (MS.Balance * 2) --+ (MS.CashDeposit * 2)
			FROM dbo.CashApprovedLimit AS CC
			INNER JOIN margin.Tb_MarginRptSummary AS MS
			ON CC.AcctNo = MS.AcctNo;

			INSERT INTO #CashCollateral_Margin (AcctNo,BusinessDate,FormulaSelected,AutoOrManual,ApprovedLimit,CalBuyLimit)
			SELECT CC.AcctNo, CC.BusinessDate, 2, 
					CASE WHEN ShareholdingCount>=2 AND ParentGroup IN ('M','G') THEN 'A' ELSE 'N' END, CC.ApprovedLimit,
					--CASE WHEN MS.Equity <= CC.ApprovedLimit
					--			   THEN ((MS.CappedMktValue + MS.ContractOSValue) / NParameterValue) -
					--			   (CASE WHEN CC.NetCreditDebit < 0 THEN ABS(CC.NetCreditDebit) ELSE 0 END) + (MS.Balance * 2)
								   --ELSE 
								   --(CC.ApprovedLimit -
								   --(CASE WHEN CC.NetCreditDebit < 0 THEN ABS(CC.NetCreditDebit) ELSE 0 END)) --+ (MS.Balance * 2)) --END
								   (CC.ApprovedLimit + CC.NetCreditDebit)
			FROM dbo.CashApprovedLimit AS CC
			INNER JOIN margin.Tb_MarginRptSummary AS MS
			ON CC.AcctNo = MS.AcctNo;

			UPDATE M1
			SET M1.AutoOrManual = 'A'
			FROM #CashCollateral_Margin AS M1
			INNER JOIN #CashCollateral_Margin AS M2
			ON M1.AcctNo = M2.AcctNo AND M1.FormulaSelected = 1 AND M2.FormulaSelected = 2
			INNER JOIN margin.Tb_MarginRptSummary AS MS
			ON M1.AcctNo = MS.AcctNo
			WHERE ShareholdingCount >= 2 AND 
				((MS.Equity <= M1.ApprovedLimit) OR
				(MS.Equity > M1.ApprovedLimit AND M1.CalBuyLimit < M2.CalBuyLimit));
			
			UPDATE M2
			SET M2.AutoOrManual = 'N'
			FROM #CashCollateral_Margin AS M1
			INNER JOIN #CashCollateral_Margin AS M2
			ON M1.AcctNo = M2.AcctNo AND M1.FormulaSelected = 1 AND M2.FormulaSelected = 2
			INNER JOIN margin.Tb_MarginRptSummary AS MS
			ON M1.AcctNo = MS.AcctNo
			WHERE ShareholdingCount >= 2 AND 
				((MS.Equity <= M1.ApprovedLimit) OR
				(MS.Equity > M1.ApprovedLimit AND M1.CalBuyLimit < M2.CalBuyLimit));

			INSERT INTO #CashCollateral_Margin (AcctNo,BusinessDate,FormulaSelected,AutoOrManual,ApprovedLimit,CalBuyLimit)
			SELECT CC.AcctNo, CC.BusinessDate, 3, 'N', ApprovedLimit, MS.CappedMktValue + MS.ContractOSValue
			FROM dbo.CashApprovedLimit AS CC
			INNER JOIN margin.Tb_MarginRptSummary AS MS
			ON CC.AcctNo = MS.AcctNo;

			UPDATE #CashCollateral_Margin
			SET RealBuyLimit = CASE WHEN ApprovedLimit < CalBuyLimit THEN ApprovedLimit ELSE CalBuyLimit END
		
			UPDATE #CashCollateral_Margin
			SET RealBuyLimit = 0
			WHERE RealBuyLimit < 0;
		
			UPDATE CC
			SET CalBuyLimit = CCM.CalBuyLimit, RealBuyLimit = CCM.RealBuyLimit
			FROM dbo.CashApprovedLimit AS CC
			INNER JOIN #CashCollateral_Margin AS CCM
			ON CC.AcctNo = CCM.AcctNo AND CC.BusinessDate = CCM.BusinessDate
			INNER JOIN margin.Tb_MarginRptSummary AS MS
			ON CC.AcctNo = MS.AcctNo
			WHERE AutoOrManual='A';
			
			--SELECT * FROM [margin].[Tb_MarginRptSummary] AS MS WHERE AcctNo='011683509'
			--SELECT * FROM CashApprovedLimit AS MS WHERE AcctNo='011683509'

			--CASE D
			--UPDATE CC
			--SET CalBuyLimit = ((MS.CappedMktValue + MS.ContractOSValue) / NParameterValue) - CC.NetCreditDebit + (MS.CashDeposit * 2)
			--FROM #CashCollateral AS CC
			--INNER JOIN margin.Tb_MarginRptSummary AS MS
			--ON CC.AcctNo = MS.AcctNo
			--WHERE ShareholdingCount<2 AND ParentGroup IN ('M');
		

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Margin Call Computation');

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - INSERT INTO [margin].[Tb_MarginRptSummary] FROM GlobalBO.setup.Tb_Account');

			INSERT INTO [margin].[Tb_MarginRptSummary]
					   ([BusinessDate],[AcctNo],[MarginCurrCd],[ShareholdingCount]
					   ,[NParameterValue],[Balance],[BalanceCompanyBased],[Loan]
					   ,[LoanCompanyBased],[CashDeposit],[ContractOSValue],[CappedMktValue]
					   ,[Equity],[OutstandingAmount],[MarginRatio],[CallShortage],[Action],[CreatedDate])
			select	@dteBusinessDate,[AcctNo],'MYR',0,0,0,0,0,0,0,0,0,0,0,0,0, '' AS [Action], GETDATE()
			FROM GlobalBO.setup.Tb_Account AS A
			WHERE A.ServiceType IN (SELECT ServiceType FROM #ServiceTypeList_Margin) 
				AND A.AcctStatus = 'AA'
				AND AcctNo NOT IN (SELECT AcctNo FROM [margin].[Tb_MarginRptSummary] WHERE BusinessDate=@dteBusinessDate)
			
			TRUNCATE TABLE CashApprovedLimit_Margin;

			INSERT INTO CashApprovedLimit_Margin
				([BusinessDate],[AcctNo],[FormulaSelected],[AutoOrManual],[ApprovedLimit],[CalBuyLimit],[RealBuyLimit])
			SELECT [BusinessDate],[AcctNo],[FormulaSelected],[AutoOrManual],[ApprovedLimit],[CalBuyLimit],[RealBuyLimit]
			FROM #CashCollateral_Margin;

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - INSERT INTO [margin].[Tb_MarginRptSummary] FROM GlobalBO.setup.Tb_Account');
			
			DROP TABLE IF EXISTS #ServiceTypeList_Margin;
			DROP TABLE #CashCollateral_Margin;
			--DROP TABLE #TSFCAccounts;
			--DROP TABLE #MarginFormulaIM;
			--DROP TABLE #MarginFormulaDMM;
			--DROP TABLE #MarginFormulaMM;
			--DROP TABLE #MarginFormulaDSMM;
			--DROP TABLE #MarginFormulaSMM;
			--DROP TABLE #MarginFormulaDFS;
			--DROP TABLE #MarginFormulaFS;
			--DROP TABLE #MarginFormulaDSFS;
			--DROP TABLE #MarginFormulaSFS;
		--END

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_CalculateMarginCallReport', '', [MessageLog] 
		from @logs;

    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);

		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_CalculateMarginCallReport: Failed'

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
												  SELECT LogDateTime, 'GlobalBOMY.process.Usp_CalculateMarginCallReport', '', [MessageLog] 
												  from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		      		
		EXEC [master].[dbo].DBA_SendEmail   
		@istrMailTo             = @strEmailTo,
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = @strEmailSubj, 
		@istrimportance         = 'high', 
		@istrfrom_address       = @strEmailFrom, 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END