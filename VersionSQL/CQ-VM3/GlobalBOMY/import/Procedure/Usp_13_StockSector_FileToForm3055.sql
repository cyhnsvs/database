/****** Object:  Procedure [import].[Usp_13_StockSector_FileToForm3055]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_13_StockSector_FileToForm3055] 
AS
/***********************************************************************             
            
Created By        : Nathiya
Created Date      : 04/12/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Stock Sector List file data into CQForm
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_13_StockSector_FileToForm3055] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		EXEC CQBTempDB.form.[Usp_CreateImportTable] 3055;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3055;

		INSERT INTO CQBTempDB.[import].Tb_FormData_3055
		(
			 RecordID
			,Action
			,[StockSectorCode (textinput-1)]
			,[StockSectorName (textinput-2)]
			,[ExchangeCode (selectsource-1)]
		)    
		SELECT
			null as [RecordID],
			'I' as [Action],
			MarketSectorCode,
			Description,
			CASE 
				WHEN MarketCode = 'AUSE' THEN 'XASX'
				WHEN MarketCode = 'BMSB' THEN 'XKLS'
				WHEN MarketCode = 'HKSE' THEN 'XHKG'
				WHEN MarketCode = 'IDX' THEN 'XIDX'
				WHEN MarketCode = 'LSE' THEN 'XLON'
				WHEN MarketCode = 'NASD' THEN 'XNAS'
				WHEN MarketCode = 'OTC' THEN 'UOTC'
				WHEN MarketCode = 'SGX' THEN 'XSES'
				WHEN MarketCode = 'SSE' THEN 'XSHG'
				WHEN MarketCode = 'TH' THEN 'XBKK'
				WHEN MarketCode = 'TKY' THEN 'XTKS'
				WHEN MarketCode = 'TO' THEN 'XTSE'
				WHEN MarketCode = 'US' THEN 'XNYS'
				ELSE MarketCode
			END AS MarketCode
		FROM import.Tb_MarketSector;

		-- UPDATE LIMIT INFO FROM SAMPLE DATA
		UPDATE	F
		SET
			[BuyLimit (textinput-3)] = ISNULL(S.BuyLimit,0),
			[SellLimit (textinput-4)] = ISNULL(S.SellLimit,0),
			[NetLimit (textinput-5)] = ISNULL(S.NetLimit,0),
			[TotalLimit (textinput-6)] = ISNULL(S.TotalLimit,0),
			[BuyTopUp (textinput-7)] = ISNULL(S.BuyTopUp,0),
			[SellTopUp (textinput-8)] =  ISNULL(S.SellTopUp,0),
			[NetTopUp (textinput-9)] = ISNULL(S.NetTopUp,0),
			[TotalTopUp (textinput-10)] = ISNULL(S.TotalTopUp,0),
			[WithLimit (multipleradiosinline-1)] = S.LimitCheckFlag
		FROM CQBTempDB.[import].Tb_FormData_3055	F
		LEFT JOIN GlobalBOMY.import.Tb_StockSectorLimitInfo_SampleData S 
				ON F.[StockSectorCode (textinput-1)] = S.SectorCode
			

        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
	    
	    ROLLBACK TRANSACTION;
	    
        DECLARE @intErrorNumber INT
	        ,@intErrorLine INT
	        ,@intErrorSeverity INT
	        ,@intErrorState INT
	        ,@strObjectName VARCHAR(200)
			,@ostrReturnMessage VARCHAR(4000);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

   --     EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	  --      --,@ostrReturnMessage
			--,''
	  --      ,@intErrorLine
	  --      ,@strObjectName
	  --      ,NULL /*Code Section not available*/
	  --      ,'Process fail.';

        RAISERROR 
		(
			@ostrReturnMessage
			,@intErrorSeverity
			,@intErrorState
		);

    END CATCH
    
    SET NOCOUNT OFF;
END