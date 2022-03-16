/****** Object:  Procedure [process].[Usp_Daily_UpdateAccountFirstTradingDate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_Daily_UpdateAccountFirstTradingDate]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_Daily_UpdateAccountFirstTradingDate]
Created By        : Nishanth
Created Date      : 08/10/2021
Last Updated Date : 
Description       : this sp is used to update the FirstTrading Date 
Table(s) Used     : 
					
Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_Daily_UpdateAccountFirstTradingDate] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;

	DECLARE @dteBusinessDate DATE
	SELECT @dteBusinessDate = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')

    BEGIN TRY
    	BEGIN TRANSACTION
        		
		SELECT DISTINCT AcctNo
		INTO #Contracts
		FROM GlobalBO.contracts.Tb_ContractOutstanding
		WHERE ContractDate = @dteBusinessDate;

		UPDATE	Acc 
		SET		FormDetails = JSON_MODIFY(JSON_MODIFY(FormDetails,'$[0].dateinput25',CAST(@dteBusinessDate AS VARCHAR)),'$[1].dateinput25',CAST(@dteBusinessDate AS VARCHAR))
		FROM CQBuilder.form.Tb_FormData_1409 Acc 
		INNER JOIN #Contracts AS C 
			ON Acc.[textinput-5] = C.AcctNo
		WHERE [selectsource-31] <> 'C' AND ISNULL([dateinput-25],'') = '';
			
		UPDATE	Acc 
		SET	    [FirstTradingDate (dateinput-25)] = @dteBusinessDate
		FROM CQBTempDB.import.Tb_FormData_1409 Acc 
		INNER JOIN #Contracts AS C 
			ON Acc.[AccountNumber (textinput-5)] = C.AcctNo
		WHERE [Tradingaccount (selectsource-31)] <> 'C' AND ISNULL([FirstTradingDate (dateinput-25)],'') = '';

		DROP TABLE #Contracts;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		      
		ROLLBACK TRANSACTION;

		Select @ostrReturnMessage;
		
		--EXEC [master].[dbo].DBA_SendEmail   
		--@istrMailTo             = 'nishanthc@cyberquote.com.sg;',
		--@istrMailBody           = @ostrReturnMessage,  
		--@istrMailSubject        = 'Usp_ProcessAccountDetails: Failed', 
		--@istrimportance         = 'high', 
		--@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		--@istrreply_to           = '',   
		--@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END