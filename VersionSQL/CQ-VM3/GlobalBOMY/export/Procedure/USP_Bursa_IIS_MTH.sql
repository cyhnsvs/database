/****** Object:  Procedure [export].[USP_Bursa_IIS_MTH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_IIS_MTH]
(
	@idteProcessDate DATETIME
)
AS
/*

EXEC [export].[USP_Bursa_IIS_MTH] '2020-06-01'
*/
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 Header		     CHAR(1)
		,Positiondate	 DATE
		,RecordCount	 DECIMAL(8,0)
		
	);

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType			CHAR(1)
		,AcctNo				VARCHAR(20)
		,POCode				CHAR(5)
		,Positiondate		CHAR(20)
		,ProvisionCategory	CHAR(20)
		,ProvisionType		CHAR(5)
		,OpeningValue		DECIMAL(21,0)
		,GrossProvision		DECIMAL(21,0)
		,CashOpeningBalance	DECIMAL(21,0)
		,AdditionValue		DECIMAL(21,0)
		,ReversalValue		DECIMAL(21,0)
		,WrittenOffValue	DECIMAL(21,0)
	);

	INSERT INTO #Detail
	(
		  AcctNo
		 ,RecordType			
		 ,POCode				
		 ,Positiondate		
		 ,ProvisionCategory	
		 ,ProvisionType		
		 ,OpeningValue		
		 ,GrossProvision		
		 ,CashOpeningBalance
	)
	SELECT 
	UP.AcctNo,
	'1' RecordType,
	'012' POCode,
	@idteProcessDate Positiondate,
	(CASE WHEN  TransType IN ('CHLS','SCHLS') THEN 'IIS' ELSE 'IP' END) ProvisionCategory,
	(CASE WHEN TransType='CHLS' THEN 'CL' 
	      WHEN TransType='TRBUY' THEN 'OP'
		  WHEN [ParentGroup (selectsource-3)] IN ('M','G') THEN 'MA' ELSE 'OTH' END)ProvisionType,
	ISNULL(CashBalanceBF,0) OpeningBalance,
	((SUM(CASE WHEN [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,16,NULL) >= GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
						AND [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,30,NULL) <= GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
						AND TransType IN ('CHLS','SCHLS')
						THEN ISNULL(UP.Balance,0)
						ELSE 0.00
						END) +
			 (CASE WHEN [AccountGroup (selectsource-2)]='Z' THEN 
			 SUM(CASE WHEN [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,9,NULL) >= GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
			 		  AND [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,30,NULL) <= GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
			 		  AND TransType IN ('CHLS','SCHLS')
			 		  THEN ISNULL(UP.Balance,0)
			 	      ELSE 0.00
			 		  END)
			 	  WHEN [AccountGroup (selectsource-2)] <>'Z' THEN 
			 SUM(CASE WHEN [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,4,NULL) >= GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
			 	      AND [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,30,NULL) <= GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
			 		  AND TransType IN ('CHLS','SCHLS')
			 		  THEN ISNULL(UP.Balance,0)
			 		  ELSE 0.00
			 		  END)
			 	   END))*50/100) +
			 
			 ((SUM(CASE WHEN [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,30,NULL) > GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
			 			AND TransType IN ('CHLS','SCHLS')
			 			THEN ISNULL(UP.Balance,0)
			 			ELSE 0.00
			 			END)+
			 (CASE WHEN [AccountGroup (selectsource-2)]='Z' THEN 
			 SUM(CASE WHEN [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,30,NULL) > GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
			 		  AND TransType IN ('CHLS','SCHLS')
			 		  THEN ISNULL(UP.Balance,0)
			 		  ELSE 0.00
			 		  END)
			 	  WHEN [AccountGroup (selectsource-2)] <>'Z' THEN 
			 SUM(CASE WHEN [GlobalBO].[global].[Udf_GetNextBusDateByDaysExcludePH](UP.ContractDate,30,NULL) > GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')
			 		  AND TransType IN ('CHLS','SCHLS')
			 		  THEN ISNULL(UP.Balance,0)
			 		  ELSE 0.00
			 		  END)
			 	   END))*100/100) GrossProvision,
			ISNULL(CashBalance,0) CashOpeningBalance
	FROM GlobalBORpt.transmanagement.Tb_TransactionsSettledUnPaidRpt UP  
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 ACC 
		ON ACC.[AccountNumber (textinput-5)] = UP.AcctNo
	LEFT JOIN  GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt CV 
		ON CV.AcctNo = UP.AcctNo
	WHERE TransType IN ('CHLS','SCHLS','TRBUY')
	GROUP BY UP.AcctNo,TransType,[ParentGroup (selectsource-3)],CashBalanceBF,[AccountGroup (selectsource-2)],CashBalance;

	UPDATE TRS
		SET 
			AdditionValue	  =	(CASE WHEN (CASE WHEN ((CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) + 
								(CASE WHEN (GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)))>0 THEN
								(GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) - 
								 ISNULL(Collateral,0) - CashOpeningBalance) ELSE 0 END) -0)>0 THEN (CashOpeningBalance - (CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN 
								(CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) - 0) ELSE
								(CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE 
								(CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) END) > 0 
								THEN 
								(CASE WHEN ((CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) + 
								(CASE WHEN (GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)))>0 THEN
								(GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) - 
								 ISNULL(Collateral,0) - CashOpeningBalance) ELSE 0 END) -0)>0 THEN (CashOpeningBalance - (CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN 
								(CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) - 0) ELSE
								(CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE 
								(CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) END)
								ELSE 0 END),
			ReversalValue	  = (CASE WHEN (CASE WHEN ((CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) + 
								(CASE WHEN (GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)))>0 THEN
								(GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) - 
								 ISNULL(Collateral,0) - CashOpeningBalance) ELSE 0 END) -0)>0 THEN (CashOpeningBalance - (CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN 
								(CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) - 0) ELSE
								(CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE 
								(CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) END) < 0 
								THEN 
								(CASE WHEN ((CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) + 
								(CASE WHEN (GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)))>0 THEN
								(GrossProvision - (CashOpeningBalance - (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)) - 
								 ISNULL(Collateral,0) - CashOpeningBalance) ELSE 0 END) -0)>0 THEN (CashOpeningBalance - (CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN 
								(CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) - 0) ELSE
								(CashOpeningBalance - (CASE WHEN (CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END)>CashOpeningBalance THEN CashOpeningBalance ELSE 
								(CASE WHEN (CashOpeningBalance - GrossProvision)>0 THEN (CashOpeningBalance - GrossProvision) ELSE 0 END) END)) END)
								ELSE 0 END),
			WrittenOffValue   = 0
	FROM #Detail AS TRS
	LEFT JOIN GlobalBORpt.valuation.Tb_CustodyAssetsRPValuationCollateralRpt CUSTDY 
		ON CUSTDY.AcctNo = TRS.AcctNo;
	-- BATCH TRAILER
	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);

		INSERT INTO #Header
	(
		 Header		
		,Positiondate 	
		,RecordCount
	)
	VALUES (0,FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13))

	-- RESULT SET
	SELECT 
		Header + CAST(Positiondate AS CHAR(15)) + CAST(RecordCount AS CHAR(10))
	FROM #Header
	UNION ALL
	SELECT 
		 RecordType		
		+ POCode			
		+ Positiondate		
		+ ProvisionCategory	
		+ ProvisionType		
		+ CAST(OpeningValue AS CHAR(10))
		+ CAST(AdditionValue AS CHAR(10))
		+ CAST(ReversalValue AS CHAR(10))
		+ CAST(WrittenOffValue AS CHAR(10))	
	FROM #Detail;

	DROP TABLE #Header;
	DROP TABLE #Detail;

END