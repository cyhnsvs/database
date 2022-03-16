/****** Object:  Procedure [export].[USP_CQTrader_B2BClientHolding]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_CQTrader_B2BClientHolding]
(
	@idteProcessDate DATE
)
/*
Client Holding Info
EXEC [export].[USP_CQTrader_B2BClientHolding] '2020-06-01'
*/
AS
BEGIN
	
	-- BATCH DETAILS
	CREATE TABLE #ClientHolding
	(
		 B2BAcctNo				CHAR(20)
		,Market					CHAR(2)
		,CompanyCode			CHAR(10)
		,Quantity				CHAR(11)
		,SecurityCode			CHAR(4)
	)

	INSERT INTO #ClientHolding
	(
		 B2BAcctNo	
		,Market		
		,CompanyCode
		,Quantity	
		,SecurityCode						
	)
	SELECT 
		A.AcctNo,
		TE.CountryCd,
		[CounterShortName (textinput-3)],
		Balance,
		[MarketSymbol (textinput-5)]
	FROM 
		CQBTempDB.export.Tb_FormData_1345 Product 
	INNER JOIN 
		GlobalBO.setup.Tb_Exchange TE ON Product.[MarketCode (selectsource-11)] = TE.ExchCd
	INNER JOIN 
		GlobalBO.holdings.Tb_CustodyAssets A ON   Product.[InstrumentCode (textinput-49)]= A.InstrumentId
	WHERE
		Product.[InstrumentCode (textinput-49)] LIKE '%.XKLS%' 
		
	-- RESULT SET
	SELECT 
		B2BAcctNo + Market + CompanyCode + Quantity + SecurityCode 
	FROM 
		#ClientHolding

	DROP TABLE #ClientHolding
END