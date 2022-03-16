/****** Object:  Procedure [export].[USP_FRA_COU]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_COU]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
	 ExchangeCode CHAR(10)
	,ExchangeName CHAR(30)
	,CounterCode CHAR(8)
	,CounterName CHAR(35)
	,Industry CHAR(5)
	,Classification CHAR(35)
	,Board CHAR(2)
	,Status CHAR(8)
	,SuspensionDate date
	,MaturityDate date
	,Restricted CHAR(1)
	,ClosingPrice Decimal(12,4)
	,FinalCappedPrice Decimal(10,4)
	,ExclusionIndicator CHAR(5)
	,RemisierCollateralCappingIndicator CHAR(2)
	,ISIN CHAR(20)
	,AppDate date
  	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(   
			ExchangeCode
			,ExchangeName
			,CounterCode
			,CounterName
			,Industry
			,Classification
			,Board
			,Status
			,SuspensionDate
			,MaturityDate
			,Restricted
			,ClosingPrice
			,FinalCappedPrice
			,ExclusionIndicator
			,RemisierCollateralCappingIndicator
			,ISIN
			,AppDate
 			)	 	
			 
			SELECT   
			 'Bursa'  
			,'Bursa Malaysia'  
			,'CntCode'  
			,'CounterName'  
			,'Ind'  
			,'Classification'  
			,'M'  
			,'Active'  
			,getdate()
			,getdate()
			,'R'  
			,1000
			,1000
			,'0'  
			,'B'  
			,'ISIN'  
			,getdate()
  	      ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT  
		 ExchangeCode
		+ ExchangeName
		+ CounterCode
		+ CounterName
		+ Industry
		+ Classification
		+ Board
		+ Status
		+ FORMAT (SuspensionDate ,'dd-MM-yyyy' )
		+ FORMAT (MaturityDate ,'dd-MM-yyyy' )
		+Restricted
		+ CAST(ClosingPrice AS  CHAR(16))
		+ CAST(FinalCappedPrice AS  CHAR(14))
		+ ExclusionIndicator
		+ RemisierCollateralCappingIndicator
		+ ISIN
		+ FORMAT (AppDate ,'dd-MM-yyyy' )
	from #Detail
 	DROP TABLE #Detail 
END