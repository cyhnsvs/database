/****** Object:  Procedure [export].[USP_BURSA_SBLPFT_AHOC]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [export].[USP_BURSA_SBLPFT_AHOC]
	-- Add the parameters for the stored procedure here
	(
		@idteProcessDate DATE
    )
AS
-- SBLFailedTrades
-- EXEC [export].[USP_BURSA_SBLPFT_AHOC] '2020-06-01'
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-4)]) 
	FROM CQBTempDB.export.Tb_FormData_3176
	WHERE CAST([ReportDate (dateinput-4)] as date) <= @idteProcessDate;

	IF OBJECT_ID(N'tempdb..#BURSA_SBLPFT_AHOC') IS NOT NULL
	BEGIN
		DROP TABLE #BURSA_SBLPFT_AHOC;
	END

	IF OBJECT_ID(N'tempdb..#BURSA_SBLPFT_AHOCControl') IS NOT NULL
	BEGIN
		DROP TABLE #BURSA_SBLPFT_AHOCControl;
	END

    -- Insert statements for procedure here

	CREATE TABLE #BURSA_SBLPFT_AHOC
	(
		RecordType		VARCHAR(1),
		POCode			VARCHAR(6),
		PositionDate	DATE,
		SBLDate			DATE,
		ContractDate	DATE,
		StockCode		VARCHAR(12),
		ContractVolume  NUMERIC(15),
		ContractPrice   VARCHAR(300),
		ClientCode		VARCHAR(12),
		ClientName		VARCHAR(60),
		CDSAccount		VARCHAR(12),
		DealerCode		VARCHAR(8),
		DealerName		VARCHAR(60),
		Remarks			VARCHAR(300)
	);

	INSERT INTO #BURSA_SBLPFT_AHOC
	(
		RecordType,
		POCode,			
		PositionDate,
		SBLDate,			
		ContractDate,		
		StockCode,			
		ContractVolume,		
		ContractPrice,		
		ClientCode,			
		ClientName,			
		CDSAccount,			
		DealerCode,			
		DealerName,			
		Remarks				
	)
	SELECT 
		 1
		,[POCode (textinput-1)]
		,CONVERT(VARCHAR,@idteProcessDate,103)
		,CONVERT(VARCHAR,[SBLDate (dateinput-2)],103)
		,CONVERT(VARCHAR,[ContractDate (dateinput-3)],103)
		,[StockCode (textinput-2)]
		,[ContractVolume (textinput-3)]
		,[ContractPrice (textinput-4)]
		,[ClientCode (textinput-5)]
		,[ClientName (textinput-6)]
		,[CDSAccount (textinput-7)]
		,[DealerCode (textinput-8)]
		,[DealerName (textinput-9)]
		,[Remarks (textinput-10)]	
	FROM CQBTempDB.export.tb_formdata_3176
	WHERE [ReportDate (dateinput-4)] = @ReportDate;


	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #BURSA_SBLPFT_AHOC);

	CREATE TABLE #BURSA_SBLPFT_AHOCControl
	(
		RecordType  varchar(50),
		CurrentApplicateDate Varchar(50),
		TotalRecord int
	);

	INSERT INTO #BURSA_SBLPFT_AHOCControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord
	)
	VALUES (0,CONVERT(varchar,@idteProcessDate,103),@Count);

	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + ',' + CONVERT(varchar,CurrentApplicateDate,120) +  ',' + CAST(TotalRecord AS VARCHAR)
	FROM #BURSA_SBLPFT_AHOCControl

	UNION ALL	
	SELECT 
		CAST(RecordType AS VARCHAR) + ',' + POCode + ',' +  CONVERT(varchar,PositionDate,120) + ',' + CONVERT(varchar,SBLDate,120) + ',' + CONVERT(varchar,ContractDate,120) + ',' +  StockCode + ',' + CAST(ContractVolume AS VARCHAR)
		+ ',' + ContractPrice + ',' +  ClientCode + ',' +  ClientName+ ',' + CDSAccount + ',' +  DealerCode + ',' +  DealerName
		+ ',' + Remarks
	FROM #BURSA_SBLPFT_AHOC;
	
	DROP TABLE #BURSA_SBLPFT_AHOC;
	DROP TABLE #BURSA_SBLPFT_AHOCControl;

END