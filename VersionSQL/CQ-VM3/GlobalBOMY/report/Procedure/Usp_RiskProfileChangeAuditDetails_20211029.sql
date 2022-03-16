/****** Object:  Procedure [report].[Usp_RiskProfileChangeAuditDetails_20211029]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_RiskProfileChangeAuditDetails_20211029]
-- EXEC report.Usp_RiskProfileChangeAuditDetails  
AS
BEGIN

	DECLARE @dteBusinessDate DATE = (SELECT * FROM GlobalBO.global.Udf_GetPreviousBusinessDate(GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')));
	DECLARE @iintAuditCount INT = (SELECT COUNT(*) FROM report.Tb_FormData_1410_AuditLog WHERE BusinessDate=@dteBusinessDate);

	IF @iintAuditCount >0
	BEGIN
		DELETE FROM report.Tb_FormData_1410_AuditLog 
		WHERE BusinessDate=@dteBusinessDate;
	END
	CREATE TABLE #CustomerAudit
	(
		RecordID		VARCHAR(200),
		FieldName		VARCHAR(100),
		BusinessDate	DATE,
		AuditDateTime	VARCHAR(200),
		UpdatedBy		VARCHAR(50),
		CustomerID		VARCHAR(20),
		CustomerName	VARCHAR(100),
		--RiskProfileMode	VARCHAR(200),
		OldRiskProfile	VARCHAR(MAX),
		NewRiskProfile	VARCHAR(MAX),
		OldRiskMode		VARCHAR(200),
		NewRiskMode		VARCHAR(100),
		OldRiskscore	VARCHAR(100),
		NewRiskscore	VARCHAR(50)
	);
	CREATE TABLE #FinalTempAudit
	(
		RecordID		VARCHAR(200),
		FieldName		VARCHAR(100),
		BusinessDate	DATE,
		AuditDateTime	VARCHAR(200),
		UpdatedBy		VARCHAR(50),
		CustomerID		VARCHAR(20),
		CustomerName	VARCHAR(100),
		--RiskProfileMode	VARCHAR(200),
		OldRiskProfile	VARCHAR(200),
		NewRiskProfile	VARCHAR(200),
		OldRiskMode		VARCHAR(200),
		NewRiskMode		VARCHAR(100),
		OldRiskscore	VARCHAR(100),
		NewRiskscore	VARCHAR(50)
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
	EXEC CQBTempDB.[log].[USP_CQBAuditLogDataRetrieval_Daily] '1410',@dteBusinessDate, 'N,U,D';
	
	UPDATE #TempAudit set BusinessDate=@dteBusinessDate; -- CAST(AuditDateTime AS DATE);
	
	INSERT INTO report.Tb_FormData_1410_AuditLog
	SELECT * FROM #TempAudit;
	
	--LWC, MWC, HWC
	INSERT INTO #CustomerAudit
	SELECT C.RecordID,FieldName,BusinessDate, AuditDateTime,AL.Updatedby AS UpdatedBy, C.[CustomerID (textinput-1)] AS CustomerID, C.[CustomerName (textinput-3)] AS CustomerName, 
		 OldValue AS OldRiskProfile, NewValue AS NewRiskProfile,
		'','','',''
	FROM CQBTempDB.export.Tb_FormData_1410 as C
	INNER JOIN report.Tb_FormData_1410_AuditLog AL 
		ON C.RecordID = AL.RecordID
	WHERE  AL.BusinessDate=DATEADD(day, -1,CAST(GETDATE() AS DATE));
	 --([RiskProfiling (selectbasic-42)] OR [RiskProfiling (textinput-156)] OR [RiskProfilingScore (textinput-155)],[RiskProfilingMode (multipleradiosinline-37)]); USE GlobalBOMY
	 --(FieldName='selectbasic-42' OR FieldName='textinput-156') AND // --[RiskProfilingMode (multipleradiosinline-37)] AS RiskProfileMode,

	 INSERT INTO #FinalTempAudit
	 SELECT 
		CA.RecordID,
		CA.FieldName,		
		CA.BusinessDate,	
		CA.AuditDateTime,	
		CA.UpdatedBy,		
		CA.CustomerID,		
		CA.CustomerName,	
		--CA.RiskProfileMode,	
		CA.OldRiskProfile,	
		CA.NewRiskProfile,	
		CA.OldRiskMode,		
		CA.NewRiskMode,		
		CA.OldRiskscore,
		CA.NewRiskscore	
	 FROM #CustomerAudit CA
	 WHERE FieldName='selectbasic-42' OR FieldName='textinput-156';
	
	--select * from #FinalTempAudit


	UPDATE FR SET
		FR.OldRiskscore=CAT.OldRiskProfile,
		FR.NewRiskscore=CAT.NewRiskProfile	
	FROM #FinalTempAudit FR
	LEFT JOIN #CustomerAudit CAT 
		ON CAT.RecordID = FR.RecordID
	WHERE CAT.FieldName='textinput-155' 
	
	UPDATE FR SET
		FR.OldRiskMode=CAT.OldRiskProfile,		
		FR.NewRiskMode=CAT.NewRiskProfile
	FROM #FinalTempAudit FR
	LEFT JOIN #CustomerAudit CAT 
		ON CAT.RecordID = FR.RecordID
	WHERE CAT.FieldName='multipleradiosinline-37'

	SELECT 
	
		BusinessDate,	
		AuditDateTime,	
		UpdatedBy,		
		CustomerID,		
		CustomerName,	
		OldRiskProfile,	
		NewRiskProfile,	
		OldRiskMode,		
		NewRiskMode,		
		OldRiskscore,	
		NewRiskscore	
	FROM #FinalTempAudit;
END

 --EXEC report.Usp_RiskProfileChangeAuditDetails  
--select * from report.Tb_FormData_1410_AuditLog where CustomerID='0223496'
--update report.Tb_FormData_1410_AuditLog set OldRiskMode='M',NewRiskMode='A',OldRiskscore='10', NewRiskScore='12' where CustomerID='0223496'