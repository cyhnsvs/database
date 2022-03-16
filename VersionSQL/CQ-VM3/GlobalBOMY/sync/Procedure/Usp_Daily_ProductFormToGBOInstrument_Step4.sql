/****** Object:  Procedure [sync].[Usp_Daily_ProductFormToGBOInstrument_Step4]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_ProductFormToGBOInstrument_Step4]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_Daily_ProductFormToGBOInstrument_Step4
Created By        : Nishanth
Created Date      : 08/02/2021
Last Updated Date : 
Description       : this sp is used to sync the instrument info from Product Form to GBO Instrument table
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 

PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [sync].[Usp_Daily_ProductFormToGBOInstrument_Step4] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		--select * from GlobalBO.setup.Tb_Instrument 
		--select * FROM CQBTempDB.export.Tb_FormData_1345 AS S

		;WITH cte_InstrumentDetails AS (
				SELECT DISTINCT 
					  '' AS ExtRefKey,
					  1 AS [CompanyId],
					  PC.ProductId AS [ProductId],
					  [InstrumentCode (textinput-49)] AS [InstrumentCd],
					  [Description (textinput-2)] AS [FullName],
					  [CounterShortName (textinput-3)] [ShortName],
					  [PreviousName (textinput-4)] [AliasName],
					  [ISIN (textinput-6)] AS [ISINCd],
					  'Share Grade' AS [CodeType1],
					  [ShareGrade (selectsource-4)] AS [CodeTypeValue1],
					  'Sector' AS [CodeType2],
					  [Sector (selectsource-2)] AS [CodeTypeValue2],
					  [MarketSymbol (textinput-5)] AS [Symbol],
					  '' AS [SymbolSuffix],
					  E.CountryCd AS [ListedCountryCd],
					  S.[MarketCode (selectsource-11)] AS [ListedExchCd],
					  E.CountryCd AS [HomeCountryCd],
					  S.[MarketCode (selectsource-11)] AS [HomeExchCd],
					  [Currency (selectsource-12)] AS [TradedCurrCd],
					  [Currency (selectsource-12)] AS [SetlCurrCd],
					  [Lotsize (textinput-11)] AS LotSize,
					  [Issuedquantity (textinput-10)] AS [IssuedShare],
					  --0 AS [ParValue],
					  CASE WHEN ISNULL([ProductStatus (selectbasic-3)],'')='' OR [ProductStatus (selectbasic-3)] = 'A' THEN 'AA' 
						WHEN [ProductStatus (selectbasic-3)] = 'S' THEN 'SS'
						ELSE [ProductStatus (selectbasic-3)] END AS [Status],
					  CASE WHEN [DateListed (dateinput-1)] = '0001-01-01' THEN '1900-01-01' ELSE [DateListed (dateinput-1)] END AS [ListedDate],
					  [Lastcoupdate (dateinput-20)] As LastCouponDate,
					  [Nextcoupdate (dateinput-21)] As NextCouponDate,
					  [Datesuspended (dateinput-8)] AS [DelistedDate],
					  [Board (selectsource-1)] AS Tag1,
					  [BasisCode (selectsource-5)] AS Tag2,
					  [SecuritiesType (selectsource-6)] AS Tag3,
					  [NetLimit (textinput-47)] AS Tag4
			    FROM CQBTempDB.export.Tb_FormData_1345 AS S
				INNER JOIN GlobalBO.setup.Tb_ProductCategory AS PC
				ON S.[ProductClass (selectsource-3)] = PC.ProductCd
				INNER JOIN GlobalBO.setup.Tb_Exchange AS E
				ON S.[MarketCode (selectsource-11)] = E.ExchCd
				--WHERE [InstrumentCode (textinput-49)]<>'USEG.XNAS'
				
		)
		--select InstrumentCd from cte_InstrumentDetails
		--group by InstrumentCd
		--		having count(1)>1
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
            TRGT.ISINCd = SRC.ISINCd,
            TRGT.CodeType1 = SRC.CodeType1,
            TRGT.CodeTypeValue1 = SRC.CodeTypeValue1,
            TRGT.CodeType2 = SRC.CodeType2,
            TRGT.CodeTypeValue2 = SRC.CodeTypeValue2,
            TRGT.Symbol = SRC.Symbol,
            TRGT.ListedCountryCd = SRC.ListedCountryCd,
            TRGT.ListedExchCd = SRC.ListedExchCd,
            TRGT.HomeCountryCd = SRC.HomeCountryCd,
            TRGT.HomeExchCd = SRC.HomeExchCd,
            TRGT.TradedCurrCd = SRC.TradedCurrCd,
            TRGT.SetlCurrCd = SRC.SetlCurrCd,
            TRGT.LotSize = SRC.LotSize,
            TRGT.[IssuedShare] = SRC.[IssuedShare],
            --TRGT.[ParValue] = SRC.[ParValue],
            TRGT.[Status] = SRC.[Status],
            TRGT.ListedDate = CAST(SRC.ListedDate AS DATE),
            TRGT.LastCouponDate = SRC.LastCouponDate,
            TRGT.NextCouponDate = SRC.NextCouponDate,
            --TRGT.InternalCreditRating = SRC.SecGrade,
            TRGT.DelistedDate = CAST(SRC.DelistedDate AS DATE),
			TRGT.Tag1 = SRC.Tag1,
			TRGT.Tag2 = SRC.Tag2,
			TRGT.Tag3 = SRC.Tag3,
			TRGT.Tag4 = SRC.Tag4,
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
                Tag4,
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
				--ParValue,
                0,
                CAST(SRC.DelistedDate AS DATE),
                'N',
                --'', --IndexList
                --'', --SRC.AvgVolume30D,
                --'', --SRC.AvgVolume100D,
                Tag1,
                Tag2,
                Tag3,
                Tag4,
                Status,
                NEWID(), --RecordId
                '', --ActionInd
                '', --CurrentUser
                'SYSTEM', --CreatedBy
                GETDATE() --CreatedDate
            );
		
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

		Select @ostrReturnMessage;
		
		--EXEC [master].[dbo].DBA_SendEmail   
		--@istrMailTo             = 'nishanthc@cyberquote.com.sg;',
		--@istrMailBody           = @ostrReturnMessage,  
		--@istrMailSubject        = 'Usp_ProcessAccountDetails: Failed', 
		--@istrimportance         = 'high', 
		--@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		--@istrreply_to           = '',   
		--@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END