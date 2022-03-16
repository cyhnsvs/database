/****** Object:  Procedure [export].[USP_FRA_MGUA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [export].[USP_FRA_MGUA]
 AS 
 BEGIN
  DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(   Branch CHAR(10)
,ClientCode CHAR(20)
,GuarantorName1 CHAR(200)
,GuarantorNRIC1 CHAR(20)
,GuarantorCountry1 CHAR(20)
,GuaranteeType1 CHAR(5)
,GuarantorName2 CHAR(200)
,GuarantorNRIC2 CHAR(20)
,GuarantorCountry2 CHAR(20)
,GuaranteeType2 CHAR(5)
,GuarantorName3 CHAR(200)
,GuarantorNRIC3 CHAR(20)
,GuarantorCountry3 CHAR(20)
,GuaranteeType3 CHAR(5)

   	)

	WHILE  @RecType<10
		BEGIN
			INSERT INTO #Detail
			( Branch
,ClientCode
,GuarantorName1
,GuarantorNRIC1
,GuarantorCountry1
,GuaranteeType1
,GuarantorName2
,GuarantorNRIC2
,GuarantorCountry2
,GuaranteeType2
,GuarantorName3
,GuarantorNRIC3
,GuarantorCountry3
,GuaranteeType3

  )	 	
select  'Branch'  
,'ClientCode'  
,'GuarantorName1'  
,'GuarantorNRIC1'  
,'GuarantorCountry1'  
,'Gua1'  
,'GuarantorName2'  
,'GuarantorNRIC2'  
,'GuarantorCountry2'  
,'Gua2'  
,'GuarantorName3'  
,'GuarantorNRIC3'  
,'GuarantorCountry3'  
,'Gua3'  

  


   	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
  END

 	-- RESULT SET
	 SELECT   Branch
+ClientCode
+GuarantorName1
+GuarantorNRIC1
+GuarantorCountry1
+GuaranteeType1
+GuarantorName2
+GuarantorNRIC2
+GuarantorCountry2
+GuaranteeType2
+GuarantorName3
+GuarantorNRIC3
+GuarantorCountry3
+GuaranteeType3


  from #Detail


   
	DROP TABLE #Detail 
END