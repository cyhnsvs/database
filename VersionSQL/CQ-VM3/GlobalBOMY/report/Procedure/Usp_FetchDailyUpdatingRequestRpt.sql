/****** Object:  Procedure [report].[Usp_FetchDailyUpdatingRequestRpt]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [report].[Usp_FetchDailyUpdatingRequestRpt]
Created By        : Fadlin    
Created Date      : 11/12/2020
Used by           : 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : 
Table(s) Used     : 

Modification History :            
 ModifiedBy : Raman             Project UIN :                   ModifiedDate : 18-10-2021           Reason : Updated from Subramani's SP changes
 EXEC [report].[Usp_FetchDailyUpdatingRequestRpt] '2021-10-29'
**********************************************************************************/   
CREATE PROCEDURE [report].[Usp_FetchDailyUpdatingRequestRpt]
	@idteReportDate date
AS
BEGIN
	BEGIN TRY 
	
		DECLARE @dteBusinessDate DATE = GETDATE() --GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');
		DECLARE @iintAuditCount1 INT = (SELECT COUNT(1) FROM report.Tb_FormData_1410_AuditLog WHERE BusinessDate=@dteBusinessDate);
		DECLARE @iintAuditCount2 INT = (SELECT COUNT(1) FROM report.Tb_FormData_1409_AuditLog WHERE BusinessDate=@dteBusinessDate);

		IF @iintAuditCount1 > 0 OR @iintAuditCount2 > 0 
		BEGIN
			DELETE FROM report.Tb_FormData_1410_AuditLog 
			WHERE BusinessDate=@dteBusinessDate;
			DELETE FROM report.Tb_FormData_1409_AuditLog 
			WHERE BusinessDate=@dteBusinessDate;
		END
		
		CREATE TABLE #TempAudit
		(
			BusinessDate	DATE,
			RecordID		VARCHAR(200),
			AuditDateTime	VARCHAR(200),
			Mode			VARCHAR(200),
			FieldName		VARCHAR(200),
			OldValue		VARCHAR(max),
			NewValue		VARCHAR(max),
			Createdby		VARCHAR(50),
			CreatedTime		VARCHAR(200),
			Updatedby		VARCHAR(50),
			UpdatedTime		VARCHAR(200)
		);

		INSERT INTO #TempAudit(
			RecordID	
			,AuditDateTime
			,Mode		
			,FieldName	
			,OldValue	
			,NewValue	
			,Createdby	
			,CreatedTime	
			,Updatedby	
			,UpdatedTime	
		)
		EXEC CQBTempDB.[log].[USP_CQBAuditLogDataRetrieval_Daily] '1410', @dteBusinessDate, 'N,U,D';
	
		UPDATE #TempAudit set BusinessDate=@dteBusinessDate; -- CAST(AuditDateTime AS DATE);
	
		INSERT INTO report.Tb_FormData_1410_AuditLog
		SELECT * FROM #TempAudit;

		TRUNCATE TABLE #TempAudit;
		
		INSERT INTO #TempAudit(
			RecordID	
			,AuditDateTime
			,Mode		
			,FieldName	
			,OldValue	
			,NewValue	
			,Createdby	
			,CreatedTime	
			,Updatedby	
			,UpdatedTime	
		)
		EXEC CQBTempDB.[log].[USP_CQBAuditLogDataRetrieval_Daily] '1409', @dteBusinessDate, 'N,U,D';
	
		UPDATE #TempAudit set BusinessDate=@dteBusinessDate;
	
		INSERT INTO report.Tb_FormData_1409_AuditLog
		SELECT * FROM #TempAudit;
		
		--SELECT * FROM GlobalBOMY.report.Tb_FormData_1409_AuditLog
		
		--SELECT * FROM GlobalBOMY.report.Tb_FormData_1410_AuditLog
		
		SELECT * 
		INTO #CustomerFormFields
		FROM [CQBuilder].[form].[Udf_GetFields](1410, 1);
		
		SELECT * 
		INTO #AccountFormFields
		FROM [CQBuilder].[form].[Udf_GetFields](1409, 1);

		SELECT FormID, AcctNo, CustName, ColName, OldValue, NewValue
		FROM (
			SELECT '1409 - Account Form' as FormID, AF.[AccountNumber (textinput-5)] AS AcctNo, AF.[CustomerName (textinput-76)] AS CustName, AL.AuditDateTime,
					ISNULL(AFF.ComponentLabel, FieldName) AS ColName, OldValue, NewValue
			FROM GlobalBOMY.report.Tb_FormData_1409_AuditLog AS AL
			INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS AF
			ON AL.RecordID = AF.RecordID
			LEFT JOIN #AccountFormFields AS AFF
			ON AL.FieldName = AFF.ComponentID
			WHERE (ISNULL(OldValue,'') <>'' OR ISNULL(NewValue,'') <> '') --AND BusinessDate = @idteReportDate

			UNION
		
			SELECT '1410 - Customer Form' as FormID, CF.[CustomerID (textinput-1)] AS AcctNo, [CustomerName (textinput-3)] AS CustName, AL.AuditDateTime,
					ISNULL(CFF.ComponentLabel, FieldName) AS ColName, OldValue, NewValue
			FROM GlobalBOMY.report.Tb_FormData_1410_AuditLog AS AL
			INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS CF
			ON AL.RecordID = CF.RecordID
			INNER JOIN #CustomerFormFields AS CFF
			ON AL.FieldName = CFF.ComponentID
			WHERE (ISNULL(OldValue,'') <>'' OR ISNULL(NewValue,'') <> '') --AND BusinessDate = @idteReportDate
		) AS A
		ORDER BY FormID, AuditDateTime DESC;

		--(
		--	SELECT *
		--	,ROW_NUMBER() OVER (PARTITION BY ColName,AcctNo ORDER BY ReportDate,ColName,AcctNo) row_num
		--	FROM #unp1409_2
		--) as Z
		--GROUP BY AcctNo, ColName
		--ORDER BY AcctNo;

		DROP TABLE #AccountFormFields;
		DROP TABLE #CustomerFormFields;
		DROP TABLE #TempAudit;

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END