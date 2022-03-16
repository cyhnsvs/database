/****** Object:  Procedure [export].[USP_FRA_MAC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_MAC]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(	BranchCode char(6)
		,RemisierCode char(20)
		,ClientCode char(20)
		,CDSNumber char(9)
		,CounterCode char(8)
		,TransactionCode char(17)
		,TransactionDate date
		,TransactionType char(3)
		,ContractNo char(10)
		,BSSign char(1)
		,Quantity Decimal(10,0)
		,Price Decimal(8,4)
		,Amount Decimal(12,2)
		,BrokerageAmount Decimal(12,2)
		,StampDuty Decimal(8,2)
		,ClearingFees Decimal(8,2)
		,LevyFees Decimal(8,2)
		,LastPaymentDate date
		,AppDate date
    )

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(     
			BranchCode
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
			,AppDate
			)	 	
			select  '07300'  +CAST(@RecType AS  CHAR(1))	 
			,'AO'  
			,'KE5914'  
			,'CDSNumber'  
			,'CNTCode'  
			,'MAS'  
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
			,getdate()
   	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT BranchCode 
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
		+ CAST(Price AS  CHAR(12))
		+ CAST(Amount AS  CHAR(14))
		+ CAST(BrokerageAmount AS  CHAR(14))
		+ CAST(StampDuty AS  CHAR(10))
		+ CAST(ClearingFees AS  CHAR(10))
		+ CAST(LevyFees AS  CHAR(10))
		+ FORMAT (LastPaymentDate ,'dd-MM-yyyy' )
		+ FORMAT (AppDate ,'dd-MM-yyyy')
	 from #Detail
 	DROP TABLE #Detail 
END