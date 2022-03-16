/****** Object:  Procedure [import].[SSIS_PSPL_OSCONTRACTKSP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[SSIS_PSPL_OSCONTRACTKSP] AS 

BEGIN


DECLARE @dteBusinessDate Date;

SET @dteBusinessDate = (SELECT DateValue FROM GlobalBO.setup.Tb_Date WHERE CompanyId = 1);

--set @dteBusinessDate = '2020-12-17'

--DELETE FROM [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction] WHERE CreatedBy LIKE '%OSContract%';
	
--;WITH OS AS
--(
	SELECT 
			CAST('20'+left([CON DATE],2) + right([CON DATE],4) AS DATE) AS [CON DATE],
			CAST('20'+left([CON DATE],2) + right([DUE DATE],4) AS DATE) [DUE DATE],		
			[CURR CODE], 
			[SETTLE CURR CODE], 
			ROUND(
			(CAST([BROK AMT] AS DECIMAL(30,2))/100 
			+CAST([CLR FEE] AS DECIMAL(30,2))/100
			+CAST([AFM FEE] AS DECIMAL(30,2))/100 
			+CAST(FFP AS DECIMAL(30,2))/100)
			/(CAST([SETTLE EXCH RATE] AS DECIMAL(30,6))/1000000)
			,2) AS OSContract_B2B
			,OS_Min.SourceFileName    
			,OS_MIN.[CONTRACT NO]
	INTO #OScONTRACTACTS
	FROM 
		--GlobalBOTH_Kasikorn.import.PSPL_OSCONTRACTKSP_Archive OS_ARCHIVE
		GlobalBOMY.import.PSPL_OSCONTRACTKSP AS OS_ARCHIVE
		INNER JOIN
		(
			SELECT	[CONTRACT NO], MIN(SourceFileName) SourceFileName 
			--FROM	GlobalBOTH_Kasikorn.import.PSPL_OSCONTRACTKSP_Archive 
			FROM	GlobalBOMY.import.PSPL_OSCONTRACTKSP 
			GROUP BY [CONTRACT NO]
		) OS_MIN 
			ON (OS_ARCHIVE.[CONTRACT NO] = OS_MIN.[CONTRACT NO])
			AND (OS_ARCHIVE.SourceFileName = OS_MIN.SourceFileName)
	WHERE
		[CLIENT NO] = '0632076'  and LEN([CON DATE]) >5  
--)
	UPDATE #OScONTRACTACTS
	SET OSContract_B2B = ROUND(OSContract_B2B,0)
	WHERE [SETTLE CURR CODE] = 'JPY'

	declare @strContractNo VARCHAR(3000);
	declare @tblContractNo as table 
	(ContarctNo varchar(30))

	SELECT @strContractNo = 
		SUBSTRING(
		(SELECT ';' + G.Tag1 
		  FROM	GlobalBOLocal.import.Tb_NonTradeTransactionInstructionArchive AS G 
		  WHERE G.ReferenceNo LIKE '%COMMISSION%' AND G.Tag1 IS NOT NULL AND G.ArchiveDate > DATEADD(DAY,-15,@dteBusinessDate)
			FOR XML PATH('')), 3, 3000
			)  

	IF @strContractNo IS NOT NULL
	BEGIN
		INSERT INTO @tblContractNo
		SELECT CAST([Data] AS BIGINT) FROM GlobalBO.[global].Udf_Split(@strContractNo,',');
		
		DELETE FROM #OScONTRACTACTS WHERE [CONTRACT NO] IN (
			SELECT Tag2 FROM GlobalBO.contracts.Tb_Contract WHERE ContractNo IN (
				SELECT ContractNo FROM @tblContractNo
			)
		)

	END



	INSERT INTO [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]( 
			[CompanyId],
			[ExtTransactionId], -- ## UNIQUE KEY e.g. 2013-A0015388  ,2013-CN0202878 
			[NonTradeTransInstructionType],
			[TransNo],
			[BatchId],
			[PickInd],
			[AcctNo],
			[FundSourceCd],
			[CustodianAcctNo],
			[TransDate],
			[SetlDate],
			[TransType],
			[TransDesc],
			ReferenceNo ,
			[InstrumentCd],
			[CurrCd],
			[Amount],		
			[CreatedBy],
			CreatedDate,
			Tag1)

		SELECT 
			1 AS  [CompanyId],
			'DUMMY-Os-' + CAST(ROW_NUMBER() OVER(ORDER BY SourceFileName, TradedCurrCd ASC) as varchar(20)) AS [ExtTransactionId], 
			1 AS [NonTradeTransInstructionType],
			'' AS [TransNo],
			0 AS [BatchId],
			'N' AS [PickInd],
			'DUMMY' AS [AcctNo],
			'PSPL' AS [FundSourceCd],
			NULL AS [CustodianAcctNo],
			TradeDate AS [TransDate],
			[DUE DATE] AS [SetlDate],
			'CHDP' as [TransType],
			'OSContract Refund' AS [TransDesc],
			'COMMISSION' AS ReferenceNo,
			NULL AS [InstrumentCd],
			TradedCurrCd AS [CurrCd],
			ROUND(SYS_B2B - (OSContract_B2B*A.TradeSetlExchRate),2) AS [Amount],			
			SourceFileName AS [CreatedBy],
			GETDATE() AS CreatedDate,
			TAG1

		 --SELECT 
			--'DUMMY' As AcctNo,
			--TradeDate  , 
			--ROUND(SYS_B2B - OSContract_B2B,2) AS DIFF, 
			--OSContract_B2B,SYS_B2B,
			--TradedCurrCd , 
			--[DUE DATE] ,
			--SourceFileName
		 FROM 
 
		 (
			 SELECT 		
				CAST(a.TradeDate AS DATE) TradeDate, 
				CAST(a.SetlDate AS DATE) SetlDate,		
				a.TradedCurrCd,
				SUM(ABS(a.BrokerageExpenseSetl)) AS SYS_B2B,
				a.SetlCurrCd	,A.TradeSetlExchRate	,
				SUBSTRING(
					(SELECT ';' + CAST(C.ContractNo AS VARCHAR(20))
					 FROM GlobalBO.contracts.Tb_Contract AS  C 
					 WHERE 
						C.FundSourceId = 2 AND 
						C.CPartyInd ='N' AND 
						C.BusinessDate = @dteBusinessDate AND NOT EXISTS
						( SELECT 1 FROM GlobalBO.contracts.Tb_ContractOutstandingAuditLog AS E where C.contractno = E.contractno and E.LogEvent ='D')
					  FOR XML PATH('')), 3, 200
					 ) AS TAG1

			FROM GlobalBO.contracts.Tb_Contract  AS A 
			INNER JOIN GlobalBO.setup.Tb_Instrument AS B
				ON a.InstrumentId = b.InstrumentId AND a.CompanyId = b.CompanyId 
			WHERE 
				FundSourceId = 2 AND CPartyInd ='N' AND NOT EXISTS
				( SELECT 1 FROM GlobalBO.contracts.Tb_ContractOutstandingAuditLog AS C where a.contractno = c.contractno and c.LogEvent ='D') AND
				A.BusinessDate = @dteBusinessDate  AND A.ContractNo NOT IN  (SELECT ContractNo FROM @tblContractNo )
			GROUP BY 
				A.TradeDate,A.TradedCurrCd,A.SetlCurrCd,A.SetlDate,A.TradeSetlExchRate	
		) AS A  INNER JOIN 

			--(SELECT 
			--	CAST('2020' + right([CON DATE],4) AS DATE) AS [CON DATE],
			--	CAST('2020' + right([DUE DATE],4) AS DATE) [DUE DATE],		
			--	[CURR CODE], 
			--	SUM((CAST([BROK AMT] AS DECIMAL(30,2))/100 +CAST([CLR FEE] AS DECIMAL(30,2))/100
			--	+CAST([AFM FEE] AS DECIMAL(30,2))/100 +CAST(FFP AS DECIMAL(30,2))/100)/(CAST([SETTLE EXCH RATE] AS DECIMAL(30,6))/1000000)) AS OSContract_B2B
			--	--,[SEC CODE],
			--	--CASE WHEN RT ='BUY' THEN 'TRBUY' ELSE 'TRSELL' END  AS TRANSTYPE,
			--	,SourceFileName -- ,  
			--	--cast(QUANTITY as bigint) as QUANTITY,
			--	--CAST('2020' + right([CON DATE],4) AS DATE) as ContractDate, 
			--	--[SETTLE CURR CODE],
			--	--[EXCH CODE],
			--	--[SEC NAME]
			--FROM 
			--	GlobalBOTH_Kasikorn.import.PSPL_OSCONTRACTKSP_Archive
			--WHERE
			--	[CLIENT NO] = '0632076' ) 
		(
		SELECT	[CON DATE],[CURR CODE],[DUE DATE],sum(OSContract_B2B) as OSContract_B2B ,SourceFileName,[SETTLE CURR CODE]  FROM	#OScONTRACTACTS --OS		
		group by [CON DATE],[CURR CODE],[DUE DATE],SourceFileName,[SETTLE CURR CODE] ) 
			AS B 
		on a.TradeDate = b.[CON DATE]  AND A.TradedCurrCd = B.[CURR CODE] AND A.SetlCurrCd = B.[SETTLE CURR CODE]
		WHERE ROUND(SYS_B2B - (OSContract_B2B*A.TradeSetlExchRate),2) > 0

		

-- for CD & CW 

INSERT INTO [GlobalBOLocal].[import].[Tb_NonTradeTransactionInstruction]( 
			[CompanyId],
			[ExtTransactionId], -- ## UNIQUE KEY e.g. 2013-A0015388  ,2013-CN0202878 
			[NonTradeTransInstructionType],
			[TransNo],
			[BatchId],
			[PickInd],
			[AcctNo],
			[FundSourceCd],
			[CustodianAcctNo],
			[TransDate],
			[SetlDate],
			[TransType],
			[TransDesc],
			ReferenceNo ,
			[InstrumentCd],
			[CurrCd],
			[Amount],		
			[CreatedBy],
			CreatedDate)

		SELECT 
			1 AS  [CompanyId],
			AcctNo + TransType +  CAST(ROW_NUMBER() OVER(ORDER BY  SetlCurrCd ASC) as varchar(20)) AS [ExtTransactionId], 
			1 AS [NonTradeTransInstructionType],
			'' AS [TransNo],
			0 AS [BatchId],
			'N' AS [PickInd],
			AcctNo AS [AcctNo],
			'PSPL' AS [FundSourceCd],
			NULL AS [CustodianAcctNo],
			TransDate AS [TransDate],
			SetlDate AS [SetlDate],
			[TransType],
			TransDesc AS [TransDesc],
			'COMMISSION' AS ReferenceNo,
			NULL AS [InstrumentCd],
			SetlCurrCd AS [CurrCd],
			Amount,			
			'PSPL-OSContracts' AS [CreatedBy],
			GETDATE() AS CreatedDate

	FROM 
	(
	SELECT 
		'DUMMY' As AcctNo,
		cast(A.TradeDate as date) as TransDate ,
		 A.SetlDate , 
		 A.SetlCurrCd , 
		 'CHDP' as TransType , 
		 --sum(abs(ROUND(A.ClientBrokerageSetl,2)+ROUND(A.ExchFeeSetlTax,2))) as Amount , 
		 ROUND(sum(abs((A.ClientBrokerageTrade+A.ExchFeeTrade+A.ExchFeeTradeTax)*TradeSetlExchRate)),2)  as Amount , 
		 'Commission Received'  as TransDesc,
		 'PSPL' AS FundSource
	FROM 
		GlobalBO.contracts.Tb_Contract  AS A 
	WHERE 
		FundSourceId = 2 AND CPartyInd ='N' AND
		A.BusinessDate = @dteBusinessDate AND NOT EXISTS
		( SELECT 1 FROM GlobalBO.contracts.Tb_ContractOutstandingAuditLog AS C where a.contractno = c.contractno and c.LogEvent ='D') AND
		A.ContractNo NOT IN (SELECT ContractNo FROM @tblContractNo )

	GROUP BY 
			A.TradeDate , A.SetlDate,A.SetlCurrCd
	HAVING  sum(abs(A.ClientBrokerageSetl )) <> 0

	UNION ALL

	SELECT 
		'DUMMY' As AcctNo,
		 cast(A.TradeDate as date) as TransDate ,
		 A.SetlDate , 
		 A.SetlCurrCd , 
		 'CHWD' as TransType , 
		 --sum(abs(ROUND(A.BrokerageExpenseSetl,2) )) as Amount , 
		 ROUND(SUM(ABS((BrokerageExpenseTrade+ExchFeeTrade)*TradeSetlExchRate)),2)  as Amount , 
		 'B2B Commission'  as TransDesc,
		 'PSPL' AS FundSource
	FROM 
		GlobalBO.contracts.Tb_Contract  AS A 
	WHERE 
		FundSourceId = 2 AND CPartyInd ='N' AND
		A.BusinessDate = @dteBusinessDate AND NOT EXISTS
		( SELECT 1 FROM GlobalBO.contracts.Tb_ContractOutstandingAuditLog AS C where a.contractno = c.contractno and c.LogEvent ='D')  AND
		A.ContractNo NOT IN (SELECT ContractNo FROM @tblContractNo )
	GROUP BY 
			A.TradeDate , A.SetlDate,A.SetlCurrCd
	HAVING 
		 sum(abs(A.BrokerageExpenseSetl )) <> 0
	--) AS A INNER JOIN #OScONTRACTACTS AS B on a.TransDate = b.[CON DATE] AND A.SetlCurrCd = B.[CURR CODE] 
	) AS A INNER JOIN 
		(select [CON DATE], [SETTLE CURR CODE]  from  #OScONTRACTACTS group by [CON DATE], [SETTLE CURR CODE] )AS B
	 on a.TransDate = b.[CON DATE]  AND A.SetlCurrCd = B.[SETTLE CURR CODE] 


	DROP TABLE #OScONTRACTACTS;

	
   INSERT INTO [import].[PSPL_OSCONTRACTKSP_Archive]
           ([REMI NO]
           ,[CLIENT NO]
           ,[CLIENT NAME]
           ,[NRIC]
           ,[SEC CODE]
           ,[SEC NAME]
           ,[CONTRACT NO]
           ,[RT]
           ,[CURR CODE]
           ,[PRICE]
           ,[QUANTITY]
           ,[PROCEEDS]
           ,[NET AMT]
           ,[CON DATE]
           ,[DUE DATE]
           ,[SPELCD]
           ,[BROK AMT]
           ,[BROK GST]
           ,[CLR FEE]
           ,[CLR GST]
           ,[AFM FEE]
           ,[AFM GST]
           ,[SETTLE EXCH RATE]
           ,[FCN AMOUNT]
           ,[AFAMT]
           ,[FFP]
           ,[SETTLE CURR CODE]
           ,[EXCH CODE]
           ,[MARKET CODE]
           ,[COMPANY CODE]
           ,[ISIN CODE]
           ,[SourceFileName]
           ,[ImportedDateTime]
		   ,ArchiveDateTime)
    select 
	[REMI NO]
           ,[CLIENT NO]
           ,[CLIENT NAME]
           ,[NRIC]
           ,[SEC CODE]
           ,[SEC NAME]
           ,[CONTRACT NO]
           ,[RT]
           ,[CURR CODE]
           ,[PRICE]
           ,[QUANTITY]
           ,[PROCEEDS]
           ,[NET AMT]
           ,[CON DATE]
           ,[DUE DATE]
           ,[SPELCD]
           ,[BROK AMT]
           ,[BROK GST]
           ,[CLR FEE]
           ,[CLR GST]
           ,[AFM FEE]
           ,[AFM GST]
           ,[SETTLE EXCH RATE]
           ,[FCN AMOUNT]
           ,[AFAMT]
           ,[FFP]
           ,[SETTLE CURR CODE]
           ,[EXCH CODE]
           ,[MARKET CODE]
           ,[COMPANY CODE]
           ,[ISIN CODE]
           ,[SourceFileName]
           ,[ImportedDateTime]
		   ,getdate() as ArchiveDateTime
	from 
	[import].[PSPL_OSCONTRACTKSP]
	
	TRUNCATE table [import].[PSPL_OSCONTRACTKSP];

	

END