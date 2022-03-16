/****** Object:  Procedure [process].[Usp_BulkRemisierChange]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_BulkRemisierChange](
	@istrCurrentDealer  VARCHAR(100) = null,
	@istrNewDealer      VARCHAR(100) = null,
	@istrCurrentMR      VARCHAR(100) = null,
	@istrNewMR          VARCHAR(100) = null,
	@istrAccounts       VARCHAR(MAX) = '(All)'
)AS
BEGIN
	DECLARE
	@CurrentDealer VARCHAR(100),
	@NewDealer VARCHAR(100)

	SET NOCOUNT ON
	BEGIN TRY


	if( ISNULL(@istrCurrentDealer,'') != '' AND ISNULL(@istrNewDealer,'') != '') /* D1 => D2 */
		BEGIN
			if (@istrAccounts = '(All)')
				BEGIN

					UPDATE  CQBTempDB.export.Tb_FormData_1575 
					SET [DealerCode (selectsource-1)] = @istrNewDealer
					WHERE [MRCode (textinput-17)] IN (
						SELECT DISTINCT [MRReference (selectsource-22)] 
						FROM CQBTempDB.export.Tb_FormData_1409
						WHERE [MRReference (selectsource-22)] != '' 
						AND [DealerCode (selectsource-21)] = @istrCurrentDealer)


					UPDATE CQBTempDB.export.Tb_FormData_1409 
					SET [DealerCode (selectsource-21)] = @istrNewDealer
					WHERE [DealerCode (selectsource-21)] = @istrCurrentDealer
					
				END
			ELSE
				BEGIN
					UPDATE  CQBTempDB.export.Tb_FormData_1575 
					SET [DealerCode (selectsource-1)] = @istrNewDealer
					WHERE [MRCode (textinput-17)] IN (
						SELECT DISTINCT [MRReference (selectsource-22)] 
						FROM CQBTempDB.export.Tb_FormData_1409
						WHERE [MRReference (selectsource-22)] != '' 
						AND [DealerCode (selectsource-21)] = @istrCurrentDealer)

					UPDATE CQBTempDB.export.Tb_FormData_1409 
					SET [DealerCode (selectsource-21)] = @istrNewDealer
					WHERE [DealerCode (selectsource-21)] = @istrCurrentDealer
					AND [AccountNumber (textinput-5)] IN ( SELECT [value] FROM string_split(@istrAccounts,','))
					
					UPDATE CQBTempDB.export.Tb_FormData_1409 
					SET [MRReference (selectsource-22)] = ''
					WHERE [DealerCode (selectsource-21)] = @istrCurrentDealer
					AND [AccountNumber (textinput-5)] NOT IN ( SELECT [value] FROM string_split(@istrAccounts,','))

					
				END
		END
	ELSE IF ( ISNULL(@istrCurrentMR,'') != '' AND ISNULL(@istrNewMR,'') != '' ) /* MR1 => MR2 */
		BEGIN
			
			SELECT @CurrentDealer = [DealerCode (selectsource-1)] FROM CQBTempDB.export.Tb_FormData_1575 WHERE [MRCode (textinput-17)] = @istrCurrentMR

			SELECT @NewDealer = [DealerCode (selectsource-1)] FROM CQBTempDB.export.Tb_FormData_1575 WHERE [MRCode (textinput-17)] = @istrNewMR

			
			if (@CurrentDealer = @NewDealer) /* With in same Dealer */
				BEGIN
					if (@istrAccounts = '(All)')
						BEGIN
							UPDATE CQBTempDB.export.Tb_FormData_1409 SET [MRReference (selectsource-22)] = @istrNewMR,
							UpdatedBy = suser_sname(), UpdatedTime = getdate()
							where  [MRReference (selectsource-22)]  = @istrCurrentMR
						END
					ELSE
						BEGIN
							UPDATE CQBTempDB.export.Tb_FormData_1409 SET [MRReference (selectsource-22)] = @istrNewMR,
							UpdatedBy = suser_sname(), UpdatedTime = getdate()
							where  [MRReference (selectsource-22)]  = @istrCurrentMR 
							AND [AccountNumber (textinput-5)] IN ( SELECT [value] FROM string_split(@istrAccounts,','))
						END
				END
			ELSE			/* To a different Dealer */
				BEGIN
					if (@istrAccounts = '(All)')
						BEGIN
							UPDATE CQBTempDB.export.Tb_FormData_1409 SET [MRReference (selectsource-22)] = @istrNewMR,
							[DealerCode (selectsource-21)] = @NewDealer, UpdatedBy = suser_sname(), UpdatedTime = getdate()
							where  [MRReference (selectsource-22)]  = @istrCurrentMR

						END
					ELSE
						BEGIN
							UPDATE CQBTempDB.export.Tb_FormData_1409 SET [MRReference (selectsource-22)] = @istrNewMR,
							[DealerCode (selectsource-21)] = @NewDealer, UpdatedBy = suser_sname(), UpdatedTime = getdate()
							where  [MRReference (selectsource-22)]  = @istrCurrentMR
							AND [AccountNumber (textinput-5)] IN ( SELECT [value] FROM string_split(@istrAccounts,','))
						END
					
				END

		END
	ELSE IF ( ISNULL(@istrCurrentMR,'') != '' AND ISNULL(@istrNewDealer,'') != '' ) /* MR1 => D2 */
		BEGIN
			if(@istrAccounts = '(All)')
				BEGIN
					UPDATE CQBTempDB.export.Tb_FormData_1575 SET 
					[DealerCode (selectsource-1)] = @istrNewDealer,
					UpdatedBy = suser_sname(),
					UpdatedTime = getdate()
					WHERE [MRCode (textinput-17)] = @istrCurrentMR

					UPDATE CQBTempDB.export.Tb_FormData_1409 SET
					[DealerCode (selectsource-21)] = @istrNewDealer,
					UpdatedBy = suser_sname(),
					UpdatedTime = getdate()
					where  [MRReference (selectsource-22)]  = @istrCurrentMR
				END
			ELSE
				BEGIN
					UPDATE CQBTempDB.export.Tb_FormData_1575 SET 
					[DealerCode (selectsource-1)] = @istrNewDealer,
					UpdatedBy = suser_sname(),
					UpdatedTime = getdate()
					WHERE [MRCode (textinput-17)] = @istrCurrentMR

					UPDATE CQBTempDB.export.Tb_FormData_1409 SET
					[DealerCode (selectsource-21)] = @istrNewDealer,
					UpdatedBy = suser_sname(),
					UpdatedTime = getdate()
					where  [MRReference (selectsource-22)]  = @istrCurrentMR
					AND [AccountNumber (textinput-5)] IN ( SELECT [value] FROM string_split(@istrAccounts,','))

					UPDATE CQBTempDB.export.Tb_FormData_1409 SET
					[MRReference (selectsource-22)] = '',
					UpdatedBy = suser_sname(),
					UpdatedTime = getdate()
					where  [MRReference (selectsource-22)]  = @istrCurrentMR
					AND [AccountNumber (textinput-5)] NOT IN ( SELECT [value] FROM string_split(@istrAccounts,','))

				END
		END



	END TRY
	BEGIN CATCH
		EXECUTE GlobalBO.utilities.usp_RethrowError ',usp_BulkRemisierChange'
	END CATCH

	SET NOCOUNT OFF
END