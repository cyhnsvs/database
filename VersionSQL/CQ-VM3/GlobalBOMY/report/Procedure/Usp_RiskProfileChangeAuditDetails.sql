/****** Object:  Procedure [report].[Usp_RiskProfileChangeAuditDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [report].[Usp_RiskProfileChangeAuditDetails]
-- EXEC report.Usp_RiskProfileChangeAuditDetails  
AS
BEGIN

	DECLARE @dteBusinessDate DATE = GETDATE() --GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');
	DECLARE @iintAuditCount INT = (SELECT COUNT(1) FROM report.Tb_FormData_1410_AuditLog WHERE BusinessDate=@dteBusinessDate);

	IF @iintAuditCount > 0
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
		CurrentRiskMode VARCHAR(100),
		CurrentRiskProfile VARCHAR(100),
		CurrentRiskScore VARCHAR(100),
		OldValue		VARCHAR(MAX),
		NewValue		VARCHAR(MAX),
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
	EXEC CQBTempDB.[log].[USP_CQBAuditLogDataRetrieval_Daily] '1410', @dteBusinessDate, 'N,U,D';
	
	UPDATE #TempAudit set BusinessDate=@dteBusinessDate; -- CAST(AuditDateTime AS DATE);
	
	INSERT INTO report.Tb_FormData_1410_AuditLog
	SELECT * FROM #TempAudit;
	
	--SELECT * FROM report.Tb_FormData_1410_AuditLog;

	--LWC, MWC, HWC
	INSERT INTO #CustomerAudit
	SELECT C.RecordID, AL.FieldName, AL.BusinessDate, AL.AuditDateTime, AL.Updatedby AS UpdatedBy, 
			C.[CustomerID (textinput-1)] AS CustomerID, C.[CustomerName (textinput-3)] AS CustomerName, 
			C.[RiskProfilingMode (multipleradiosinline-37)] AS CurrentRiskMode, 
			CASE WHEN C.[RiskProfilingMode (multipleradiosinline-37)] = 'A' THEN C.[RiskProfiling (textinput-156)] ELSE C.[RiskProfiling (selectbasic-42)] END AS CurrentRiskProfile,
			C.[RiskProfilingScore (textinput-155)] AS CurrentRiskScore,
		 OldValue, NewValue
	FROM CQBTempDB.export.Tb_FormData_1410 as C
	INNER JOIN report.Tb_FormData_1410_AuditLog AL 
		ON C.RecordID = AL.RecordID
	WHERE  AL.BusinessDate= '2021-10-29' and
	 (FieldName='selectbasic-42' OR FieldName='textinput-156' OR FieldName='textinput-155' OR FieldName='multipleradiosinline-37');

	 INSERT INTO #FinalTempAudit
	 SELECT DISTINCT 
		CA.RecordID,
		CA.FieldName,		
		CA.BusinessDate,	
		CA.AuditDateTime,	
		CA.UpdatedBy,		
		CA.CustomerID,		
		CA.CustomerName,	
		CA.CurrentRiskProfile AS OldRiskProfile,	
		CA.CurrentRiskProfile AS NewRiskProfile,	
		CA.CurrentRiskMode AS OldRiskMode,		
		CA.CurrentRiskMode AS NewRiskMode,		
		CA.CurrentRiskScore AS OldRiskscore,
		CA.CurrentRiskScore AS NewRiskscore
	 FROM #CustomerAudit CA
	 WHERE (FieldName='selectbasic-42' OR FieldName='textinput-156' OR FieldName='textinput-155' OR FieldName='multipleradiosinline-37')
	
	-- [RiskProfiling (selectbasic-42)], MANUAL SELECTION WHEN [RiskProfilingMode (multipleradiosinline-37)] = M
	-- [RiskProfiling (textinput-156)], AUTO COMPUTED WHEN [RiskProfilingMode (multipleradiosinline-37)] = A
	-- [RiskProfilingScore (textinput-155)], COMPUTED FOR BOTH MODES
	
	UPDATE FR SET
		FR.OldRiskMode= ISNULL(CAT.OldValue,FR.OldRiskMode),
		FR.NewRiskMode=CAT.NewValue
	FROM #FinalTempAudit FR
	INNER JOIN #CustomerAudit CAT
		ON CAT.RecordID = FR.RecordID
	WHERE CAT.FieldName='multipleradiosinline-37';

	UPDATE FR SET
		FR.OldRiskscore=ISNULL(CAT.OldValue,FR.OldRiskscore),
		FR.NewRiskscore=CAT.NewValue
	FROM #FinalTempAudit FR
	INNER JOIN #CustomerAudit CAT 
		ON CAT.RecordID = FR.RecordID
	WHERE CAT.FieldName='textinput-155';

	UPDATE FR SET
		FR.OldRiskProfile=ISNULL(CAT.OldValue,FR.OldRiskProfile),
		FR.NewRiskProfile=CAT.NewValue	
	FROM #FinalTempAudit FR
	INNER JOIN #CustomerAudit CAT 
		ON CAT.RecordID = FR.RecordID
	WHERE CAT.FieldName='selectbasic-42' AND FR.NewRiskMode='M';

	UPDATE FR SET
		FR.OldRiskProfile=ISNULL(CAT.OldValue,FR.OldRiskProfile),
		FR.NewRiskProfile=CAT.NewValue	
	FROM #FinalTempAudit FR
	INNER JOIN #CustomerAudit CAT 
		ON CAT.RecordID = FR.RecordID
	WHERE CAT.FieldName='textinput-156' AND FR.NewRiskMode='A';

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
	FROM #FinalTempAudit
	ORDER BY BusinessDate DESC, AuditDateTime DESC, CustomerID;

END

 --EXEC report.Usp_RiskProfileChangeAuditDetails  
--select * from report.Tb_FormData_1410_AuditLog where CustomerID='0223496'
--update report.Tb_FormData_1410_AuditLog set OldRiskMode='M',NewRiskMode='A',OldRiskscore='10', NewRiskScore='12' where CustomerID='0223496'