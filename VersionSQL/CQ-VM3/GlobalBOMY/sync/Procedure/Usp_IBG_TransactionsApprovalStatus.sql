/****** Object:  Procedure [sync].[Usp_IBG_TransactionsApprovalStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_IBG_TransactionsApprovalStatus]
AS
/***********************************************************************************             
            
Name              : sync.Usp_IBG_TransactionsApprovalStatus     
Created By        : Subramani V
Created Date      : 02/03/2020    
Last Updated Date :             
Description       : this sp is used to import successful transaction need to update approval status as 'A'.
            
Table(s) Used     : 
            
Modification History :  											
 
PARAMETERS
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors            
            
Used By : 
EXEC [import].[Usp_IBG_TransactionsApprovalStatus]
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    DECLARE @ostrReturnMessage VARCHAR(4000);
    BEGIN TRY
    	BEGIN TRANSACTION
     
	UPDATE 
	    TA
	SET 
		AppStatus = CASE TransactionStatus
					WHEN 'Successful' THEN 'A'
					WHEN 'Rejected' THEN 'R'
					END 
	FROM 
	    [GlobalBOMY].[import].[IBG_APPROVED_TRANSACTION]  IBG
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1410_grid6 CG ON CG.[Account Number (TextBox)] = IBG.BeneficiaryAcc
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1410 C ON CG.RecordId = C.RecordId
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1409 A ON C.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)]	 
	INNER JOIN 
		[GlobalBO].[transmanagement].[Tb_Transactions] TS ON TS.AcctNo = A.[AccountNumber (textinput-5)] AND CAST(IBG.CreatedOn AS DATE) = TS.TransDate AND TS.Amount = CAST(REPLACE(SUBSTRING(IBG.Amount,5, LEN(IBG.Amount)),',','') AS DECIMAL(24,9))
	INNER JOIN
		[GlobalBO].[transmanagement].[Tb_TransactionApproval] TA ON TA.ReferenceID = TS.RecordId
	WHERE 
	    SubTransType='IBG';
		
    	COMMIT TRANSACTION
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