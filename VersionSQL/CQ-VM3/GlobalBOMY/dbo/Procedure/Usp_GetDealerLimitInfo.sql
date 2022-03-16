/****** Object:  Procedure [dbo].[Usp_GetDealerLimitInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_GetDealerLimitInfo]
	@iintCompanyId bigint,
	@sDealerCode varchar(50),
	@sMarketCode varchar(50)
AS
/***********************************************************************************             
Name              : [dbo].[Usp_GetDealerLimitInfo]
Created By        : Kristine
Created Date      : 15/07/2021
Used by           : Dealer Market Limit Maintenance Form
					http://128.1.17.102/CQBuilder/FormData/CreateData/3676
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used in form 3676 to get existing fields from 
					Dealer Market (Tb_FormData_1379) and Dealer (Tb_FormData_1377)
					to preload to a new the Dealer Market limit maintenance form

Table(s) Used     : CQBuilder.form.Tb_FormData_1377, CQBuilder.form.Tb_FormData_1379

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 

 EXEC [dbo].[Usp_GetDealerLimitInfo] 1, 'BRK', 'XKLS'
**********************************************************************************/   
BEGIN
	BEGIN TRY
		-- DECLARE @iintCompanyId bigint = 1,@sDealerCode varchar(50) = 'BRK',@sMarketCode varchar(50) = 'XKLS'
		SELECT dMarket.[selectsource-14] DealerCode	
			,dMarket.[selectsource-15] MarketCode
			,dMarket.[textinput-7] MaxBuyLimit
			,dMarket.[textinput-8] MaxSellLimit
			,dMarket.[textinput-9] MaxNetLimit
			,dMarket.[textinput-12] TradingLimit
			,dealer.[selectsource-6] MultiplierMethod
			,dealer.[textinput-23] MultiplierMethodValue
		FROM CQBuilder.form.Tb_FormData_1379 dMarket
			INNER JOIN CQBuilder.form.Tb_FormData_1377 dealer
				ON dealer.[textinput-35] = dMarket.[selectsource-14]

		WHERE dMarket.[selectsource-14] = @sDealerCode
			AND dMarket.[selectsource-15] = @sMarketCode

	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END