/****** Object:  Procedure [export].[USP_N2N_UserGroup]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE  PROCEDURE [export].[USP_N2N_UserGroup]
 
AS
 
BEGIN
 
 DECLARE @RecType int =1

	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType		CHAR(1)
		,GrpID			CHAR(8)
		,[Desc]			CHAR(40)
		,Status  		CHAR(1)
		,BFEDealer		CHAR(8)
		,BHBranch		CHAR(5)
		,AutoActivate	CHAR(1)
		,ChkLimit		CHAR(1)
		,BHCode 		CHAR(10) --Type: Const  ??
		,ExchCode 		CHAR(10)--Type: Const  ??
		,Type 			CHAR(10)--Type: Const  ??
		,BuyLimit		CHAR(10)--Type: Const  ??
		,SellLimit		CHAR(10)--Type: Const  ??
		,NetLimit		CHAR(10)--Type: Const  ??
	    ,TotLimit		CHAR(10) --Type: Const  ??
        ,ParentGrpID	CHAR(10)--Type: Const  ??
		,Dealer			CHAR(10)--Type: Const  ??
        ,DealerTeamCode	CHAR(8) 

	)
		while  @RecType<10
		BEGIN
	INSERT INTO #Detail
	(    
		RecordType		 
		,GrpID			 
		,[Desc]		 
		,Status  		 
		,BFEDealer	 
		,BHBranch		 
		,AutoActivate	 
		,ChkLimit 
		,BHCode 	 
		,ExchCode  
		,Type 		 
		,BuyLimit	 
		,SellLimit 
		,NetLimit	 
	    ,TotLimit		 
        ,ParentGrpID
		,Dealer	
        ,DealerTeamCode		)

	SELECT  
	'A'		 
		,'00130' + CAST(@RecType AS CHAR(1)) 	 
		,'Description'		
		,'S'	 
		,'BFEDEAL'		 
		,'BHB'			 
		,'Y'
		,'Y' 				 
		,'' 			 
		,'' 			 
		,''	 
		,''			 
		,''			 
	    ,''		 
        ,'' 
		,'' 	 
        ,'' 
		,'DEALERCD'
		 
	   ---FROM CQBTempDB.export.tb_formdata_xxxx
		SET @RecType=@RecType+1
 END
	
 
	SELECT   
		RecordType		 
		+GrpID			 
		+[Desc]		 
		+Status  		 
		+BFEDealer	 
		+BHBranch		 
		+AutoActivate	 
		+ChkLimit 
		+BHCode 	 
		+ExchCode  
		+Type 		 
		+BuyLimit	 
		+SellLimit 
		+NetLimit	 
	    +TotLimit		 
        +ParentGrpID
		+Dealer	
        +DealerTeamCode
 	FROM #Detail


	DROP TABLE #Detail
END