/****** Object:  Procedure [dbo].[Usp_GetMarginAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetMarginAccounts]
Created By        : Fadlin    
Created Date      : 11/09/2020
Used by           : Margin Incentive Rate Setup Form
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to get list of margin accounts
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [dbo].[Usp_GetMarginAccounts] 'R086'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetMarginAccounts] 
	@istrDealerCode varchar(50)
AS
BEGIN
	BEGIN TRY 

		SELECT [selectsource-1] as CustNo, [textinput-5] as AcctNo
		INTO #tmptAcct
		FROM CQBuilder.form.Tb_FormData_1409 as acct
		WHERE acct.[selectsource-21] = @istrDealerCode

		SELECT B.[AcctNo],cust.[grid-1]
		INTO #tmpGrid
		FROM CQBuilder.form.Tb_FormData_1410 as cust
		INNER JOIN #tmptAcct as B
		ON cust.[textinput-1] = B.CustNo

		SELECT A.AcctNo
		FROM #tmpGrid as A
		CROSS APPLY OPENJSON(A.[grid-1])
		WITH (
			AcctType NVARCHAR(50) '$.seq1'
		) as B
		WHERE B.AcctType IN ('07','09') --G OR M
		
		

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END