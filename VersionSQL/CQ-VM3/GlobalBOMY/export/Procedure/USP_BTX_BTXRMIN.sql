/****** Object:  Procedure [export].[USP_BTX_BTXRMIN]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXRMIN]
(
	@idteProcessDate DATETIME
)
AS
-- REMISIER INFO
-- EXEC [export].[USP_BTX_BTXRMIN] '2020-06-01'
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(8)
		,HeaderTime		 CHAR(8)
		,Filler1		 CHAR(3)
		,InterfaceID	 CHAR(10)
		,Filler2		 CHAR(3)
		,SystemID		 CHAR(15)
		,Filler3		 CHAR(943)
		,LastPosition	 CHAR(1)
	);
	INSERT INTO #Header
	(
		 RecordType	
		,HeaderDate	
		,HeaderTime	
		,Filler1	
		,InterfaceID
		,Filler2	
		,SystemID	
		,Filler3	
		,LastPosition
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'), CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXRMIN','','BOS','','T');
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,LoginID				CHAR(16)
		,DealerID				CHAR(16)
		,[Name]					CHAR(200)
		,NewICNo				CHAR(30)
		,OldICNo				CHAR(30)
		,Gender					CHAR(1)
		,Race					CHAR(50)
		,LicenseNo				CHAR(30)
		,CommenceDate			CHAR(10)
		,Address1				CHAR(50)
		,Address2				CHAR(50)
		,Address3				CHAR(50)
		,Address4				CHAR(50)
		,TelPhNo1				CHAR(15)
		,TelPhNo2				CHAR(15)
		,HandPhNo1				CHAR(15)
		,HandPhNo2				CHAR(15)
		,Email					CHAR(250)
		,BFEDealerID			CHAR(13)
		,TradingAcctNO			CHAR(20)
		,CashDeposit			DECIMAL(13,2)
		,ShareDeposit			CHAR(16)--DECIMAL(13,2)
		,BankGuarantee			CHAR(16)--DECIMAL(13,2)
		,RemisierType			CHAR(2)
		,RemisierStatus			CHAR(1)
		,Filler					CHAR(10)
		,LastPosition			CHAR(1)
	);
	INSERT INTO #Detail
	(
		 RecordType			
		,BranchCode			
		,LoginID			
		,DealerID			
		,[Name]				
		,NewICNo			
		,OldICNo			
		,Gender				
		,Race				
		,LicenseNo			
		,CommenceDate		
		,Address1			
		,Address2			
		,Address3			
		,Address4			
		,TelPhNo1			
		,TelPhNo2			
		,HandPhNo1			
		,HandPhNo2			
		,Email				
		,BFEDealerID		
		,TradingAcctNO		
		,CashDeposit		
		,ShareDeposit		
		,BankGuarantee		
		,RemisierType		
		,RemisierStatus		
		,Filler				
		,LastPosition		
	)
	SELECT 
		1,
		CASE WHEN ISNULL(Dealer.[BranchID (selectsource-1)],'') <> '' THEN Dealer.[BranchID (selectsource-1)] ELSE '001' END,
		CASE WHEN ISNULL(Dealer.[BranchID (selectsource-1)],'') <> '' THEN Dealer.[BranchID (selectsource-1)] ELSE '001' END + '0' + [BFEDealerCode (textinput-26)]  AS LoginID,
		[BFEDealerCode (textinput-26)],
		[Name (textinput-3)],
		[IDNumber (textinput-9)],
		[AlternateIDno (textinput-10)],
		[Sex (multipleradiosinline-2)],
		[Race (selectsource-5)],
		[LicenseNumber (textinput-6)],
		[LicenseSince (dateinput-1)],
		[Address1 (textinput-11)],
		[Address2 (textinput-14)],
		[Address3 (textinput-13)],
		[Town (textinput-12)],
		[TelephoneExtension (textinput-18)],
		'',
		[Phone (textinput-16)],
		[MobilePhone (textinput-17)],
		[PersonalEmail (textinput-27)],
		[BFEDealerCode (textinput-26)],
		[CollateralAccountNo (textinput-7)],
		[InitialDeposit (textinput-21)],
		'',
		'',
		[DealerType (selectsource-3)],
		[Status (selectsource-12)],
		'',
		'T'
	FROM CQBTempDB.export.Tb_FormData_1377	Dealer;
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(956)
		,LastPosition		CHAR(1)
	);
	INSERT INTO #Trailer
	(
		 RecordType		
		,TrailerCount	
		,ProcessingDate	
		,HASHTotal		
		,Filler			
		,LastPosition	
	)
	VALUES(0,@Count,FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') ,@Count,'','T'); 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT  RecordType + BranchCode + LoginID + DealerID + [Name] + NewICNo + OldICNo + Gender + Race + LicenseNo + CommenceDate + Address1 + Address2 + Address3			
			+ Address4 + TelPhNo1 + TelPhNo2 + HandPhNo1 + HandPhNo2 + Email + BFEDealerID + TradingAcctNO 
			+ CASE WHEN CashDeposit < 0 THEN '-' + RIGHT(REPLICATE('0',15) + CAST(CashDeposit AS VARCHAR),15) ELSE RIGHT(REPLICATE('0',16) + CAST(CashDeposit AS VARCHAR),16) END 
			+ ShareDeposit	+ BankGuarantee	+ RemisierType + RemisierStatus + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + RIGHT(REPLICATE('0',13) + RTRIM(TrailerCount),13) + ProcessingDate + RIGHT(REPLICATE('0',13) + RTRIM(HASHTotal),13) + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END