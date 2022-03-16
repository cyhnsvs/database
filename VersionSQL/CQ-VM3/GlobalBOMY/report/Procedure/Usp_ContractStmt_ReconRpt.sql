/****** Object:  Procedure [report].[Usp_ContractStmt_ReconRpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_ContractStmt_ReconRpt] (@dteReportDate DATE ,
@istrMode VARCHAR(20)
	)
AS
--EXEC [report].[Usp_ContractStmt_ReconRpt]  '2020-02-03','STDCF'
BEGIN
	SET NOCOUNT ON;

	 --set  @dteReportDate   ='2019-06-28'
	DROP TABLE IF EXISTS #STDCF_Header;
	DROP TABLE IF EXISTS #STDCF_Header1;
	DROP TABLE IF EXISTS #tmpSBLAcctNo;

	CREATE TABLE #STDCF_Header (
		Mode VARCHAR(30 )
		,CustGrp VARCHAR(100)
		,DocumentNo               VARCHAR(30 )
		,ReportDate                VARCHAR(10 ) 
		,AccountNo                VARCHAR(20 )
		,CustNo						VARCHAR(20 )
		,ChannelCode              VARCHAR(10 )
		,BranchCode               VARCHAR(10 )
		,BranchName               VARCHAR(50 )
		,PostalCode               VARCHAR(50 )
	);

	CREATE TABLE #STDCF_Header1 (
		DocumentNo               VARCHAR(30 )
		,ReportDate                VARCHAR(10 ) 
		,AccountNo                VARCHAR(20 )
		,CustNo						VARCHAR(20 )
		,ChannelCode              VARCHAR(10 )
		,BranchCode               VARCHAR(10 )
		,BranchName               VARCHAR(50 )
		,PostalCode               VARCHAR(50 )
	);

	CREATE TABLE #tmpSBLAcctNo (
		CustNo varchar(20)
	);

	declare @emailcnt bigint = 0;
			 
	if (@istrMode ='STDCF')
	begin
			 
		INSERT INTO #STDCF_Header (
			Mode
			,ReportDate
			,DocumentNo                     
			,AccountNo                           
			,CustNo 
			,ChannelCode                    
			,BranchCode                     
			,BranchName 
		)
		select 
			'STDCF',
			DS.TradeDate as ReportDate
			,AcctNo as DocumentNo
			,AcctNo as AccountNo
			,CustNo AS CustNo
			,'' as ChannelCode
			,'' as BranchCode
			,'' as BranchName 
		from (
			SELECT TradeDate, CustNo, CustNo AcctNo
			FROM report.Tb_DailyStmtAcctDetails A1
			UNION 
			SELECT TradeDate, CustNo,CustNo AcctNo
			FROM report.Tb_DailyStmtAcctDetails_Archive A2
		) AS DS
		WHERE DS.TradeDate=@dteReportDate ;
				
		INSERT INTO #STDCF_Header1 (
			ReportDate
			,DocumentNo                     
			,AccountNo                           
			,CustNo 
			,ChannelCode                    
			,BranchCode                     
			,BranchName 
		)
		select 
			DS.TradeDate as ReportDate
			,AcctNo as DocumentNo                     
			,AcctNo as AccountNo                           
			,CustNo AS CustNo 
			,'' as ChannelCode                    
			,'' as BranchCode                     
			,'' as BranchName                    
		from (
			SELECT TradeDate, CustNo,  AcctNo
			FROM report.Tb_DailyStmtAcctDetails A1
			UNION 
			SELECT TradeDate, CustNo, AcctNo
			FROM report.Tb_DailyStmtAcctDetails_Archive A2
		) AS DS
		WHERE DS.TradeDate=@dteReportDate ;
 
 		Update X
		set X.ChannelCode = A.mode		 
 		FROM #STDCF_Header1 X
		inner join (
			SELECT [CustomerID (textinput-1)] as custcode,
			CASE 
				--WHEN EA.acc_no IS NOT NULL AND email in ('privatefund@phillip.co.th','PF_Div@phillip.co.th') THEN 'PDFOnly' 
				WHEN EA.acc_no IS NOT NULL THEN 'e-doc'
				WHEN EA.acc_no IS NULL THEN 'By Hand'
				--WHEN [SettleRouteSBA (selectbasic-59)] NOT IN ('D','T') AND EA.acc_no IS NULL THEN 'By Hand'
				Else 'By Mail' 
			END AS mode,
			EA.email
			FROM CQBTempDB.export.Tb_FormData_1410 AS CI
			LEFT JOIN import.EDoc_Activate AS EA
			ON CI.[CustomerID (textinput-1)] = EA.acc_no and cast(EA.eff_date as date)<=@dteReportDate
		) A on X.CustNo = A.custcode;

		select @emailcnt = count(1) from #STDCF_Header1 where ChannelCode='e-doc';

	end

	Update X
	SET X.PostalCode = A.PostalCode,
		X.CustGrp = A.CustGrp,
		X.BranchCode = A.BranchCode,
		X.BranchName = A.BranchName
 	FROM #STDCF_Header X
	INNER JOIN ( 
		SELECT
			X.CustNo
			,BR.[BranchCode (textinput-42)] AS BranchCode
			,BR.[BranchLocation (textinput-2)] AS BranchName
			,BR.[PostalCode (textinput-11)] AS PostalCode
			,Acct.[AccountGroup (selectsource-2)] AS CustGrp
		FROM #STDCF_Header X  
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS Acct
		ON x.CustNo = Acct.[CustomerID (selectsource-1)]
		INNER JOIN CQBTempDB.export.Tb_FormData_1377 as Dealer
		ON Dealer.[DealerCode (textinput-35)] = Acct.[DealerCode (selectsource-21)]
		LEFT JOIN CQBTempDB.export.Tb_FormData_1374 AS BR
		ON BR.[BranchID (textinput-1)] = Dealer.[BranchID (selectsource-1)]
	) A on X.CustNo = A.CustNo

	Update X
	set X.ChannelCode = A.mode
 	FROM #STDCF_Header X
	INNER JOIN (
		SELECT 
			[CustomerID (textinput-1)] as custcode,
			CASE 
				--WHEN EA.acc_no IS NOT NULL AND email in ('privatefund@phillip.co.th','PF_Div@phillip.co.th') THEN 'PDFOnly' 
				WHEN EA.acc_no IS NOT NULL THEN 'e-doc' 
				WHEN EA.acc_no IS NULL THEN 'By Hand'
				--WHEN [SettleRouteSBA (selectbasic-59)] NOT IN ('D','T') AND EA.acc_no IS NULL THEN 'By Hand'
				Else 'By Mail'
			END AS mode,
			EA.email
		FROM CQBTempDB.export.Tb_FormData_1410 AS CI
		LEFT JOIN import.EDoc_Activate AS EA
		ON CI.[CustomerID (textinput-1)] = EA.acc_no and cast(EA.eff_date as date)<=@dteReportDate
	) A on X.CustNo = A.custcode;

	update #STDCF_Header SET BranchCode='F', BranchName='Foreign' where PostalCode='99999' and ChannelCode NOT IN ( 'e-doc' ,'PDFOnly');

	if (@istrMode <> 'STDCF')
	BEGIN
		select @emailcnt=count(1) from #STDCF_Header where ChannelCode='e-doc';
 	END
			 
	drop table  if exists #t;

	select BranchCode ,BranchName,
	SUM( CASE when ChannelCode = 'By Hand' Then Cnt
	when ChannelCode = 'By Mail'	Then 0
	when ChannelCode = 'e-doc'	Then 0
	when ChannelCode = 'PDFOnly'	Then 0
	else 0 END) 'By Hand' 
	,SUM(CASE when ChannelCode = 'By Hand' Then 0
	when ChannelCode = 'By Mail'	Then Cnt
	when ChannelCode = 'e-doc'	Then 0
	when ChannelCode = 'PDFOnly'	Then 0
	else 0 END) 'By Mail   ' 
	,SUM(CASE when ChannelCode = 'By Hand' Then 0
	when ChannelCode = 'By Mail'	Then 0
	when ChannelCode = 'e-doc'	Then Cnt
	when ChannelCode = 'PDFOnly'	Then 0
	else 0 END) 'e-doc   ' 
	,SUM(CASE when ChannelCode = 'By Hand' Then 0
	when ChannelCode = 'By Mail'	Then 0
	when ChannelCode = 'e-doc'	Then 0
	when ChannelCode = 'PDFOnly'	Then Cnt
	else 0 END) 'PDFOnly'
	,SUM(  Cnt)  'Total'
	,@emailcnt 'TotalEmail' 
	into #t
	 from ( 
		select BranchCode,BranchName,ChannelCode ,count(1) Cnt 
			from 
				(select X.AccountNo, BranchCode,BranchName,ChannelCode
				 FROM #STDCF_Header X)  C 
			group by BranchCode,BranchName,ChannelCode 
		) a 
		group by BranchCode ,BranchName
	order by BranchCode,BranchName;

	select BranchCode,BranchName,[By Hand],[By Mail],[e-doc],[PDFOnly],[Total],TotalEmail, '' Remarks 
	from (
		select 1 as Ord , BranchCode,BranchName,[By Hand],[By Mail],[e-doc],[PDFOnly],[Total],TotalEmail
	 from #t
	 ) a order by Ord, BranchCode;

	SET NOCOUNT OFF;
END