/****** Object:  Procedure [export].[USP_BTX_BTXCLAC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCLAC]
(
	@idteProcessDate DATETIME
)
AS
/*
CLIENT ACCOUNT INFO  
EXEC [export].[USP_BTX_BTXCLAC] '2020-06-01'
*/
BEGIN
	DECLARE @idte3PreviousYear DATE = DATEADD(year,-3,@idteProcessDate);
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(16)
		,Filler1		 CHAR(3)
		,InterfaceID	 CHAR(10)
		,Filler2		 CHAR(3)
		,SystemID		 CHAR(15)
		,Filler3		 CHAR(1038)
		,LastPosition	 CHAR(1)
	);
	INSERT INTO #Header
	(
		 RecordType	
		,HeaderDate	
		,Filler1	
		,InterfaceID
		,Filler2	
		,SystemID	
		,Filler3	
		,LastPosition
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') + CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCLAC','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,TradingAccount			CHAR(15)
		,GCIF					CHAR(20)
		,BFETradingCd			CHAR(9)
		,AccountType			CHAR(5)
		,ClientName				CHAR(255)
		,CDSNo					CHAR(20)
		,DealerID				CHAR(16)
		,[Status]				CHAR(1)
		,CompanyCode			CHAR(3)
		,BranchCode				CHAR(3)
		,AllowAssociate			CHAR(1)
		,CrossAmend				CHAR(1)
		,DealerReassign			CHAR(1)
		,AuthorizedFlag			CHAR(1)
		,DormantStatus			CHAR(1)
		,DelinquentStatus		CHAR(1)
		,ReassignDelaerCode		CHAR(16)
		,AvailableTradingLimit	DECIMAL(16,2)
		,ApprovedTradingLimit	DECIMAL(16,2)
		,TrustAccountBalance	DECIMAL(16,2)
		,Country				CHAR(5)
		,AccountOpenDate		CHAR(10)
		,AccountCloseDate		CHAR(10)
		,LastTransDate			CHAR(10)
		,ActivationDate			CHAR(10)
		,DormantDate			CHAR(10)
		,SuspendDate			CHAR(10)
		,SuspendReason			CHAR(500)
		,BankAccount			CHAR(50)
		,MarginAccount			CHAR(16)
		,InternalAccountType	CHAR(2)
		,FSTInd					CHAR(2)
		,FSTIndUS				CHAR(2)
		,FSTClientClass			CHAR(5)
		,FSTClientStatus		CHAR(2)
		,FSTRIMStatus			CHAR(2)
		,FSTDRBStatus			CHAR(2)
		,Filler					CHAR(20)
		,LastPosition			CHAR(1)
		,CashMultiplier			CHAR(5)
	);
	INSERT INTO #Detail
	(
		  RecordType				
		 ,TradingAccount			
		 ,GCIF					
		 ,BFETradingCd			
		 ,AccountType			
		 ,ClientName				
		 ,CDSNo					
		 ,DealerID				
		 ,[Status]				
		 ,CompanyCode			
		 ,BranchCode				
		 ,AllowAssociate			
		 ,CrossAmend				
		 ,DealerReassign			
		 ,AuthorizedFlag
		 ,DormantStatus			
		 ,DelinquentStatus		
		 ,ReassignDelaerCode		
		 ,AvailableTradingLimit	
		 ,ApprovedTradingLimit	
		 ,TrustAccountBalance	
		 ,Country				
		 ,AccountOpenDate		
		 ,AccountCloseDate		
		 ,LastTransDate			
		 ,ActivationDate			
		 ,DormantDate			
		 ,SuspendDate			
		 ,SuspendReason			
		 ,BankAccount			
		 ,MarginAccount			
		 ,InternalAccountType	
		 ,FSTInd					
		 ,FSTIndUS				
		 ,FSTClientClass			
		 ,FSTClientStatus		
		 ,FSTRIMStatus			
		 ,FSTDRBStatus			
		 ,Filler					
		 ,LastPosition			
		 ,CashMultiplier				
	)
	SELECT 
		1,
		Account.[AccountNumber (textinput-5)],
		[IDNumber (textinput-5)],
		Account.[AccountNumber (textinput-5)],
		[AccountType (selectsource-7)],
		[CustomerName (textinput-3)],
		[CDSNo (textinput-19)],
		[DealerCode (selectsource-21)],
		Account.[Tradingaccount (selectsource-31)],--[AccountStatus (selectsource-9)],
		1,
		[CDSACOpenBranch (selectsource-4)],
		[ClientAssoallowed (multipleradiosinline-13)],
		[ClientCrossamend (multipleradiosinline-15)],
		[ClientReassignallowed (multipleradiosinline-14)],
		'N',
		'', -- Dormant Status
		'N',
		'', -- Reassign Dealer Code
		RIGHT(REPLICATE('0',16)+CAST(CAST([MaxNetLimit (textinput-70)] AS DECIMAL(13,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST((CASE WHEN [ApproveTradingLimit (textinput-54)]='' THEN CAST(0 AS DECIMAL(13,2)) ELSE CAST(REPLACE([ApproveTradingLimit (textinput-54)],',','') AS DECIMAL(13,2)) END)  AS VARCHAR(16)),16), -- [ApprovedLimit (textinput-64)]
		--RIGHT(REPLICATE('0',16)+CAST(CAST((CASE WHEN [ApproveTradingLimit (textinput-54)]='' THEN CAST(0 AS DECIMAL(24,9)) ELSE [ApproveTradingLimit (textinput-54)] END) AS DECIMAL(13,2)) AS VARCHAR(16)),16), -- [ApprovedLimit (textinput-64)]
		REPLICATE('0',16), -- Trust Account Balance
		[Country (selectsource-24)], 
		'', -- Account Opening Date
		'', -- Account Closing Date
		'', -- Last Transaction Date
		'', -- Activation Date
		'', -- Dormant Date
		'', -- Suspend Date
		[SuspensionCloseReason (selectsource-30)],--[SuspensionReason (selectsource-30)],
		[AccountNumber (textinput-5)],
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'T',
		[MultiplierforCashDeposit (textinput-56)]
	FROM CQBTempDB.export.Tb_FormData_1409	Account
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)];

	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(1056)
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
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),'','T'); 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + TradingAccount + GCIF + BFETradingCd + AccountType + ClientName + CDSNo + DealerID + [Status] + CompanyCode + BranchCode + AllowAssociate + CrossAmend
		+ DealerReassign + AuthorizedFlag + DormantStatus + DelinquentStatus + ReassignDelaerCode + CAST(AvailableTradingLimit AS VARCHAR(50)) + CAST(ApprovedTradingLimit  AS VARCHAR(50)) + CAST(TrustAccountBalance AS VARCHAR(50)) + Country + AccountCloseDate
		+ AccountCloseDate + LastTransDate + ActivationDate + DormantDate + SuspendDate + SuspendReason + BankAccount + MarginAccount + InternalAccountType + FSTInd
		+ FSTIndUS + FSTClientClass + FSTClientStatus + FSTDRBStatus + Filler + LastPosition + CashMultiplier
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END