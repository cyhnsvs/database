/****** Object:  Procedure [report].[USP_GetConfirmedClosedAccount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[USP_GetConfirmedClosedAccount]
	@istrRpttype Varchar(10)
	
AS
/*********************************************************************************** 

Name              : [report].[USP_GetConfirmedClosedAccount]
Created By        : Akshay
Created Date      : 12/04/2021
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@istrRpttype 
	  CCA -ConfirmedClosedAccount
	  RCA -RejectedClosedAccount
  
		
Used By :
Exec [report].[USP_GetConfirmedClosedAccount] 'CCA' 
Exec [report].[USP_GetConfirmedClosedAccount] 'RCA'
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
		IF @istrRpttype = 'CCA'
		BEGIN
        
			SELECT
				RecordType,
				'' as ClientCode,
				AcctNo,	
				NRIC,	
				InvestorName,	
				OpeningDate,
				LastTransDate,	
				GroupId,	
				UserId
			FROM  import.Tb_Bursa_CFT015 Where openingdate is not null;
		END
		ELSE
		BEGIN 
            
			SELECT
				RecordType,
				'' as ClientCode,
				AcctNo,	
				NRIC,	
				InvestorName,	
				OpeningDate,
				LastTransDate,	
				GroupId,	
				UserId
			FROM  import.Tb_Bursa_CFT015 Where openingdate is null;
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