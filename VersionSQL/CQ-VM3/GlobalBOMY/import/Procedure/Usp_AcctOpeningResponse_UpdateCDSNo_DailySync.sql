/****** Object:  Procedure [import].[Usp_AcctOpeningResponse_UpdateCDSNo_DailySync]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_AcctOpeningResponse_UpdateCDSNo_DailySync]
AS
/***********************************************************************************             
Name              : import.Usp_AcctOpeningResponse_UpdateCDSNo_DailySync     
Created By        : Subramani V
Created Date      : 02/03/2020    
Last Updated Date :             
Description       : this sp is used to import CDS Account's Trading Limit from Hong Leong to GBO
            
Table(s) Used     : 
            
Modification History :  	
 ModifiedBy : 			ModifiedDate : 			Reason : 
 Kristine				2021-10-04				Update to match current flow and fields
 
PARAMETERS
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors            
            
Used By : 
EXEC [import].[Usp_AcctOpeningResponse_UpdateCDSNo_DailySync]
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    DECLARE @ostrReturnMessage VARCHAR(4000);
    BEGIN TRY
        
		DROP TABLE IF EXISTS #Tb_AcctOpening_CFT040;
		DROP TABLE IF EXISTS #TblAccountsToUpdate;
		
		CREATE TABLE #Tb_AcctOpening_CFT040(
			[RecordType] [varchar](1),
			[RecordStatus] [varchar](1),
			[AcctNo] [varchar](9),
			[NRICId] [varchar](14),
			[OldNRICId] [varchar](14),
			[AcctStatus] [varchar](1),
			[IsImported] [bit],
			[RecordID] [bigint]
		);

		CREATE TABLE #TblAccountsToUpdate (
			RecordID NVARCHAR(50),
			CustomerID NVARCHAR(50),
			CustomerIDNumber NVARCHAR(50),
			AccountNumber NVARCHAR(50)
		)

		INSERT INTO #Tb_AcctOpening_CFT040
		SELECT [RecordType],
			[RecordStatus],
			[AcctNo],
			REPLACE(NRICId,'-','') AS [NRICId],
			[OldNRICId],
			[AcctStatus],
			[IsImported],
			[RecordID]
		FROM [GlobalBOMY].[import].[Tb_AcctOpening_CFT040]
		WHERE RecordStatus = 'S' AND IsImported = 0

        IF EXISTS (SELECT 1 FROM #Tb_AcctOpening_CFT040) 
        BEGIN
			
			INSERT INTO #TblAccountsToUpdate 
			SELECT A.[RecordID] RecordID
				,C.[textinput-1] CustomerID
				,C.[textinput-5] CustomerIDNumber
				,A.[textinput-5] AccountNumber
			FROM CQBuilder.form.Tb_FormData_1409 A
				LEFT JOIN CQBuilder.form.Tb_FormData_1410 C 
					ON C.[textinput-1] = A.[selectsource-1]
			WHERE ISNULL(UPPER(A.[textinput-19]),'DUMMY') IN ( 'DUMMY', '' )
				AND ISNULL(C.[textinput-5],'') <> '';

			
    		BEGIN TRANSACTION

			UPDATE CI
			SET FormDetails =  JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(FormDetails
				,'$[0].textinput19', B.AcctNo)
				,'$[1].textinput19', B.AcctNo)
				,'$[0].dateinput21', CAST(GETDATE() as varchar(20)))
				,'$[1].dateinput21', CAST(GETDATE() as varchar(20)))
				,'$[0].selectsource32', B.AcctStatus)
				,'$[1].selectsource32', B.AcctStatus)
				,CI.UpdatedBy = 'CQB-Process'
				,CI.UpdatedTime = GETDATE()
			FROM CQBuilder.form.Tb_FormData_1409 CI
			INNER JOIN #TblAccountsToUpdate AC 
				ON CI.[textinput-5] = AC.AccountNumber
			INNER JOIN #Tb_AcctOpening_CFT040 B 
				ON B.NRICId = AC.CustomerIDNumber ;


			-- UPDATE CDS No 
			UPDATE TGC 
			SET TGC.CDSNo = B.AcctNo
			FROM GlobalBOMY.import.Tb_Gbo_Cust_Acc_Type TGC
			INNER JOIN #TblAccountsToUpdate AC ON AC.CustomerID = TGC.GeneratedCustomerID
			INNER JOIN #Tb_AcctOpening_CFT040 B 
				ON B.NRICId = AC.CustomerIDNumber;

			UPDATE TA
			SET TA.IsImported = 1
			FROM GlobalBOMY.[import].[Tb_AcctOpening_CFT040] TA 
			INNER JOIN #Tb_AcctOpening_CFT040 AS TEMP
				ON TA.RecordID = TEMP.RecordID
			
			
    		COMMIT TRANSACTION
		END
		
    END TRY
    BEGIN CATCH
		
		 DECLARE @intErrorNumber INT
        ,@intErrorLine INT
        ,@intErrorSeverity INT
        ,@intErrorState INT
        ,@strObjectName VARCHAR(200)

		SELECT 
                  @intErrorNumber = ERROR_NUMBER(), 
                  @ostrReturnMessage = ERROR_MESSAGE(), 
                  @intErrorLine = ERROR_LINE(), 
                  @intErrorSeverity = ERROR_SEVERITY(), 
                  @intErrorState = ERROR_STATE(), 
                  @strObjectName = ERROR_PROCEDURE();
				   
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; 

    	EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber, @ostrReturnMessage, @intErrorLine, @strObjectName,NULL, 'Process fail.';

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);           

    END CATCH

	SET NOCOUNT OFF;
END