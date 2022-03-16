/****** Object:  Procedure [report].[Usp_ContractStmt_ReconDetailsRpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_ContractStmt_ReconDetailsRpt] (
@dteReportDate DATE ,
@istrMode VARCHAR(20),
@istChannelCode VARCHAR(10 ) = null
,@istBranchCode VARCHAR(10 )= null
,@istBranchName VARCHAR(50 )= null
	)
AS
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2019-09-25','STDCF','e-doc','99','Private Fund'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2019-09-25','ADDWSA'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2019-09-25','ADDDSA'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2019-09-25','STDTAA'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2019-10-31','REPOST'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2020-05-20','STDSBB'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2020-05-20','STDSBR'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2020-05-20','STDSLL'
--EXEC [report].[Usp_ContractStmt_ReconDetailsRpt]  '2020-05-20','STDSLR'
BEGIN
	SET NOCOUNT ON;

	 --set  @dteReportDate   ='2019-06-28'
	DROP TABLE IF EXISTS #STDCF_Header 
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

	CREATE TABLE #tmpSBLAcctNo (
		CustNo varchar(20)
	);
			 
	if (@istrMode ='STDCF')
	begin
		INSERT INTO #STDCF_Header(
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
			,InvoiceNo as DocumentNo                     
			,AcctNo as AccountNo                           
			,CustNo AS CustNo 
			,'' as ChannelCode                    
			,'' as BranchCode                     
			,'' as BranchName                    
		from (
			SELECT TradeDate, CustNo, AcctNo, SetlDate, settlementRoute, InvoiceNo, '' OldInvoiceNo, ClientTaxID, Location, Branch  
			FROM report.Tb_DailyStmtAcctDetails A1
			UNION 
			SELECT TradeDate, CustNo,AcctNo, SetlDate, settlementRoute, InvoiceNo, '' OldInvoiceNo, ClientTaxID, Location, Branch  
			FROM report.Tb_DailyStmtAcctDetails_Archive A2
		) AS DS
		WHERE DS.TradeDate=@dteReportDate ;

	end

			
						
		    Update X
			set 
				X.PostalCode = A.PostalCode ,
				X.BranchCode = A.BranchCode ,
				X.CustGrp = A.CustGrp ,
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
			set 
				X.ChannelCode = A.mode
 			FROM #STDCF_Header X
			inner join (
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
			) A on X.CustNo = A.custcode
			
			update #STDCF_Header SET BranchCode='F', BranchName='Foreign' where PostalCode='99999' and ChannelCode NOT IN ( 'e-doc' ,'PDFOnly')
					
			 select * from #STDCF_Header where 
				(@istChannelCode is null OR	ChannelCode =@istChannelCode  )
			 and (@istBranchCode is null OR	BranchCode=@istBranchCode )
			 and (@istBranchName is null OR	BranchName=@istBranchName )
			 order by BranchCode,ChannelCode,AccountNo;                
		 
	SET NOCOUNT OFF;
END