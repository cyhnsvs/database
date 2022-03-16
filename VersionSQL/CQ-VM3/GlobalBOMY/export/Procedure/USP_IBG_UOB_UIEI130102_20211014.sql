/****** Object:  Procedure [export].[USP_IBG_UOB_UIEI130102_20211014]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_IBG_UOB_UIEI130102_20211014]
(
	@idteProcessDate DATETIME
)
AS
BEGIN
	
	SET NOCOUNT ON;
	CREATE TABLE #FILECONTROLHEADER
	(
		RecordType			CHAR(1),
		FileName			CHAR(10),
		FileCreationDate	DATE,
		FileCreationTime	TIME,
		CompanyID			CHAR(12),
		CheckSummary		CHAR(15),
		CompanyID_CIF		CHAR(19),
		Filler				CHAR(1731)
	)

	INSERT INTO #FILECONTROLHEADER
	(
		RecordType,
		FileName,
		FileCreationDate,
		FileCreationTime,
		CompanyID,
		CheckSummary,
		CompanyID_CIF,
		Filler
	)
	SELECT 
	'0',
	'UIEI' + CONVERT(varchar,@idteProcessDate,6) as [DD MM],
	 CONVERT(varchar,@idteProcessDate,12) as [YYMMDD],
	 CONVERT(varchar,@idteProcessDate,14) as [HH:MM:SS],
	 '',
	 '',
	 '',
	 ''
	
	CREATE TABLE #BATCHHEADER 
	(
		RecordType CHAR(1),
		ServiceType CHAR(10),
		OriginatingBankCode CHAR(4),
		OriginatingBranchCode CHAR(3),
		OriginatingAccountNo CHAR(11),
		OriginatingACName CHAR(20),
		CreationDate DATE,
		ValueDate DATE,
		ROSReferenceNo CHAR(5),
		Filler CHAR(10),
		Batchnumber CHAR(20),
		PaymentAdviceHeaderLine1 CHAR(105),
		PaymentAdviceHeaderLine2 CHAR(105),
		Filler_1 CHAR(1492)
	)

	INSERT INTO #BATCHHEADER
	(
		RecordType,
		ServiceType,
		OriginatingBankCode,
		OriginatingBranchCode,
		OriginatingAccountNo,
		OriginatingACName,
		CreationDate,
		ValueDate,
		ROSReferenceNo,
		Filler,
		Batchnumber,
		PaymentAdviceHeaderLine1,
		PaymentAdviceHeaderLine2,
		Filler_1
	)
	SELECT 
	'1',
	'IBGINORM',
	GR6.[Bank (Dropdown)],
	1,
	ACCOUNT.[AccountNumber (textinput-5)],
	CUSTOMER.[CustomerName (textinput-3)],
	CONVERT(varchar,ACCOUNT.CreatedTime,12) as [YYMMDD],	
	'',
	'',
	'',
	'',
	1,
	1,
	1
	FROM CQBTempDB.export.Tb_FormData_1409 ACCOUNT
	LEFT JOIN CQBTEMPDB.EXPORT.TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)] = CUSTOMER.[CustomerID (textinput-1)]
	LEFT JOIN CQBTEMPDB.[export].[Tb_FormData_1410_grid6] GR6 ON CUSTOMER.[CustomerName (textinput-3)] = GR6.[Account Holder Name (TextBox)]
	
	CREATE TABLE #BATCHDETAIL
	(
		RecordType CHAR(1),
		ReceivingBankCode CHAR(3),
		ReceivingBranchCode CHAR(3),
		ReceivingAccountNo CHAR(17),
		ReceivingACName CHAR(20),
		TransactionCode CHAR(2),
		Amount DECIMAL(9,2),
		Filler CHAR(24),
		IDverificationindicator CHAR(1),
		IDtype CHAR(1),
		IDNumber CHAR(20),
		Otherpaymentdetails CHAR(20),
		Recipientsreference CHAR(20),
		PrintPaymentAdviceIndicator CHAR(1),
		DeliveryMode CHAR(1),
		AdviceFormat CHAR(1),
		BeneficiaryID CHAR(20),
		BeneficiaryName_line1 CHAR(35),
		BeneficiaryName_line2 CHAR(35),
		BeneficiaryName_line3 CHAR(35),
		BeneficiaryName_line4 CHAR(35),
		BeneficiaryAddress_line_1_5 CHAR(35),
		BeneficiaryAddress_line_2 CHAR(35),
		BeneficiaryAddress_line_3 CHAR(35),
		BeneficiaryAddress_line_4 CHAR(35),
		BeneficiaryCity CHAR(17),
		BeneficiaryCountryCode CHAR(3),
		BeneficiaryPostalCode CHAR(15),
		EmailAddressofBeneficiary CHAR(50),
		FacsimileNumberofBeneficiary CHAR(20),
		PaymentCurrency CHAR(3),
		PayersName_Line_1 CHAR(35),
		PayersName_Line_2 CHAR(35),
		CustomersPayerreferencenumber CHAR(30),
		Filler1 CHAR(1),
		BeneficiaryResidentindicator CHAR(1),
		PurposeCode CHAR(5),
		ReasonofPayment CHAR(60),
		Transactorrelationship CHAR(1),
		BeneficiaryOriginCountry CHAR(5),
		ApprovalCode CHAR(20),
		Filler_1 CHAR(1054)
	)

	INSERT INTO #BATCHDETAIL
	(
		RecordType,
		ReceivingBankCode,
		ReceivingBranchCode,
		ReceivingAccountNo,
		ReceivingACName,
		TransactionCode,
		Amount,
		Filler,
		IDverificationindicator,
		IDtype,
		IDNumber,
		Otherpaymentdetails,
		Recipientsreference,
		PrintPaymentAdviceIndicator,
		DeliveryMode,
		AdviceFormat,
		BeneficiaryID,
		BeneficiaryName_line1,
		BeneficiaryName_line2,
		BeneficiaryName_line3,
		BeneficiaryName_line4,
		BeneficiaryAddress_line_1_5,
		BeneficiaryAddress_line_2,
		BeneficiaryAddress_line_3,
		BeneficiaryAddress_line_4,
		BeneficiaryCity,
		BeneficiaryCountryCode,
		BeneficiaryPostalCode,
		EmailAddressofBeneficiary,
		FacsimileNumberofBeneficiary,
		PaymentCurrency,
		PayersName_Line_1,
		PayersName_Line_2,
		CustomersPayerreferencenumber,
		Filler,
		BeneficiaryResidentindicator,
		PurposeCode,
		ReasonofPayment,
		Transactorrelationship,
		BeneficiaryOriginCountry,
		ApprovalCode,
		Filler_1
	)
	SELECT 
	'2',
	GR6.[Bank (Dropdown)],
	'000',
	ACCOUNT.[AccountNumber (textinput-5)],
	[CustomerName (textinput-3)],
	'',
	TTS.NetAmountSetl,
	'',
	'Y',
	CUSTOMER.[IDType (selectsource-1)],
	CUSTOMER.[IDNumber (textinput-5)],
	'',
	TTS.ContractNo,
	'Y',
	'E',
	'2',
	CUSTOMER.[IDNumber (textinput-5)],
	CUSTOMER.[CustomerName (textinput-3)],
	'',
	'',
	'',
	CUSTOMER.[Address1 (textinput-35)],
	CUSTOMER.[Address2 (textinput-36)],
	CUSTOMER.[Address3 (textinput-37)],
	CUSTOMER.[Address1 (textinput-41)],
	CUSTOMER.[State (textinput-39)],
	CUSTOMER.[Country (selectsource-27)],
	CUSTOMER.[Postcode (textinput-46)],
	CUSTOMER.[Email (textinput-58)],
	'',
	'MYR',
	'MYRMALACCA SECURITIES',
	'',
	'',
	'',
	'Y',
	1,
	TTS.TransDesc,
	'N',
	'',
	'',
	''
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled TTS 
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 ACCOUNT ON TTS.AcctNo = ACCOUNT.[AccountNumber (textinput-5)]
	LEFT JOIN CQBTEMPDB.EXPORT.TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)] = CUSTOMER.[CustomerID (textinput-1)]
	LEFT JOIN CQBTEMPDB.[export].[Tb_FormData_1410_grid6] GR6 ON CUSTOMER.RecordID = GR6.RecordID

	CREATE TABLE #PAYMENTADVICEFORMAT
	(
		RecordType CHAR(1),
		SpacingLines CHAR(2),
		PaymentAdviceDetails CHAR(105),
		Filler CHAR(1694)
	)

	INSERT INTO #PAYMENTADVICEFORMAT
	(
		RecordType,
		SpacingLines,
		PaymentAdviceDetails,
		Filler
	)
	SELECT 
	'4',
	'02',
	TTS.TransDesc,
	''
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled TTS

	CREATE TABLE #BATCHTRAILER
	(
		RecordType CHAR(1),
		TotalDebitAmount DECIMAL(11,2),
		TotalCreditAmount DECIMAL(11,2),
		TotalDebitCount CHAR(7),
		TotalCreditCount CHAR(7),
		Filler CHAR(1761)
	)

	INSERT INTO #BATCHTRAILER
	(
		RecordType,
		TotalDebitAmount,
		TotalCreditAmount,
		TotalDebitCount,
		TotalCreditCount,
		Filler
	)
	SELECT 
	'9',
	1,
	1,
	1,
	1,
	''
	FROM GlobalBO.contracts.Tb_Contract


	--RESULT TYPE

	SELECT RecordType +''+ FileName +''+ FileCreationDate +''+ FileCreationTime +''+ CompanyID +''+ CheckSummary +''+ 
		CompanyID_CIF +''+ Filler
		FROM #FILECONTROLHEADER

	UNION 

	SELECT RecordType +''+ ServiceType +''+ OriginatingBankCode +''+ OriginatingBranchCode +''+ OriginatingAccountNo +''+ 
		OriginatingACName +''+ CreationDate +''+ ValueDate +''+ ROSReferenceNo +''+ Filler +''+ Batchnumber +''+ PaymentAdviceHeaderLine1 +''+ 
		PaymentAdviceHeaderLine2 +''+ Filler_1
		FROM #BATCHHEADER

	UNION

	SELECT RecordType +''+ ReceivingBankCode +''+ ReceivingBranchCode +''+ ReceivingAccountNo +''+ ReceivingACName +''+ 
		TransactionCode +''+ Amount +''+ Filler +''+ IDverificationindicator +''+ IDtype +''+ IDNumber +''+ Otherpaymentdetails +''+ 
		Recipientsreference +''+ PrintPaymentAdviceIndicator +''+ DeliveryMode +''+ AdviceFormat +''+ BeneficiaryID +''+ 
		BeneficiaryName_line1 +''+ BeneficiaryName_line2 +''+ BeneficiaryName_line3 +''+ BeneficiaryName_line4 +''+ BeneficiaryAddress_line_1_5 +''+ 
		BeneficiaryAddress_line_2 +''+ BeneficiaryAddress_line_3 +''+ BeneficiaryAddress_line_4 +''+ BeneficiaryCity +''+ 
		BeneficiaryCountryCode +''+ BeneficiaryPostalCode  +''+ EmailAddressofBeneficiary +''+ FacsimileNumberofBeneficiary +''+ 
		PaymentCurrency +''+ PayersName_Line_1 +''+ PayersName_Line_2 +''+ CustomersPayerreferencenumber +''+ Filler +''+ 
		BeneficiaryResidentindicator +''+ PurposeCode +''+ ReasonofPayment +''+ Transactorrelationship +''+ BeneficiaryOriginCountry +''+ 
		ApprovalCode +''+ Filler_1
		FROM #BATCHDETAIL

	UNION

	SELECT RecordType +''+ SpacingLines +''+ PaymentAdviceDetails +''+ Filler FROM #PAYMENTADVICEFORMAT

	UNION 

	SELECT RecordType +''+ TotalDebitAmount +''+ TotalCreditAmount +''+ TotalDebitCount +''+ TotalCreditCount +''+ Filler
	FROM #BATCHTRAILER

END