/****** Object:  Procedure [process].[Usp_UpdateMarginFormulaApplied]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_UpdateMarginFormulaApplied]
	@iintCompanyId BIGINT,
	@istrAcctNo VARCHAR(30),
	@idteBusinessDate DATE,
	@istrFormulaSelected VARCHAR(30),
	@iintNewMarginRatio BIGINT = 0,
	@istrModifiedBy VARCHAR(64),
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_UpdateMarginFormulaApplied]
Created By        : Fadlin
Created Date      : 04/09/2020
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	
		
Used By :
EXEC [process].[Usp_UpdateMarginFormulaApplied] 1,'019398714','2020-09-07','MR','50','system',''
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
		--DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');
		DECLARE @dteBusinessDate DATE = @idteBusinessDate;

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Update Margin Formula Applied');

		IF (@istrFormulaSelected = 'MR')
		BEGIN
			IF EXISTS (SELECT 1 FROM CashApprovedLimit_Margin WHERE AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate AND FormulaSelected = 'MR')
			BEGIN
				UPDATE CM
				SET 
					CM.CalBuyLimit = CASE WHEN @iintNewMarginRatio = 0 THEN 0 
											ELSE (CappedMktValue-(@iintNewMarginRatio * (CASE WHEN NetOSBalance < 0 THEN NetOSBalance ELSE 0 END)))/(@iintNewMarginRatio-1) END
					,CM.RealBuyLimit = CASE WHEN @iintNewMarginRatio = 0 THEN 0 
											ELSE (CappedMktValue-(@iintNewMarginRatio * (CASE WHEN NetOSBalance < 0 THEN NetOSBalance ELSE 0 END)))/(@iintNewMarginRatio-1) END
					,ModifedBy = @istrModifiedBy
					,ModifiedDate = GETDATE()
				FROM CashApprovedLimit_Margin AS CM
				INNER JOIN CashApprovedLimit AS CA
				ON CA.AcctNo = CM.AcctNo AND CA.BusinessDate = CM.BusinessDate
				WHERE CA.AcctNo = @istrAcctNo AND CA.BusinessDate = @dteBusinessDate AND FormulaSelected = @istrFormulaSelected;
			END
			ELSE
			BEGIN
				INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert margin ratio to CashApprovedLimit_Margin');

				INSERT INTO CashApprovedLimit_Margin
				SELECT 
					BusinessDate
					,AcctNo
					,@istrFormulaSelected
					,'M' as AutoOrManual
					,ApprovedLimit
					,CASE WHEN @iintNewMarginRatio = 0 THEN 0 
							ELSE (CappedMktValue-(@iintNewMarginRatio * (CASE WHEN NetOSBalance < 0 THEN NetOSBalance ELSE 0 END)))/(@iintNewMarginRatio-1) END as CalBuyLimit
					,CASE WHEN @iintNewMarginRatio = 0 THEN 0 
							ELSE (CappedMktValue-(@iintNewMarginRatio * (CASE WHEN NetOSBalance < 0 THEN NetOSBalance ELSE 0 END)))/(@iintNewMarginRatio-1) END as RealBuyLimit
					,'system'
					,GETDATE()
					,null
					,null
				FROM CashApprovedLimit
				WHERE AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate;

				INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert margin ratio to CashApprovedLimit_Margin');
			END
		END

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Update CashApprovedLimit_Margin');
		
		UPDATE CM
		SET AutoOrManual = 'N', ModifedBy = @istrModifiedBy, ModifiedDate = GETDATE()
		FROM CashApprovedLimit_Margin AS CM
		WHERE AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate AND FormulaSelected <> @istrFormulaSelected;

		UPDATE CM
		SET AutoOrManual = 'M', ModifedBy = @istrModifiedBy, ModifiedDate = GETDATE()
		FROM CashApprovedLimit_Margin AS CM
		WHERE AcctNo = @istrAcctNo AND BusinessDate = @idteBusinessDate AND FormulaSelected = @istrFormulaSelected;
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Update CashApprovedLimit');

		UPDATE CA
		SET CalBuyLimit = CM.CalBuyLimit, RealBuyLimit = CM.RealBuyLimit,
			ModifedBy = @istrModifiedBy, ModifiedDate = GETDATE()
		FROM CashApprovedLimit AS CA
		INNER JOIN CashApprovedLimit_Margin AS CM
		ON CA.AcctNo = CM.AcctNo AND CA.BusinessDate = CM.BusinessDate
		WHERE CA.AcctNo = @istrAcctNo AND CA.BusinessDate = @dteBusinessDate AND FormulaSelected = @istrFormulaSelected AND CM.AutoOrManual = 'M';

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_UpdateMarginFormulaApplied', '', [MessageLog] 
		from @logs;

    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);

		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_UpdateMarginFormulaApplied: Failed'

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

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
												  SELECT LogDateTime, 'GlobalBOMY.process.Usp_UpdateMarginFormulaApplied', '', [MessageLog] 
												  from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		      		
		EXEC [master].[dbo].DBA_SendEmail   
		@istrMailTo             = @strEmailTo,
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = @strEmailSubj, 
		@istrimportance         = 'high', 
		@istrfrom_address       = @strEmailFrom, 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END