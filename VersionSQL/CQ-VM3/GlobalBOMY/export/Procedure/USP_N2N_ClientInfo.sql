/****** Object:  Procedure [export].[USP_N2N_ClientInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_N2N_ClientInfo]
 
AS
 
BEGIN
 
 DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType			CHAR(1)
		,AccountBranchId	CHAR(5)
		,DealerId			CHAR(5)
		,TradingAccount  	CHAR(20)
		,AccountType		CHAR(5)
		,OrgAccountType		CHAR(3)
		,ClientName			CHAR(50)
		,ClientCDSNumber	CHAR(9)
		,NewIC 				CHAR(14)
		,OldIC 				CHAR(10)
		,Race 				CHAR(1)
		,Nationality		CHAR(2)
		,Phone				CHAR(12)
		,Status				CHAR(1)
	    ,BankBranch			CHAR(8) 
        ,AssociateFlag		CHAR(11)
		,SuspensionFlag		DECIMAL(1,0)
        ,InquiryDealerId	CHAR(5)
		,AppCreditLimit		CHAR(12)
		,MasterAccount		CHAR(20)
		,BHCode				CHAR(3)
		,ExchangeCode		CHAR(5)
		,CDPAccount			CHAR(20)
		,SGTradingAccount	CHAR(20)
		,CDSBranch			CHAR(5)
		,USFormEffective	Date 
		,USFormExpired		Date  
		,DealerTeamCode		CHAR(8)
		,CallWarrIndicator	CHAR(1)


	)
		while  @RecType<10
		BEGIN
	INSERT INTO #Detail
	(    
		RecordType		 
		,AccountBranchId	 
		,DealerId		 
		,TradingAccount   
		,AccountType	 
		,OrgAccountType		 
		,ClientName			 
		,ClientCDSNumber	 
		,NewIC 				 
		,OldIC 			 
		,Race 			 
		,Nationality	 
		,Phone			 
		,Status			 
	    ,BankBranch		 
        ,AssociateFlag	 
		,SuspensionFlag	 
        ,InquiryDealerId 
		,AppCreditLimit	 
		,MasterAccount	 
		,BHCode			 
		,ExchangeCode	 
		,CDPAccount		 
		,SGTradingAccount 
		,CDSBranch		 
		,USFormEffective 
		,USFormExpired		 
		,DealerTeamCode		 
		,CallWarrIndicator 	)

	SELECT  'A'		 
		,'112'	 
		,'800'		 
		,'0D1234'   
		,'STS'	 
		,'R'		 
		,'NAVEEN '			 
		,'CDS' + CAST(@RecType AS CHAR(1)) 
		
		,'340201104567' 				 
		,'1234567890' 			 
		,'1' 			 
		,'SG'	 
		,'5326554201'			 
		,'A'			 
	    ,'001300'		 
        ,'1' 
		,1 	 
        ,'1234' 
		,'1251'	 
		,'MA5568'	 
		,'073'			 
		,'KL'	 
		,'CDP123'		 
		,'SGTA123' 
		,'CDSBr'		 
		,getdate() 
		,getdate() +100	 
		,'DTCode'		 
		,'1'
		 
	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
 END
	
 
	SELECT   
	RecordType		 
		+AccountBranchId	 
		+DealerId		 
		+TradingAccount   
		+AccountType	 
		+OrgAccountType		 
		+ClientName			 
		+ClientCDSNumber	 
		+NewIC 				 
		+OldIC 			 
		+Race 			 
		+Nationality	 
		+Phone			 
		+Status			 
	    +BankBranch		 
        +AssociateFlag	 
		+ CAST(SuspensionFlag AS CHAR(1)) 
        +InquiryDealerId 
		+AppCreditLimit	 
		+MasterAccount	 
		+BHCode			 
		+ExchangeCode	 
		+CDPAccount		 
		+SGTradingAccount 
		+CDSBranch		 
		+ FORMAT (USFormEffective, 'ddMMyyyy')  
		+ FORMAT (USFormExpired, 'ddMMyyyy')  
		+DealerTeamCode		 
		+CallWarrIndicator 
 	FROM #Detail


	DROP TABLE #Detail
END