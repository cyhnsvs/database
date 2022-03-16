/****** Object:  Procedure [report].[Usp_GetMarginFormulaApplied]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_GetMarginFormulaApplied]
	@iintCompanyId BIGINT,
	@istrAcctNo VARCHAR(30),
	@idteBusinessDate DATE,
	@iintNewMarginRatio BIGINT = 0
AS
/*********************************************************************************** 

Name              : [report].[Usp_GetMarginFormulaApplied]
Created By        : Fadlin
Created Date      : 04/09/2020
Last Updated Date : 
Description       : this sp is used to get the margin formula applied
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [report].[Usp_GetMarginFormulaApplied] 1, '018377601', '2020-09-07', ''
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		DECLARE @strAutoFormula varchar(5);

		SELECT 
			@strAutoFormula = FormulaSelected 
		FROM dbo.CashApprovedLimit_Margin 
		WHERE AutoOrManual IN ('A','M') AND AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate

		;with CTE as  
		(  
			SELECT * FROM
			(
				SELECT
				BusinessDate,
				AcctNo,
				CASE 
					WHEN FormulaSelected = '1' THEN 'CallBuy1'
					WHEN FormulaSelected = '2' THEN 'CallBuy2'
					WHEN FormulaSelected = '3' THEN 'CallBuy3'
				END AS LimitType,
				CalBuyLimit AS Amount
				FROM dbo.CashApprovedLimit_Margin
				WHERE AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate

				UNION

				SELECT 
				BusinessDate,
				AcctNo,
				CASE 
					WHEN FormulaSelected = '1' THEN 'RealBuy1'
					WHEN FormulaSelected = '2' THEN 'RealBuy2'
					WHEN FormulaSelected = '3' THEN 'RealBuy3'
				END AS LimitType,
				RealBuyLimit AS Amount
				FROM dbo.CashApprovedLimit_Margin
				WHERE AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate
			) AS SourceTable
			PIVOT
			(
				SUM(Amount)
				FOR LimitType IN ([CallBuy1], [CallBuy2], [CallBuy3], [RealBuy1], [RealBuy2], [RealBuy3])
			) AS pv1
		)  

		SELECT CA.[BusinessDate]
			  ,CA.[AcctNo]
			  ,ACT.[textinput-76] AS CustomerName
			  ,[AT].[textinput-2] AS AcctServiceType
			  ,PG.[textinput-2] AS ParentGroup
			  ,CA.[ApprovedLimit]
			  ,MS.ApprovedMarginRatio
			  ,[CashBalance]
			  ,[PendingCashBalance]
			  ,[TotalCashBalance]
			  ,[DrPurchase]
			  ,[DrContraLoss]
			  ,[DrSetoffLoss]
			  ,[DrInterest]
			  ,[DrNonTrade]
			  ,[TotalDebit]
			  ,[CrSales]
			  ,[CrSalesT1]
			  ,[CrContraGain]
			  ,[CrSetoffGain]
			  ,[CrInterest]
			  ,[CrNonTrade]
			  ,[TotalCredit]
			  ,[NetCreditDebit]
			  ,[NetOSBalance]
			  ,CA.[CappedMktValue]
			  ,[CapBuyLimit]
			  ,@strAutoFormula AS AutoFormula
			  ,CTE.CallBuy1
			  ,CTE.CallBuy2
			  ,CTE.CallBuy3
			  ,CTE.RealBuy1
			  ,CTE.RealBuy2
			  ,CTE.RealBuy3
			  ,CASE WHEN @iintNewMarginRatio = 0 THEN 0 
					ELSE (CA.CappedMktValue-(@iintNewMarginRatio * (CASE WHEN NetOSBalance < 0 THEN NetOSBalance ELSE 0 END)))/(@iintNewMarginRatio-1) END as NewMarginLimit,
				CA.CappedMktValue
			  , MS.MarginRatio
		FROM dbo.CashApprovedLimit AS CA
		INNER JOIN CTE AS CTE
		ON CA.AcctNo = CTE.AcctNo AND CA.BusinessDate = CTE.BusinessDate
		INNER JOIN GlobalBOMY.margin.Tb_MarginRptSummary AS MS
		ON CA.AcctNo = MS.AcctNo AND CA.BusinessDate = MS.BusinessDate
		INNER JOIN CQBuilder.form.Tb_FormData_1409 as ACT
		ON ACT.[textinput-5] = CA.AcctNo
		INNER JOIN CQBuilder.form.Tb_FormData_1319 as PG
		ON PG.[textinput-3] = ACT.[selectsource-3] AND PG.Status = 'Active' AND PG.[selectbasic-1] = 'AccountGroup'
		INNER JOIN CQBuilder.form.Tb_FormData_1319 as [AT]
		ON [AT].[textinput-3] = ACT.[selectsource-7] AND [AT].Status = 'Active' AND [AT].[selectbasic-1] = 'AccountType'
		WHERE CA.AcctNo = @istrAcctNo AND CA.BusinessDate = @idteBusinessDate;

    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200)
		,@strErrorMessage VARCHAR(4000);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@strErrorMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@strErrorMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

        RAISERROR (@strErrorMessage,@intErrorSeverity,@intErrorState);
        
    END CATCH
	SET NOCOUNT OFF;
END