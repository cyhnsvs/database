/****** Object:  Procedure [process].[Usp_CalculateAEBrokerage_DealerMonthly]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_CalculateAEBrokerage_DealerMonthly]
	@iintCompanyId BIGINT,
	@idteBusinessDate DATE,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_CalculateAEBrokerage_DealerMonthly]
Created By        : Nishanth Chowdhary
Created Date      : 15/09/2020
Last Updated Date : 
Description       : this sp is used to calculate all AE (remisier & dealer) brokerage
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_CalculateAEBrokerage_DealerMonthly] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY

	begin tran
    	
		DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');
		
		DECLARE @dteFOM DATE = DATEFROMPARTS(year(@idteBusinessDate),month(@idteBusinessDate),1);
		DECLARE @dteEOM DATE = EOMONTH(@idteBusinessDate);
		
		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		); 
		
		--DROP TABLE #AEBrokerageDetailed;
		CREATE TABLE #AEBrokerageDetailed
		(
			IDD bigint IDENTITY (1,1),
			BusinessDate date,
			TeamId bigint,
			AcctExecutiveCd VARCHAR(30),
			AcctExecutiveCdMR VARCHAR(30) DEFAULT(''),
			BranchId VARCHAR(20),
			SetlCurrCd VARCHAR(20),
			ClientBrokerageSetl decimal(24,9),
			IncentiveType VARCHAR(50) DEFAULT(''),
			IncentiveTierGroupId BIGINT NULL,
			IncentiveTierGroupCd VARCHAR(20) NULL,
			IncentiveAmount decimal(24,9) DEFAULT (0)
		);
		
		CREATE TABLE #AEBrokerageSummary
		(
			IDD bigint IDENTITY (1,1),
			BusinessDate date,
			TeamId bigint,
			AcctExecutiveCd VARCHAR(30),
			BranchId VARCHAR(20),
			SetlCurrCd VARCHAR(20),
			ClientBrokerageSetl decimal(24,9),
			IncentiveAmount decimal(24,9) DEFAULT (0)
		);

		CREATE TABLE #AEMRBrokerageSummary
		(
			IDD bigint IDENTITY (1,1),
			BusinessDate date,
			AcctExecutiveCd VARCHAR(30),
			AcctExecutiveCdMR VARCHAR(30),
			BranchId VARCHAR(20),
			SetlCurrCd VARCHAR(20),
			ClientBrokerageSetl decimal(24,9),
			IncentiveAmount decimal(24,9) DEFAULT (0)
		);

		DECLARE @FundSourceId INT = (SELECT FundSourceId FROM Globalbo.setup.Tb_FundSource WHERE FundSourceCd='Cash');
		
		--ARCHIVE YESTERDAY 
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Archive CashBuyLimit');

		--INSERT INTO CashBuyLimit_Archive
		--	([BusinessDate],[AcctNo],[CollateralType],[ApprovedLimit],CashBalance,AdvanceWithdrawal,[Balance],[MktValue]
  --          ,[WHTaxJuristic],[OtherCollateral],[ART],[ARTMinus1],[APT],[ATSFeeT]
		--	,[APTMinus1],[ATSFeeTMinus1],[NETAR],[NETAP],[CapBuyLimit],[CalBuyLimit],[CalBuyLimitBeforeATS],[RealBuyLimit]
		--	,[OverBuyLimit],[APOver],[APToATS],[APToATSMinus1],[ARToATS],[ARToATSMinus1],[WHTaxJuristic1],[APToCashBalance],[ArchiveDate])
		--SELECT [BusinessDate],[AcctNo],[CollateralType],[ApprovedLimit],CashBalance,AdvanceWithdrawal,[Balance],[MktValue]
  --          ,[WHTaxJuristic],[OtherCollateral],[ART],[ARTMinus1],[APT],[ATSFeeT]
		--	,[APTMinus1],[ATSFeeTMinus1],[NETAR],[NETAP],[CapBuyLimit],[CalBuyLimit],[CalBuyLimitBeforeATS],[RealBuyLimit]
		--	,[OverBuyLimit],[APOver],[APToATS],[APToATSMinus1],[ARToATS],[ARToATSMinus1],[WHTaxJuristic1],[APToCashBalance], GETDATE() 
		--FROM CashBuyLimit;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Archive CashBuyLimit');

		--TRUNCATE TABLE CashApprovedLimit;
		
		--select * 
		--INTO #Dealers
		--FROM CQBTempDB.export.Tb_FormData_1377
		--WHERE [DealerType (selectsource-3)] IN ('D','H','I','V');
		
		SELECT * 
		INTO #IncentiveContributors
		FROM (
			SELECT RecordID, [TeamGroupName (textinput-5)], [TeamLeader (selectsource-3)], value as DealerCode
			FROM CQBTempDB.export.Tb_FormData_1710 AS TS
			CROSS APPLY string_split([IncentiveContributors (selectsourcemultiple-2)], ',')
			UNION
			SELECT RecordID, [TeamGroupName (textinput-5)], [TeamLeader (selectsource-3)], '' as DealerCode
			FROM CQBTempDB.export.Tb_FormData_1710 AS TS
			WHERE [IncentiveContributors (selectsourcemultiple-2)] IS NULL) AS D;

		SELECT *
		INTO #Contracts
		FROM (
			SELECT CO.AcctExecutiveCd, CO.ExchCd, InstrumentCd, BG.TierGroupId, TG.TierGroupCd, CO.SetlCurrCd, CO.ClientBrokerageSetl, 
					SUBSTRING(CO.Tag5,0,CHARINDEX('|',CO.Tag5)) AS AcctExecutiveCdMR, SUBSTRING(CO.Tag5,CHARINDEX('|',CO.Tag5)+1,LEN(CO.Tag5)) AS BranchId, D.RecordId AS TeamId
			FROM GlobalBO.contracts.Tb_ContractOutstanding AS CO
			INNER JOIN GlobalBO.contracts.Tb_Contract AS C
			ON CO.ContractNo = C.ContractNo AND CO.TradeDate = C.TradeDate
			INNER JOIN #IncentiveContributors AS D
			ON CO.AcctExecutiveCd = D.DealerCode --OR (D.DealerCode = '' AND D.[BranchID (selectsource-1)] = SUBSTRING(CO.Tag5,CHARINDEX('|',CO.Tag5)+1,LEN(CO.Tag5)))
			INNER JOIN GlobalBO.setup.Tb_BrokerageGroup AS BG
			ON C.BrokerageGroupId = BG.BrokerageGroupId
			INNER JOIN GlobalBO.setup.Tb_TierGroup AS TG
			ON BG.TierGroupId = TG.TierGroupId
			INNER JOIN GlobalBO.setup.Tb_Instrument AS I
			ON CO.ProductId = I.ProductId AND CO.InstrumentId = I.InstrumentId
			WHERE CO.TradeDate BETWEEN @dteFOM AND @dteEOM
			UNION
			SELECT CO.AcctExecutiveCd, CO.ExchCd, InstrumentCd, BG.TierGroupId, TG.TierGroupCd, CO.SetlCurrCd, CO.ClientBrokerageSetl, 
					SUBSTRING(CO.Tag5,0,CHARINDEX('|',CO.Tag5)) AS AcctExecutiveCdMR, SUBSTRING(CO.Tag5,CHARINDEX('|',CO.Tag5)+1,LEN(CO.Tag5)) AS BranchId, D.RecordId AS TeamId
			FROM GlobalBO.transmanagement.Tb_TransactionsSettled AS CO
			INNER JOIN GlobalBO.contracts.Tb_Contract AS C
			ON CO.ContractNo = C.ContractNo AND CO.TradeDate = C.TradeDate
			INNER JOIN #IncentiveContributors AS D
			ON CO.AcctExecutiveCd = D.DealerCode
			INNER JOIN GlobalBO.setup.Tb_BrokerageGroup AS BG
			ON C.BrokerageGroupId = BG.BrokerageGroupId
			INNER JOIN GlobalBO.setup.Tb_TierGroup AS TG
			ON BG.TierGroupId = TG.TierGroupId
			INNER JOIN GlobalBO.setup.Tb_Instrument AS I
			ON CO.ProductId = I.ProductId AND CO.InstrumentId = I.InstrumentId
			WHERE CO.TransType NOT IN ('TRBUY','TRSELL')
			AND CO.TradeDate BETWEEN @dteFOM AND @dteEOM
		) AS C

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into #AEBrokerageDetailed');
		
		-- Normal
		INSERT INTO #AEBrokerageDetailed
			(BusinessDate, TeamId, AcctExecutiveCd, BranchId, SetlCurrCd, ClientBrokerageSetl, IncentiveType, IncentiveTierGroupId, IncentiveTierGroupCd)
		SELECT @dteEOM, TeamId, AcctExecutiveCd, C.BranchId, SetlCurrCd, SUM(ClientBrokerageSetl) AS ClientBrokerageSetl, 'IndNormal' AS IncentiveType, TG.TierGroupId, TG.TierGroupCd
		FROM #Contracts AS C
		INNER JOIN CQBTempDB.export.Tb_FormData_1710 AS TS
		ON C.TeamId = TS.RecordID
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS TG
		ON TS.[IncentiveRate (selectbasic-3)] = CAST(TG.TierGroupId as varchar(30)) + '-' + TG.TierGroupCd
		GROUP BY TeamId, AcctExecutiveCd, C.BranchId, SetlCurrCd, TG.TierGroupId, TG.TierGroupCd;
		
		-- MR
		INSERT INTO #AEBrokerageDetailed
			(BusinessDate, TeamId, AcctExecutiveCd, AcctExecutiveCdMR, BranchId, SetlCurrCd, ClientBrokerageSetl, IncentiveType, IncentiveTierGroupId, IncentiveTierGroupCd)
		SELECT @dteEOM, TeamId, AcctExecutiveCd, AcctExecutiveCdMR, C.BranchId, SetlCurrCd, SUM(ClientBrokerageSetl) AS ClientBrokerageSetl, 'MRNormal' AS IncentiveType, TG.TierGroupId, TG.TierGroupCd
		FROM #Contracts AS C
		INNER JOIN CQBTempDB.export.Tb_FormData_1575 AS MR
		ON C.AcctExecutiveCdMR = MR.[RegistrationNo (textinput-2)]
		INNER JOIN GlobalBO.setup.Tb_TierGroup AS TG
		ON MR.[MRIncentiveRate (selectbasic-2)] = CAST(TG.TierGroupId as varchar(30)) + TG.TierGroupCd
		GROUP BY TeamId, AcctExecutiveCd, AcctExecutiveCdMR, C.BranchId, SetlCurrCd, TG.TierGroupId, TG.TierGroupCd;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into #AEBrokerageDetailed');
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Sharing Computation');
		
     DECLARE @strTierFromToConversionInd CHAR(1) = ISNULL(GlobalBO.setup.Udf_FetchGlobalValue(@iintCompanyId, 'TierFromToConversionInd'),'0');
    
	 CREATE TABLE #tblTierOriginal (
		[ReferenceCd] [varchar](50) NOT NULL,
		[SourceId] [bigint] NOT NULL,
		[FromValue] [decimal](24, 9) NOT NULL,
		[ToValue] [decimal](25, 9) NOT NULL,
		[Rate] [decimal](24, 9) NOT NULL,
		[ValueConverted] [decimal](24, 9) NOT NULL,
		[ComputationMethod] [varchar](50) NOT NULL,
		[ProcessType] [varchar](20) NOT NULL,
		[Amount] [decimal](24, 9) NOT NULL,
		[TierId] BIGINT,
		[SrNo] BIGINT 
		PRIMARY KEY CLUSTERED 
			(
				[ReferenceCd] ASC,
				[SourceId] ASC,
				[SrNo] ASC,
				[TierId] ASC
			)
		);

		CREATE TABLE #tblResultSummary  (
            ReferenceCd BIGINT,
            BatchId BIGINT,
            SourceCd BIGINT,
            Amount DECIMAL(24, 9),
            PRIMARY KEY CLUSTERED(ReferenceCd, [BatchId], SourceCd)
        );
		
		INSERT INTO #tblTierOriginal(
			ReferenceCd,
			SourceId,
			FromValue,
			ToValue,
			Rate,
			ValueConverted,
			ComputationMethod,
			ProcessType,
			Amount,
			SrNo,
			TierId
			)
        SELECT
              A.IDD,
              A.IDD,
              CASE WHEN @strTierFromToConversionInd = '1' THEN              
	              CAST(ROUND(D.FromValue * COALESCE(E.AvgExchRate, 1.0),H.RoundingDecimal) AS decimal(24, 9)) 
              ELSE D.FromValue END AS FromValue,
              CASE WHEN @strTierFromToConversionInd = '1' THEN
              	 --CASE WHEN D.ToValue  > =  F.MaximumAmount THEN
                --      F.MaximumAmount
                --  ELSE
                      CAST(ROUND(D.ToValue * COALESCE(E.AvgExchRate, 1.0),H.RoundingDecimal) AS decimal(25, 9)) 
                  --END              	 
              ELSE              
                  --CASE WHEN (D.ToValue) > F.MaximumAmount THEN
                  --    F.MaximumAmount
                  --ELSE
                      D.ToValue 
                  --END
              END AS ToValue,
              CASE WHEN @strTierFromToConversionInd = '1' THEN
              	 CAST(ROUND(D.Rate * COALESCE(E.AvgExchRate, 1.0),H.RoundingDecimal) AS decimal(24, 9)) 
              ELSE
              	 D.Rate
              END AS Rate,
              CASE WHEN @strTierFromToConversionInd = '1' THEN
              	 CAST(ROUND(D.Rate * COALESCE(E.AvgExchRate, 1.0),H.RoundingDecimal) AS decimal(24, 9)) 
              ELSE
              	 D.Rate
              END AS ValueConverted,
              'Percentage',
              'Fixed',
			  ABS(A.ClientBrokerageSetl) AS Amount,
              ROW_NUMBER() OVER (PARTITION BY A.IDD,D.TierGroupId ORDER BY D.TierId ) As SRNO,
              D.TierGroupId
        FROM #AEBrokerageDetailed AS A
        INNER JOIN GlobalBO.setup.Tb_Tier AS D ON
            D.TierGroupId = A.IncentiveTierGroupId
        INNER JOIN GlobalBO.global.Tb_CompanyMaster AS G ON
			G.CompanyId = D.CompanyId   
        INNER JOIN GlobalBO.contracts.Tb_ExchangeRateProcess E ON    
            E.OtherCurrCd = G.BaseCurrCd  AND  
            E.BaseCurrCd = A.SetlCurrCd AND	
            E.CompanyId = D.CompanyId AND
            E.BusinessDate = A.BusinessDate
            --E.TimeSlotId =  ISNULL(C.TimeSlotId,'ExchRate_0000_0000')  -- 'ExchRate_0000_0000'
        INNER JOIN GlobalBO.setup.Tb_Currency AS H ON
			H.CompanyId = D.CompanyId AND
			H.CurrCd = A.SetlCurrCd
   --     INNER JOIN GlobalBO.setup.Tb_Instrument AS K ON
			--C.CompanyId = K.CompanyId AND
			--C.InstrumentId = k.InstrumentId   			
        WHERE D.TierCategory = 'AESharing'
        ORDER BY A.IDD;

		CREATE TABLE #tblTier (
			[ReferenceCd] [varchar](50) NOT NULL,
			[SourceId] [bigint] NOT NULL,
			[FromValue] [decimal](24, 9) NOT NULL,
			[ToValue] [decimal](25, 9) NOT NULL,
			[Rate] [decimal](24, 9) NOT NULL,
			[ValueConverted] [decimal](24, 9) NOT NULL,
			[ComputationMethod] [varchar](20) NOT NULL,
			[ProcessType] [varchar](20) NOT NULL,
			[Amount] [decimal](24, 9) NOT NULL,
			PRIMARY KEY CLUSTERED 
			(
				[ReferenceCd] ASC,
				[SourceId] ASC,
				[FromValue] ASC,
				[ToValue] ASC,
				[Rate] ASC
			)WITH (IGNORE_DUP_KEY = OFF)
		);

		INSERT INTO #tblTier (
			ReferenceCd,
			SourceId,
			FromValue,
			ToValue,
			Rate,
			ValueConverted,
			ComputationMethod,
			ProcessType,
			Amount
		)
		SELECT 
			A.ReferenceCd,
			A.SourceId,
			CASE WHEN A.SrNo = 1 THEN A.FromValue ELSE B.ToValue + 0.01 END AS FromValue ,
			A.ToValue,
			A.Rate,
			A.ValueConverted,
			A.ComputationMethod,
			A.ProcessType,
			A.Amount
		FROM #tblTierOriginal AS A 
		LEFT JOIN #tblTierOriginal AS B
		ON A.SrNo = B.SrNo + 1 AND
			A.ReferenceCd = B.ReferenceCd AND
			A.SourceId = B.SourceId AND
			A.TierId = B.TierId
		order by A.ReferenceCd,A.SourceId,A.SrNo ;
					
			INSERT INTO #tblResultSummary
			SELECT  
				ReferenceCd,
				0 AS BatchId,
				SourceId,			
				SUM(CASE WHEN ProcessType = 'Fixed' AND ComputationMethod = 'Percentage'  THEN
					CASE WHEN ABS(Amount) > FromValue AND ABS(Amount) <= ToValue THEN
						ABS(Amount) * (Rate/100)
					ELSE 
						0	
					END	

					WHEN ProcessType = 'Sliding' AND ComputationMethod = 'Percentage' THEN				    
						CASE WHEN ABS(Amount) > FromValue AND ABS(Amount) > ToValue THEN
							(ToValue - FromValue) * (Rate/100)
						WHEN ABS(Amount) > FromValue AND ABS(Amount) <= ToValue THEN		 
							(ABS(Amount) - FromValue) * (Rate/100)
						ELSE 
							0	
						END
						
					WHEN ProcessType = 'Fixed' AND ComputationMethod = 'Value'  THEN
						CASE WHEN ABS(Amount) > FromValue AND ABS(Amount) <= ToValue THEN
							Rate
						ELSE 
							0	
						END	
						
					WHEN ProcessType = 'Sliding' AND ComputationMethod = 'Value' THEN				    
						CASE WHEN ABS(Amount) > FromValue AND ABS(Amount) > ToValue THEN
							Rate
						WHEN ABS(Amount) > FromValue AND ABS(Amount) <= ToValue THEN		 
							Rate
						ELSE 
							0	
						END						
																		  
				END ) As Amount							
			FROM 	#tblTier 
			GROUP BY ReferenceCd,SourceId;

		UPDATE AED
		SET IncentiveAmount = RS.Amount
		FROM #AEBrokerageDetailed AS AED
		INNER JOIN #tblResultSummary AS RS
		ON AED.IDD = RS.ReferenceCd;
		
		INSERT INTO #AEMRBrokerageSummary
			(BusinessDate, AcctExecutiveCd, AcctExecutiveCdMR, BranchId, SetlCurrCd, ClientBrokerageSetl, IncentiveAmount)
		SELECT BusinessDate, AcctExecutiveCd, AcctExecutiveCdMR, BranchId, SetlCurrCd, SUM(ClientBrokerageSetl), SUM(IncentiveAmount)
		FROM #AEBrokerageDetailed AS AB
		WHERE IncentiveType IN ('MRNormal')
		GROUP BY BusinessDate, AcctExecutiveCd, AcctExecutiveCdMR, BranchId, SetlCurrCd;
		
		--select * 
		--from #Contracts AS C
		
		--INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS CL
		--ON C.
		--INNER JOIN CQBTempDB.export.Tb_FormData_1377 AS D
		--ON C.AcctExecutiveCd = D.[DealerCode (selectsource-14)]
		--INNER JOIN CQBTempDB.export.Tb_FormData_1575 AS MR
		--ON D.[DealerCode (selectsource-14)] = MR.

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Sharing Computation');

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Insert Into AEBrokerage');

		--INSERT FROM TEMP TABLE TO PHYSICAL TABLE
		INSERT INTO [dbo].[AEIncentive_Dealers_Details]
           ([BusinessDate],[TeamId],[AcctExecutiveCd],[AcctExecutiveCdMR],[BranchId]
		   ,[SetlCurrCd],[ClientBrokerageSetl],[IncentiveType],[IncentiveTierGroupId]
           ,[IncentiveTierGroupCd],[IncentiveAmount])
		SELECT [BusinessDate],[TeamId],[AcctExecutiveCd],[AcctExecutiveCdMR],[BranchId]
		   ,[SetlCurrCd],[ClientBrokerageSetl],[IncentiveType],[IncentiveTierGroupId]
           ,[IncentiveTierGroupCd],[IncentiveAmount]
		FROM #AEBrokerageDetailed;
		
		INSERT INTO [dbo].[AEIncentive_Dealers_Summary]
           ([BusinessDate],[TeamId],[AcctExecutiveCd],[BranchId],[SetlCurrCd]
           ,[ClientBrokerageSetl],[IncentiveAmount])
		SELECT [BusinessDate],[TeamId],[AcctExecutiveCd],[BranchId],[SetlCurrCd]
           ,[ClientBrokerageSetl],[IncentiveAmount]
		FROM #AEBrokerageSummary;

		INSERT INTO [dbo].[AEIncentive_Dealers_MR_Summary]
           ([BusinessDate],[AcctExecutiveCd],[AcctExecutiveCdMR],[BranchId]
           ,[SetlCurrCd],[ClientBrokerageSetl],[IncentiveAmount])
		SELECT [BusinessDate],[AcctExecutiveCd],[AcctExecutiveCdMR],[BranchId]
           ,[SetlCurrCd],[ClientBrokerageSetl],[IncentiveAmount]
		FROM #AEMRBrokerageSummary;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into AEBrokerage');

		DROP TABLE #AEBrokerageDetailed;
		DROP TABLE #Contracts;
		DROP TABLE #AEBrokerageSummary;
		--DROP TABLE #Dealers;
		DROP TABLE #AEMRBrokerageSummary;
		DROP TABLE #tblResultSummary;
		DROP TABLE #tblTier;
		DROP TABLE #tblTierOriginal;

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
		SELECT LogDateTime, 'GlobalBOMY.process.Usp_CalculateAEBrokerage_DealerMonthly', '', [MessageLog] 
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
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_CalculateAEBrokerage_DealerMonthly: Failed'

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
												  SELECT LogDateTime, 'GlobalBOMY.process.Usp_CalculateAEBrokerage_DealerMonthly', '', [MessageLog] 
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