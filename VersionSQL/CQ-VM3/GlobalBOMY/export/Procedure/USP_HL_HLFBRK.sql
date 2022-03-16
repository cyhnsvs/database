/****** Object:  Procedure [export].[USP_HL_HLFBRK]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_HL_HLFBRK]
(
	@idteProcessDate DATE
)
AS
-- EXEC [export].[USP_HL_HLFBRK] '2021-02-15'
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType					 	 CHAR(1)
		,BrokerCode                  	 CHAR(6)
		,PurchaseOrSale              	 CHAR(1)
		,ContractNumber              	 CHAR(15)
		,TRSBroker                   	 CHAR(3)
		,ContractDate                	 CHAR(6)
		,TRSNumber                   	 CHAR(5)
		,UnitPrice                   	 DECIMAL(9,6)
		,Quantity                    	 DECIMAL(9,0)
		,StockCode                   	 CHAR(8)
		,CDSAccountNumber            	 CHAR(20)
		,ClientBrokerage             	 DECIMAL(9,2)
		,BankBrokerage               	 DECIMAL(9,2)
		,ClearingFees                	 DECIMAL(9,2)
		,ContractStamp               	 DECIMAL(9,2)
		,StampDuty                   	 DECIMAL(9,2)
		,BillOrOtherAmount           	 DECIMAL(9,2)
		,FICode                      	 CHAR(1)
		,ProcessingFlag              	 CHAR(1)
		,GSTOnClientsBrokerage       	 DECIMAL(9,2)
		,GSTonBanksBrokerage         	 DECIMAL(9,2)
		,GSTonClearingFees		     	 DECIMAL(9,2)
		,RebateAmount                	 DECIMAL(9,2)
		,CreditOrDebitIndicator      	 CHAR(1)
		,ContractValue               	 DECIMAL(12,2)
		,ContractDuedate             	 CHAR(6)
	)
	INSERT INTO #Detail
	(
		 RecordType				
		,BrokerCode            
		,PurchaseOrSale        
		,ContractNumber        
		,TRSBroker             
		,ContractDate          
		,TRSNumber             
		,UnitPrice             
		,Quantity              
		,StockCode             
		,CDSAccountNumber      
		,ClientBrokerage       
		,BankBrokerage         
		,ClearingFees          
		,ContractStamp         
		,StampDuty             
		,BillOrOtherAmount     
		,FICode                
		,ProcessingFlag        
		,GSTOnClientsBrokerage 
		,GSTonBanksBrokerage   
		,GSTonClearingFees    
		,RebateAmount          
		,CreditOrDebitIndicator
		,ContractValue         
		,ContractDuedate       				
	)
	SELECT 
		 'C'
		,BrokerInfo.[BrokerCode (textinput-1)],
		CASE WHEN C.TransType = 'TRBUY'
			 THEN 'P'
			 ELSE 'S'
		END,
		C.ContractNo,
		'',
		FORMAT(CAST(ContractDate AS DATETIME), 'ddMMyy'),
		'',
		TradedPrice,
		TradedQty,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		Acct.[CDSNo (textinput-19)],
		ClientBrokerageSetl,
		ClientBrokerageSetl,
		A.FeeAmountSetl,
		B.FeeAmountSetl,
		000000.00,
		000000.00,
		'',
		'',
		ClientBrokerageSetlTax,
		ClientBrokerageSetlTax,
		A.FeeTaxSetl,
		.00,
		CASE WHEN C.TransType ='TRBUY' AND (C.TransType = 'TRSELL' AND C.NetAmountSetl < 0) THEN 'D' ELSE 'C' END,
		NetAmountSetl,
		FORMAT(CAST(SetlDate AS DATETIME), 'ddMMyy')
		
	FROM 
		GlobalBO.contracts.Tb_ContractOutstanding C
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_2795 BrokerInfo ON BrokerInfo.[StockExchange (selectsource-2)] = C.ExchCd
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON C.InstrumentId = I.InstrumentId
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Acct ON C.AcctNo = Acct.[AccountNumber (textinput-5)]	
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo
	WHERE
		InstrumentCd LIKE '%.XKLS%'  AND C.ContractDate = @idteProcessDate

	UNION

	SELECT 
		 'C'
		,BrokerInfo.[BrokerCode (textinput-1)],
		CASE WHEN C.TransType = 'TRBUY'
			 THEN 'P'
			 ELSE 'S'
		END,
		C.ContractNo,
		'',
		FORMAT(CAST(ContractDate AS DATETIME), 'ddMMyy'),
		'',
		TradedPrice,
		TradedQty,
		SUBSTRING(InstrumentCd,0,CHARINDEX('.',InstrumentCd)),
		Acct.[CDSNo (textinput-19)],
		ClientBrokerageSetl,
		ClientBrokerageSetl,
		A.FeeAmountSetl,
		B.FeeAmountSetl,
		000000.00,
		000000.00,
		'',
		'',
		ClientBrokerageSetlTax,
		ClientBrokerageSetlTax,
		A.FeeTaxSetl,
		.00,
		CASE WHEN C.TransType ='TRBUY' AND (C.TransType = 'TRSELL' AND C.NetAmountSetl < 0) THEN 'D' ELSE 'C' END,
		NetAmountSetl,
		FORMAT(CAST(SetlDate AS DATETIME), 'ddMMyy')
		
	FROM 
		GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_2795 BrokerInfo ON BrokerInfo.[StockExchange (selectsource-2)] = C.ExchCd
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON C.InstrumentId = I.InstrumentId
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Acct ON C.AcctNo = Acct.[AccountNumber (textinput-5)]	
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Clearing Fee'
		) AS A ON A.ContractNo =  C.ContractNo
	LEFT JOIN 
		(SELECT ContractNo,FeeAmountSetl, FeeTaxSetl FROM GlobalBO.contracts.Tb_ContractFeeDetails CF
			INNER JOIN  
			GlobalBO.setup.Tb_TransactionFee TF ON CF.FeeId =  TF.FeeId AND TF.FeeDesc = 'Contract Stamp Fee'
		) AS B ON B.ContractNo = C.ContractNo

	WHERE
		InstrumentCd LIKE '%.XKLS%'  AND C.ContractDate = @idteProcessDate AND C.TransType IN ('TRBUY','TRSELL')

	-- RESULT SET
	SELECT 
			RecordType + BrokerCode + PurchaseOrSale + ContractNumber +  TRSBroker + ContractDate + TRSNumber + CAST(UnitPrice AS CHAR(9))  				
		  + CAST(Quantity  AS CHAR(9)) + StockCode +  CDSAccountNumber + CAST(ClientBrokerage  AS CHAR(9)) + CAST(BankBrokerage  AS CHAR(9))    
		  + CAST(ClearingFees  AS CHAR(9)) + CAST(ContractStamp  AS CHAR(9)) + CAST(StampDuty  AS CHAR(9)) + CAST(BillOrOtherAmount  AS CHAR(9))     
		  + FICode + ProcessingFlag + CAST(GSTOnClientsBrokerage  AS CHAR(9)) +  CAST(GSTonBanksBrokerage  AS CHAR(9)) + CAST(GSTonClearingFees  AS CHAR(9))    
		  + CAST(RebateAmount  AS CHAR(9)) +  CreditOrDebitIndicator + CAST(ContractValue  AS CHAR(15)) +  ContractDuedate    
	FROM 
		#Detail
END