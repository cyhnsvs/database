/****** Object:  Procedure [sync].[Usp_OneTime_StockFileToGBOInstrument_Step5]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_OneTime_StockFileToGBOInstrument_Step5] 
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessInstrumentDetails
Created By        : Jansi
Created Date      : 20/03/2020
Last Updated Date : 
Description       : this sp is used to import the instruments from ClientData onetime
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
        
		;WITH cte_InstrumentDetails AS (
				SELECT DISTINCT 
					  '' AS ExtRefKey,
					  1 AS [CompanyId],
					  C.ProductId AS [ProductId],
					  A.ProductCd + '.' + ISNULL(B.GBOExchCd,'') AS [InstrumentCd],
					  Description AS [FullName],
					  ShortName [ShortName],
					  PreviousName [AliasName],
					  ISIN AS [ISINCd],
					  'Share Grade' AS [CodeType1],
					  ShareGrade AS [CodeTypeValue1],
					  'Sector' AS [CodeType2],
					  Sector AS [CodeTypeValue2],
					  MarketSymbol AS [Symbol],
					  '' AS [SymbolSuffix],
					  'MY' AS [ListedCountryCd],
					  B.GBOExchCd AS [ListedExchCd],
					  'MY' AS [HomeCountryCd],
					  B.GBOExchCd AS [HomeExchCd],
					  CADCurrency AS [TradedCurrCd],
					  CADCurrency AS [SetlCurrCd],
					  LotSize,
					  IssuedQty AS [IssuedShare],
					  ParValue AS [ParValue],
					  CASE WHEN ISNULL([Status],'')='' THEN 'AA' 
						WHEN [Status] = 'S' THEN 'SS'
						ELSE [Status] 
					  END AS [Status],
					  CASE WHEN DateListed = '0001-01-01' THEN '1900-01-01' ELSE DateListed END AS [ListedDate],
					  CADLastCoupDate As LastCouponDate,
					  CADNextCoupDate As NextCouponDate,
					  DateSuspended AS [DelistedDate],
					  Board AS Tag1,
					  BasisCode AS Tag2,
					  SecuritiesType AS Tag3
			    FROM [import].Tb_Stock A 
				LEFT JOIN import.Tb_ExchangeMapping As B
				ON A.MarketCd = B.ExchCd
				LEFT JOIN GlobalBO.setup.Tb_ProductCategory As C
				ON C.ProductCd = A.ProductClass
				--inner join [import].[Ins_tmst] B on A.shareid=B.shareid
				--FROM #tst A 
				--inner join #tmst B on A.shareid=B.shareid
				--Where A.ProductCd <> '4634CM'
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
            TRGT.CodeTypeValue1 = SRC.CodeTypeValue1,
            TRGT.CodeTypeValue2 = SRC.CodeTypeValue2,
            --TRGT.InternalCreditRating = SRC.SecGrade,
            TRGT.ListedDate = CAST(SRC.ListedDate AS DATE),
            TRGT.DelistedDate = CAST(SRC.DelistedDate AS DATE),
			TRGT.Tag1 = SRC.Tag1,
			TRGT.Tag2 = SRC.Tag2,
			TRGT.Tag3 = SRC.Tag3,
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
                LotSize,
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
                LastCouponDate,
                NextCouponDate,
                --DaysInAYear,
                --ExpiryDate,
                ParValue,
				DelistedDate,
				SwitchInd,
                --IndexList,
                --Average30DaysVolume,
                --Average100DaysVolume,
                Tag1,
                Tag2,
                Tag3,
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
                SRC.LotSize,
                --0, --SRC.ShareHoldersFund,
                IssuedShare,
                SRC.CodeType1, --CodeType1,
                SRC.CodeTypeValue1, --CodeTypeValue1
                SRC.CodeType2, --CodeType2,
                SRC.CodeTypeValue2, --CodeTypeValue2
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
                CAST(SRC.LastCouponDate AS DATE),
                CAST(SRC.NextCouponDate AS DATE),
                --0, --CASE WHEN SRC.DayCount = 'A65' THEN
                --    365
                --WHEN SRC.DayCount = '360' THEN
                --    360
                --ELSE
                --    365
                --END, --DaysInAYear
                ParValue,
                CAST(SRC.DelistedDate AS DATE),
                'N',
                --'', --IndexList
                --'', --SRC.AvgVolume30D,
                --'', --SRC.AvgVolume100D,
                Tag1,
                Tag2,
                Tag3,
                Status,
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
		SELECT @ostrReturnMessage;
		--EXEC [master].[dbo].DBA_SendEmail   
		--@istrMailTo             = 'nishanthc@cyberquote.com.sg;',   
		--@istrMailBody           = @ostrReturnMessage,  
		--@istrMailSubject        = 'Usp_ProcessInstrumentDetails: Failed', 
		--@istrimportance         = 'high', 
		--@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		--@istrreply_to           = '',   
		--@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END