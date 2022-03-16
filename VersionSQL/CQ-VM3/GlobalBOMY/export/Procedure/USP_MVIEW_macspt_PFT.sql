/****** Object:  Procedure [export].[USP_MVIEW_macspt_PFT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MVIEW_macspt_PFT]
(
	@idteProcessDate DATETIME
)
AS
/*

EXEC [export].[USP_N2N_macspt_PFT] '2020-06-01'

*/
BEGIN
	
	-- BATCH DETAILS
	CREATE TABLE #Details
	(
		 RecordType	  CHAR(1)       
		,ClientCode	  CHAR(10)       
		,CDSNo		  CHAR(9) 
		,StockCode    CHAR(8)       
		,StockName    CHAR(20)      
		,NetQty       CHAR(15)      
		,FreeQty      CHAR(15)      
		
	)

	INSERT INTO #Details
	(
			 RecordType	  
			,ClientCode	  
			,CDSNo   
			,StockCode   
			,StockName   
			,NetQty   
			,FreeQty 
	)
	SELECT 
	
		    1
		   ,[AccountNumber (textinput-5)]
		   ,[CDSNo (textinput-19)]
		   ,SUBSTRING(I.InstrumentCd,0,CHARINDEX('.',I.InstrumentCd))
		   ,I.ShortName
		   ,CustodyAssetsBalance
		   ,0
		  
		FROM 
			CQBTempDB.export.Tb_FormData_1409 ACC
		INNER JOIN 
			GlobalBORpt.valuation.Tb_CustodyAssetsRPValuationCollateralRpt RPT ON RPT.AcctNo = ACC.[AccountNumber (textinput-5)] 
		INNER JOIN 
			GlobalBO.setup.Tb_Instrument I ON I.InstrumentId = RPT.InstrumentId
	-- BATCH TRAILER

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Details)

	CREATE TABLE #ControlRecord
	(
		 RecordType			CHAR(1)
		,TotalNumberRecord	CHAR(12)
		,ProcessingDate		CHAR(10)
	)
	INSERT INTO #ControlRecord
	(
		 RecordType			
		,TotalNumberRecord	
		,ProcessingDate		
	)
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd')) 
		
	SELECT 
			 RecordType	+ '|' +  ClientCode + '|' +  CDSNo + '|' +  StockCode + '|' +  StockName + '|' +  NetQty + '|' +  FreeQty 
	FROM 
		#Details

		UNION ALL

	SELECT 
		 RecordType	+ '|' +  TotalNumberRecord	+ '|' +  ProcessingDate		
	FROM 
		#ControlRecord

	DROP TABLE #Details
	DROP TABLE #ControlRecord
	
END