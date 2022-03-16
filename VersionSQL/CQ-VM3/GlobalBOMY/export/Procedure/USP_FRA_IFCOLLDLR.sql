/****** Object:  Procedure [export].[USP_FRA_IFCOLLDLR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFCOLLDLR] 
(
	@idteProcessDate DATE
)
AS
BEGIN
--exec [export].[USP_FRA_IFCOLLDLR]  '2021-01-01'

	SET NOCOUNT ON;

	CREATE TABLE #IFDEFAULTR
	(
		BROKERCD     CHAR(5),
		DLREAFID     CHAR(3),
		DEALERCD     CHAR(4),
		COLPUR       DECIMAL(15,2),
		NETPURC      DECIMAL(15,2),
		NETPURA      DECIMAL(15,2),
		NETPURO      DECIMAL(15,2),
		UNCOLPUR     DECIMAL(15,2),
		TOTOSPUR     DECIMAL(15,2),
		TOTCOLOS     DECIMAL(15,2),
		TCL          DECIMAL(15,2),
		SCL          DECIMAL(15,2),
		UCL          DECIMAL(15,2),
		DNE          DECIMAL(15,2),
		DCD          DECIMAL(15,2),
		DSV          DECIMAL(15,2),
		OTHCHG       DECIMAL(15,2),
		DTL          DECIMAL(15,2),
		GR           DECIMAL(15,2),
		NP           DECIMAL(15,2),
		CLTATL       DECIMAL(15,2),
		DATL         DECIMAL(15,2),
		RAMT1        DECIMAL(15,2),
		RAMT2        DECIMAL(15,2),
		DTM          DECIMAL(15,2),
		NOSS         DECIMAL(15,2),
		NOSCL        DECIMAL(15,2),
		NOSCG        DECIMAL(15,2),
		NOS          DECIMAL(15,2),
		DTTL         DECIMAL(15,2),
		DRATIO       DECIMAL(15,2),
		AMOUNT1      DECIMAL(15,2),
		AMOUNT2      DECIMAL(15,2),
		AMOUNT3      DECIMAL(15,2),
		AMOUNT4      DECIMAL(15,2),
		AMOUNT5      DECIMAL(15,2),
		CHQNOTISS    DECIMAL(15,2),
		USRCREATED   CHAR(10),
		DTCREATED    CHAR(10),
		TMCREATED    CHAR(8),
		USRUPDATED   CHAR(10),
		DTUPDATED    CHAR(10),
		TMUPDATED    CHAR(8),
		RCDSTAT      CHAR(1),
		RCDVERSION   DECIMAL(5,0),
		PGMLSTUPD    CHAR(10),
		TRIGGERACT   CHAR(1),
		DRATIO2      DECIMAL(15,6),
		DLCBRHID     CHAR(4),
		DLCEAFID     CHAR(3),
		TEAMID       CHAR(10)
	)
	
	INSERT INTO #IFDEFAULTR
	(
		BROKERCD,
		DLREAFID,
		DEALERCD,
		COLPUR,
		NETPURC,
		NETPURA,
		NETPURO,
		UNCOLPUR,
		TOTOSPUR,
		TOTCOLOS,
		TCL,
		SCL,
		UCL,
		DNE,
		DCD,
		DSV,
		OTHCHG,
		DTL,
		GR,
		NP,
		CLTATL,
		DATL,
		RAMT1,
		RAMT2,
		DTM,
		NOSS,
		NOSCL,
		NOSCG,
		NOS,
		DTTL,
		DRATIO,
		AMOUNT1,
		AMOUNT2,
		AMOUNT3,
		AMOUNT4,
		AMOUNT5,
		CHQNOTISS,
		USRCREATED,
		DTCREATED,
		TMCREATED,
		USRUPDATED,
		DTUPDATED,
		TMUPDATED,
		RCDSTAT,
		RCDVERSION,
		PGMLSTUPD,
		TRIGGERACT,
		DRATIO2,
		DLCBRHID,
		DLCEAFID,
		TEAMID
	)
	SELECT 
		'001' --BROKERCD	
		,'' 
		,CAST([DealerCode (textinput-35)] AS CHAR(4))--DEALERCD	 	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0 --10 
	
		,0  
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0--20
	
		,0  
		,0  
		,0 --DATL 
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0  	
		,0--30  
	
		,0  
		,0  	
		,0  	
		,0  	
		,0  	
		,'' 	
		,'' 	
		,'' 	
		,'' 	
		,'' 	
		,''--40 
	
		,'' 
		,0  
		,'' 
		,'' 
		,0  
		,'' 
		,''--50 
		,'' 	
	FROM 
		CQBTempDB.export.tb_formdata_1377 DELEAR
	INNER JOIN 
		CQBTempDB.export.tb_formdata_1379 D_Market ON D_Market.[DealerCode (selectsource-14)] = DELEAR.[DealerCode (textinput-35)]

	-- RESULT SET 

	SELECT 
		CAST(BROKERCD AS CHAR(4)) + CAST(DLREAFID AS CHAR(4)) + CAST(DEALERCD AS CHAR(4)) + CAST(COLPUR AS CHAR(8)) + CAST(NETPURC AS CHAR(8)) 
		+ CAST(NETPURA AS CHAR(8)) + CAST(NETPURO AS CHAR(8)) + CAST(UNCOLPUR AS CHAR(8)) + CAST(TOTOSPUR AS CHAR(8)) + CAST(TOTCOLOS AS CHAR(8)) 
		+ CAST(TCL AS CHAR(8)) + CAST(SCL AS CHAR(8)) + CAST(UCL AS CHAR(8)) + CAST(DNE AS CHAR(8)) + CAST(DCD AS CHAR(8)) + CAST(DSV AS CHAR(8)) 
		+ CAST(OTHCHG AS CHAR(8)) + CAST(DTL AS CHAR(8)) + CAST(GR AS CHAR(8)) + CAST(NP AS CHAR(8)) + CAST(CLTATL AS CHAR(8)) + CAST(DATL AS CHAR(8)) 
		+ CAST(RAMT1 AS CHAR(8)) + CAST(RAMT2 AS CHAR(8)) + CAST(DTM AS CHAR(8)) + CAST(NOSS AS CHAR(8)) + CAST(NOSCL AS CHAR(8)) + CAST(NOSCG AS CHAR(8)) 
		+ CAST(NOS AS CHAR(8)) + CAST(DTTL AS CHAR(8)) + CAST(DRATIO AS CHAR(8)) + CAST(AMOUNT1 AS CHAR(8)) + CAST(AMOUNT2 AS CHAR(8)) + CAST(AMOUNT3 AS CHAR(8)) 
		+ CAST(AMOUNT4 AS CHAR(8)) + CAST(AMOUNT5 AS CHAR(8)) + CAST(CHQNOTISS AS CHAR(8)) + USRCREATED + DTCREATED + TMCREATED + USRUPDATED + DTUPDATED + TMUPDATED 
		+ RCDSTAT + CAST(RCDVERSION AS CHAR(8)) + PGMLSTUPD + TRIGGERACT + CAST(DRATIO2 AS CHAR(8)) + DLCBRHID + DLCEAFID + TEAMID
	FROM #IFDEFAULTR

	DROP TABLE #IFDEFAULTR
END