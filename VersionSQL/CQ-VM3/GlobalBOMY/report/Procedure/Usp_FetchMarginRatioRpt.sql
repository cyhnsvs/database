/****** Object:  Procedure [report].[Usp_FetchMarginRatioRpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_FetchMarginRatioRpt]
	@iintCompanyId BIGINT,
	@idteReportDate DATE
AS
/*********************************************************************************** 

Name              : [report].[Usp_FetchMarginRatioRpt]
Created By        : Fadlin
Created Date      : 06/01/2021
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [report].[Usp_FetchMarginRatioRpt] 1,'2021-09-30'
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		SELECT
			Acct.[DealerCode (selectsource-21)] as DealerCd,
			A.AcctNo as AcctNo,
			Cust.[CustomerName (textinput-3)] as AcctName,
			A.CashBalance,
			A.CappedMktValue,
			A.CashBalance + A.CappedMktValue as MarginEQ,
			A.NetOSBalance,
			ISNULL(MS.MarginRatio,0) as MarginRatioComp,
			A.ApprovedLimit
		FROM CashApprovedLimit as A
		INNER JOIN margin.Tb_MarginRptSummary as MS
		ON MS.AcctNo = A.AcctNo AND A.BusinessDate = MS.BusinessDate
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 as Acct
		ON A.AcctNo = Acct.[AccountNumber (textinput-5)]
		INNER JOIN CQBTempDB.export.Tb_FormData_1410 as Cust
		ON Cust.[CustomerID (textinput-1)] = Acct.[CustomerID (selectsource-1)]
		--INNER JOIN GlobalBORpt.form.Tb_FormData_1409 as Acct
		--ON A.AcctNo = Acct.[AccountNumber (textinput-5)] AND Acct.ReportDate = @idteReportDate
		--INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as Cust
		--ON Cust.[CustomerID (textinput-1)] = Acct.[CustomerID (selectsource-1)] AND cust.ReportDate = @idteReportDate
		WHERE Acct.[DealerCode (selectsource-21)] <> '' AND A.BusinessDate = @idteReportDate;

    END TRY
    BEGIN CATCH
    
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
		SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
        
    END CATCH
	SET NOCOUNT OFF;
END