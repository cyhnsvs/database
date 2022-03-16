/****** Object:  Procedure [dbo].[Usp_ReComputeRiskProfilingScore]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_ReComputeRiskProfilingScore]
Created By        : Fadlin    
Created Date      : 02/07/2021
Used by           : 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to calculate score when got changes in form 1425
Table(s) Used     : 

Modification History :            
 ModifiedBy :               Project UIN :							ModifiedDate :				Reason : 
 Kristine					https://app.clickup.com/t/ar011e		02 Aug 2021					Updated based on the new Risk Profiling Rating

 EXEC [dbo].[Usp_ReComputeRiskProfilingScore] 

**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_ReComputeRiskProfilingScore] 
	--@iintCompanyId BIGINT
AS
BEGIN

	BEGIN TRY 

		IF OBJECT_ID('tempdb.dbo.#tmpCustomers') IS NOT NULL DROP TABLE #tmpCustomers;
		IF OBJECT_ID('tempdb.dbo.#tmpScoring') IS NOT NULL DROP TABLE #tmpScoring;

		DECLARE @strRiskType nvarchar(100), @strRiskValue nvarchar(250), @intMinrecord INT = 1, @intRecordCount INT,
			@strCustomerId VARCHAR(100), 
			@strNationality VARCHAR(10), 
			@strCustomerType VARCHAR(1), 
			@strCompanyNetAsset VARCHAR(50), 
			@strIndustries VARCHAR(200), 
			@strEstimatedNetWorth VARCHAR(1), 
			@strEmploymentStatus VARCHAR(200), 
			@strPEP VARCHAR(20), 
			@strTradingChannel VARCHAR(10), 
			@strOnboardingMethod VARCHAR(10),
			@intScoring BIGINT, @strScoreStatus VARCHAR(10);

		
		CREATE TABLE #tmpCustomers
		(
			TempId BIGINT IDENTITY(1,1),
			CustomerId VARCHAR(100),
			Nationality VARCHAR(10),
			CustomerType VARCHAR(1),
			CompanyNetAsset VARCHAR(50),
			Corporate_BusinessNature VARCHAR(200),
			EstimatedNetWorth VARCHAR(1),
			Individual_Industry VARCHAR(200),
			EmploymentStatus VARCHAR(200),
			PEP VARCHAR(20),
			PEPClassification VARCHAR(1),
			TradingChannel VARCHAR(10),
			OnboardingMethod VARCHAR(10),
			RiskProfilingProcess VARCHAR(1),
			Corporate_PlaceOfIncorporation VARCHAR(10)
		)
		
		CREATE TABLE #tmpScoring
		(
			Scoring BIGINT,
			ScoreStatus varchar(10)
		)

		SELECT TOP 1 
			@strRiskType = B.RiskProfileType,
			@strRiskValue = B.RiskValue
		FROM CQBuilderAuditLog.log.Tb_FormData_1425 as A 
		CROSS APPLY OPENJSON(A.FormDetails)
		WITH (
			RiskProfileType nvarchar(100) '$.selectbasic1',
			RiskValue nvarchar(250) '$.textinput2',
			RiskScoring nvarchar(20) '$.textinput3'
		) as B
		order by AuditDateTime desc


		IF(@strRiskType = 'CompanyNetAsset')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 
			WHERE   [selectbasic-26] = 'C'
				AND (1 = CASE @strRiskValue
							WHEN '< RM500,000'							THEN	IIF(CAST([textinput-164] AS decimal(24)) < 500000, 1,0)
							WHEN 'RM500,000 - RM1,000,000'				THEN	IIF(CAST([textinput-164] AS decimal(24)) BETWEEN 500000 AND 1000000, 1,0)
							WHEN '> RM1,000,000'						THEN	IIF(CAST([textinput-164] AS decimal(24)) > 1000000, 1,0) 
							WHEN 'NoInfo'	THEN	IIF(ISNULL([textinput-164],'') = '', 1,0)
						 END 	
				)
			 
		END

		ELSE IF(@strRiskType = 'CustomerType')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 WHERE [selectbasic-26] = @strRiskValue
		END

		ELSE IF(@strRiskType = 'EstimatedNetWorth')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 WHERE [multipleradios-4] = @strRiskValue
		END

		ELSE IF(@strRiskType = 'Industries')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 
			WHERE  @strRiskValue = IIF([selectbasic-26] = 'C'
										,[selectsource-39]	--Business Nature
										,[selectsource-6]	--Industries / Specialization
									 ) 
		END

		ELSE IF(@strRiskType = 'Nationality')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 
			WHERE @strRiskValue IN ([selectsource-4], [selectsource-42])
		END

		ELSE IF(@strRiskType = 'EmploymentStatus')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 
			WHERE  @strRiskValue = IIF([selectbasic-26] = 'C', 'Company', [selectbasic-1])
		END

		ELSE IF(@strRiskType = 'OnboardingMethod')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 
			WHERE  @strRiskValue = [selectbasic-25]
		END
		
		ELSE IF(@strRiskType = 'PEP')
		BEGIN
			
			SELECT TOP 1  @strRiskValue = [Data]
			FROM GlobalBO.global.Udf_Split(@strRiskValue, ', ')

			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 
			WHERE  @strRiskValue = [selectbasic-24]
		END
		
		ELSE IF(@strRiskType = 'TradingChannel')
		BEGIN
			INSERT INTO #tmpCustomers
			SELECT
				[textinput-1] as CustomerId,
 				[selectsource-4] as Nationality, 
				[selectbasic-26] as CustomerType,
				[textinput-164] as CompanyNetAsset,
				[selectsource-39] as Corporate_BusinessNature,
				[multipleradios-4] as EstimatedNetWorth,
				[selectsource-6] as Individual_Industry,
				[selectsource-13] as EmploymentStatus,
				[selectbasic-24] as PEP,
				[multipleradiosinline-38] as PEPClassification,
				[selectbasic-27] as TradingChannel,
				[selectbasic-25] as OnboardMethod,
				[multipleradiosinline-37] as RiskProfilingProcess,
				[selectsource-42] as Corporate_PlaceOfIncorporation
			FROM CQBuilder.form.Tb_FormData_1410 
			WHERE  @strRiskValue = [selectbasic-27]
		END


		SELECT @intRecordCount = COUNT(1) FROM #tmpCustomers;

		IF EXISTS (SELECT 1 FROM #tmpCustomers)
		BEGIN
			WHILE (@intMinrecord <= @intRecordCount)
			BEGIN

				TRUNCATE TABLE #tmpScoring;

				SELECT
					@strCustomerId = CustomerId,
					@strNationality =  IIF(CustomerType = 'C',Corporate_PlaceOfIncorporation, Nationality) ,
					@strCustomerType = CustomerType,
					@strCompanyNetAsset = CASE		WHEN CustomerType = 'I'												    THEN ''
													WHEN ISNULL(CompanyNetAsset,'') = ''                                    THEN 'NoInfo'
													WHEN CAST(CompanyNetAsset AS decimal(24)) < 500000                      THEN '< RM500,000'
													WHEN CAST(CompanyNetAsset AS decimal(24)) BETWEEN 500000 AND 1000000    THEN 'RM500,000 - RM1,000,000'
													WHEN CAST(CompanyNetAsset AS decimal(24)) > 1000000                     THEN '> RM1,000,000'
										  END,
					@strIndustries = ISNULL(NULLIF(IIF(CustomerType = 'C'	,Corporate_BusinessNature	--Business Nature
																			,Individual_Industry	--Industries / Specialization
																),'')
													,'NoInfo'),
					@strEstimatedNetWorth = IIF(CustomerType = 'I', ISNULL(NULLIF(EstimatedNetWorth,''), 'NoInfo') , ''),
					@strEmploymentStatus = IIF(CustomerType = 'C', 'Company', EmploymentStatus),
					@strPEP = CONCAT(PEP, IIF(PEP = 'Y' , CONCAT(', ',PEPClassification),'') ),
					@strTradingChannel = TradingChannel,
					@strOnboardingMethod = OnboardingMethod
				FROM #tmpCustomers WHERE TempId = @intMinrecord;


				INSERT INTO #tmpScoring
				EXEC CQBuilder.[dbo].[Usp_CalculateProfileRating] 'N', @strNationality, @strCustomerType, @strCompanyNetAsset, @strIndustries, @strEstimatedNetWorth, @strEmploymentStatus, @strPEP, @strTradingChannel, @strOnboardingMethod

				SELECT @intScoring = Scoring, @strScoreStatus = ScoreStatus FROM #tmpScoring;

				UPDATE CQBuilder.form.Tb_FormData_1410
				SET FormDetails = IIF(ISNULL([multipleradiosinline-37], 'A') IN ('A','')
									 -- if Risk Profiling Process ([multipleradiosinline-37]) is Auto
									,JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(
													FormDetails, '$[0].textinput155', @intScoring), '$[1].textinput155', @intScoring)
																,'$[0].textinput156', @strScoreStatus), '$[1].textinput156', @strScoreStatus)
																,'$[0].selectbasic42', @strScoreStatus), '$[1].selectbasic42', @strScoreStatus)
									 -- if Risk Profiling Process ([multipleradiosinline-37]) is Manual, Do not change Risk Profiling 
									,JSON_MODIFY(JSON_MODIFY(FormDetails, '$[0].textinput155', @intScoring), '$[1].textinput155', @intScoring)
								)
				
				WHERE [textinput-1] = @strCustomerId

				SET @intMinrecord = @intMinrecord + 1;
			END
		END

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END