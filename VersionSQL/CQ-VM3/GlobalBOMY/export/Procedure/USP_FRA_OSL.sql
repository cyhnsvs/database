/****** Object:  Procedure [export].[USP_FRA_OSL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_OSL]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(    BranchCode CHAR(6)
,RemisierCode CHAR(20)
,ClientCode CHAR(20)
,CDSNumber CHAR(9)
,CounterCode CHAR(8)
,TransactionCode CHAR(17)
,TransactionDate DATE
,TransactionType CHAR(3)
,ContractNo CHAR(10)
,BSSign CHAR(1)
,Quantity Decimal(10,0)
,Price Decimal(25,4)
,Amount Decimal(20,2)
,BrokerageAmount Decimal(12,2)
,StampDuty Decimal(8,2)
,ClearingFees Decimal(8,2)
,LevyFees Decimal(8,2)
,LastPaymentDate DATE
,RASIndicator CHAR(5)
,DebitInterestAmount Decimal(20,2)
,CreditInterestAmount Decimal(20,2)
,RollOverDate CHAR(10)
,RASAmount Decimal(20,2)
,RASInterest Decimal(20,2)
,AppDate DATE

   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(    BranchCode
				,RemisierCode
				,ClientCode
				,CDSNumber
				,CounterCode
				,TransactionCode
				,TransactionDate
				,TransactionType
				,ContractNo
				,BSSign
				,Quantity
				,Price
				,Amount
				,BrokerageAmount
				,StampDuty
				,ClearingFees
				,LevyFees
				,LastPaymentDate
				,RASIndicator
				,DebitInterestAmount
				,CreditInterestAmount
				,RollOverDate
				,RASAmount
				,RASInterest
				,AppDate
		)	 	
		select  '07300'  +CAST(@RecType AS  CHAR(1))	 
		,'AO'  
		,'KE5914'  
		,'CDSNumber'  
		,'CNTCode'  
		,'TransactionCode'  
		,getdate()
		,'CON'  
		,'ContractNo'  
		,'B'  
		,1000
		,1000
		,1000
		,1000
		,1000
		,1000
		,1000
		,getdate()
		,'RASIn'  
		,1000
		,1000
		,'01022022'  
		,1000
		,1000
		,getdate()
  	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
	 END

 	-- RESULT SET
	 SELECT   BranchCode	
		+RemisierCode	
		+ClientCode	
		+CDSNumber	
		+CounterCode	
		+TransactionCode	
		+ FORMAT (TransactionDate ,'dd-MM-yyyy' )	
		+TransactionType	
		+ContractNo	
		+BSSign	
		+ CAST(Quantity AS  CHAR(10))	
		+ CAST(Price AS  CHAR(29))	
		+ CAST(Amount AS  CHAR(22))	
		+ CAST(BrokerageAmount AS  CHAR(14))	
		+ CAST(StampDuty AS  CHAR(10))	
		+ CAST(ClearingFees AS  CHAR(10))	
		+ CAST(LevyFees AS  CHAR(10))	
		+ FORMAT (LastPaymentDate ,'dd-MM-yyyy' )	
		+RASIndicator	
		+ CAST(DebitInterestAmount AS  CHAR(22))	
		+ CAST(CreditInterestAmount AS  CHAR(22))	
		+RollOverDate	
		+ CAST(RASAmount AS  CHAR(22))	
		+ CAST(RASInterest AS  CHAR(22))	
		+ FORMAT (AppDate ,'dd-MM-yyyy')	
   from #Detail
    
	DROP TABLE #Detail 
END