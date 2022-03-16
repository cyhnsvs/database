/****** Object:  Procedure [process].[Usp_ProcessCustomerCharge]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_ProcessCustomerCharge]
	@iintCompanyId BIGINT,
	@idteBussDate DATE,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_ProcessCustomerCharge]
Created By        : Fadlin
Created Date      : 01/12/2020
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  

PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_ProcessCustomerCharge] 1,'2021-10-01',''
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
		
		DECLARE @istrProcessedBy VARCHAR(64) = 'CustomerForm/AutoDebitAcctOpeningFees';
		DECLARE @intMinrecord INT,
				@intInterval INT = 200,
				@intMaxrecord INT = 1,
				@intRecordCount INT;
		DECLARE @xmlContent XML;
		DECLARE @strInterfaceCdForCash VARCHAR(50) = 'CASHB_NL',
				@bitAutoSubmit BIT = 1,
				@intProcessRefNoForCash BIGINT,
				@strCompanyCd VARCHAR(50),
				@istrExtTransactionId VARCHAR(20)='CHDN';

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		DECLARE @tblTransactions TABLE (
			ExecutedBy VARCHAR(64),
			BatchRefNo VARCHAR(50),
			DataRefNo VARCHAR(100),
			TransNo VARCHAR(30),
			CompanyId BIGINT,
			TransDate DATE,
			SetlDate DATE,
			InterestSetlDate DATE,
			AcctNo VARCHAR(20),
			FundSourceCd VARCHAR(30),                
			TransType VARCHAR(100),
			SubTransType VARCHAR(10),
			CurrCd CHAR(3),
			TradedPrice DECIMAL(24, 9),                
			ProductCd VARCHAR(50),
			InstrumentCd VARCHAR(50),
			Amount DECIMAL(24, 9),
			TaxAmount DECIMAL(24,9),
			TradedQty  DECIMAL(24, 9),
			CustodianAcctno VARCHAR(20),
			ReferenceNo VARCHAR(50),
			GLAccount VARCHAR(50),
			TransDesc VARCHAR(400),
			ProcessInfo VARCHAR(40),
			Tag1 VARCHAR(200),
			Tag2 VARCHAR(200),
			Tag3 VARCHAR(200),
			Tag4 VARCHAR(200),
			Tag5 VARCHAR(200),
			SetGroupID VARCHAR(50),
			IsParent VARCHAR(5),
			AmountBased DECIMAL(24, 9),
			ExchRateBased DECIMAL(24, 9) ,
			LedgerOrShare VARCHAR(10),
			SrNO BIGINT IDENTITY(1,1) 
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - INSERT INTO @tblTransactions');  

		INSERT INTO @tblTransactions 
		(
			ExecutedBy,BatchRefNo,DataRefNo,TransDate,SetlDate,InterestSetlDate,AcctNo,
			FundSourceCd,TransType,SubTransType,CurrCd,Amount,ReferenceNo,GLAccount,
			TransDesc,ProcessInfo,Tag1,Tag2,Tag3,Tag4,Tag5,SetGroupID,IsParent,LedgerOrShare
		)
		SELECT
			@istrProcessedBy AS ExecutedBy,
			'' AS BatchRefNo,
			'' AS DataRefNo,
			@idteBussDate AS TransDate,
			@idteBussDate AS SetlDate,
			@idteBussDate AS InterestSetlDate,
			--CASE WHEN B.[selectsource-34] IN ('PBCC','PBCB') THEN A.[textinput-5] ELSE C.[textinput-37] END AS AcctNo,
			A.[textinput-5] as AcctNo,
			'Cash' AS FundSourceCd,
			T.TransTypeDesc AS TransType,
			'CDSAOF' AS SubTransType,
			'MYR' AS CurrCd,                    
			'10' AS Amount,                        
			'' AS ReferenceNo,
			'' AS GLAccount,
			'New Account Opening Fees - ' + A.[textinput-5] AS TransDesc,
			'X0X0XXXXXX' + 
					CASE WHEN T.LedgerCrDr = '' THEN 'X' ELSE '0' END +
					CASE WHEN T.CustodianCrDr = '' THEN 'X' ELSE '0' END +
					CASE WHEN T.LedgerCrDr = '' THEN 'X' ELSE '0' END + 'X' + 
					CASE WHEN T.LedgerCrDr = 'Dr' THEN '0' ELSE 'X' END + 
					'C' +
			'XXXXX0XXXXXXXX0000000000' AS ProcessInfo,
			'' AS Tag1,
			'' AS Tag2,
			'' AS Tag3,
			'' AS Tag4,
			'' AS Tag5,
			'' AS SetGroupID,
			'True' AS IsParent,
			'CASH' AS LedgerOrShare
		FROM CQBuilder.form.Tb_FormData_1409 AS A
		INNER JOIN CQBuilder.form.Tb_FormData_1410 AS B
		ON A.[selectsource-1] = B.[textinput-1]
		INNER JOIN GlobalBO.setup.Tb_TransactionType AS T
		ON T.TransType = 'CHDN'
		LEFT JOIN CQBuilder.form.Tb_FormData_1377 as C
		ON C.[textinput-35] = A.[selectsource-21]
		WHERE CAST(A.CreatedTime as date) >= @idteBussDate
		AND B.[selectsource-34] IN ('PBR','PBF','PBCC','PBCB') AND A.CreatedBy = 'CQBuilder Trigger' AND A.Status = 'Active' AND B.Status = 'Active';

		--SELECT * FROM @tblTransactions;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - INSERT INTO @tblTransactions');     

		SET @intMinrecord = @intMaxrecord ;
		SET @intMaxrecord = @intMaxrecord + @intInterval;
		SET @intRecordCount = (SELECT max(SrNO) FROM @tblTransactions);
                        
		select @intMinrecord, @intMaxrecord, @intRecordCount, @intInterval;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - While Loop for InsertInterfaceExecution');  

		WHILE (@intMinrecord < = @intRecordCount)
		BEGIN

			SET @xmlContent = (
				SELECT (
					SELECT
						SetGroupID,
						IsParent,
						ExecutedBy,
						BatchRefNo,
						DataRefNo,
						TransDate,
						SetlDate,
						InterestSetlDate,
						AcctNo,
						FundSourceCd,
						TransType,
						SubTransType,
						CurrCd,
						ExchRateBased,
						Amount,
						AmountBased,
						TaxAmount,
						ReferenceNo,
						GLAccount,
						TransDesc,
						ProcessInfo,
						Tag1,
						Tag2,
						Tag3,
						Tag4,
						Tag5
					FROM @tblTransactions 
					WHERE LedgerOrShare = 'CASH'  AND SrNO > = @intMinrecord AND SrNO < @intMaxrecord  
					FOR XML PATH ('Cash')   
                                                      
				) AS XMLOutput
			);

			SELECT @strCompanyCd = CompanyCd
			FROM GlobalBO.global.Tb_CompanyMaster
			WHERE CompanyId = @iintCompanyId;

			EXECUTE GlobalBO.[utilities].[usp_InsertInterfaceExecution] 
					@strCompanyCd,
					@strInterfaceCdForCash, 
					@istrProcessedBy,
					@istrExtTransactionId,
					@xmlContent,
					@bitAutoSubmit,
					@intProcessRefNoForCash OUTPUT,
					@ostrReturnMessage OUTPUT;
                                       
			IF @ostrReturnMessage <> '' OR @intProcessRefNoForCash = -1
			BEGIN
				SET @ostrReturnMessage = @ostrReturnMessage + N',utilities.usp_InsertInterfaceExecution' ;
				EXECUTE GlobalBO.utilities.usp_RethrowError @ostrReturnMessage ;
			END

			INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - While Loop for InsertInterfaceExecution'); 
			
			SET @intMinrecord = @intMaxrecord ;
			SET @intMaxrecord = @intMaxrecord + @intInterval;                                   
		END

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_ProcessCustomerCharge', '', [MessageLog] 
		from @logs;

    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200)

		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');

		SET @strEmailSubj = @strEmailSubj + ' - Usp_ProcessCustomerCharge: Failed';

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

		ROLLBACK TRANSACTION;

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_ProcessCustomerCharge', '', [MessageLog] 
		from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		
		--EXEC [master].[dbo].DBA_SendEmail   
		--@istrMailTo             = @strEmailTo,
		--@istrMailBody           = @ostrReturnMessage,  
		--@istrMailSubject        = @strEmailSubj, 
		--@istrimportance         = 'high', 
		--@istrfrom_address       = @strEmailFrom, 
		--@istrreply_to           = '',   
		--@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END