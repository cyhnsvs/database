/****** Object:  Procedure [export].[Usp_TRACSTOBTX_BTXCURR]    Committed by VersionSQL https://www.versionsql.com ******/

--Exec [export].[Usp_TRACSTOBTX_BTXCURR]
--EXEC [export].[Usp_TRACSTOBTX_BTXCURR] 'DetailBTXCURR'
--EXEC [export].[Usp_TRACSTOBTX_BTXCURR] 'TrailerBTXCURR'
--EXEC [export].[Usp_TRACSTOBTX_BTXCURR] 'HeaderBTXCURR'
CREATE PROCEDURE [export].[Usp_TRACSTOBTX_BTXCURR]
	@param char(20) = NULL
AS 
/***********************************************************************
Created By : Akshay
Created Date : 06/05/2020
Last Updated Date :
Description :
FILE NAME & FORMAT: BTXCURR.DAT
Modification History :
ModifiedBy : ModifiedDate : Reason :
Exec [export].[Usp_TRACSTOBTX_BTXCURR]
EXEC [export].[Usp_TRACSTOBTX_BTXCURR] 'DetailBTXCURR'
EXEC [export].[Usp_TRACSTOBTX_BTXCURR] 'TrailerBTXCURR'
EXEC [export].[Usp_TRACSTOBTX_BTXCURR] 'HeaderBTXCURR'
************************************************************************************/           
BEGIN  
		IF OBJECT_ID('tempdb..#HeaderBTXCURR') IS NOT NULL
					DROP TABLE #HeaderBTXCURR
		IF OBJECT_ID('tempdb..#DetailBTXCURR') IS NOT NULL
					DROP TABLE #DetailBTXCURR
		IF OBJECT_ID('tempdb..#TrailerBTXCURR') IS NOT NULL
					DROP TABLE #TrailerBTXCURR

        --HeaderBTXCURR
		Create table #HeaderBTXCURR(
			RecordType char(1),
			HeaderDate char(8),
			HeaderTime char(8),
			Filler1 char(3),
			InterfaceID char(10),
			Filler2 char(3),
			SystemID char(15),
			Filler3 char(1),
			LastPosition char(1)
		)
		Insert into #HeaderBTXCURR(
			RecordType,
			HeaderDate ,
			HeaderTime,
			Filler1 ,
			InterfaceID ,
			Filler2 ,
			SystemID ,
			Filler3 ,
			LastPosition
		)
		Select
			'H' AS RecordType,-- HARDCODE PROVIDED IN SPECS 
			format(getdate(),'yyyyMMdd') as HeaderDate ,
			format(getdate(),'HHmmss') AS HeaderTime,
			'' AS Filler1 ,
			'BTXCURR' AS InterfaceID,-- HARDCODE PROVIDED IN SPECS 
			'' AS Filler2 ,
			'BOST-IIUPLO2'SystemID,-- HARDCODE PROVIDED IN SPECS 
			'' AS Filler3 ,
			'T' AS LastPosition-- HARDCODE PROVIDED IN SPECS 
		

		--DetailBTXCURR
		Create table #DetailBTXCURR(
			RecordType char(1),
			CurrencyCode char(5),
			BuyRate char(20),
			SellRate char(20),
			Filler char(3),
			LastPosition char(1)
		)
		Insert into #DetailBTXCURR(
			RecordType,
			CurrencyCode ,
			BuyRate ,
			SellRate,
			Filler,
			LastPosition
		) 
		Select
			'1' AS RecordType,-- HARDCODE PROVIDED IN SPECS 
			'' as CurrencyCode ,
			CAST(CAST(999 AS DECIMAL(20,8)) AS VARCHAR(20))as BuyRate ,
			 CAST(CAST(999 AS DECIMAL(20,8)) AS VARCHAR(20))as SellRate,
			'' as Filler,
			'T' as LastPosition-- HARDCODE PROVIDED IN SPECS 
		
		

		--TrailerBTXCURR
		 Create Table #TrailerBTXCURR(
			RecordType char(1),
			Totalnumberofrecords char(13),
			ProcessingDate char(8),
			BatchNumber char(13),
			Filler char(14),
			LastPosition char(1)		
		 )
		 Insert into #TrailerBTXCURR(
			RecordType, 
			Totalnumberofrecords ,
			ProcessingDate ,
			BatchNumber ,
			Filler ,
			LastPosition 	
		 )
		 select
			'0' as RecordType,-- HARDCODE PROVIDED IN SPECS  
			'' as Totalnumberofrecords ,
			format(getdate(),'yyyyMMdd') AS ProcessingDate ,
			'1' as BatchNumber ,
			'' as Filler ,
			'T' as LastPosition-- HARDCODE PROVIDED IN SPECS  	
	

		IF @param= 'DetailBTXCURR'
		BEGIN
			SELECT 
	  			RecordType,
				CurrencyCode,
				BuyRate,
		  		SellRate,
				Filler,
				LastPosition 
			from #DetailBTXCURR
		END
		ELSE IF @param= 'TrailerBTXCURR'
		BEGIN
			SELECT 
				RecordType, 
				Totalnumberofrecords ,
				ProcessingDate ,
				BatchNumber ,
				Filler ,
				LastPosition 
			FROM #TrailerBTXCURR
			
		END
		ELSE IF @param= 'HeaderBTXCURR'
		BEGIN
			SELECT 
				RecordType,
				HeaderDate ,
				HeaderTime,
	     		Filler1 ,
				InterfaceID ,
				Filler2 ,
				SystemID ,
				Filler3 ,
				LastPosition
			FROM #HeaderBTXCURR
		END
		ElSE
		BEGIN		
			SELECT 
	  			RecordType +
				CurrencyCode +
				BuyRate +
		  		SellRate +
				Filler+
				LastPosition  as Column1
			from #DetailBTXCURR
		Union ALL
			SELECT 
				RecordType + 
				Totalnumberofrecords +
				ProcessingDate +
				BatchNumber +
				Filler +
				LastPosition as Column1
			FROM #TrailerBTXCURR
		
	    Union   ALL
			SELECT 
				RecordType + 
				HeaderDate  + 
				HeaderTime + 
	     		Filler1  + 
				InterfaceID  + 
				Filler2  + 
				SystemID  + 
				Filler3 +
				LastPosition as Column1
			FROM #HeaderBTXCURR
		END

		IF OBJECT_ID('tempdb..#HeaderBTXCURR') IS NOT NULL
					DROP TABLE #HeaderBTXCURR
		IF OBJECT_ID('tempdb..#DetailBTXCURR') IS NOT NULL
					DROP TABLE #DetailBTXCURR
		IF OBJECT_ID('tempdb..#TrailerBTXCURR') IS NOT NULL
					DROP TABLE #TrailerBTXCURR

SET NOCOUNT OFF;
end