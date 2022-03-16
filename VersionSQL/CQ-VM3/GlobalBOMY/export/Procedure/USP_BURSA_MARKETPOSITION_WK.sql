/****** Object:  Procedure [export].[USP_BURSA_MARKETPOSITION_WK]    Committed by VersionSQL https://www.versionsql.com ******/

--exec [export].[USP_BURSA_MARKETPOSITION_WK] '2020-12-29'

CREATE PROCEDURE [export].[USP_BURSA_MARKETPOSITION_WK]
	(
		@idteProcessDate DATE
    )
	
AS
BEGIN

	SET NOCOUNT ON;
	
	CREATE TABLE #BURSA_MARKETPOSITION_WK
	(
	  RecordType		VARCHAR(1),
	  POCode			VARCHAR(6),
	  PositionDate		DATE,
	  PositionCategory	VARCHAR(3),
	  TransactionType	VARCHAR(6),
	  Range1Value		NUMERIC(15,2),
	  Range2Value		NUMERIC(15,2),
	  Range3Value		NUMERIC(15,2),
	  Range4Value		NUMERIC(15,2),
	  MTMValue			NUMERIC(15,2),
	  AccountGroup		varchar(10) -- Just for internal use not for export
	);

	INSERT INTO #BURSA_MARKETPOSITION_WK
	(
	  RecordType,
	  POCode,
	  PositionDate,
	  PositionCategory,
	  TransactionType,
	  Range1Value,
	  Range2Value,
	  Range3Value,
	  Range4Value,
	  MTMValue,
	  AccountGroup
	)
	SELECT 
		1,
		'012',
		CONVERT(varchar,@idteProcessDate,103) as [DD/MM/YYYY],
		CASE
		WHEN [AccountGroup (selectsource-2)] NOT IN ('CD1','CD2','CD3','M','G') THEN 'CA1'
		WHEN [AccountGroup (selectsource-2)] IN ('CD1','CD2','CD3') THEN 'CA2'
		WHEN [AccountGroup (selectsource-2)] IN ('M','G','D') THEN 'MA'
		END,
		TCO.TransType,
		(TCRV.RPCustodianBalance + TCA.UnavailableBalance) AS Range1Value,
		CASE 
		WHEN ([GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TCO.ContractDate,8,NULL)) = (select DateValue from [GLOBALBO].[setup].[Tb_Date]) THEN (TCRV.RPCustodianBalance + TCA.UnavailableBalance)
		END AS Range2Value,
		CASE 
		WHEN ([GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TCO.ContractDate,12,NULL)) = (select DateValue from [GLOBALBO].[setup].[Tb_Date]) THEN (TCRV.RPCustodianBalance + TCA.UnavailableBalance) 
		END AS Range3Value ,
		CASE WHEN ([GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TCO.ContractDate,13,NULL)) = (select DateValue from [GLOBALBO].[setup].[Tb_Date]) THEN (TCRV.RPCustodianBalance + TCA.UnavailableBalance) 
		END AS Range3Value ,
		TCRV.ClosingPrice,
		Account.[AccountGroup (selectsource-2)]
	FROM GlobalBO.contracts.Tb_ContractOutstanding TCO
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		on TCO.AcctNo = Account.[AccountNumber (textinput-5)]
	LEFT JOIN GLOBALBORPT.[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] TCRV 
		ON TCO.AcctNo = TCRV.AcctNo
	LEFT JOIN [GLOBALBO].[holdings].[Tb_CustodyAssets] TCA 
		ON TCA.AcctNo = TCO.AcctNo
	WHERE CONTRACTDATE = @idteProcessDate

	UNION

	SELECT 
		1,
		'012',
		CONVERT(varchar,@idteProcessDate,103) as [DD/MM/YYYY],
		CASE
		WHEN [AccountGroup (selectsource-2)] NOT IN ('CD1','CD2','CD3','M','G') THEN 'CA1'
		WHEN [AccountGroup (selectsource-2)] IN ('CD1','CD2','CD3') THEN 'CA2'
		WHEN [AccountGroup (selectsource-2)] IN ('M','G','D') THEN 'MA'
		END,
		TCO.TransType,
		(TCRV.RPCustodianBalance + TCA.UnavailableBalance) AS Range1Value,
		CASE 
		WHEN ([GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TCO.TransDate,8,NULL)) = (select DateValue from [GLOBALBO].[setup].[Tb_Date]) THEN (TCRV.RPCustodianBalance + TCA.UnavailableBalance)
		END AS Range2Value,
		CASE 
		WHEN ([GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TCO.TransDate,12,NULL)) = (select DateValue from [GLOBALBO].[setup].[Tb_Date]) THEN (TCRV.RPCustodianBalance + TCA.UnavailableBalance) 
		END AS Range3Value ,
		CASE WHEN ([GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](TCO.TransDate,13,NULL)) = (select DateValue from [GLOBALBO].[setup].[Tb_Date]) THEN (TCRV.RPCustodianBalance + TCA.UnavailableBalance) 
		END AS Range3Value ,
		TCRV.ClosingPrice,
		Account.[AccountGroup (selectsource-2)]
	  FROM GlobalBO.transmanagement.Tb_Transactions TCO
	  LEFT JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		on TCO.AcctNo = Account.[AccountNumber (textinput-5)]
	  LEFT JOIN GLOBALBORPT.[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] TCRV 
		ON TCO.AcctNo = TCRV.AcctNo
	  LEFT JOIN [GLOBALBO].[holdings].[Tb_CustodyAssets] TCA 
		ON TCA.AcctNo = TCO.AcctNo
	  WHERE TRANSDATE = @idteProcessDate;

	UPDATE #BURSA_MARKETPOSITION_WK 
	SET TransactionType = 
		CASE
			WHEN PositionCategory IN ('CA1','CA2') AND TransactionType IN ('TRBUY') THEN 'OP'
			WHEN PositionCategory IN ('CA1','CA2') AND TransactionType IN('CHLS') THEN 'CL'
			WHEN PositionCategory IN ('CA1','CA2') AND TransactionType IN('TRSELL') THEN 'OS'
			WHEN PositionCategory IN ('CA1','CA2') AND TransactionType IN('CHGN') THEN 'CG'
			WHEN PositionCategory IN ('MA') AND TransactionType IN ('TRBUY') AND AccountGroup IN ('D') THEN 'OPCA'
			WHEN PositionCategory IN ('MA') AND TransactionType IN ('TRSELL') AND AccountGroup IN ('D') THEN 'OSCA'
			WHEN PositionCategory IN ('MA') AND TransactionType IN ('TRBUY') AND AccountGroup IN ('M','G') THEN 'OPMA'
			WHEN PositionCategory IN ('MA') AND TransactionType IN ('TRSELL') AND AccountGroup IN ('M','G') THEN 'OSMA'
			ELSE 'ONSS'
		END;

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #BURSA_MARKETPOSITION_WK);

	CREATE TABLE #BURSA_MARKETPOSITION_WKControl
	(
		RecordType  varchar(50),
		CurrentApplicateDate Varchar(50),
		TotalRecord int
	);
	INSERT INTO #BURSA_MARKETPOSITION_WKControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord
	)
	VALUES (0,@idteProcessDate,@Count);

	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + ',' + CONVERT(varchar,CurrentApplicateDate,120) +  ',' + CAST(TotalRecord AS VARCHAR)
	FROM #BURSA_MARKETPOSITION_WKControl

	UNION ALL	

	SELECT 
		CAST(RecordType AS VARCHAR) + ',' + POCode + ',' +  CONVERT(varchar,PositionDate,120) + ',' + PositionCategory + ',' +
	    TransactionType + ',' +  CAST(Range1Value AS VARCHAR) + ',' +  CAST(Range2Value AS VARCHAR) + ',' + CAST(Range3Value AS VARCHAR) + ',' +  CAST(Range4Value AS VARCHAR) + ',' +
		  CAST(MTMValue AS VARCHAR)
	FROM #BURSA_MARKETPOSITION_WK;

	DROP TABLE #BURSA_MARKETPOSITION_WKControl;
	DROP TABLE #BURSA_MARKETPOSITION_WK;
END