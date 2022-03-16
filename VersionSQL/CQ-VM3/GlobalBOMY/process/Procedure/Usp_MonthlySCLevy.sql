/****** Object:  Procedure [process].[Usp_MonthlySCLevy]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_MonthlySCLevy]
	@iintCompanyId BIGINT,
	@idteBussDate DATE,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_MonthlySCLevy]
Created By        : Fadlin
Created Date      : 30/12/2020
Last Updated Date : 
Description       : 
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  

PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_MonthlySCLevy] 1,'2020-06-20',''
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
		
		DECLARE @istrProcessedBy VARCHAR(64) = 'AutoRaiseDebit - Levy';
		DECLARE @intMinrecord INT,
				@intInterval INT = 200,
				@intMaxrecord INT = 1,
				@intRecordCount INT;
		DECLARE @xmlContent XML;
		DECLARE @strInterfaceCdForCash VARCHAR(50) = 'CASHB_NL',
				@bitAutoSubmit BIT = 1,
				@intProcessRefNoForCash BIGINT,
				@strCompanyCd VARCHAR(50),
				@istrExtTransactionId VARCHAR(20)='CHDP';
		DECLARE @dteStartDate date = DATEADD(DAY,1,EOMONTH(@idteBussDate,-1))
		DECLARE @dteEndDate date = EOMONTH(@idteBussDate)

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

		SELECT
			c.AcctExecutiveCd,
			dr.[DealerAccountNo (textinput-37)] as DealerAcctNo,
			SUM(FeeTaxSetl + FeeAmountSetl) as Amount
		INTO #trans
		FROM GlobalBO.contracts.Tb_Contract as c
		INNER JOIN GlobalBO.contracts.Tb_ContractFeeDetails as cf
			ON c.ContractNo = cf.ContractNo 
			AND c.SubContractNo = cf.SubContractNo
			AND c.ContractPartNo = cf.ContractPartNo
			AND c.ContractAmendNo = cf.ContractAmendNo
			AND c.CompanyId = cf.CompanyId
		INNER JOIN GlobalBO.setup.Tb_TransactionFeeDetails as tf
			ON tf.FeeDetailId = cf.FeeDetailId
			AND tf.CompanyId = cf.CompanyId
			AND tf.FeeChargedTo LIKE 'AE%'
		INNER JOIN CQBTempDB.export.Tb_FormData_1377 as dr
			ON dr.[DealerCode (textinput-35)] = c.AcctExecutiveCd
		WHERE c.ContractDate BETWEEN @dteStartDate AND @dteEndDate
		GROUP BY c.AcctExecutiveCd,dr.[DealerAccountNo (textinput-37)]


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
			A.DealerAcctNo as AcctNo,
			'Cash' AS FundSourceCd,
			T.TransTypeDesc AS TransType,
			'' AS SubTransType,
			'MYR' AS CurrCd,                    
			A.Amount AS Amount,                                                            
			'' AS ReferenceNo,
			'' AS GLAccount,
			'Remisier Lavy - ' + A.AcctExecutiveCd AS TransDesc,
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
		from #trans as A
		INNER JOIN GlobalBO.setup.Tb_TransactionType AS T
		ON T.TransType = 'CHDN'

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - INSERT INTO @tblTransactions');     


		SELECT * FROM @tblTransactions

		--SET @intMinrecord = @intMaxrecord ;
		--SET @intMaxrecord = @intMaxrecord + @intInterval;
		--SET @intRecordCount = (SELECT max(SrNO) FROM @tblTransactions);
                        
		--select @intMinrecord, @intMaxrecord, @intRecordCount, @intInterval;

		--INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - While Loop for InsertInterfaceExecution');  

		--WHILE (@intMinrecord < = @intRecordCount)
		--BEGIN

		--	SET @xmlContent = (
		--		SELECT (
		--			SELECT
		--				SetGroupID,
		--				IsParent,
		--				ExecutedBy,
		--				BatchRefNo,
		--				DataRefNo,
		--				TransDate,
		--				SetlDate,
		--				InterestSetlDate,
		--				AcctNo,
		--				FundSourceCd,
		--				TransType,
		--				SubTransType,
		--				CurrCd,
		--				ExchRateBased,
		--				Amount,
		--				AmountBased,
		--				TaxAmount,
		--				ReferenceNo,
		--				GLAccount,
		--				TransDesc,
		--				ProcessInfo,
		--				Tag1,
		--				Tag2,
		--				Tag3,
		--				Tag4,
		--				Tag5
		--			FROM @tblTransactions 
		--			WHERE LedgerOrShare = 'CASH'  AND SrNO > = @intMinrecord AND SrNO < @intMaxrecord  
		--			FOR XML PATH ('Cash')   
                                                      
		--		) AS XMLOutput
		--	);

		--	SELECT @strCompanyCd = CompanyCd
		--	FROM GlobalBO.global.Tb_CompanyMaster
		--	WHERE CompanyId = @iintCompanyId;

		--	EXECUTE GlobalBO.[utilities].[usp_InsertInterfaceExecution] 
		--			@strCompanyCd,
		--			@strInterfaceCdForCash, 
		--			@istrProcessedBy,
		--			@istrExtTransactionId,
		--			@xmlContent,
		--			@bitAutoSubmit,
		--			@intProcessRefNoForCash OUTPUT,
		--			@ostrReturnMessage OUTPUT;
                                       
		--	IF @ostrReturnMessage <> '' OR @intProcessRefNoForCash = -1
		--	BEGIN
		--		SET @ostrReturnMessage = @ostrReturnMessage + N',utilities.usp_InsertInterfaceExecution' ;
		--		EXECUTE GlobalBO.utilities.usp_RethrowError @ostrReturnMessage ;
		--	END

		--	INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - While Loop for InsertInterfaceExecution'); 
			
		--	SET @intMinrecord = @intMaxrecord ;
		--	SET @intMaxrecord = @intMaxrecord + @intInterval;                                   
		--END

		--insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		--SELECT LogDateTime, 'GlobalBOTH.process.Usp_ProcessCustomerCharge', '', [MessageLog] 
		--from @logs;

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