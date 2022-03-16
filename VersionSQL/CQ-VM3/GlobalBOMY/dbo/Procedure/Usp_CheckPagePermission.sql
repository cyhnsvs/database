/****** Object:  Procedure [dbo].[Usp_CheckPagePermission]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_CheckPagePermission]
Created By        : Jemariel Requina       
Created Date      : 05 November 2016
Used by           : GBOSG Phase 2 UI   
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to check if the page availability in GBOSG2 UI
Table(s) Used     : [setup].[Tb_Lokoup]

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 
 Jmar                    GBO-PTSAPI_SG00001                11/06/2016                 Created the SP
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_CheckPagePermission] 
	@istrModuleName varchar(50),
	@istrSubModuleName varchar(50),
	@onumResult tinyint output,
	@ostrRemarks varchar(4000) output
AS
BEGIN
	BEGIN TRY 
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		DECLARE @codeName varchar(20) = ''
		
		-- SET ALLOWED BY DEFAULT
		set @onumResult = 1;
		
		 	-- CHECK FOR SGX CUTOFF TIME
			declare @currentDateTime datetime = getdate();
			declare @time int = CAST(REPLACE(SUBSTRING(CONVERT(varchar, @currentDateTime, 121),12,5),':','') AS int);
			declare @fromTime int;
			declare @toTime int;
					 
		 IF(@istrModuleName='TRADE' AND @istrSubModuleName='EDIT')
		 begin
			select @fromTime = cast(Value3 as int), @toTime = CAST(Value4 as int) from [Setup].[Tb_Lookup] where CodeType = 'SGXCutoffDateRange';
						IF @time < @fromTime or @time > @toTime
						BEGIN
							SET @onumResult = 0;
							SET @ostrRemarks = 'Changes are not allowed as of the moment due to current time is not within Cutoff time. The changes are only allowed from ';
							SET @ostrRemarks = @ostrRemarks + right(convert(varchar(20), cast(stuff(right('0000' + convert(varchar(4),@fromTime),4),3,0,':') as datetime),100),7) + ' to ';
							SET @ostrRemarks = @ostrRemarks + right(convert(varchar(20), cast(stuff(right('0000' + convert(varchar(4),@toTime),4),3,0,':') as datetime),100),7);
						END
						--ELSE IF NOT EXISTS(select 1 from GlobalBOSG.dbo.Tb_GBOSGProcessToken where OutputProcID='AutoTradeAmendment' AND ProcessStatus='2')
						--BEGIN
						--	SET @onumResult = 0;
						--	SET @ostrRemarks = 'Cares Auto Amendment Not yet Processed by the System. Please contact ITGBOSG for details';
						--END
		 END
		 ELSE IF(@istrSubModuleName<>'VIEW' AND @istrSubModuleName<>'MERGE'AND @istrSubModuleName<>'SPLIT'AND @istrSubModuleName<>'UPLOAD')
		 begin
			-- CHECK FOR SGX CUTOFF TIME
			select @fromTime = cast(Value1 as int), @toTime = CAST(Value2 as int) from [Setup].[Tb_Lookup] where CodeType = 'SGXCutoffDateRange';
						IF @time < @fromTime or @time > @toTime
						BEGIN
							SET @onumResult = 0;
							SET @ostrRemarks = 'Changes are not allowed as of the moment due to current time is not within SGX API Cutoff time. The changes are only allowed from ';
							SET @ostrRemarks = @ostrRemarks + right(convert(varchar(20), cast(stuff(right('0000' + convert(varchar(4),@fromTime),4),3,0,':') as datetime),100),7) + ' to ';
							SET @ostrRemarks = @ostrRemarks + right(convert(varchar(20), cast(stuff(right('0000' + convert(varchar(4),@toTime),4),3,0,':') as datetime),100),7);
						END
			 end
	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END