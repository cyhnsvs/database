/****** Object:  Procedure [dbo].[Usp_CreateCashTransaction]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_CreateCashTransaction]
	@iintCompanyId BIGINT, 
	@strlRecordID VARCHAR(2000),
	@strInitiatedBy VARCHAR(100) = 'CQB-CashTrans'
AS
/*********************************************************************************** 

Name              : dbo.Usp_CreateCashTransaction
Created By        : Kristine
Created Date      : 2021-07-15
Last Updated Date : 
Description       : Create a Cash Transaction after a form in 3426 is approved
Table(s) Used     : 

Modification History :
	ModifiedBy :		Project UIN:          ModifiedDate :     Reason :
	

PARAMETERS 

Used By :	CQBuilder > GBO Realtime > Cash Transaction Form

EXECUTE dbo.Usp_CreateCashTransaction 1, '30,31'
************************************************************************************/    
--DECLARE @iintCompanyId BIGINT, 
--	@strInitiatedBy VARCHAR(100) = 'CQB-CashTrans'
BEGIN    

	SET NOCOUNT ON;

    BEGIN TRY

		DECLARE  @dteBusinessDate DATE,@strResponseType VARCHAR(20),@strAccruedInd VARCHAR(5),@strRefCd VARCHAR(50),@strCorpActCd VARCHAR(20),
				 @strActionCd CHAR(2),@strCATransTypeClientCash VARCHAR(100),@strDiagnosticLog AS VARCHAR(4000);
				 
		DECLARE @intMinrecord INT =1,@intMaxrecord INT=1, @intInterval INT = 200,@intRecordCount INT;
		 
		DECLARE @strCompanyCd varchar(50) = (SELECT CompanyCd FROM [GlobalBO].global.[Tb_CompanyMaster] WHERE CompanyId = @iintCompanyId), 
                @strInterfaceCd VARCHAR(20),
                @strProcessBy VARCHAR(64) = @strInitiatedBy,
                @strExtRefNo VARCHAR(50), 
                @xmlContent XML,
                @bitAutoSubmit BIT=1,		
                @intProcessRefNo BIGINT,
                @strMessage VARCHAR(100),
				@strBatchRefNo VARCHAR(50) = CONCAT('TMP_',FORMAT(GETDATE(), 'yyyyMMddHHMM')) -- TEMP!
					-- @intBatchRefNo BIGINT =  (select max(BatchId)+1 from GlobalBO.utilities.Tb_BatchDiagnostics) -- NOT SURE!
				;

		--SET @strDiagnosticLog = 'Cash Transaction  : form.Usp_CreateCashTransaction - Start';		-- TEMP COMMENT
			
		--EXECUTE GlobalBO.[utilities].[Usp_WriteDiagnostics] @intBatchRefNo, @strDiagnosticLog;			-- TEMP COMMENT
		
		IF OBJECT_ID('tempdb.dbo.#tmpTb_CashTransaction') IS NOT NULL	DROP TABLE #tmpTb_CashTransaction;  	
				
		CREATE TABLE  #tmpTb_CashTransaction
		(
			RecNo INT IDENTITY(1,1),
			RecordId BIGINT,
			GridRowIndex INT,
			ExecutedBy VARCHAR(100),
			BatchRefNo VARCHAR(100), 
			DataRefNo VARCHAR(200), 
			TransDate DATE,
			SetlDate DATE,
			InterestSetlDate DATE,
			AcctNo VARCHAR(20), 
			FundSourceCd VARCHAR(10),
			TransType VARCHAR(255),
			TransTypeCd VARCHAR(50),
			SubTransType VARCHAR(50),
			CurrCd VARCHAR(3), 
			ExchRateBased DECIMAL(24,9),
			ExchRateClientBased DECIMAL(24,9),
			Amount DECIMAL(24,9),
			TransDesc NVARCHAR(400),
			CostTrade DECIMAL(24,9),
			ReferenceNo VARCHAR(100),
			Tag1 VARCHAR(200),
			Tag2 VARCHAR(200),
			Tag3 VARCHAR(200),
			Tag4 VARCHAR(200),
			Tag5 VARCHAR(200)
		);
		
		-- DECLARE @strCompanyCd varchar(50), @strInterfaceCd VARCHAR(20),@strProcessBy VARCHAR(64) = 'CQB-CashTrans',@strExtRefNo VARCHAR(50), @xmlContent XML, @bitAutoSubmit BIT=1	, @intProcessRefNo BIGINT, @strMessage VARCHAR(100), @strBatchRefNo VARCHAR(50) = FORMAT(GETDATE(), 'yyyyMMddHHMM')
		INSERT INTO #tmpTb_CashTransaction
		SELECT a.RecordID
			,j.GridRowIndex
			,@strProcessBy ExecutedBy
			,@strBatchRefNo BatchRefNo						
			,CONCAT(a.RecordID,'_', j.GridRowIndex) DataRefNo
			,a.[dateinput-2] [TransDate]
			,j.SetlDate
			,j.IntStartDate 
			,j.AcctNo
			,j.FundSource
			,TT.TransTypeDesc [TransType]
			,a.[textinput-1] [TransTypeCd]
			,j.SubTransType [SubTransType]
			,j.Currency [CurrCd]
			,NULL [ExchRateBased]			
			,NULL [ExchRateClientBased]	
			,CAST(NULLIF(j.Amount,'') AS decimal(24,9)) Amount
			,j.Description [TransDesc]
			,NULL [CostTrade]				
			,j.RefNo
			,j.Remarks [Tag1]					
			,'' [Tag2]					
			,'' [Tag3]					
			,'' [Tag4]					
			,'' [Tag5]					
		FROM GlobalBoLocal.dbo.Udf_Split(@strlRecordID, ',') R
			INNER JOIN CQBuilder.form.Tb_FormData_3426 A
				ON A.RecordId = R.val
			
			CROSS APPLY OPENJSON(A.[grid-1])
			WITH (
				GridRowIndex INT '$.rowIndex',
				AcctNo VARCHAR(50) '$.seq1',
				--SvcType VARCHAR(50) '$.seq2',
				ClientName VARCHAR(255) '$.seq3',
				AvailBalance VARCHAR(255)'$.seq4',
				FundSource VARCHAR(50) '$.seq5',
				SubTransType VARCHAR(50) '$.seq6',
				SetlDate DATE '$.seq7',
				IntStartDate DATE '$.seq8',
				Currency VARCHAR(50) '$.seq9',
				Amount VARCHAR(255) '$.seq10',
				TaxAmt VARCHAR(255) '$.seq11',
				[Description] VARCHAR(4000) '$.seq12',
				RefNo VARCHAR(50) '$.seq13',
				Remarks VARCHAR(4000) '$.seq14'
			) AS j

			LEFT JOIN GlobalBO.setup.Tb_TransactionType TT
				ON a.[textinput-1] = TT.TransType


		IF EXISTS (SELECT TOP 1 1 FROM #tmpTb_CashTransaction)
		BEGIN
		
			BEGIN TRANSACTION

				SET @intMinrecord = @intMaxrecord;
				SET @intMaxrecord = @intMaxrecord + @intInterval;
				SELECT @intRecordCount = COUNT(1) FROM #tmpTb_CashTransaction;
			
				WHILE ( @intMinrecord <= @intRecordCount)
				BEGIN

					SELECT @xmlContent = (
						SELECT ExecutedBy,
							BatchRefNo, 
							DataRefNo, 
							TransDate,
							SetlDate,
							InterestSetlDate,
							AcctNo, 
							FundSourceCd,
							TransType,
							TransTypeCd,
							SubTransType,
							CurrCd, 
							ExchRateBased,
							ExchRateClientBased,
							Amount,
							TransDesc,
							ReferenceNo,
							Tag1,
							Tag2,
							Tag3,
							Tag4,
							Tag5
						FROM #tmpTb_CashTransaction
						WHERE RecNo >= @intMinrecord
							AND RecNo < @intMaxrecord
						FOR XML PATH ('Cash')

					)
					

					SET @strInterfaceCd = 'CASH_L';
					SET @strExtRefNo = @strCompanyCd + ' | ' + @strInitiatedBy + ' | ' + @strBatchRefNo + ' | ' ;
			
					EXECUTE GlobalBO.[utilities].[usp_InsertInterfaceExecution] 
							@strCompanyCd,
							@strInterfaceCd, 
							@strProcessBy,
							@strExtRefNo,
							@xmlContent,
							@bitAutoSubmit,    
							@intProcessRefNo OUT,
							@strMessage OUT;

					
					UPDATE F
					SET F.FormDetails = JSON_MODIFY(JSON_MODIFY(FormDetails, '$[1].textinput3', 'Queued'), '$[0].textinput3', 'Queued')
					FROM CQBuilder.form.Tb_FormData_3426 F
						INNER JOIN #tmpTb_CashTransaction T 
							ON F.RecordID = T.RecordId
					WHERE T.RecNo >= @intMinrecord
							AND T.RecNo < @intMaxrecord

					SET @intMinrecord = @intMaxrecord ;
					SET @intMaxrecord = @intMaxrecord + @intInterval;
					
				END

			
			IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

			IF OBJECT_ID('tempdb.dbo.#tmpTb_CashTransaction') IS NOT NULL	DROP TABLE #tmpTb_CashTransaction; 
		
			--SET @strDiagnosticLog = 'Cash Deduction: form.Usp_CreateCashTransaction - End';		-- TEMP COMMENT
						
			--EXECUTE GlobalBO.[utilities].[Usp_WriteDiagnostics] @intBatchRefNo, @strDiagnosticLog;	
		
		END 
		
	END TRY
    BEGIN CATCH

		SELECT @@TRANCOUNT [TranCount], ERROR_MESSAGE(),  ERROR_NUMBER(),  ERROR_LINE(),  'form.Usp_CreateCashTransaction' ;
		
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
		
		IF OBJECT_ID('tempdb.dbo.#tmpTb_CashTransaction') IS NOT NULL	DROP TABLE #tmpTb_CashTransaction;  
		
		DECLARE @strErrorMessage NVARCHAR(4000), @intErrorNumber INT, @intErrorLine INT, @strErrorProcedure NVARCHAR(200);
	    
		SELECT @strErrorMessage=ERROR_MESSAGE(), @intErrorNumber = ERROR_NUMBER(), @intErrorLine = ERROR_LINE(), @strErrorProcedure = 'form.Usp_CreateCashTransaction' ;
	    
	    EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber, @strErrorMessage, @intErrorLine, @strErrorProcedure, @strInitiatedBy, 'form.Usp_CreateCashTransaction - Failed';
	    	    
	    EXECUTE GlobalBO.utilities.usp_RethrowError 'form.Usp_CreateCashTransaction - Failed';
		  		 
    END CATCH
    
    SET NOCOUNT OFF;
	 

END