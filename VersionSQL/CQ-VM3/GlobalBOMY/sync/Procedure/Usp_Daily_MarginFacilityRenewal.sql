/****** Object:  Procedure [sync].[Usp_Daily_MarginFacilityRenewal]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_MarginFacilityRenewal]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : sync.[Usp_Daily_MarginFacilityRenewal]
Created By        : Nishanth
Created Date      : 19/07/2020
Last Updated Date : 
Description       : this sp is used to renew the margin facility for expiring margin accounts
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 

PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [sync].[Usp_Daily_MarginFacilityRenewal] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;

	DECLARE @dteBusinessDate DATE 
	SET @dteBusinessDate = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

	DECLARE @dteNextBusinessDate DATE
	SET @dteNextBusinessDate = [global].[Udf_GetNextBusDateByDaysExcludePH](@dteBusinessDate,1,NULL);
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		UPDATE	A
		SET		[CommencementDate (dateinput-4)] = @dteBusinessDate,
				[TenorExpiryDate (dateinput-5)]  = DATEADD(day, 90, @dteBusinessDate)	
		FROM	CQBTempDB.export.Tb_FormData_1409	A
		WHERE	[ParentGroup (selectsource-3)] = 'M' 
		AND		[TenorExpiryDate (dateinput-5)] = @dteBusinessDate AND [TenorExpiryDate (dateinput-5)] < @dteNextBusinessDate
		
		--SELECT [dateinput-4],*		
		--FROM CQBuilder.form.Tb_FormData_1409
		--WHERE [selectsource-3]='M' AND [dateinput-5]= GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')

		--[CommencementDate (dateinput-4)] = '2020-12-31'
		--[TenorExpiryDate (dateinput-5)] = '2020-12-31' + 90

		--select * from GlobalBOMY.import.Tb_AccountMargin

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