/****** Object:  Procedure [process].[USP_AutoDebitNoteForRemisierAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[USP_AutoDebitNoteForRemisierAccounts]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : process.[USP_AutoDebitNoteForRemisierAccounts]
Created By        : Nathiya Palanisamy
Created Date      : 15/06/2021
Last Updated Date : 
Description       : this sp is used to Auto debit 3RM * total as CHDN from Remisier accounts  on 1st of every month
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[USP_AutoDebitNoteForRemisierAccounts] 1, ''

************************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');

	BEGIN TRY
		--BEGIN TRANSACTION;

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');
		
		IF EXISTS (
			SELECT 1
			FROM GlobalBOMY.import.Tb_RM3_Remisier R
			LEFT JOIN CQBTempDB.export.Tb_FormData_1377 D 
			ON LTRIM(RTRIM(R.DRCode)) = D.[DealerCode (textinput-35)]
			WHERE CAST(R.Total as bigint) > 0 AND LEFT(LTRIM(RTRIM(R.DRCode)),1) = 'R' AND D.[DealerCode (textinput-35)] IS NULL
		)
			execute utilities.usp_RethrowError  '1 or more Remisier/Dealer Code(s) not found in GBO - process.USP_AutoDebitNoteForRemisierAccounts';

		-- Service charge Transactions
		INSERT INTO [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction] (
			[CompanyId],[ExtTransactionId],[NonTradeTransInstructionType],[TransDate],
			[AcctNo],[TransType],
			[SubTransType],
			[CurrCd],
			[TransDesc],
			[TaxAmount],
			[Amount],
			[TradedQty],			
			[ReferenceNo],
			Tag1,
			Tag2,	
			Tag3,	
			[FundSourceCd],
			[SetlDate],
			Tag4,
			CreatedBy,
			CreatedDate
		)
		SELECT
			@iintCompanyId,
			'REM' + CAST(@dteBusinessDate AS CHAR(10)) + '|' + CAST(ROW_NUMBER() OVER (ORDER BY R.DRCode ASC) as varchar(20)) + '|' + DRCode + '|' + CAST(Total as varchar(20)),
			1,
			@dteBusinessDate,
			[DealerAccountNo (textinput-37)],
			'CHDN',
			'DLRAOF',
			'MYR',
			'Remisier/Dealer Account Opening Charges',
			0,
			3 * CAST(R.Total as bigint),
			0,		
			CAST(ROW_NUMBER() OVER (ORDER BY R.DRCode ASC) as varchar(20)) + '|' + DRCode + '|' + CAST(Total as varchar(20)),	
			'',
			'',
			'',
			'Cash',
			@dteBusinessDate,
			'',
			'AutoDebitProcess_RemisierAccounts',
			GETDATE() 
		FROM GlobalBOMY.import.Tb_RM3_Remisier R
		INNER JOIN CQBTempDB.export.Tb_FormData_1377 D 
			ON LTRIM(RTRIM(R.DRCode)) = D.[DealerCode (textinput-35)]
		INNER JOIN GlobalBO.setup.Tb_Account AS A
			ON D.[DealerAccountNo (textinput-37)] = A.AcctNo
		WHERE CAST(R.Total as bigint) > 0 AND LEFT(LTRIM(RTRIM(R.DRCode)),1) = 'R' AND D.[DealerAccountNo (textinput-37)] <> '';
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]');

		declare @ointBatchid bigint,
				@strmessage varchar(3000);
        
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		EXECUTE GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction NULL,1,'AutoDebitProcess_RemisierAccounts',@ointBatchid output,@strmessage Output;
		
		--select * from GlobalBO.interface.Tb_InterfaceExecution order by ExecutionId desc
		--select * from GlobalBO.interface.Tb_InterfaceData where ExecutionId=2484 order by ExecutionId desc
		--SELECT * FROM GlobalBO.transmanagement.Tb_Transactions where TransType='CHDN' and SubTransType='DLRAOF'

		DECLARE @loop BIT
		SET @loop = 1
		WHILE (@loop = 1)
		BEGIN
		
			IF EXISTS(select 1 from GlobalBO.interface.Tb_InterfaceExecution with(nolock) 
							where SourceFileName='BACKEND_INSERT' --AND ExecutionStatus IN ('I','P','T','U','V'))
						  AND (ExecutionStatus IN ('I','P','T','U','V') OR (ExecutionStatus='F' AND Remarks LIKE '%deadlock%')))
			BEGIN 
				WAITFOR DELAY '00:00:15'
			END
			ELSE
			BEGIN
				SET @loop = 0;
				BREAK;
			END
		END

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Execute GlobalBOLocal.import.Usp_ProcessNonTradeTransactionInstruction');

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.Process.USP_AutoDebitNoteForRemisierAccounts', '', [MessageLog] 
		from @logs;

		--COMMIT TRANSACTION
		
	END TRY
	BEGIN CATCH
		
		--IF @@TRANCOUNT > 0
		--	ROLLBACK TRANSACTION; 

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

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOTH.process.USP_AutoDebitNoteForRemisierAccounts', '', [MessageLog] 
		from @logs;

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
	 
		 
	END CATCH

END