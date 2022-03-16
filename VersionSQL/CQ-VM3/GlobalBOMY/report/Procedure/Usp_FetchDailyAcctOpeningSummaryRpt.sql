/****** Object:  Procedure [report].[Usp_FetchDailyAcctOpeningSummaryRpt]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [report].[Usp_FetchDailyAcctOpeningSummaryRpt]
Created By        : Fadlin    
Created Date      : 05/01/2021
Used by           : 
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : 
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 EXEC [report].[Usp_FetchDailyAcctOpeningSummaryRpt] '2021-01-05'
**********************************************************************************/   
CREATE PROCEDURE [report].[Usp_FetchDailyAcctOpeningSummaryRpt]
	@idteReportDate date
AS
BEGIN
	BEGIN TRY 

		DECLARE @dteReportDate date;
		DECLARE @dteCreatedDate date;

		SELECT @dteReportDate = MAX(ReportDate) FROM GlobalBORpt.form.Tb_FormData_1409
		SET @dteCreatedDate = @idteReportDate;

		DROP TABLE IF EXISTS #tmpSummary;

		CREATE TABLE #tmpSummary
		(
			[Order] BIGINT
			,[Group] BIGINT
			,Parent varchar(150)
			,ParentInd char(1)
			,Mode varchar(150)
			,AcctOpened BIGINT
			,CDSGenerated BIGINT
			,PendingCDS BIGINT
		)

		SELECT * INTO #tmpAcct 
		FROM GlobalBORpt.form.Tb_FormData_1409 as acct
		WHERE CAST(acct.CreatedTime as date) = @dteCreatedDate
		AND acct.ReportDate = @dteReportDate

		INSERT INTO #tmpSummary
		SELECT 1,1,'Total','Y','Total',0,0,0
		UNION
		SELECT 2,2,'Online','Y','Online',0,0,0
		UNION
		SELECT 3,2,'BA','Y','BA',0,0,0
		UNION
		SELECT 4,2,'Physical','Y','Physical',0,0,0
		UNION
		SELECT 5,3,'Dealer','Y','Dealer',0,0,0
		UNION
	
		SELECT 
			6,3,
			'- ' + DealerCode AS parent,
			CASE WHEN MR = '' THEN 'Y' ELSE 'N' END,
			CASE WHEN MR = '' THEN '- ' + DealerCode ELSE '-- ' + MR END,
			0,0,0
		FROM
		(
			SELECT [DealerCode (selectsource-21)] as DealerCode,'' as MR
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			GROUP BY [DealerCode (selectsource-21)]

			UNION ALL

			SELECT [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
			ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
			AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
			WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			GROUP BY [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
		) as M
		UNION
		SELECT 7,3,'Remisier','Y','Remisier',0,0,0

		UNION
	
		SELECT 
			8,3,
			'- ' + DealerCode AS parent,
			CASE WHEN MR = '' THEN 'Y' ELSE 'N' END,
			CASE WHEN MR = '' THEN '- ' + DealerCode ELSE '-- ' + MR END,
			0,0,0
		FROM
		(
			SELECT [DealerCode (selectsource-21)] as DealerCode,'' as MR
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			GROUP BY [DealerCode (selectsource-21)]

			UNION ALL

			SELECT [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
			ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
			AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
			WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			GROUP BY [DealerCode (selectsource-21)],MR.[RegistrationNo (textinput-2)]
		) as N
		UNION

		SELECT 9,4,'Region then Branch','Y','Region then Branch',0,0,0

		UNION

		SELECT 
			10,4,
			Region AS parent,
			CASE WHEN Branch = '' THEN 'Y' ELSE 'N' END,
			CASE WHEN Branch = '' THEN Region ELSE '- ' + Branch END,
			0,0,0
		FROM
		(
			SELECT branch.[Region (selectsource-10)] as Region, '' as Branch
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			AND branch.ReportDate = @dteReportDate
			GROUP BY branch.[Region (selectsource-10)]

			UNION ALL

			SELECT branch.[Region (selectsource-10)],branch.[BranchLocation (textinput-2)]
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			AND branch.ReportDate = @dteReportDate
			GROUP BY branch.[Region (selectsource-10)],branch.[BranchLocation (textinput-2)]
		) as T
		UNION

		SELECT 11,5,'Account Types','Y','Account Types',0,0,0

		UNION

		SELECT 12,5,
		'- ' + AcctTypes.[Description (textinput-2)],
		'Y',
		'- ' + AcctTypes.[Description (textinput-2)]
		,0,0,0
		FROM #tmpAcct as acct
		INNER JOIN GlobalBORpt.form.Tb_FormData_1457 as AcctTypes
		ON AcctTypes.[2DigitCode (textinput-1)] = RIGHT(acct.[AccountNumber (textinput-5)],2)
		AND AcctTypes.ReportDate = @dteReportDate
		GROUP BY AcctTypes.[Description (textinput-2)]
	
		UNION

		SELECT 13,6,'IDSS','Y','IDSS',0,0,0
		UNION
		SELECT 14,6,'Leap','Y','Leap',0,0,0
		UNION
		SELECT 15,6,'Multicurrency','Y','Multicurrency',0,0,0
		UNION
		SELECT 16,7,'Individual','Y','Individual',0,0,0
		UNION
		SELECT 17,7,'Corporate','Y','Corporate',0,0,0
		UNION
		SELECT 18,8,'Female','Y','Female',0,0,0
		UNION
		SELECT 19,8,'Male','Y','Male',0,0,0
		UNION
		SELECT 20,9,'M+ Online','Y','M+ Online',0,0,0
		UNION
		SELECT 21,9,'MVIEW','Y','MVIEW',0,0,0
		UNION
		SELECT 22,9,'N2N','Y','N2N',0,0,0
		UNION
		SELECT 23,10,'No. of closed accounts','Y','No. of closed accounts',0,0,0


		UPDATE A SET 
			A.AcctOpened = B.TotalAccounts
			,A.CDSGenerated = B.TotalCDS
			,A.PendingCDS = B.TotalPendingCDS
		FROM #tmpSummary as A
		INNER JOIN 
		(
			--GET TOTAL ACCOUNTS
			SELECT 
				ISNULL(MAX('Total'),'Total') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					[CDSNo (textinput-19)]
					,count(1) as Cnt FROM
				#tmpAcct as acct
				GROUP BY [CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL ONLINE ACCOUNTS
			SELECT 
				ISNULL(MAX('Online'),'Online') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt FROM
				#tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON acct.[CustomerID (selectsource-1)] = cust.[CustomerID (textinput-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[ModeofClientAcquisition (selectbasic-25)] = 'ONFTF'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL BA ACCOUNTS
			SELECT 
				ISNULL(MAX('BA'),'BA') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt FROM
				#tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON acct.[CustomerID (selectsource-1)] = cust.[CustomerID (textinput-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[ModeofClientAcquisition (selectbasic-25)] = 'PFTF'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL Physical ACCOUNTS
			SELECT 
				ISNULL(MAX('Physical'),'Physical') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt FROM
				#tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON acct.[CustomerID (selectsource-1)] = cust.[CustomerID (textinput-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[ModeofClientAcquisition (selectbasic-25)] = 'PNFTF'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL DEALER ACCOUNTS
			SELECT 
				ISNULL(MAX('Dealer'),'Dealer') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,acct.[DealerCode (selectsource-21)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @dteReportDate
				WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
				GROUP BY acct.[CDSNo (textinput-19)],acct.[DealerCode (selectsource-21)]
			) as Z

			UNION ALL

			--GET TOTAL DEALER ACCOUNTS GROUP BY DEALER CODE
			SELECT 
				'- ' + acct.[DealerCode (selectsource-21)] as Mode
				,SUM(1) as TotalAccounts
				,SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN 1 ELSE 0 END) as TotalCDS
				,SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN 1 ELSE 0 END) as TotalPendingCDS
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			GROUP BY acct.[DealerCode (selectsource-21)]

			UNION ALL
		
			--GET TOTAL DEALER ACCOUNTS GROUP BY MARKETING REPRESENTATIVE (MR)
			SELECT 
				'-- ' + MR.[RegistrationNo (textinput-2)] as Mode
				,SUM(1) as TotalAccounts
				,SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN 1 ELSE 0 END) as TotalCDS
				,SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN 1 ELSE 0 END) as TotalPendingCDS
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
			ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
			AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
			WHERE dealer.[DealerType (selectsource-3)] NOT IN ('R','M')
			GROUP BY MR.[RegistrationNo (textinput-2)]

			UNION ALL

			--GET TOTAL REMISIER ACCOUNTS
			SELECT 
				ISNULL(MAX('Remisier'),'Remisier') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,acct.[DealerCode (selectsource-21)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @dteReportDate
				WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
				GROUP BY acct.[CDSNo (textinput-19)],acct.[DealerCode (selectsource-21)]
			) as Z

			UNION ALL

			--GET TOTAL REMISIER ACCOUNTS GROUP BY DEALER CODE
			SELECT 
				'- ' + acct.[DealerCode (selectsource-21)] as Mode
				,SUM(1) as TotalAccounts
				,SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN 1 ELSE 0 END) as TotalCDS
				,SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN 1 ELSE 0 END) as TotalPendingCDS
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			GROUP BY acct.[DealerCode (selectsource-21)]

			UNION ALL

			--GET TOTAL REMISIER ACCOUNTS GROUP BY MARKETING REPRESENTATIVE (MR)
			SELECT 
				'-- ' + MR.[RegistrationNo (textinput-2)] as Mode
				,SUM(1) as TotalAccounts
				,SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN 1 ELSE 0 END) as TotalCDS
				,SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN 1 ELSE 0 END) as TotalPendingCDS
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN CQBTempDB.export.Tb_FormData_1575 as MR
			ON MR.[MRCode (textinput-17)] = acct.[MRReference (selectsource-22)]
			AND MR.[DealerCode (selectsource-1)] = acct.[DealerCode (selectsource-21)]
			WHERE dealer.[DealerType (selectsource-3)] IN ('R','M')
			GROUP BY MR.[RegistrationNo (textinput-2)]

			UNION ALL

			--GET TOTAL ACCOUNTS BY REGION
			SELECT 
				ISNULL(MAX('Region then Branch'),'Region then Branch') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,branch.[Region (selectsource-10)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
				ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
				AND dealer.ReportDate = @dteReportDate
				INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
				ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
				AND branch.ReportDate = @dteReportDate
				GROUP BY acct.[CDSNo (textinput-19)],branch.[Region (selectsource-10)]
			) as Z

			UNION ALL

			--GET TOTAL ACCOUNTS GROUP BY REGION
			SELECT 
				branch.[Region (selectsource-10)] as Mode
				,SUM(1) as TotalAccounts
				,SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN 1 ELSE 0 END) as TotalCDS
				,SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN 1 ELSE 0 END) as TotalPendingCDS
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			AND branch.ReportDate = @dteReportDate
			GROUP BY branch.[Region (selectsource-10)]

			UNION ALL

			--GET TOTAL ACCOUNTS GROUP BY BRANCH LOCATION
			SELECT 
				'- ' + branch.[BranchLocation (textinput-2)] as Mode
				,SUM(1) as TotalAccounts
				,SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN 1 ELSE 0 END) as TotalCDS
				,SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN 1 ELSE 0 END) as TotalPendingCDS
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1377 as dealer
			ON acct.[DealerCode (selectsource-21)] = dealer.[DealerCode (textinput-35)]
			AND dealer.ReportDate = @dteReportDate
			INNER JOIN GlobalBORpt.form.Tb_FormData_1374 as branch
			ON branch.[BranchID (textinput-1)] = dealer.[BranchID (selectsource-1)]
			AND branch.ReportDate = @dteReportDate
			GROUP BY branch.[BranchLocation (textinput-2)]

			UNION ALL

			--GET TOTAL ACCOUNTS BY ACCOUNT TYPES
			SELECT 
				ISNULL(MAX('Account Types'),'Account Types') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,AcctTypes.[Description (textinput-2)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1457 as AcctTypes
				ON AcctTypes.[2DigitCode (textinput-1)] = RIGHT(acct.[AccountNumber (textinput-5)],2)
				AND AcctTypes.ReportDate = @dteReportDate
				GROUP BY acct.[CDSNo (textinput-19)],AcctTypes.[Description (textinput-2)]
			) as Z

			UNION ALL

			--GET TOTAL ACCOUNTS GROUP BY ACCOUNT TYPES
			SELECT 
				'- ' + AcctTypes.[Description (textinput-2)] as Mode
				,SUM(1) as TotalAccounts
				,SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN 1 ELSE 0 END) as TotalCDS
				,SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN 1 ELSE 0 END) as TotalPendingCDS
			FROM #tmpAcct as acct
			INNER JOIN GlobalBORpt.form.Tb_FormData_1457 as AcctTypes
			ON AcctTypes.[2DigitCode (textinput-1)] = RIGHT(acct.[AccountNumber (textinput-5)],2)
			AND AcctTypes.ReportDate = @dteReportDate
			GROUP BY AcctTypes.[Description (textinput-2)]

			UNION ALL

			--GET TOTAL IDSS ACCOUNTS
			SELECT 
				ISNULL(MAX('IDSS'),'IDSS') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[IDSS (multipleradiosinline-17)] = 'Y'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL LEAP ACCOUNTS
			SELECT 
				ISNULL(MAX('Leap'),'Leap') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[LEAP (selectbasic-29)] = 'Y'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL INDIVIDUAL ACCOUNTS
			SELECT 
				ISNULL(MAX('Individual'),'Individual') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[ClientType (selectbasic-26)] = 'I'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL CORPORATE ACCOUNTS
			SELECT 
				ISNULL(MAX('Corporate'),'Corporate') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[ClientType (selectbasic-26)] = 'C'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL FEMALE ACCOUNTS
			SELECT 
				ISNULL(MAX('Female'),'Female') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[Gender (selectbasic-1)] = 'F'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL MALE ACCOUNTS
			SELECT 
				ISNULL(MAX('Male'),'Male') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[Gender (selectbasic-1)] = 'M'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL MALE ACCOUNTS
			SELECT 
				ISNULL(MAX('Male'),'Male') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				INNER JOIN GlobalBORpt.form.Tb_FormData_1410 as cust
				ON cust.[CustomerID (textinput-1)] = acct.[CustomerID (selectsource-1)]
				AND cust.ReportDate = @dteReportDate
				WHERE cust.[Gender (selectbasic-1)] = 'M'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL M+ ONLINE ACCOUNTS
			SELECT 
				ISNULL(MAX('M+ Online'),'M+ Online') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				WHERE acct.[OnlineSystemIndicator (multiplecheckboxesinline-1)] = 'M+'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL MVIEW ACCOUNTS
			SELECT 
				ISNULL(MAX('MVIEW'),'MVIEW') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				WHERE acct.[OnlineSystemIndicator (multiplecheckboxesinline-1)] = 'MV'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL N2N ACCOUNTS
			SELECT 
				ISNULL(MAX('N2N'),'N2N') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				WHERE acct.[OnlineSystemIndicator (multiplecheckboxesinline-1)] = 'N2'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

			UNION ALL

			--GET TOTAL CLOSED ACCOUNTS
			SELECT 
				ISNULL(MAX('No. of closed accounts'),'No. of closed accounts') as Mode,
				ISNULL(SUM(Cnt),0) as TotalAccounts, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] <> '' AND [CDSNo (textinput-19)] IS NOT NULL THEN Cnt END ),0) as TotalCDS, 
				ISNULL(SUM( CASE WHEN [CDSNo (textinput-19)] = '' OR [CDSNo (textinput-19)] IS NULL THEN Cnt END),0) as TotalPendingCDS
			FROM (
				SELECT 
					acct.[CDSNo (textinput-19)]
					,count(1) as Cnt 
				FROM #tmpAcct as acct
				WHERE acct.[AccountStatus (selectsource-9)] = 'C'
				GROUP BY acct.[CDSNo (textinput-19)]
			) as Z

		) as B
		ON A.Mode = B.Mode

		SELECT * 
		FROM #tmpSummary 
		order by [Order], Parent, CASE WHEN ParentInd = 'Y' THEN 2 ELSE 3 END

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END