/****** Object:  Procedure [dbo].[Usp_GetClientsCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_GetClientsCode]
    @iintCompanyId int
AS
BEGIN

SET NOCOUNT ON;
    
	SELECT ClientCd FROM GlobalBO.setup.Tb_Personnel WHERE CompanyId = @iintCompanyId GROUP BY ClientCd

SET NOCOUNT OFF;

END