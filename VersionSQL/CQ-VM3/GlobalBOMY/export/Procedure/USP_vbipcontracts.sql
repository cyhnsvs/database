/****** Object:  Procedure [export].[USP_vbipcontracts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_vbipcontracts]
	(
		@idteProcessDate DATE
    )
	
AS
BEGIN

    -- EXEC [export].[USP_vbipcontracts] '2020-06-01'

	SET NOCOUNT ON;
	CREATE TABLE #vbipcontracts
	(
		RecordType			VARCHAR(1),
		BrokerCode			VARCHAR(3),
		ContractIdentifier	VARCHAR(15),
		ContractDate		DATE,
		CDSAccount			VARCHAR(9),
		Direction			VARCHAR(1),
		CounterCode			VARCHAR(6),
		Quantity			VARCHAR(9),
		AverageMatchedPrice DECIMAL(9,6),
		GrossContractValue	DECIMAL(9,6),
		Amendment			VARCHAR(1)

	)
    -- Insert statements for procedure here

	INSERT INTO #vbipcontracts
	(
		RecordType,
		BrokerCode,
		ContractIdentifier,
		ContractDate,
		CDSAccount,
		Direction,
		CounterCode,
		Quantity,
		AverageMatchedPrice,
		GrossContractValue,
		Amendment
	)

	SELECT 
		1,
		'012',
		CTC.ContractNo,
		CTC.ContractDate,
		Account.[CDSNo (textinput-19)],
		CASE 
			WHEN CTC.TransType = 'TRSELL' THEN 'S'
			WHEN CTC.TransType = 'TRBUY' THEN 'B'
		END,
		SUBSTRING(IT.InstrumentCd,0,CHARINDEX('.',IT.InstrumentCd)),
		CTC.TradedQty,
		CTC.TradedPrice,
		CTC.GrossAmountTrade,
		'N'
	FROM GlobalBO.contracts.Tb_ContractOutStanding CTC
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON CTC.AcctNo = Account.[CustomerID (selectsource-1)]
	LEFT JOIN GlobalBO.setup.tb_instrument IT 
		ON CTC.InstrumentId = IT.InstrumentId	

	UNION

	SELECT 
		1,
		'012',
		TTS.ContractNo,
		TTS.ContractDate,
		Account.[CDSNo (textinput-19)],
		CASE 
			WHEN TTS.TransType = 'TRSELL' THEN 'S'
			WHEN TTS.TransType = 'TRBUY' THEN 'B'
		 END,
		SUBSTRING(IT.InstrumentCd,0,CHARINDEX('.',IT.InstrumentCd)),
		TTS.TradedQty,
		TTS.TradedPrice,
		TTS.GrossAmountTrade,
		'N'
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled TTS
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON TTS.AcctNo = Account.[CustomerID (selectsource-1)]
	LEFT JOIN GlobalBO.setup.tb_instrument IT 
		ON TTS.InstrumentId = IT.InstrumentId	



	-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #vbipcontracts)

	DECLARE @TotalContractQuantity DECIMAL(15,2)
	SET @TotalContractQuantity = (SELECT SUM(Quantity) FROM #vbipcontracts)

	DECLARE @TotalContractValue DECIMAL(15,2)
	SET @TotalContractValue = (SELECT SUM(GrossContractValue) FROM #vbipcontracts)

	CREATE TABLE #vbipcontractsControl
	(
		RecordType  VARCHAR(1),
		NumberOfContracts VARCHAR(12),
		SumContractQuantity VARCHAR(12),
		SumContractValue DECIMAL(12,6),
		ProcessingDate DATE
	)
	INSERT INTO #vbipcontractsControl
	(
		RecordType,
		NumberOfContracts,
		SumContractQuantity,
		SumContractValue,
		ProcessingDate
	)
	VALUES (0,@Count,CAST(@TotalContractQuantity AS VARCHAR),CAST(@TotalContractValue AS VARCHAR),CONVERT(VARCHAR,@idteProcessDate,112))

	-- TRANSACTION RECORD - RESULT SET
	
	SELECT 
		RecordType + '' + BrokerCode + '' +  ContractIdentifier + '' +  CONVERT(VARCHAR,ContractDate,112) + '' +  CDSAccount + '' +  CDSAccount + '' +  
		Direction + '' +  CounterCode + '' + Quantity + '' + CAST(AverageMatchedPrice AS VARCHAR(9)) + '' + CAST(GrossContractValue AS VARCHAR(9)) + '' + Amendment
	FROM 
		#vbipcontracts	
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '' + NumberOfContracts +  '' + SumContractQuantity + '' + SumContractValue + '' + ProcessingDate
	FROM
		#vbipcontractsControl

	DROP TABLE #vbipcontracts
	DROP TABLE #vbipcontractsControl

END