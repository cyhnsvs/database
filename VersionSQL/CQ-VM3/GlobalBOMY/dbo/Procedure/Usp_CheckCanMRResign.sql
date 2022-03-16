/****** Object:  Procedure [dbo].[Usp_CheckCanMRResign]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_CheckCanMRResign](
	@iintCompanyId BIGINT,
	@istrMRReference VARCHAR(100)
)AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @FundSourceId BIGINT

	SELECT @FundSourceId = FundSourceId FROM GlobalBO.setup.Tb_FundSource WHERE FundSourceCd = 'Remisier'

	IF EXISTS(
		SELECT 1 FROM GlobalBO.holdings.Tb_Cash WHERE 
		CompanyId = @iintCompanyId AND
		FundSourceId = @FundSourceId AND
		AcctNo in (
			select D.[AccountNumber (textinput-5)] 
			FROM CQBTempDB.export.Tb_FormData_1409 D
			WHERE D.[MRReference (selectsource-22)] = @istrMRReference)
		)
		SELECT ReturnValue = '0', ReturnText = 'This Marketing representative has some accounts where the losses are earmarked to the Remisier.'
	ELSE
		SELECT ReturnValue = '1', ReturnText = '' 

	END TRY
    BEGIN CATCH
		EXECUTE GlobalBO.utilities.usp_RethrowError ',usp_CheckCanDealerResign'

    END CATCH

    SET NOCOUNT OFF;
	

END