/****** Object:  Procedure [report].[Usp_FetchDailyUpdatingRequestRpt_Subramani_02-08-21]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [report].[[Usp_FetchDailyUpdatingRequestRpt_Subramani_02-08-21]]
Created By        : Fadlin    
Created Date      : 11/12/2020
Used by           : 
Project UIN:      : 
RFA:              :   
Last Updated Date :             
Description       : 
Table(s) Used     :  

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [report].[Usp_FetchDailyUpdatingRequestRpt_Subramani_02-08-21] '2020-12-09'
**********************************************************************************/   
CREATE PROCEDURE [report].[Usp_FetchDailyUpdatingRequestRpt_Subramani_02-08-21]
	@idteReportDate date
AS
BEGIN
	BEGIN TRY 

		DECLARE @strColName nvarchar(max),@strSubColName  nvarchar(max), @strColNameWithoutAcctNo nvarchar(max), @strColNameWithout nvarchar(max);
		DECLARE @query nvarchar(max) = '';
		
		CREATE TABLE #unp1409_1
		(
			ColName varchar(200), 
			ColValue varchar(200), 
			AcctNo varchar(20),
		)

		CREATE TABLE #unp1409_2
		(
			ColName varchar(200), 
			ColValue varchar(200), 
			AcctNo varchar(20),
			ReportDate date
		)

		CREATE TABLE #diff1409
		(
			AcctNo varchar(20),
			CustomerID varchar(20)
		)
		--DROP TABLE #old1409;
		CREATE TABLE #old1409(
			rnum bigint NULL,
			row_num bigint NULL,
			[ReportDate] [NVARCHAR](20) NULL,
			[RecordID]  [NVARCHAR](20) NULL,
			[CreatedBy] [NVARCHAR](50) NULL,
			[CreatedTime]  [NVARCHAR](50) NULL,
			[UpdatedBy] [NVARCHAR](50) NULL,
			[UpdatedTime] [NVARCHAR](50) NULL,
			[AccountGroup (selectsource-2)] [nvarchar](4000) NULL,
			[ParentGroup (selectsource-3)] [nvarchar](4000) NULL,
			[AccountType (selectsource-7)] [nvarchar](4000) NULL,
			[ALGOIndicator (selectbasic-26)] [nvarchar](4000) NULL,
			[CustomerID (selectsource-1)] [nvarchar](4000) NULL,
			[AccountNumber (textinput-5)] [nvarchar](4000) NULL,
			[AccountSubCode (textinput-6)] [nvarchar](4000) NULL,
			[NomineesName1 (selectsource-20)] [nvarchar](4000) NULL,
			[NomineesName2 (textinput-7)] [nvarchar](4000) NULL,
			[NomineesName3 (textinput-8)] [nvarchar](4000) NULL,
			[NomineesName4 (textinput-9)] [nvarchar](4000) NULL,
			[AbbreviatedName (textinput-10)] [nvarchar](4000) NULL,
			[CADEntityType1 (selectsource-18)] [nvarchar](4000) NULL,
			[AveragingOption (multipleradiosinline-1)] [nvarchar](4000) NULL,
			[OddLotAveragingOption (selectbasic-4)] [nvarchar](4000) NULL,
			[DealerCode (selectsource-21)] [nvarchar](4000) NULL,
			[SendClientInfotoBFE (selectbasic-27)] [nvarchar](4000) NULL,
			[AccountStatus (selectsource-9)] [nvarchar](4000) NULL,
			[MRIndicator (multipleradiosinline-4)] [nvarchar](4000) NULL,
			[MRReference (selectsource-22)] [nvarchar](4000) NULL,
			[ReferenceSource (selectsource-23)] [nvarchar](4000) NULL,
			[CDSNo (textinput-19)] [nvarchar](4000) NULL,
			[CDSACOpenBranch (selectsource-4)] [nvarchar](4000) NULL,
			[NomineeInd (selectsource-5)] [nvarchar](4000) NULL,
			[StructureWarrant (selectbasic-7)] [nvarchar](4000) NULL,
			[ShortSellInd (selectsource-19)] [nvarchar](4000) NULL,
			[IDSSInd (multipleradiosinline-10)] [nvarchar](4000) NULL,
			[PSSInd (multipleradiosinline-11)] [nvarchar](4000) NULL,
			[IslamicTradeInd (selectbasic-9)] [nvarchar](4000) NULL,
			[IntraDayInd (selectbasic-12)] [nvarchar](4000) NULL,
			[SettlementCurrency (selectsource-6)] [nvarchar](4000) NULL,
			[ContraInd (selectbasic-13)] [nvarchar](4000) NULL,
			[ContraforShortSelling (selectbasic-28)] [nvarchar](4000) NULL,
			[ContraforOddLots (selectbasic-15)] [nvarchar](4000) NULL,
			[ContraforIntraday (selectbasic-29)] [nvarchar](4000) NULL,
			[DesignatedCounterInd (selectbasic-16)] [nvarchar](4000) NULL,
			[ImmediateBasisInd (selectbasic-19)] [nvarchar](4000) NULL,
			[SetoffInd (selectbasic-30)] [nvarchar](4000) NULL,
			[SetoffContraGainDebitAmount (selectbasic-31)] [nvarchar](4000) NULL,
			[SetoffSalesPurchasesReport (selectbasic-32)] [nvarchar](4000) NULL,
			[SetoffTrustDebitTransactions (selectbasic-33)] [nvarchar](4000) NULL,
			[SetoffTrustContraLoss (selectbasic-34)] [nvarchar](4000) NULL,
			[TransferCreditTransactiontoTrust (selectbasic-35)] [nvarchar](4000) NULL,
			[UserID (textinput-52)] [nvarchar](4000) NULL,
			[OnlineSystemIndicator (multiplecheckboxesinline-1)] [nvarchar](4000) NULL,
			[VBIP (selectbasic-39)] [nvarchar](4000) NULL,
			[WithLimit (multipleradiosinline-18)] [nvarchar](4000) NULL,
			[ClearPreviousDayOrder (multipleradiosinline-19)] [nvarchar](4000) NULL,
			[Access (multipleradiosinline-20)] [nvarchar](4000) NULL,
			[Buy (multipleradiosinline-21)] [nvarchar](4000) NULL,
			[Sell (multipleradiosinline-22)] [nvarchar](4000) NULL,
			[SuspensionReason (selectsource-30)] [nvarchar](4000) NULL,
			[Remarks (textinput-72)] [nvarchar](4000) NULL,
			[MaxBuyLimit (textinput-68)] [nvarchar](4000) NULL,
			[MaxSellLimit (textinput-69)] [nvarchar](4000) NULL,
			[MaxNetLimit (textinput-70)] [nvarchar](4000) NULL,
			[ExceedLimit (textinput-71)] [nvarchar](4000) NULL,
			[ApproveTradingLimit (textinput-54)] [nvarchar](4000) NULL,
			[AvailableTradingLimit (textinput-55)] [nvarchar](4000) NULL,
			[BFEACType (selectsource-29)] [nvarchar](4000) NULL,
			[ClientAssoallowed (multipleradiosinline-13)] [nvarchar](4000) NULL,
			[ClientReassignallowed (multipleradiosinline-14)] [nvarchar](4000) NULL,
			[ClientCrossamend (multipleradiosinline-15)] [nvarchar](4000) NULL,
			[MultiplierforCashDeposit (textinput-56)] [nvarchar](4000) NULL,
			[MultiplierforSharePledged (textinput-57)] [nvarchar](4000) NULL,
			[MultiplierforNonShare (textinput-58)] [nvarchar](4000) NULL,
			[AvailableCleanLineLimit (textinput-59)] [nvarchar](4000) NULL,
			[StartDate (dateinput-9)] [nvarchar](4000) NULL,
			[EndDate (dateinput-10)] [nvarchar](4000) NULL,
			[TemporaryLimit (textinput-60)] [nvarchar](4000) NULL,
			[StartDate (dateinput-11)] [nvarchar](4000) NULL,
			[EndDate (dateinput-12)] [nvarchar](4000) NULL,
			[LegalStatus (selectsource-24)] [nvarchar](4000) NULL,
			[BankruptcyorWindingupstatus (multipleradiosinline-12)] [nvarchar](4000) NULL,
			[BankruptcyorWindingupreason (textinput-61)] [nvarchar](4000) NULL,
			[DatedeclaredbankruptcyorWindingup (dateinput-13)] [nvarchar](4000) NULL,
			[DatedischargedbankruptcyorWindingup (dateinput-14)] [nvarchar](4000) NULL,
			[Remark1 (textinput-62)] [nvarchar](4000) NULL,
			[Remark2 (textinput-63)] [nvarchar](4000) NULL,
			[Financier (selectsource-25)] [nvarchar](4000) NULL,
			[MarginCode (textinput-39)] [nvarchar](4000) NULL,
			[CommencementDate (dateinput-4)] [nvarchar](4000) NULL,
			[ExclusionforAutoRenewal (selectbasic-40)] [nvarchar](4000) NULL,
			[TenorExpiryDate (dateinput-5)] [nvarchar](4000) NULL,
			[LetterofOfferdate (dateinput-15)] [nvarchar](4000) NULL,
			[FacilityAgreementDate (dateinput-16)] [nvarchar](4000) NULL,
			[MortgageAgreementDate (dateinput-17)] [nvarchar](4000) NULL,
			[ApprovedLimit (textinput-64)] [nvarchar](4000) NULL,
			[ApprovedMargin (textinput-65)] [nvarchar](4000) NULL,
			[ApprovedRSV (textinput-43)] [nvarchar](4000) NULL,
			[PriceCapMOF (textinput-44)] [nvarchar](4000) NULL,
			[MarginCallInterval (selectbasic-38)] [nvarchar](4000) NULL,
			[AuthorisedRepresentative (textinput-66)] [nvarchar](4000) NULL,
			[CurrentMargin (textinput-47)] [nvarchar](4000) NULL,
			[CurrentRSV (textinput-48)] [nvarchar](4000) NULL,
			[CommitmentFeeCode (selectsource-26)] [nvarchar](4000) NULL
		)

		SELECT '[' + COLUMN_NAME + ']' as ColName 
		INTO #Col1409
		FROM GlobalBORpt.INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_SCHEMA = 'form' AND TABLE_NAME = 'Tb_FormData_1409' and COLUMN_NAME NOT IN ('ReportDate');

		SELECT @strColNameWithoutAcctNo = STRING_AGG (ColName, ',') FROM #Col1409 WHERE ColName <> '[AccountNumber (textinput-5)]' ;--AND ColName <> 'ReportDate'; -- 
		SELECT @strColName = STRING_AGG (ColName, ',') FROM #Col1409;
		PRINT 'IN'


		SELECT  COLUMN_NAME  as CollName 
		INTO #SubCol1409
		FROM GlobalBORpt.INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_SCHEMA = 'form' AND TABLE_NAME = 'Tb_FormData_1409'
		
		
				------SELECT @strSubColName = STUFF ((SELECT 
				------							',ISNULL(CAST(' + QUOTENAME(CollName) + ' AS VARCHAR(MAX)),'''+''+''') AS ' + QUOTENAME(CollName)  
				------						  FROM #SubCol1409
				------						  ORDER BY CollName FOR XML PATH('')), 1, 1, '')
				SELECT @strSubColName = STUFF ((SELECT 
											',' + QUOTENAME(CollName) + ' VARCHAR(MAX) NULL'
										  FROM #SubCol1409
										  ORDER BY CollName FOR XML PATH('')), 1, 1, '')

		SET @query = '
			';
		EXEC sp_executesql @query;

		SET @query = 
		'
		CREATE TABLE #current1409(
			'+@strSubColName+'
			);
		INSERT INTO #current1409 
		SELECT '+@strSubColName+' FROM GlobalBORpt.form.Tb_FormData_1409 WHERE ReportDate = '''+CAST(@idteReportDate as varchar(50))+'''';
		EXEC sp_executesql @query;
		PRINT 'IN_OUT'

			select * from #current1409;


		----SELECT * INTO #current1409 FROM GlobalBORpt.form.Tb_FormData_1409 WHERE ReportDate = @idteReportDate
		----SELECT * INTO #old1409 FROM GlobalBORpt.form.Tb_FormData_1409 WHERE ReportDate < @idteReportDate
		--SET @query = '
		--	INSERT INTO #old1409
		--	SELECT * FROM 
		--	(
		--		SELECT ROW_NUMBER() OVER (PARTITION BY [AccountNumber (textinput-5)], row_num ORDER BY ReportDate desc) rnum,*
		--		FROM
		--		(
		--			SELECT ROW_NUMBER() OVER (PARTITION BY '+ @strColName +' ORDER BY ReportDate) row_num,*
		--			FROM GlobalBORpt.form.Tb_FormData_1409 WHERE ReportDate < '''+ CAST(@idteReportDate as varchar(50)) +'''
		--		) as Z
		--		WHERE row_num = 1
		--	) as T
		--	WHERE rnum = 1
		--';
		--PRINT 'IN-1'

		--EXEC sp_executesql @query;
		--ALTER TABLE #old1409 DROP COLUMN rnum;
		--ALTER TABLE #old1409 DROP COLUMN row_num;

		--PRINT 'IN-2'

		--SET @query = '
		--INSERT INTO #diff1409
		--SELECT 
		--	[AccountNumber (textinput-5)] as AcctNo
		--	,[CustomerID (selectsource-1)] as CustomerID 
		--FROM
		--(
		--	SELECT '+ @strColName +' FROM #old1409
		--	EXCEPT
		--	SELECT '+ @strColName +' FROM #current1409
		--) as X
		--';
		--PRINT 'IN-3'
		--Print @query

			--SELECT [column] = c.name, 
   --    [type] = t.name, c.max_length, c.precision, c.scale, c.is_nullable 
   -- FROM tempdb.sys.columns AS c
   -- INNER JOIN tempdb.sys.types AS t
   -- ON c.system_type_id = t.system_type_id
   -- AND t.system_type_id = t.user_type_id
   -- WHERE [object_id] = OBJECT_ID(N'tempdb.dbo.#diff1409');

	--	EXEC sp_executesql @query;
	--	PRINT 'IN-4'


	--	SELECT * INTO #diffData1409 FROM
	--	(
	--		SELECT * FROM #current1409 WHERE [AccountNumber (textinput-5)] IN (select AcctNo FROM #diff1409)
	--		UNION ALL
	--		SELECT * FROM #old1409 WHERE [AccountNumber (textinput-5)] IN (select AcctNo FROM #diff1409)
	--	) as Z

	--	--SELECT [type] = t.name, c.max_length, c.precision, c.scale, c.is_nullable INTO #SubCol1409
	--	--FROM tempdb.sys.columns AS c
	--	--INNER JOIN tempdb.sys.types AS t ON c.system_type_id = t.system_type_id
	--	--AND t.system_type_id = t.user_type_id
	--	--WHERE 
	--	--	[object_id] = OBJECT_ID(N'tempdb.dbo.#diffData1409');


	----SELECT  @strColNameWithout= STRING_AGG (CAST(COLNAME  AS VARCHAR(MAX)), ',') FROM #SubCol1409
	
	--	SET @query = '
	--	INSERT INTO #unp1409_1
	--	SELECT *
	--	FROM
	--	(
	--		SELECT ColName, ColValue, [AccountNumber (textinput-5)] FROM (SELECT * FROM #diffData1409 ) a
	--		UNPIVOT(ColValue FOR ColName IN ('+ @strColNameWithoutAcctNo +')) AS unp
	--	) as Z
	--	GROUP BY ColName, ColValue, [AccountNumber (textinput-5)] HAVING (count(ColName) = 1)
	--	ORDER BY [AccountNumber (textinput-5)],ColName';
	--	PRINT @query


	--	EXEC sp_executesql @query;
	--	PRINT 'IN'

	--	SET @query = '
	--	INSERT INTO #unp1409_2
	--	SELECT A.*,B.ReportDate
	--	FROM
	--	#unp1409_1 as A
	--	INNER JOIN
	--	(
	--		SELECT ColName, ColValue, [AccountNumber (textinput-5)], ReportDate FROM (SELECT * FROM #diffData1409) a
	--		UNPIVOT(ColValue FOR ColName IN ('+ @strColNameWithoutAcctNo +')) AS unp
	--	) as B
	--	ON A.AcctNo = B.[AccountNumber (textinput-5)] AND A.ColName = B.ColName AND A.ColValue = B.ColValue';
	
	--	EXEC sp_executesql @query;

	--	SELECT
	--		'1409' as FormID,AcctNo,ColName, MIN(CASE WHEN row_num = 1 THEN ColValue END) as OldValue, MIN(CASE WHEN row_num = 2 THEN ColValue END) as NewValue
	--	FROM (
	--		SELECT *
	--		,ROW_NUMBER() OVER (PARTITION BY ColName,AcctNo ORDER BY ReportDate,ColName,AcctNo) row_num
	--		FROM #unp1409_2
	--	) as Z
	--	GROUP BY AcctNo, ColName
	--	ORDER BY AcctNo;

	--	DROP TABLE #Col1409;
	--	DROP TABLE #current1409;
	--	DROP TABLE #diff1409;
	--	DROP TABLE #diffData1409;
	--	DROP TABLE #old1409;
	--	DROP TABLE #unp1409_1;
	--	DROP TABLE #unp1409_2;

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END