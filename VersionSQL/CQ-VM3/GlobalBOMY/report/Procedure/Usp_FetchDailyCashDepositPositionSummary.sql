/****** Object:  Procedure [report].[Usp_FetchDailyCashDepositPositionSummary]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_FetchDailyCashDepositPositionSummary]
	@iintCompanyId BIGINT,
	@idteReportDate DATE,
	@istrBranchId VARCHAR(5),
	@istrDealerType VARCHAR(10)
AS
/*********************************************************************************** 

Name              : [report].[Usp_FetchDailyCashDepositPositionSummary]
Created By        : Fadlin
Created Date      : 27/01/2021
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [report].[Usp_FetchDailyCashDepositPositionSummary] 1, '2021-01-05', '001', 'D'
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		SELECT *
		INTO #trans
		FROM
		(
			SELECT 
				dealer.[DealerCode (textinput-35)] as DealerCd,
				dealer.[DealerAccountNo (textinput-37)] as DealerAcctNo,
				dealer.[Name (textinput-3)] as DealerName,
				acct.[AccountNumber (textinput-5)] as AcctNo,
				CRP.CashBalance,
				0 as UnrealisedLossAmount,
				0 as NettOS,
				'Client' as Flag
			FROM GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt as CRP
			INNER JOIN GlobalBORpt.form.Tb_FormData_1409 as acct
			ON acct.ReportDate = @idteReportDate AND acct.[AccountNumber (textinput-5)] = CRP.AcctNo
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON dealer.ReportDate = @idteReportDate AND dealer.[DealerCode (textinput-35)] = acct.[DealerCode (selectsource-21)]
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.ReportDate = @idteReportDate AND branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			WHERE CRP.ReportDate = @idteReportDate
			AND CRP.FundSourceCd = 'Remisier'
			AND CRP.CompanyId = @iintCompanyId
			AND branch.[BranchID (textinput-1)] = @istrBranchId
			AND dealer.[DealerType (selectsource-3)] = @istrDealerType

			UNION ALL

			SELECT
				dealer.[DealerCode (textinput-35)] as DealerCd,
				dealer.[DealerAccountNo (textinput-37)] as DealerAcctNo,
				dealer.[Name (textinput-3)] as DealerName,
				'' as AcctNo,
				CRP.CashBalance,
				0 as UnrealisedLossAmount,
				0 as NettOS,
				'Remisier' as Flag
			FROM GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt as CRP
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON dealer.ReportDate = @idteReportDate AND dealer.[DealerAccountNo (textinput-37)] = CRP.AcctNo
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.ReportDate = @idteReportDate AND branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			WHERE CRP.ReportDate = @idteReportDate
			AND CRP.CompanyId = @iintCompanyId
			AND branch.[BranchID (textinput-1)] = @istrBranchId
			AND dealer.[DealerType (selectsource-3)] = @istrDealerType
		) as Z
		
		UPDATE trans
		SET 
			trans.UnrealisedLossAmount = (COR.TradedQty * CPR.ClosingPrice) - COR.NetAmountSetl,
			trans.NettOS = COR.NetAmountSetl - ISNULL(CA.MktValue,0)
		FROM #trans as trans
		INNER JOIN GlobalBORpt.contracts.Tb_ContractOutstandingRpt as COR
		ON COR.ReportDate = @idteReportDate AND COR.AcctNo = trans.AcctNo
		INNER JOIN GlobalBORpt.archive.Tb_ClosingPrice as CPR
		ON CPR.BusinessDate = @idteReportDate AND CPR.InstrumentId = COR.InstrumentId
		INNER JOIN CQBTempDB.export.Tb_FormData_1457 as ATL
		ON ATL.[2DigitCode (textinput-1)] = RIGHT(trans.AcctNo,2)
		LEFT JOIN GlobalBORpt.[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] as CA
		ON CA.ReportDate = @idteReportDate AND CA.CompanyId = @iintCompanyId AND CA.AcctNo = trans.AcctNo 
		WHERE trans.Flag = 'Client'
		AND ATL.[CharCode (textinput-3)] = 'A'

		SELECT 
			DealerCd,
			DealerName,
			DealerAcctNo,
			SUM(CASE WHEN Flag = 'Remisier' THEN CashBalance ELSE 0 END) as GrossCashDeposit,
			0 as CollectedInterest,
			SUM(CASE WHEN Flag = 'Remisier' THEN CashBalance + 0 ELSE 0 END) as TotalCashDeposit,
			SUM(CASE WHEN Flag = 'Client' THEN CashBalance ELSE 0 END) as TaggedAmount,
			SUM(CASE WHEN Flag = 'Remisier' THEN CashBalance + 0 ELSE 0 END) + SUM(CASE WHEN Flag = 'Client' THEN CashBalance ELSE 0 END) as BalanceCashDepo,
			0 as UntaggedAmount,
			SUM(UnrealisedLossAmount) as UnrealisedLossAmount,
			0 as UnrecoverAmount,
			0 as NetDeposit,
			0 as ShortFall,
			0 as NetDepositMultiplier,
			SUM(NettOS) as NettOS,
			0 as TopUpDeposit
		INTO #summary
		FROM #trans
		GROUP BY DealerCd, DealerAcctNo, DealerName

		UPDATE summ
		SET summ.UntaggedAmount = upd.NetAmountTrade
		FROM #summary as summ
		INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid as upd
		ON upd.AcctNo = summ.DealerAcctNo
		WHERE upd.TransType IN ('TRBUY','TRSELL')
		AND ABS(DATEDIFF(day, @idteReportDate, upd.SetlDate)) > 30

		UPDATE #summary
		SET 
			NetDeposit = CASE WHEN (TotalCashDeposit - UnrecoverAmount) < 0 THEN TotalCashDeposit - UnrecoverAmount ELSE 0 END,
			ShortFall = CASE WHEN (TotalCashDeposit - UnrecoverAmount) > 0 THEN TotalCashDeposit - UnrecoverAmount ELSE 0 END
		FROM #summary as summ

		UPDATE summ
		SET 
			summ.NetDepositMultiplier = NetDeposit * dealer.[MultiplierMethodValue (textinput-23)],
			summ.TopUpDeposit = (NetDeposit * dealer.[MultiplierMethodValue (textinput-23)]) - NettOS
		FROM #summary as summ
		INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
		ON dealer.ReportDate = @idteReportDate AND dealer.[DealerAccountNo (textinput-37)] = summ.DealerAcctNo

		

		SELECT * FROM #summary;

    END TRY
    BEGIN CATCH
    
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
		SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
        
    END CATCH
	SET NOCOUNT OFF;
END