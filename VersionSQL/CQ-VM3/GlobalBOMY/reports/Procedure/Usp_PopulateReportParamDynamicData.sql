/****** Object:  Procedure [reports].[Usp_PopulateReportParamDynamicData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_PopulateReportParamDynamicData]
@iReportName varchar(200)=null,
@iReportParamName varchar(200) = null
/*


*/
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dteBusinessDate DATE= (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'));
	DECLARE @dteNextBusinessDate DATE  = GlobalBO.[global].[Udf_GetNextBusDateByDaysExcludePH](@dteBusinessDate,1,NULL);
    
	DECLARE @iintCompanyId INT = (SELECT CAST(GlValue AS INT) FROM GlobalBO.setup.Tb_GlobalValues Where GlType like '%DefaultCompany%');
	
	if(@iReportName='W8BenExpiry')
	 BEGIN 

		 IF(@iReportParamName='AcctNo')
		 BEGIN

		--SELECT  '015621401' AS AcctNo

		SELECT DISTINCT A.[AccountNumber (textinput-5)] as AcctNo
		FROM CQBTempDB.export.Tb_FormData_1410 C
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 A  
		ON C.[CustomerID (textinput-1)]  = A.[CustomerID (selectsource-1)]
		WHERE [W8BENExpiryDate (dateinput-18)] < DATEADD(month, 1, @dteBusinessDate) AND [W8BEN (multipleradiosinline-21)] = 'Y'

		 END
	 END

	 ELSE if(@iReportName='OverDueOutstandingLosses')
	 BEGIN 

		 IF(@iReportParamName='AcctNo')
		 BEGIN

		-- SELECT '010680404' AS AcctNo

		   SELECT 
				DISTINCT A.[AccountNumber (textinput-5)] AS AcctNo
			
			FROM 
				GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid T
			INNER JOIN 
				CQBTempDB.export.Tb_FormData_1409 A ON T.AcctNo = A.[AccountNumber (textinput-5)]
			WHERE 
				T.NetAmountSetl < 0
		

		 END
	 END
	 ELSE if(@iReportName='ReceiptCreation')
	 BEGIN 

		 IF(@iReportParamName='ReceiptId')
		 BEGIN
	 
			--SELECT '1543' AS ReceiptId

		   SELECT DISTINCT
		   TR.ReceiptId
		   FROM 
			GlobalBOLocal.RPS.Tb_ReceiptTransaction TR
			WHERE CAST(TR.CreatedOn as date)=@dteBusinessDate
			
			

		 END

		 IF(@iReportParamName='AcctNo')
		 BEGIN
	 
			--SELECT '010037402' AS AcctNo


		   SELECT DISTINCT
		   TR.AcctNo
		   FROM 
		   GlobalBOLocal.RPS.Tb_ReceiptTransaction TR
		   WHERE CAST(TR.CreatedOn as date)=@dteBusinessDate
	
		 END
	END

	ELSE IF (@iReportName='DealerLicenseRenewalReminder')
	BEGIN
		 IF(@iReportParamName='AcctNo')
		 BEGIN

     		--SELECT 'D0003819' AS AcctNo	 
		    SELECT DISTINCT DEA.[DealerAccountNo (textinput-37)] AS AcctNo
			FROM CQBTempDB.export.Tb_FormData_1377 DEA
			LEFT JOIN CQBTempDB.export.Tb_FormData_1377_grid5 CPE
		    ON DEA.RecordId = CPE.RecordId
			WHERE CAST([LicenseAnniversaryDate (dateinput-2)] AS DATE) = CAST(DATEADD(month, 1, @dteBusinessDate) AS date)
			AND CPE.[Applicable Points (TextBox)] < (SELECT CAST(GlValue AS BIGINT) FROM GlobalBO.setup.Tb_GlobalValues WHERE GlType = 'DealerCPEPoints')
		    
		 END
	END


	ELSE IF (@iReportName='MRLicenseRenewalReminder')
	BEGIN
		 IF(@iReportParamName='MRCode') 
		 BEGIN

		-- SELECT 'A001/2018' AS MRCode
		    SELECT DISTINCT MRE.[MRCode (textinput-17)] AS MRCode 
			FROM CQBTempDB.export.Tb_FormData_1575 MRE
			LEFT JOIN CQBTempDB.export.Tb_FormData_1575_grid4 CPE
		    ON MRE.RecordId = CPE.RecordId
			WHERE MRE.[AnniversaryDate (dateinput-2)] = CAST(DATEADD(month, 1, @dteBusinessDate) AS date)
			AND CPE.[Applicable Points (TextBox)] < (SELECT CAST(GlValue AS BIGINT) FROM GlobalBO.setup.Tb_GlobalValues WHERE GlType = 'MRCPEPoints')
		
		 END


	END


	ELSE IF (@iReportName='ShariahtoNonShariah')
	BEGIN
		 IF(@iReportParamName='AcctNo') 
		 BEGIN

			--DECLARE @dteBusinessDate DATE= (SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'));

			--SELECT 
			--	DISTINCT IDENTITY (INT,1,1) AS No, 
			--	A.[textinput-49] AS StockCode,
			--	A.[textinput-2] AS NameOfSecurities
			--INTO #TempData1 
			--FROM CQBuilder.form.Tb_FormData_1345 A 
			--INNER JOIN CQBuilderAuditLog.log.Tb_FormData_1345 B
			--	ON A.RecordID = B.RecordID
			--WHERE A.[multipleradiosinline-3] = 'N' AND JSON_VALUE(B.FormDetails,'$[0].multipleradiosinline3') = 'Y' 
			--	AND B.LogEvent = 'O' AND B.AuditDateTime >= CAST(DATEADD(m, -6, @dteBusinessDate) as date);
		
		 SELECT '010016411' AS AcctNo;

		 --select * from #TempData1

		 --  SELECT DISTINCT A.[AccountNumber (textinput-5)] AS AcctNo, [CustomerName (textinput-3)]
			--FROM CQBTempDB.export.Tb_FormData_1409 A 
			--INNER JOIN CQBTempDB.export.Tb_FormData_1410 C
			--ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
			--INNER JOIN CQBTempDB.export.Tb_FormData_1457 AS AT
			--ON RIGHT(A.[AccountNumber (textinput-5)],2) = AT.[2DigitCode (textinput-1)]
			--INNER JOIN GlobalBO.holdings.Tb_CustodyAssets AS CA
			--ON A.[AccountNumber (textinput-5)] = CA.AcctNo
			--INNER JOIN GlobalBO.setup.Tb_Instrument AS I
			--ON CA.InstrumentId = I.InstrumentId
			--INNER JOIN #TempData1 AS SNS
			--ON I.InstrumentCd = SNS.StockCode
			--WHERE AT.[CharCode (textinput-3)] = 'J' AND [Tradingaccount (selectsource-31)] = 'A' AND CA.Balance <> 0;

			--DROP TABLE #TempData1;

		 END
	END

	ELSE IF (@iReportName='CDSAccountApproval')	
	BEGIN
		 IF(@iReportParamName='AcctNo')
		 BEGIN

		 SELECT '010037402' AS AcctNo
		    --SELECT A.[AccountNumber (textinput-5)] AS AcctNo 
			--FROM CQBTempDB.export.Tb_FormData_1409 A 
			--WHERE CAST(A.[CDSAccountOpenedDate (dateinput-18)] AS Date) = @dteBusinessDate
		 END
	END

	ELSE IF (@iReportName='NotificationForInActiveAccounts')
	BEGIN
		 IF(@iReportParamName='AcctNo')
		 BEGIN

		 --	SELECT '010037402' AS AcctNo

	 
		  SELECT
			T.AcctNo AS AcctNo
		FROM 
			CQBTempDB.export.Tb_FormData_1409 A
		INNER JOIN
			GlobalBO.holdings.Tb_Cash C ON C.AcctNo = A.[AccountNumber (textinput-5)]  
		INNER JOIN 
			GlobalBO.setup.Tb_FundSource F ON C.FundSourceId = F.FundSourceId  AND C.CompanyId = F.CompanyId
		LEFT JOIN
			GlobalBO.transmanagement.Tb_TransactionsSettled T ON T.AcctNo = A.[AccountNumber (textinput-5)]
		WHERE 
			(T.TransType IS NULL OR T.TransType IN ('TRBUY','TRSELL'))
		AND 
			((T.ContractDate IS NOT NULL AND ContractDate < DATEADD(year,-3,@dteBusinessDate))
			OR
			(T.ContractDate IS NULL AND CAST(A.CreatedTime AS DATE) < DATEADD(year,-3,@dteBusinessDate)))
		AND
			C.CompanyId = @iintCompanyId AND C.CurrCd = 'MYR' AND Balance > 0 AND C.FundSourceId = 1 -- Cash
		AND
			[ParentGroup (selectsource-3)] NOT IN ('M','G','V','P','CE1','CE3','CE2','I')

			
		 END


	END

	ELSE IF (@iReportName='MarginCallNotification')
	BEGIN
		 IF(@iReportParamName='AcctNo')
		 BEGIN
		 --SELECT '010037402' AS AcctNo

		 
			SELECT MRS.AcctNo AS AcctNo FROM  GlobalBOMY.margin.Tb_MarginRptSummary MRS
			WHERE (MRS.Equity * 100.00)/MRS.OutstandingAmount <= 150
			
	 

		 END


	END

	
	ELSE IF (@iReportName='MarginFacilityRenewal')
	BEGIN
		 IF(@iReportParamName='AcctNo')
		 BEGIN
		 
			SELECT 
			A.[AccountNumber (textinput-5)]
			FROM	CQBTempDB.export.Tb_FormData_1409 A
			WHERE	[ParentGroup (selectsource-3)] = 'M' 
			AND [ExclusionforAutoRenewal (selectbasic-40)] <> 'Y' 
			AND		DATEADD(day, -14, [TenorExpiryDate (dateinput-5)]) >= @dteBusinessDate AND DATEADD(day, -14, [TenorExpiryDate (dateinput-5)]) < @dteNextBusinessDate
		
		 
		 END


	END


END