/****** Object:  Procedure [import].[Usp_ProcessInstrumentDetails_1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_ProcessInstrumentDetails] 
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessInstrumentDetails
Created By        : Nishanth Chowdhary
Created Date      : 13/09/2017
Last Updated Date : 
Description       : this sp is used to import the instruments from ClientData on a daily basis
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_ProcessInstrumentDetails] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		DECLARE @intProductID BIGINT;
		SELECT @intProductID = ProductID FROm GlobalBO.setup.Tb_ProductCategory WHERE ProductCd = 'ES' AND CompanyId = @iintCompanyId; 
	    
	 --   select [Column 0]	shareid
		--		,[Column 1]	sharetname
		--		,[Column 2]	shareename
		--		,[Column 3]	sectorcode
		--		,[Column 4]	par
		--		,[Column 5]	capital
		--		,[Column 6]	commissiontype
		--		,[Column 7]	sharetype
		--		,[Column 8]	subsharetype
		--		,[Column 9]	xchgmkt
		--		,[Column 10]	bissharetype
		--		,[Column 11]	sdcflag
		--		,[Column 12]	regisflag
		--		,[Column 13]	dutyflag
		--		,[Column 14]	fundtaxexempt
		--		,[Column 15]	sharecommgroup
		--		,[Column 16]	mktcode
		--		,[Column 17]	boardlot
		--		,[Column 18]	filler1 into #tmst
		--from [GlobalBOTH].[import].[ins_pom_tmst] order by  cast([Column 0] as int)
 
		--SELECT [Column 0]	shareid
		--	  ,[Column 1]	sharecode
		--	  ,[Column 2]	closedate
		--	  ,[Column 3]	closeprice
		--	  ,[Column 4]	openprice
		--	  ,[Column 5]	highprice
		--	  ,[Column 6]	lowprice
		--	  ,[Column 7]	avgprice
		--	  ,[Column 8]	totalunit
		--	  ,[Column 9]	totalvolume
		--	  ,[Column 10]	securitynum
		--	  ,[Column 11]	board
		--	  ,[Column 12]	flag1
		--	  ,[Column 13]	flag2
		--	  ,[Column 14]	flag3
		--	  ,[Column 15]	flag4
		--	  ,[Column 16]	flag5
		--	  ,[Column 17]	flag6
		--	  ,[Column 18]	securitycode
		--	  ,[Column 19]	ncrtypeflag
		--	  ,[Column 20]	debttypeflag
		--	  ,[Column 21]	sedolcode
		--	  ,[Column 22]	dwcantrade
		--	  ,[Column 23]	riccode
		--	  ,[Column 24]	isincode
		--	  ,[Column 25]	filler into #tst
		--  FROM [GlobalBOTH].[import].[Ins_pom_tst] order by cast([Column 0] as int)
  
		;WITH cte_InstrumentDetails AS (
				SELECT DISTINCT 
					  A.shareid AS ExtRefKey,
					  1 AS [CompanyId],
					  @intProductId AS [ProductId],
					  sharecode AS [InstrumentCd],
					  shareename AS [FullName],
					  sharecode [ShortName],
					  sharetname [AliasName],
					  ISNULL(nullif(isincode,''),sharecode) AS [ISINCd],
					  '' AS [CodeType1],
					  '' AS [CodeTypeValue1],
					  '' AS [CodeType2],
					  '' AS [CodeTypeValue2],
					  '' AS [Symbol],
					  '' AS [SymbolSuffix],
					  'TH' AS [ListedCountryCd],
					  CASE mktcode
								WHEN 'OTC' THEN 'TOTC'
								WHEN 'SET' THEN 'XBKK'
								WHEN 'BEX' THEN 'TBEX'
								WHEN 'MAI' THEN 'TMAI'
								WHEN 'OTHER' THEN 'TOTH' 
								ELSE mktcode END AS [ListedExchCd],
					  'TH' AS [HomeCountryCd],
					  CASE mktcode
								WHEN 'OTC' THEN 'TOTC'
								WHEN 'SET' THEN 'XBKK'
								WHEN 'BEX' THEN 'TBEX'
								WHEN 'MAI' THEN 'TMAI'
								WHEN 'OTHER' THEN 'TOTH' 
								ELSE mktcode END AS [HomeExchCd],
					  'THB' AS [TradedCurrCd],
					  'THB' AS [SetlCurrCd],
					  0 AS [IssuedShare],
					  0 AS [ParValue],
					  'AA' AS [Status],
					  '1900-01-01' AS [ListedDate],
					  '9999-12-31' AS [DelistedDate]
			    FROM [import].[Ins_tst] A 
				inner join [import].[Ins_tmst] B on A.shareid=B.shareid
				--FROM #tst A 
				--inner join #tmst B on A.shareid=B.shareid
		)
        MERGE INTO GlobalBO.setup.Tb_Instrument AS TRGT
        USING cte_InstrumentDetails AS SRC ON
            SRC.InstrumentCd = TRGT.InstrumentCd AND
            SRC.CompanyId = TRGT.CompanyId 
            --AND SRC.ExtRefKey = TRGT.ExtRefKey
        WHEN MATCHED THEN UPDATE SET
			TRGT.ExtRefKey = SRC.ExtRefKey,
        	TRGT.FullName = SRC.FullName, 
            TRGT.ShortName = SRC.ShortName, 
            TRGT.AliasName = SRC.AliasName, 
            TRGT.ListedCountryCd = SRC.ListedCountryCd,
            TRGT.ListedExchCd = SRC.ListedExchCd,
            TRGT.HomeCountryCd = SRC.HomeCountryCd,
            TRGT.HomeExchCd = SRC.HomeExchCd,
            TRGT.TradedCurrCd = SRC.TradedCurrCd,
            TRGT.SetlCurrCd = SRC.SetlCurrCd,
            TRGT.ISINCd = SRC.ISINCd,
            --TRGT.InternalCreditRating = SRC.SecGrade,
            TRGT.ListedDate = CAST(SRC.ListedDate AS DATE),
            TRGT.DelistedDate = CAST(SRC.DelistedDate AS DATE),
            TRGT.ModifiedBy = 'SYSTEM',
            TRGT.ModifiedDate = GETDATE()
        WHEN NOT MATCHED BY TARGET THEN
			INSERT (
				ExtRefKey,
                InstrumentCd,
                CompanyId,
                ShortName,
                AliasName,
                FullName,
                ProductId,
                ListedCountryCd,
                ListedExchCd,
                HomeCountryCd,
                HomeExchCd,
                ClassificationType,
				IndustryCd,
                TradedCurrCd,
                SetlCurrCd,
                --LotSize,
                --SharesHolderFunds,
                IssuedShare,
                CodeType1,
                CodeTypeValue1,
                CodeType2,
                CodeTypeValue2,
                Symbol,
				SymbolSuffix,
                ISINCd,
                --InternalCreditRating,
                --Remarks,
                --Issuer,
                ListedDate,
                --CouponInterestRate,
                --CouponType,
                --CouponFrequency,
                --LastCouponDate,
                --NextCouponDate,
                --DaysInAYear,
                --ExpiryDate,
                ParValue,
				DelistedDate,
				SwitchInd,
                --IndexList,
                --Average30DaysVolume,
                --Average100DaysVolume,
                --Tag1,
                --Tag2,
                --Tag3,
                [Status],
                RecordId,
                ActionInd,
                CurrentUser,
                CreatedBy,
                CreatedDate)
            VALUES (		
                SRC.ExtRefKey,	
                SRC.InstrumentCd,
                SRC.CompanyId,
                SRC.ShortName,
                SRC.AliasName,
                SRC.FullName,
                SRC.ProductId, -- ProductId
                SRC.ListedCountryCd,
                SRC.ListedExchCd,
                SRC.HomeCountryCd,
                SRC.HomeExchCd,
                '',
				'',
                SRC.TradedCurrCd,
                SRC.SetlCurrCd,
                --0, --SRC.LotSize,
                --0, --SRC.ShareHoldersFund,
                0,
                '', --CodeType1,
                '', --CodeTypeValue1
                '', --CodeType2,
                '', --CodeTypeValue2
                '',
				'',
                SRC.ISINCd,
                --'', --SRC.SecGrade,
                --'', --SRC.Remarks,
                --'', --SRC.Issuer,
                CAST(SRC.ListedDate AS DATE),
                --'', --SRC.CouponRate,
                --'', --SRC.CouponType,
                --'', --SRC.CouponFrequency,
                --'1900-01-01', --CAST(SRC.CouponDateLast AS DATE),
                --'1900-01-01', --CAST(SRC.CouponDateNext AS DATE),
                --0, --CASE WHEN SRC.DayCount = 'A65' THEN
                --    365
                --WHEN SRC.DayCount = '360' THEN
                --    360
                --ELSE
                --    365
                --END, --DaysInAYear
                0,
                CAST(SRC.DelistedDate AS DATE),
                'N',
                --'', --IndexList
                --'', --SRC.AvgVolume30D,
                --'', --SRC.AvgVolume100D,
                --'', --SRC.PoemsSecCd, --Tag1
                --'', --SRC.SIPInd, --Tag2
                --'', --SRC.OnlineSecCd, --Tag3,
                'AA', --Status
                NEWID(), --RecordId
                '', --ActionInd
                '', --CurrentUser
                'SYSTEM', --CreatedBy
                GETDATE() --CreatedDate
            );
			
			--DROP TABLE #tmst;
			--DROP TABLE #tst;
			
        --ROLLBACK TRANSACTION
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
    
    		DECLARE @intErrorNumber INT
	        ,@intErrorLine INT
	        ,@intErrorSeverity INT
	        ,@intErrorState INT
	        ,@strObjectName VARCHAR(200);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		      
		ROLLBACK TRANSACTION;
		
		EXEC [master].[dbo].DBA_SendEmail   
		@istrMailTo             = 'nishanthc@cyberquote.com.sg;',   
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = 'Usp_ProcessInstrumentDetails: Failed', 
		@istrimportance         = 'high', 
		@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END