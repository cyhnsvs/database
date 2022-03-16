/****** Object:  Procedure [dbo].[Usp_GetAcctInfo]    Committed by VersionSQL https://www.versionsql.com ******/

/***********************************************************************************             
Name              : [dbo].[Usp_GetAcctInfo]
Created By        : Kristine
Created Date      : 02/07/2021
Used by           : http://128.2.17.181/CQBuilder/FormData/CreateData/3426
					CQForms > GBO Realtime > Cash Transaction
Project UIN:      : 
RFA:              : 
Last Updated Date :             
Description       : This sp is used to get Acct Info by AcctNo
Table(s) Used     : 

Modification History :            
 ModifiedBy :              Project UIN :                   ModifiedDate :            Reason : 

 EXEC [dbo].[Usp_GetAcctInfo] 1, '011434001'
**********************************************************************************/   
CREATE PROCEDURE [dbo].[Usp_GetAcctInfo] 
	@iintCompanyId bigint,
	@sAcctNo varchar(50)
AS
BEGIN
	BEGIN TRY

		SELECT a.[AccountNumber (textinput-5)] AcctNo
			,ISNULL(a.[DealerCode (selectsource-21)] ,'') AcctExecutiveCd
			,ISNULL(c.[CustomerName (textinput-3)] ,'') ClientName
			,0	AvBalance -- TEMP! NOT SURE
			,ISNULL(a.[AccountGroup (selectsource-2)],'') [ServiceType] -- TEMP. NOT SURE
		FROM CQBTempDB.export.Tb_FormData_1409 a
			LEFT JOIN CQBTempDB.export.Tb_FormData_1410 c
				ON a.[CustomerID (selectsource-1)] = c.[CustomerID (textinput-1)]

		WHERE  a.[AccountNumber (textinput-5)] = @sAcctNo 


	END TRY
	BEGIN CATCH
      DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200), @xstate int;
      SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), @xstate = XACT_STATE();
      SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;
            
      RAISERROR(@ErrorMessage, @ErrorSeverity, 1,@ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);
     END CATCH
     SET NOCOUNT OFF;
END