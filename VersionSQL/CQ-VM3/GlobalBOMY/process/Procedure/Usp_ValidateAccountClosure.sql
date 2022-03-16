/****** Object:  Procedure [process].[Usp_ValidateAccountClosure]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_ValidateAccountClosure]
	@istrAccountNumber VARCHAR(30)
AS
/*********************************************************************************** 

Name              : [process].[Usp_ValidateAccountClosure]
Created By        : Nishanth
Created Date      : 07/10/2021
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	
		
Used By :
EXEC [process].[Usp_ValidateAccountClosure] '012977702'
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');
		
		DECLARE @bitCanClose bit = 1;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Usp_ValidateAccountClosure');

		IF EXISTS (
			SELECT * 
			FROM GlobalBO.holdings.Tb_Cash
			WHERE AcctNo = @istrAccountNumber AND Balance <> 0 OR UnavailableBalance <> 0
		)
			SET @bitCanClose = 0;

		IF EXISTS (
			SELECT * 
			FROM GlobalBO.holdings.Tb_CustodyAssets
			WHERE AcctNo = @istrAccountNumber AND Balance <> 0 OR UnavailableBalance <> 0 OR FinalBalance <> 0
		)
			SET @bitCanClose = 0;

		IF EXISTS (
			SELECT * 
			FROM GlobalBO.holdings.Tb_ReceivablePayableCash
			WHERE AcctNo = @istrAccountNumber AND Balance <> 0
		)
			SET @bitCanClose = 0;

		IF EXISTS (
			SELECT * 
			FROM GlobalBO.holdings.Tb_ReceivablePayableCustodian
			WHERE AcctNo = @istrAccountNumber AND Balance <> 0
		)
			SET @bitCanClose = 0;

		SELECT CASE WHEN @bitCanClose = 1 THEN 'true' ELSE 'false' END;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Usp_ValidateAccountClosure');

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_ValidateAccountClosure', '', [MessageLog] 
		from @logs;

    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200)
		,@istrReturnMessage VARCHAR(1000);

		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_ValidateAccountClosure: Failed'

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@istrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@istrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_ValidateAccountClosure', '', [MessageLog] 
		from @logs;

        RAISERROR (@istrReturnMessage,@intErrorSeverity,@intErrorState);
		      		
		EXEC [master].[dbo].DBA_SendEmail   
		@istrMailTo             = @strEmailTo,
		@istrMailBody           = @istrReturnMessage,  
		@istrMailSubject        = @strEmailSubj, 
		@istrimportance         = 'high', 
		@istrfrom_address       = @strEmailFrom, 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END