/****** Object:  Procedure [export].[USP_FRA_ARM]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE  PROCEDURE [export].[USP_FRA_ARM]
 AS
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
	 BranchCode char(6)
	,RemisierCode char(20)
	,RemisierName char(50)
	,RemisierType char(1)
	,RemisierStatus char(1)
	,ICNumber char(15)
	,Phone1 char(20)
	,Phone2 char(20)
	,DateOpen date
	,DOB date
	,BFEID char(5)
	,NetCollateral decimal (15,2)
	,AvailableLimitGiven decimal (15,0)
	,CashBalance decimal (15,2)
	,BankGuarantee decimal (15,2)
	,UnitTrust decimal (15,2)
	,RCL  decimal (15,2)
	,BFEServer char(50)
	,TraderAdjustmentAmount decimal (20,2)
	,Address1 char(100)
	,Address2 char(100)
	,Address3 char(100)
	,Address4 char(100)
	,TradingMultiplier char(10)
	,ProhibitTradeIndicator char(5)
	,TradingSharingLocalLimit decimal (10,2)
	,TradingSharingForeignLimit decimal (10,2)
	,SpecialLimitAmount decimal (10,0)
	,SpecialLimitThreshold decimal (10,0)
	,SpecialLimitExpire char(10)
	,RemisierCompanyDeposit decimal (15,2)
	,CommissionHeld decimal (15,2)
	,RemisierSellLimit decimal (15,2)
	,AppDate date
  	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(
				BranchCode
				,RemisierCode
				,RemisierName
				,RemisierType
				,RemisierStatus
				,ICNumber
				,Phone1
				,Phone2
				,DateOpen
				,DOB
				,BFEID
				,NetCollateral
				,AvailableLimitGiven
				,CashBalance
				,BankGuarantee
				,UnitTrust
				,RCL 
				,BFEServer
				,TraderAdjustmentAmount
				,Address1
				,Address2
				,Address3
				,Address4
				,TradingMultiplier
				,ProhibitTradeIndicator
				,TradingSharingLocalLimit
				,TradingSharingForeignLimit
				,SpecialLimitAmount
				,SpecialLimitThreshold
				,SpecialLimitExpire
				,RemisierCompanyDeposit
				,CommissionHeld
				,RemisierSellLimit
				,AppDate
			)	 	

			SELECT  
			'07300'+  CAST(@RecType AS CHAR(1)) ,
			'A1 ' 	 
			,'RemisierName'
			,'D'
			,'S'
			,'ICNumber'
			,'Phone1'
			,'Phone2'
			,GETDATE()
			,GETDATE()
			,'BFEID'
			,100
			,1000
			,1000
			,1000
			,1000
			,1000 
			,'BFEServer'
			,1000 
			,'Address1'
			,'Address2'
			,'Address3'
			,'Address4'
			,'TradingMul'
			,'PRG43'
			,1000 
			,1000 
			,1000 
			,1000 
			,'SpecialLim'
			,1000 
			,1000 
			,1000 
			, getdATE() 
 	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
  END
 	-- RESULT SET

	SELECT  BranchCode
			+ RemisierCode
			+ RemisierName
			+ RemisierType
			+ RemisierStatus
			+ ICNumber
			+ Phone1
			+ Phone2
			+ FORMAT(DateOpen,	'dd-MM-yyyy')
			+ FORMAT(DOB,	'dd-MM-yyyy')
			+ BFEID
			+  CAST(NetCollateral	AS	CHAR(15))
			+  CAST(AvailableLimitGiven	AS	CHAR(15))
			+  CAST(CashBalance	AS	CHAR(15))
			+  CAST(BankGuarantee	AS	CHAR(15))
			+  CAST(UnitTrust	AS	CHAR(15))
			+   CAST(RCL	AS	CHAR(15))
			+ BFEServer
			+  CAST(TraderAdjustmentAmount	AS	CHAR(20))
			+ Address1
			+ Address2
			+ Address3
			+ Address4
			+ TradingMultiplier
			+ ProhibitTradeIndicator
			+  CAST(TradingSharingLocalLimit	AS	CHAR(10))
			+  CAST(TradingSharingForeignLimit	AS	CHAR(10))
			+  CAST(SpecialLimitAmount	AS	CHAR(10))
			+  CAST(SpecialLimitThreshold	AS	CHAR(10))
			+ SpecialLimitExpire 
			+  CAST(RemisierCompanyDeposit	AS	CHAR(15))
			+  CAST(CommissionHeld	AS	CHAR(15))
			+  CAST(RemisierSellLimit	AS	CHAR(15))
			+  FORMAT(AppDate,	'dd-MM-yyyy')
				 

	FROM #Detail
 
  
   
	DROP TABLE #Detail 
END