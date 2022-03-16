/****** Object:  Procedure [process].[Usp_UpdateCustodyAssetsCDS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_UpdateCustodyAssetsCDS]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_UpdateCustodyAssetsCDS]
Created By        : Nishanth Chowdhary
Created Date      : 18/02/2021
Last Updated Date : 
Description       : this sp is used to update the holdings at CDS Level
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_UpdateCustodyAssetsCDS] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY

	BEGIN TRAN
    	
	DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');
		
	declare @logs table(
		[MessageLog] varchar(8000),
		LogDateTime datetime
	);
		
	INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Merge Into Tb_CustodyAssetsCDS');

	;WITH cte_CustodyAssetDetails AS (
        SELECT C.CompanyId, A.[CDSNo (textinput-19)] AS CDSNo, FundSourceId, CustodianId, CustodianAcctNo, ProductId, InstrumentId,
				SUM(CustodyAssetsBalance) AS CustodyAssetsBalance, SUM(CustodyAssetsLent) AS CustodyAssetsLent, 
				SUM(CustodyAssetsBorrowed) AS CustodyAssetsBorrowed, SUM(RPCustodianBalance) AS RPCustodianBalance, 
				SUM(CustodyAssetsUBalance) AS CustodyAssetsUBalance, SUM(CustodyAssetsFBalance) AS CustodyAssetsFBalance,
				SUM(CustodyAssetsCostTrade) AS CustodyAssetsCostTrade, SUM(CustodyAssetsCostCompanyBased) AS CustodyAssetsCostCompanyBased,
				SUM(CustodyAssetsCostClientBased) AS CustodyAssetsCostClientBased
		FROM CQBTempDB.export.Tb_FormData_1409 AS A
		INNER JOIN GlobalBO.valuation.Tb_CustodyAssetsRPValuation AS C
		ON A.[AccountNumber (textinput-5)] = C.AcctNo
		WHERE C.CompanyId = @iintCompanyId
		GROUP BY C.CompanyId, A.[CDSNo (textinput-19)], FundSourceId, CustodianId, CustodianAcctNo, ProductId, InstrumentId
	  )
      MERGE INTO GlobalBOMY.holdings.Tb_CustodyAssetsCDS AS TRGT
      USING cte_CustodyAssetDetails AS SRC ON
		SRC.CDSNo = TRGT.AcctNo AND SRC.CompanyId = TRGT.CompanyId
        WHEN MATCHED THEN UPDATE SET
        	TRGT.Balance = SRC.CustodyAssetsBalance,
			TRGT.Lent = SRC.CustodyAssetsLent,
			TRGT.Borrowed = SRC.CustodyAssetsBorrowed,
			TRGT.RPBalance = SRC.RPCustodianBalance,
			TRGT.UnavailableBalance = SRC.CustodyAssetsUBalance,
            TRGT.FinalBalance = SRC.CustodyAssetsFBalance,
            TRGT.CostTrade = SRC.CustodyAssetsCostTrade,
            TRGT.CostCompanyBased = SRC.CustodyAssetsCostCompanyBased,
            TRGT.CostClientBased = SRC.CustodyAssetsCostClientBased,
            TRGT.ModifiedBy = 'CUSTODYASSETS-DAILYSYNC',
            TRGT.ModifiedDate = GETDATE()
         WHEN NOT MATCHED BY TARGET THEN
         	INSERT (
            	[CompanyId]
			   ,[AcctNo]
			   ,[FundSourceId]
			   ,[CustodianId]
			   ,[CustodianAcctNo]
			   ,[ProductId]
			   ,[InstrumentId]
			   ,[Balance]
			   ,[Lent]
			   ,[Borrowed]
			   ,[RPBalance]
			   ,[UnavailableBalance]
			   ,[FinalBalance]
			   ,[CostTrade]
			   ,[CostCompanyBased]
			   ,[CostClientBased]
			   ,[RecordId]
			   ,[ModifiedProcessId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[ModifiedBy]
			   ,[ModifiedDate]
            ) VALUES (
				@iintCompanyId,
            	SRC.CDSNo,
                SRC.FundSourceId,
				SRC.CustodianId,
				SRC.CustodianAcctNo,
				SRC.ProductId,
				SRC.InstrumentId,
				SRC.CustodyAssetsBalance,
				SRC.CustodyAssetsLent,
				SRC.CustodyAssetsBorrowed,
				SRC.RPCustodianBalance,
				SRC.CustodyAssetsUBalance,
				SRC.CustodyAssetsFBalance,
				SRC.CustodyAssetsCostTrade,
				SRC.CustodyAssetsCostCompanyBased,
				SRC.CustodyAssetsCostClientBased,
				NEWID(),
				'',
				'CUSTODYASSETS-DAILYSYNC',
				GETDATE(),
				NULL,
				NULL
				);

        --select * from GlobalBOMY.holdings.Tb_CustodyAssetsCDS 
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Merge Into Tb_CustodyAssetsCDS');

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_UpdateCustodyAssetsCDS', '', [MessageLog] 
		from @logs;

		commit tran;

    END TRY
    BEGIN CATCH

	rollback tran;
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);

		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_UpdateCustodyAssetsCDS: Failed'

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
												  SELECT LogDateTime, 'GlobalBOMY.process.Usp_UpdateCustodyAssetsCDS', '', [MessageLog] 
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