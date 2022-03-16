/****** Object:  Procedure [import].[Usp_IBG_Successful_File]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_IBG_Successful_File]
AS
/***********************************************************************************             
            
Name              : import.Usp_IBG_Successful_File     
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
EXEC [import].[Usp_IBG_Successful_File]
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    DECLARE @ostrReturnMessage VARCHAR(4000);
    BEGIN TRY
    	BEGIN TRANSACTION
     
UPDATE 
    [GlobalBO].[transmanagement].[Tb_TransactionApproval] 
SET 
 AppStatus = CASE TransactionStatus
    WHEN 'Successful' THEN 'A'
    WHEN 'Rejected' THEN 'R'
END
 
FROM 
     [GlobalBO].[transmanagement].[Tb_Transactions]  TS 
INNER JOIN [GlobalBO].[transmanagement].[Tb_TransactionApproval] TA ON TS.RecordId = TA.ReferenceID
INNER JOIN [GlobalBOMY].[import].[IBG_APPROVED_TRANSACTION] APT ON APT.BeneficiaryAcc = TS.AcctNo
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