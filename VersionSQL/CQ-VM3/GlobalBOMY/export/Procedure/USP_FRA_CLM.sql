/****** Object:  Procedure [export].[USP_FRA_CLM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_CRM]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
	 BranchCode CHAR(6)
,RemisierCode CHAR(20)
,ClientCode CHAR(20)
,CDSNumber CHAR(9)
,ClienName CHAR(100)
,ClientType CHAR(2)
,ICNo1 CHAR(15)
,ICNo2 CHAR(15)
,Phone1 CHAR(30)
,Phone2 CHAR(30)
,Occupation CHAR(40)
,Employer CHAR(100)
,DateOpen DATE
,DOB DATE
,Address1 CHAR(70)
,Address2 CHAR(70)
,Address3 CHAR(70)
,Address4 CHAR(70)
,Address5 CHAR(70)
,CreditLimit Decimal(12,0)
,BFEAccountType CHAR(2)
,TradingCode CHAR(9)
,Multiple Decimal(6,2)
,Status CHAR(1)
,StatusDate DATE
,MarginFacility Decimal(10,0)
,ClientIndicatorCode CHAR(50)
,BNMIndicator CHAR(5)
,TradingLimit Decimal(14,0)
,LastTransactionDate CHAR(10)
,SuspendIndicator CHAR(10)
,SuspendIndicator2 CHAR(10)
,SuspendRemark CHAR(100)
,TrustAmount Decimal(12,2)
,ActualClientType CHAR(10)
,Tagging CHAR(5)
,InterestRate CHAR(10)
,RolloverRate CHAR(20)
,CommitmentFeeRate CHAR(20)
,LimitRatio Decimal(7,2)
,MarginCallRatio Decimal(7,2)
,ForceSellRatio Decimal(7,2)
,MarginFacilityExpiryDate CHAR(10)
,Nationality CHAR(50)
,CQIndicator CHAR(5)
,OmibusIndicator CHAR(5)
,MarginCallissueDate CHAR(10)
,AMLARating CHAR(10)
,BursaExchangePerc Decimal(10,4)
,ForeignExchangePerc Decimal(10,4)
,ForeignCurrrencySettlementIndicator CHAR(5)
,ForeignCurrencyDeclarationIndicator CHAR(5)
,MonthlyIncome CHAR(100)
,EstimatedNetWorth CHAR(100)
,SellLimit Decimal(20,0)
,ProhibitTrade CHAR(10)
,ExcludeAutoSuspendIndicator CHAR(5)
,ClientShortName CHAR(100)
,AccountPayeeName CHAR(100)
,Race CHAR(30)
,EquitiesProductDate CHAR(20)
,ECMMoneyProductDate CHAR(20)
,FuturesProductDate CHAR(20)
,TreasuryProductDate CHAR(20)
,UnitTrustProductDate CHAR(20)
,LoanProductDate CHAR(20)
,OtherProductDate CHAR(20)
,PEPIndicator CHAR(5)
,DefaulterIndicator CHAR(5)
,DefaultedAmount Decimal(10,2)
,AppDate DATE

 	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			( BranchCode
,RemisierCode
,ClientCode
,CDSNumber
,ClienName
,ClientType
,ICNo1
,ICNo2
,Phone1
,Phone2
,Occupation
,Employer
,DateOpen
,DOB
,Address1
,Address2
,Address3
,Address4
,Address5
,CreditLimit
,BFEAccountType
,TradingCode
,Multiple
,Status
,StatusDate
,MarginFacility
,ClientIndicatorCode
,BNMIndicator
,TradingLimit
,LastTransactionDate
,SuspendIndicator
,SuspendIndicator2
,SuspendRemark
,TrustAmount
,ActualClientType
,Tagging
,InterestRate
,RolloverRate
,CommitmentFeeRate
,LimitRatio
,MarginCallRatio
,ForceSellRatio
,MarginFacilityExpiryDate
,Nationality
,CQIndicator
,OmibusIndicator
,MarginCallissueDate
,AMLARating
,BursaExchangePerc
,ForeignExchangePerc
,ForeignCurrrencySettlementIndicator
,ForeignCurrencyDeclarationIndicator
,MonthlyIncome
,EstimatedNetWorth
,SellLimit
,ProhibitTrade
,ExcludeAutoSuspendIndicator
,ClientShortName
,AccountPayeeName
,Race
,EquitiesProductDate
,ECMMoneyProductDate
,FuturesProductDate
,TreasuryProductDate
,UnitTrustProductDate
,LoanProductDate
,OtherProductDate
,PEPIndicator
,DefaulterIndicator
,DefaultedAmount
,AppDate

			)	 	
			 
			SELECT   '07300'+  CAST(@RecType AS CHAR(1)) 
,'RemisierCode'  
,'ClientCode'  
,'CDSNumber'  
,'ClienName'  
,'CT'  
,'ICNo1'  
,'ICNo2'  
,'Phone1'  
,'Phone2'  
,'Occupation'  
,'Employer'  
,getdate()
,getdate()
,'Address1'  
,'Address2'  
,'Address3'  
,'Address4'  
,'Address5'  
,1000
,'BF'  
,'TCode'  
,1
,'S'  
,getdate()
,1000
,'ClientIndicatorCode'  
,'BNMIn'  
,1000
,'LTDt'  
,'SuspInd'  
,'SuspInd2'  
,'SuspendRemark'  
,1000
,'ActClTy'  
,'Tag'  
,'IntRate'  
,'RolloverRate'  
,'CommitmentFeeRate'  
,1000
,1000
,1000
,'MFEDate'  
,'Nationality'  
,'CQIn'  
,'OmIn'  
,'MCIDate'  
,'AMLARat'  
,1000
,1000
,'FCSI'  
,'FCDI'  
,'MonthlyIncome'  
,'EstimatedNetWorth'  
,1000
,'PrhTrade'  
,'AUSI'  
,'ClientShortName'  
,'AccountPayeeName'  
,'Race'  
,'EquitiesProductDate'  
,'ECMMoneyProductDate'  
,'FuturesProductDate'  
,'TreasuryProductDate'  
,'UnitTrustProductDate'  
,'LoanProductDate'  
,'OtherProductDate'  
,'PEPIn'  
,'DefIn'  
,1000
,getdate()

 	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
  END

 	-- RESULT SET
	 SELECT  BranchCode
+RemisierCode
+ClientCode
+CDSNumber
+ClienName
+ClientType
+ICNo1
+ICNo2
+Phone1
+Phone2
+Occupation
+Employer
+ FORMAT (DateOpen ,'dd-MM-yyyy' )
+ FORMAT (DOB ,'dd-MM-yyyy' )
+Address1
+Address2
+Address3
+Address4
+Address5
+ CAST(CreditLimit AS  CHAR(12))
+BFEAccountType
+TradingCode
+ CAST(Multiple AS  CHAR(8))
+Status
+ FORMAT (StatusDate ,'dd-MM-yyyy' )
+ CAST(MarginFacility AS  CHAR(10))
+ClientIndicatorCode
+BNMIndicator
+ CAST(TradingLimit AS  CHAR(14))
+LastTransactionDate
+SuspendIndicator
+SuspendIndicator2
+SuspendRemark
+ CAST(TrustAmount AS  CHAR(14))
+ActualClientType
+Tagging
+InterestRate
+RolloverRate
+CommitmentFeeRate
+ CAST(LimitRatio AS  CHAR(9))
+ CAST(MarginCallRatio AS  CHAR(9))
+ CAST(ForceSellRatio AS  CHAR(9))
+MarginFacilityExpiryDate
+Nationality
+CQIndicator
+OmibusIndicator
+MarginCallissueDate
+AMLARating
+ CAST(BursaExchangePerc AS  CHAR(14))
+ CAST(ForeignExchangePerc AS  CHAR(14))
+ForeignCurrrencySettlementIndicator
+ForeignCurrencyDeclarationIndicator
+MonthlyIncome
+EstimatedNetWorth
+ CAST(SellLimit AS  CHAR(20))
+ProhibitTrade
+ExcludeAutoSuspendIndicator
+ClientShortName
+AccountPayeeName
+Race
+EquitiesProductDate
+ECMMoneyProductDate
+FuturesProductDate
+TreasuryProductDate
+UnitTrustProductDate
+LoanProductDate
+OtherProductDate
+PEPIndicator
+DefaulterIndicator
+ CAST(DefaultedAmount AS  CHAR(12))
+ FORMAT (AppDate ,'dd-MM-yyyy' )
 from #Detail


   
	DROP TABLE #Detail 
END