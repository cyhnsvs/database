/****** Object:  Procedure [report].[Usp_GetMarginFormulaApplied_20201130]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_GetMarginFormulaApplied_20201130]
	@iintCompanyId BIGINT,
	@istrAcctNo VARCHAR(30),
	@idteBusinessDate DATE
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
Exec [report].[Usp_GetMarginFormulaApplied] 1, '018681514', '2020-09-04', ''
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		DECLARE @intAutoFormula bigint;

		SELECT 
			@intAutoFormula = FormulaSelected 
		FROM dbo.CashApprovedLimit_Margin 
		WHERE AutoOrManual = 'A' AND AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate

		;with CTE as  
		(  
			SELECT * FROM
			(
				SELECT
				BusinessDate,
				AcctNo,
				CASE 
					WHEN FormulaSelected = 1 THEN 'CallBuy1'
					WHEN FormulaSelected = 2 THEN 'CallBuy2'
					WHEN FormulaSelected = 3 THEN 'CallBuy3'
				END AS LimitType,
				CalBuyLimit AS Amount
				FROM dbo.CashApprovedLimit_Margin
				WHERE AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate

				UNION

				SELECT 
				BusinessDate,
				AcctNo,
				CASE 
					WHEN FormulaSelected = 1 THEN 'RealBuy1'
					WHEN FormulaSelected = 2 THEN 'RealBuy2'
					WHEN FormulaSelected = 3 THEN 'RealBuy3'
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
			  ,[AcctServiceType]
			  ,[ParentGroup]
			  ,CA.[ApprovedLimit]
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
			  ,[CappedMktValue]
			  ,[CapBuyLimit]

			  ,@intAutoFormula AS AutoFormula
			  ,CTE.CallBuy1
			  ,CTE.CallBuy2
			  ,CTE.CallBuy3
			  ,CTE.RealBuy1
			  ,CTE.RealBuy2
			  ,CTE.RealBuy3

		FROM dbo.CashApprovedLimit AS CA
		INNER JOIN CTE AS CTE
		ON CA.AcctNo = CTE.AcctNo AND CA.BusinessDate = CTE.BusinessDate
		WHERE CA.AcctNo = @istrAcctNo AND CA.BusinessDate = @idteBusinessDate

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