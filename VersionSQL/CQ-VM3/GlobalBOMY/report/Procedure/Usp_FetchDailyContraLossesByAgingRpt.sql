/****** Object:  Procedure [report].[Usp_FetchDailyContraLossesByAgingRpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_FetchDailyContraLossesByAgingRpt]
	@iintCompanyId BIGINT,
	@idteReportDate DATE,
	@istrBranchId VARCHAR(5)
AS
/*********************************************************************************** 

Name              : [report].[Usp_FetchDailyContraLossesByAgingRpt]
Created By        : Fadlin
Created Date      : 26/01/2021
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [report].[Usp_FetchDailyContraLossesByAgingRpt] 1, '2021-01-05', '001'
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		SELECT *
		INTO #trans
		FROM
		(
			SELECT SetlDate, AcctNo, Amount, 0 as Interest 
			FROM GlobalBO.transmanagement.Tb_Transactions
			WHERE TransType IN ('CHLS','SCHLS')

			UNION 

			SELECT SetlDate, AcctNo, NetAmountSetl, ISNULL(AccruedInterestAmountSetl,0)
			FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid
			WHERE TransType IN ('CHLS','SCHLS')
		) as Z

		SELECT
			DealerType,
			DealerCd,
			DealerName,
			Z.AcctNo,
			AcctName,
			ISNULL(SUM(CH.CashBalance),0) as CashBalance,
			ISNULL(SUM(CA.Collateral),0) as Collateral,
			ISNULL(SUM(CA.MktValue),0) as MktValue,
			SUM(AmountAging1) as AmountAging1,
			SUM(AmountAging2) as AmountAging2,
			SUM(AmountAging3) as AmountAging3,
			SUM(AmountAging4) as AmountAging4,
			SUM(AmountAging5) as AmountAging5,
			--SUM(InterestAging1) as InterestAging1,
			--SUM(InterestAging2) as InterestAging2,
			--SUM(InterestAging3) as InterestAging3,
			--SUM(InterestAging4) as InterestAging4,
			--SUM(InterestAging5) as InterestAging5,
			SUM(AmountAging1 + AmountAging2 + AmountAging3 + AmountAging4 + AmountAging5) as TotalLoss,
			SUM(InterestAging1 + InterestAging2 + InterestAging3 + InterestAging4 + InterestAging5) as TotalInterest
		INTO #result
		FROM
		(
			SELECT 
				CR.[CodeDisplay (textinput-2)] as DealerType,
				dealer.[DealerCode (textinput-35)] as DealerCd,
				dealer.[Name (textinput-3)] as DealerName,
				acct.[AccountNumber (textinput-5)] as AcctNo,
				cust.[CustomerName (textinput-3)] as AcctName,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) <= 15 THEN trans.Amount ELSE 0 END as AmountAging1,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) BETWEEN 16 AND 30 THEN trans.Amount ELSE 0 END as AmountAging2,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) BETWEEN 31 AND 60 THEN trans.Amount ELSE 0 END as AmountAging3,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) BETWEEN 61 AND 365 THEN trans.Amount ELSE 0 END as AmountAging4,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) > 365 THEN trans.Amount ELSE 0 END as AmountAging5,

				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) <= 15 THEN trans.Interest ELSE 0 END as InterestAging1,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) BETWEEN 16 AND 30 THEN trans.Interest ELSE 0 END as InterestAging2,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) BETWEEN 31 AND 60 THEN trans.Interest ELSE 0 END as InterestAging3,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) BETWEEN 61 AND 365 THEN trans.Interest ELSE 0 END as InterestAging4,
				CASE WHEN ABS(DATEDIFF(day, @idteReportDate, trans.SetlDate)) > 365 THEN trans.Interest ELSE 0 END as InterestAging5
			FROM #trans as trans
			INNER JOIN GlobalBORpt.form.Tb_FormData_1409 as acct
			ON acct.[AccountNumber (textinput-5)] = trans.AcctNo AND acct.ReportDate = @idteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
			ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)] AND cust.ReportDate = @idteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON dealer.[DealerCode (textinput-35)] = acct.[DealerCode (selectsource-21)] AND dealer.ReportDate = @idteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)] AND branch.ReportDate = @idteReportDate
			INNER JOIN CQBTempDB.export.Tb_FormData_1319 as CR
			ON CR.[CodeType (selectbasic-1)] = 'DealerType' AND CR.[Value (textinput-3)] = dealer.[DealerType (selectsource-3)]
			WHERE branch.[BranchID (textinput-1)] = @istrBranchId
		) as Z
		LEFT JOIN GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt as CH
		ON CH.AcctNo = Z.AcctNo AND CH.ReportDate = @idteReportDate AND CH.CompanyId = @iintCompanyId
		LEFT JOIN GlobalBORpt.[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] as CA
		ON CA.AcctNo = Z.AcctNo AND CA.CompanyId = @iintCompanyId AND CA.ReportDate = @idteReportDate
		GROUP BY DealerType, DealerCd, DealerName, Z.AcctNo, AcctName
		--ORDER BY DealerType,DealerCd,AcctName
		--OPTION(RECOMPILE)

		SELECT *
		FROM #result
		ORDER BY DealerType,DealerCd,
		CASE 
			WHEN TotalLoss > (CashBalance + Collateral) THEN 1
			WHEN TotalLoss > CashBalance THEN 2
			WHEN TotalLoss = CashBalance THEN 3
			WHEN TotalLoss < CashBalance THEN 4
			WHEN TotalLoss < (CashBalance + Collateral) THEN 5
		END

    END TRY
    BEGIN CATCH
    
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
		SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
        
    END CATCH
	SET NOCOUNT OFF;
END