/****** Object:  Procedure [export].[USP_BURSA_BUYINGIN_AHOC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BURSA_BUYINGIN_AHOC] 
(
	@idteProcessDate DATE
)
AS
BEGIN
	-- EXEC [export].[USP_BURSA_BUYINGIN_AHOC] '2020-06-01'
	SET NOCOUNT ON;

	CREATE TABLE #BURSA_BUYINGIN_AHOC
	(
		RecordType      Int,
		POCode			VARCHAR(6),
		PositionDate	DATE,
		ContractDate	DATE,
		Buying_InDate   DATE,
		Buying_InType   VARCHAR(1),
		StockCode		VARCHAR(12),
		ClientCode		VARCHAR(12),
		ClientName		VARCHAR(60),
		ClientAddress	VARCHAR(100),
		CDSAccount		VARCHAR(12),
		DealerCode		VARCHAR(8),
		DealerName		VARCHAR(60),
		FailedVolume	NUMERIC(15,2),
		ContractPrice	VARCHAR(300),
		Reason			VARCHAR(300)
	);

	INSERT INTO #BURSA_BUYINGIN_AHOC
	(
		RecordType,
		POCode,
		PositionDate,
		ContractDate,
		Buying_InDate,
		Buying_InType,
		StockCode,
		ClientCode,
		ClientName,
		ClientAddress,
		CDSAccount,
		DealerCode,
		DealerName,
		FailedVolume,
		ContractPrice,
		Reason
	)

	--SELECT QUERY FOR CONTRACTOUTSTANDING VALUES
	SELECT 
		1,
		'012',
		CONVERT(varchar,@idteProcessDate,103) as [DD/MM/YYYY],
		CONVERT(VARCHAR,TCOS.ContractDate) as [DD/MM/YYYY],
		CONVERT(VARCHAR,TCOS.ContractDate) as [DD/MM/YYYY],
		'',
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		Customer.[CustomerID (textinput-1)],
		Customer.[CustomerName (textinput-3)],
		Customer.[Address1 (textinput-35)],
		Account.[CDSNo (textinput-19)],
		Dealer.[DealerCode (textinput-35)],
		Dealer.[Name (textinput-3)],
		TradedQty,
		TradedPrice,
		''
	FROM GlobalBO.contracts.Tb_ContractOutStanding TCOS
	INNER JOIN GlobalBO.setup.tb_instrument IT 
		ON TCOS.InstrumentId = IT.InstrumentId
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON TCOS.AcctNo = Account.[AccountNumber (textinput-5)]
	LEFT JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Account.[DealerCode (selectsource-21)] = Dealer.[DealerCode (textinput-35)]
	LEFT JOIN CQBTEMPDB.EXPORT.TB_FORMDATA_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE Facility IN ('B','S')

	UNION

			--SELECT QUERY FOR SETTLED TRANSACTIONS
	SELECT 
		1,
		'012',
		CONVERT(varchar,@idteProcessDate,103) as [DD/MM/YYYY],
		CONVERT(VARCHAR,TTS.ContractDate) as [DD/MM/YYYY],
		CONVERT(VARCHAR,TTS.ContractDate) as [DD/MM/YYYY],
		'',
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		Customer.[CustomerID (textinput-1)],
		Customer.[CustomerName (textinput-3)],
		Customer.[Address1 (textinput-35)],
		Account.[CDSNo (textinput-19)],
		Dealer.[DealerCode (textinput-35)],
		Dealer.[Name (textinput-3)],
		TradedQty,
		TradedPrice,
		''
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled TTS
	INNER JOIN GlobalBO.setup.tb_instrument IT 
		ON TTS.InstrumentId = IT.InstrumentId
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON TTS.AcctNo = Account.[AccountNumber (textinput-5)]
	LEFT JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Account.[DealerCode (selectsource-21)] = Dealer.[DealerCode (textinput-35)]
	LEFT JOIN CQBTEMPDB.EXPORT.TB_FORMDATA_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE Facility IN ('B','S');


	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #BURSA_BUYINGIN_AHOC);

	CREATE TABLE #BURSA_BUYINGIN_AHOCControl
	(
		RecordType  varchar(50),
		CurrentApplicateDate Varchar(50),
		TotalRecord int
	);
	INSERT INTO #BURSA_BUYINGIN_AHOCControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord
	)
	VALUES (0,@idteProcessDate,@Count);

	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' + CONVERT(varchar,CurrentApplicateDate,120) +  '|' + CAST(TotalRecord AS VARCHAR)
	FROM #BURSA_BUYINGIN_AHOCControl

	UNION ALL
	
	SELECT 
		CAST(RecordType AS VARCHAR) + '|' + POCode + '|' +  CONVERT(varchar,PositionDate,120) + '|' + CONVERT(varchar,ContractDate,120) + '|' + CONVERT(varchar,Buying_InDate,120) + '|' +  Buying_InType + '|' +  StockCode
		+ '|' + ClientCode + '|' +  ClientName + '|' +  ClientAddress+ '|' + CAST(CDSAccount AS VARCHAR) + '|' +  DealerCode + '|' +  DealerName
		+ '|' + CAST(FailedVolume AS VARCHAR)  + '|' +  ContractPrice + '|' +  Reason
	FROM #BURSA_BUYINGIN_AHOC;

	DROP TABLE #BURSA_BUYINGIN_AHOCControl;
	DROP TABLE #BURSA_BUYINGIN_AHOC;
END