/****** Object:  Procedure [report].[Usp_DealerChangeAuditDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_DealerChangeAuditDetails]
AS
-- EXEC report.Usp_DealerChangeAuditDetails 
BEGIN

	DECLARE @dteBusinessDate DATE = (SELECT * FROM GlobalBO.global.Udf_GetPreviousBusinessDate(GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')));
	--DATEADD(day, -1,(GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')));
	DECLARE @iintAuditCount INT = (SELECT COUNT(*) FROM report.Tb_FormData_1409_AuditLog WHERE BusinessDate=@dteBusinessDate);

	IF @iintAuditCount >=0
	BEGIN
		DELETE FROM report.Tb_FormData_1409_AuditLog 
		WHERE BusinessDate=@dteBusinessDate;

	END

	CREATE TABLE #FinalAuditResult
	(
		BusinessDate	DATE,
		AuditDateTime	VARCHAR(200),
		UpdatedBy		VARCHAR(50),
		AccountNo		VARCHAR(20),
		CustomerName	VARCHAR(100),
		OldDealerCode	VARCHAR(200),
		NewDealerCode	VARCHAR(200),
		OldDealerName	VARCHAR(200),
		NewDealerName	VARCHAR(100),
		OldMRCode		VARCHAR(100),
		NewMRCode		VARCHAR(50),
		OldMRName		VARCHAR(100),
		NewMRName		VARCHAR(200),
	);
	CREATE TABLE #TempAudit
	(
		BusinessDate	DATE,
		RecordID		VARCHAR(200),
		AuditDateTime	VARCHAR(200),
		Mode			VARCHAR(200),
		FieldName		VARCHAR(200),
		OldValue		VARCHAR(max),
		NewValue		VARCHAR(max),
		Createdby		VARCHAR(50),
		CreatedTime		VARCHAR(200),
		Updatedby		VARCHAR(50),
		UpdatedTime		VARCHAR(200)
	);

	INSERT INTO #TempAudit(
		 RecordID	
		,AuditDateTime
		,Mode		
		,FieldName	
		,OldValue	
		,NewValue	
		,Createdby	
		,CreatedTime	
		,Updatedby	
		,UpdatedTime	
	)
	EXEC CQBTempDB.[log].[USP_CQBAuditLogDataRetrieval_Daily] '1409', @dteBusinessDate , 'N,U,D';

	UPDATE #TempAudit SET BusinessDate= @dteBusinessDate; -- CAST(AuditDateTime AS DATE);

	INSERT INTO report.Tb_FormData_1409_AuditLog
	SELECT * 
	FROM #TempAudit;

	INSERT INTO #FinalAuditResult
	SELECT BusinessDate, AuditDateTime,AL.Updatedby AS UpdatedBy, A.[AccountNumber (textinput-5)] AS AccountNo, C.[CustomerName (textinput-3)] AS CustomerName, 
		OldValue AS OldDealerCode, NewValue AS NewDealerCode,
		'',
		'',
		'',
		'',
		'',
		''
		
	FROM CQBTempDB.export.Tb_FormData_1409 AS A
	INNER JOIN report.Tb_FormData_1409_AuditLog AL
		ON AL.RecordID = A.RecordID
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS C
		ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
	WHERE FieldName = 'selectsource-21' AND AL.BusinessDate = DATEADD(day, -1,CAST(GETDATE() AS DATE)); -- [DealerCode (selectsource-21)]
 
	UPDATE FAR SET
		OldDealerName = [Name (textinput-3)],
		OldMRCode =[MRCode (textinput-17)],
		OldMRName=[Name (textinput-1)]
	FROM #FinalAuditResult FAR
	LEFT JOIN CQBTempDB.export.tb_formdata_1377 DEA 
		ON DEA.[DealerCode (textinput-35)]=FAR.OldDealerCode
	LEFT JOIN  CQBTempDB.export.Tb_FormData_1575 MR 
		ON MR.[DealerCode (selectsource-1)]=FAR.OldDealerCode;

	UPDATE FA SET
		NewDealerName = [Name (textinput-3)],
		NewMRCode =[MRCode (textinput-17)],
		NewMRName=[Name (textinput-1)]
	FROM #FinalAuditResult FA
	LEFT JOIN CQBTempDB.export.tb_formdata_1377 DE 
		ON DE.[DealerCode (textinput-35)]=FA.NewDealerCode-- AND [MRCode (textinput-17)] = 
	LEFT JOIN  CQBTempDB.export.Tb_FormData_1575 MR 
		ON MR.[DealerCode (selectsource-1)]=FA.NewDealerCode;


	SELECT * FROM #FinalAuditResult;

END