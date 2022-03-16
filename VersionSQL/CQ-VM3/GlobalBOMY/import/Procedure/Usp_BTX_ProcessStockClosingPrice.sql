/****** Object:  Procedure [import].[Usp_BTX_ProcessStockClosingPrice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_BTX_ProcessStockClosingPrice]
AS
/***********************************************************************************             
            
Name              : import.Usp_BTX_ProcessStockClosingPrice     
Created By        : Nathiya Palanisamy
Created Date      : 28/12/2020    
Last Updated Date :             
Description       : this sp is used to import Stock Closing Price from BTX to GBO
            
Table(s) Used     : 
            
Modification History :  											
 
PARAMETERS
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors            
            
Used By : 
EXEC [import].[Usp_BTX_ProcessStockClosingPrice]
************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    DECLARE @ostrReturnMessage VARCHAR(4000);
    BEGIN TRY
    	BEGIN TRANSACTION
        
		DECLARE @iintCompanyId INT = 1;
        DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(@iintCompanyId, 'BusDate');
		
		DECLARE @intErrorNumber INT, 
                @intErrorLine INT ,
                @intErrorSeverity INT, 
                @intErrorState INT, 
                @strObjectName VARCHAR(200);
				
		IF (DATENAME(dw, @dteBusinessDate) IN ('Saturday','Sunday') OR EXISTS(SELECT 1 FROM GlobalBO.setup.Tb_CalendarDate WHERE CalendarDate = @dteBusinessDate AND TradingInd = 'F'))
		BEGIN
			
			DECLARE @dteLastBusinessDate DATE = (SELECT MAX(BusinessDate) FROM GlobalBO.setup.Tb_ClosingPrice WHERE BusinessDate<@dteBusinessDate);

			INSERT INTO GlobalBO.setup.Tb_ClosingPrice (
			CompanyId,
			BusinessDate,
			ProductId,
			InstrumentId,
			ExchCd,
			TradedCurrCd,
			Symbol,
			BidPrice,
			AskPrice,
			ClosingPrice,
			BidVol,
			AskVol,
			ClosingPriceCompanyBased
			)
			SELECT CompanyId,
				@dteBusinessDate,
				ProductId,
				InstrumentId,
				ExchCd,
				TradedCurrCd,
				Symbol,
				BidPrice,
				AskPrice,
				ClosingPrice,
				BidVol,
				AskVol,
				ClosingPriceCompanyBased
			FROM GlobalBO.setup.Tb_ClosingPrice AS CP
			WHERE BusinessDate = @dteLastBusinessDate;
		END
		ELSE
		BEGIN

			DELETE FROM GlobalBO.setup.Tb_ClosingPrice
			WHERE BusinessDate = @dteBusinessDate AND CompanyId = @iintCompanyId;
        
			--INSERT PRICE FROM BTX
			INSERT INTO GlobalBO.setup.Tb_ClosingPrice (
        		CompanyId,
				BusinessDate,
				ProductId,
				InstrumentId,
				ExchCd,
				TradedCurrCd,
				Symbol,
				BidPrice,
				AskPrice,
				ClosingPrice,
				BidVol,
				AskVol,
				ClosingPriceCompanyBased
			)
			SELECT
        		@iintCompanyId AS CompanyId,
				@dteBusinessDate AS BusinessDate,
				B.ProductId,
				B.InstrumentId,
				B.ListedExchCd AS ExchCd,
				B.TradedCurrCd,
				COALESCE(B.Symbol, '') AS Symbol,
				HighestPrice AS BidPrice,
				LowestPrice AS AskPrice,
				CASE WHEN A.LastDonePrice <> '0.00' THEN A.LastDonePrice
					 ELSE A.PreviousClosingPrice END AS ClosingPrice,
				VolumeTraded AS BidVol,
				0 AS AskVol,
				CASE WHEN A.LastDonePrice <> '0.00' THEN A.LastDonePrice
					 ELSE A.PreviousClosingPrice END AS ClosingPriceCompanyBased
			FROM [GlobalBOMY].[import].[Tb_BTX_YYYYMMDD] AS A
			INNER JOIN GlobalBO.setup.Tb_Instrument AS B  
				ON B.InstrumentCd = A.StockCode
			WHERE B.CompanyId = @iintCompanyId ;--AND IsOddLot='N' AND SecuritySymbol<>'';
        
		END
    	COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
		SELECT 
                  @intErrorNumber = ERROR_NUMBER(), 
                  @ostrReturnMessage = ERROR_MESSAGE(), 
                  @intErrorLine = ERROR_LINE(), 
                  @intErrorSeverity = ERROR_SEVERITY(), 
                  @intErrorState = ERROR_STATE(), 
                  @strObjectName = ERROR_PROCEDURE();

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; 

    	EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber, @ostrReturnMessage, @intErrorLine, @strObjectName,NULL, 'Process fail.';

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);           

    END CATCH

	SET NOCOUNT OFF;
END