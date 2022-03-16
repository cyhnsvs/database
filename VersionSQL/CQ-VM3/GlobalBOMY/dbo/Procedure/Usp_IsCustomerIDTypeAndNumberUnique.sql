/****** Object:  Procedure [dbo].[Usp_IsCustomerIDTypeAndNumberUnique]    Committed by VersionSQL https://www.versionsql.com ******/

/************************************************************************************             
Created By        : Kristine
Created Date      : 2021-10-18
Last Updated Date :             
Description       : this sp is used to check if customer Id Type and Id Number is 
					unique
Table(s) Used     : CQBuilder.form.Tb_FormData_1410
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
  

PARAMETERS
EXEC dbo.Usp_IsCustomerIDTypeAndNumberUnique 'NC', '123123'
EXEC dbo.Usp_IsCustomerIDTypeAndNumberUnique 'BR', '123123'
************************************************************************************/
CREATE PROCEDURE dbo.Usp_IsCustomerIDTypeAndNumberUnique (
	@iIdType NVARCHAR(50),
	@iIdNumber NVARCHAR(150)
)AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @Matched_CustomerId NVARCHAR(50)

	SELECT TOP 1 @Matched_CustomerId = [textinput-1]
	FROM CQBuilder.form.Tb_FormData_1410
	WHERE [Status] = 'Active'
		AND ISNULL([selectsource-1],'') = ISNULL(@iIdType,'')
		AND ISNULL([textinput-5],'') = ISNULL(@iIdNumber,'')

	IF @Matched_CustomerId IS NOT NULL
		SELECT 0 ReturnValue , @Matched_CustomerId  [Matched_CustomerId]
	ELSE
		
	SELECT IIF(@Matched_CustomerId IS NULL, 1, 0) ReturnValue, @Matched_CustomerId  [Matched_CustomerId]

	END TRY
    BEGIN CATCH
		EXECUTE GlobalBO.utilities.usp_RethrowError ',Usp_IsCustomerIDTypeAndNumberUnique'

    END CATCH

    SET NOCOUNT OFF;
	

END