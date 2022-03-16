/****** Object:  Procedure [dbo].[Usp_IsCustomerExist]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_IsCustomerExist] 
	 @CustomerId BIGINT 
AS
BEGIN

	-- EXEC Usp_IsCustomerExist 980719185404

	SET NOCOUNT ON;


	IF exists (select 1 from  GlobalBOMY.import.Tb_Bursa_BATransactions where CAST(REPLACE(ID_NRIC,'-','') AS BIGINT) = CAST(@CustomerId AS BIGINT)) 
	SELECT 'True' as IsExistCustomer 
	ELSE 
	SELECT 'False' as IsExistCustomer
	RETURN
END