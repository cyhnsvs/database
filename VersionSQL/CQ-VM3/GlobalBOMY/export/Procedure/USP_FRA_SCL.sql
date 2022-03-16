/****** Object:  Procedure [export].[USP_FRA_SCL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_SCL]
 AS 
 BEGIN
  DECLARE @RecType int =1
 	-- BATCH DETAILS
	CREATE TABLE #Detail
	(   Name CHAR(6)
		,NRICRegNo CHAR(20)
		,DOB CHAR(10)
		,GroupID CHAR(5)
		,GroupName Decimal(10,2)
		,ShareHoldingPercentage Decimal(10,2)
		,Category CHAR(10)
		,Type CHAR(10)
   )

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			(	Name
				,NRICRegNo
				,DOB
				,GroupID
				,GroupName
				,ShareHoldingPercentage
				,Category
				,Type
			)	 	
			select  'Name'  
			,'NRICRegNo'  
			,'DOB'  
			,'GrID'  
			,1000
			,1000
			,'Category'  
			,'Type'  
    	   ---FROM CQBTempDB.export.tb_formdata_xxxx
			SET @RecType=@RecType+1
		END

 	-- RESULT SET
	 SELECT    Name
			+ NRICRegNo
			+ DOB
			+ GroupID
			+ CAST(GroupName AS  CHAR(12))
			+ CAST(ShareHoldingPercentage AS  CHAR(12))
			+ Category
			+ Type
	from #Detail
 	DROP TABLE #Detail 
END