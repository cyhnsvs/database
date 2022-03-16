/****** Object:  Procedure [report].[Usp_FetchMarginRatioSummaryRpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_FetchMarginRatioSummaryRpt]
	@iintCompanyId BIGINT,
	@idteReportDate DATE
AS
/*********************************************************************************** 

Name              : [report].[Usp_FetchMarginRatioSummaryRpt]
Created By        : Fadlin
Created Date      : 08/02/2021
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [report].[Usp_FetchMarginRatioSummaryRpt] 1,'2021-01-05'
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		CREATE TABLE #MarginRatio
		(
			DealerCd varchar(10),
			AcctNo varchar(50),
			AcctName nvarchar(4000),
			CashBalance decimal(24,9),
			CappedMktValue decimal(24,9),
			MarginEQ decimal(24,9),
			NetOSBalance decimal(24,9),
			MarginRatioComp decimal(24,9),
			ApprovedLimit decimal(24,9)
		)

		INSERT INTO #MarginRatio
		EXEC [report].[Usp_FetchMarginRatioRpt] @iintCompanyId,@idteReportDate;

	
		SELECT
			SummGroup,
			OSGroup,
			count(1) as NoofAcct,
			SUM(ApprovedLimit) as ApprovedLimit,
			SUM(NetOSBalance) as OSBalance,
			SUM(MarginEQ) as MarginEQ
		FROM
		(
			SELECT 
				CASE 
					WHEN MarginRatioComp BETWEEN 0 AND 129.99 THEN 'A'
					WHEN MarginRatioComp BETWEEN 130 AND 150 THEN 'B'
					WHEN MarginRatioComp > 150 THEN 'C'
				END as SummGroup,
				CASE
					WHEN NetOSBalance = 0 THEN 'Zero'
					WHEN NetOSBalance > 0 THEN 'Positive'
					WHEN NetOSBalance <0 THEN 'Negative'
				END as OSGroup,
				ApprovedLimit,
				NetOSBalance,
				MarginEQ
			FROM #MarginRatio
		) as Z
		GROUP BY SummGroup, OSGroup



    END TRY
    BEGIN CATCH
    
		DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
		SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
		SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
		RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
        
    END CATCH
	SET NOCOUNT OFF;
END