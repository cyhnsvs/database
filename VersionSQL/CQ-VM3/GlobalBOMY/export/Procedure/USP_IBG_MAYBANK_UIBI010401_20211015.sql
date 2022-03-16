/****** Object:  Procedure [export].[USP_IBG_MAYBANK_UIBI010401_20211015]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_IBG_MAYBANK_UIBI010401_20211015]
(
	@idteProcessDate DATETIME
)
AS
BEGIN
	
	SET NOCOUNT ON;

	-- Header Record Type
	CREATE TABLE #HeaderRecordType
	(
		Recordtype CHAR(1),
		ClientCode CHAR(20),
		PIRReferenceNo CHAR(20),
		Processingreal_time_batch CHAR(1),
		TestingACverificationindicator CHAR(1),
		ConfidentialIndicator CHAR(1),
		FileUploadDate DATE,
		FilePaymentDate DATE,
		FileRemarks CHAR(40),
		CMSReturnedBatchID CHAR(20),
		Filler VARCHAR(MAX)
	)

	INSERT INTO #HeaderRecordType
	(
		Recordtype,
		ClientCode,
		PIRReferenceNo,
		Processingreal_time_batch,
		TestingACverificationindicator,
		ConfidentialIndicator,
		FileUploadDate,
		FilePaymentDate,
		FileRemarks,
		CMSReturnedBatchID,
		Filler
	)

	SELECT 
	'H',
	'',
	'',
	'',
	'',
	'',
	CONVERT(varchar,@idteProcessDate,112) as [YYYYMMDD],
	CONVERT(varchar,@idteProcessDate,112) as [YYYYMMDD],
	'',
	'',
	''
	FROM GlobalBO.contracts.Tb_Contract

	-- Detail Record Type

	CREATE TABLE #DetailRecordType
	(
		Recordtype CHAR(1),
		CompanyTranNo CHAR(20),
		CustomerProduct CHAR(10),
		Paymentmode CHAR(10),
		TransactionAmount VARCHAR(15),
		Debitaccountnumber CHAR(20),
		Debitreference CHAR(14),
		Debitdescription CHAR(40),
		PaymentDate DATE,
		InvoiceDate DATE,
		BankCodeindicator CHAR(1),
		Receivingbankcode CHAR(11),
		Beneficiary_Creditaccountnumber VARCHAR(20),
		Nameofbeneficiary CHAR(40),
		BeneficiaryNewIC VARCHAR(15),
		BeneficiaryOldIC CHAR(8),
		BeneficiaryBusinessRegistrationNo CHAR(20),
		BeneficiaryPolice_ArmyID_PassportNo CHAR(20),
		Beneficiarynon_residentIndicator_Y_N CHAR(1),
		Purposecode CHAR(2),
		FormP_Rno CHAR(20),
		Byorderof CHAR(40),
		Creditreferenceorinvoicenumber CHAR(45),
		CreditDescription CHAR(140),
		COcollectioninstruction VARCHAR(1),
		COdraweebranch VARCHAR(4),
		COcollectionbranch VARCHAR(4),
		COauthorisedperson_Name CHAR(40),
		COauthorisedperson_IC CHAR(15),
		COmailingaddressline1 CHAR(30),
		COmailingaddressline2 CHAR(30),
		COmailingaddressline3 CHAR(30),
		COmailingaddressline4 CHAR(30),
		COmailingpostcode VARCHAR(5),
		COmailingcity CHAR(60),
		COmailingstate CHAR(60),
		COmailingcountry CHAR(60),
		Chargesborneby CHAR(1),
		COAdviceLayout CHAR(20),
		InstrumentDate DATE,
		InstrumentMICRNumber VARCHAR(6),
		MCFundingAC CHAR(20),
		AddendaRecordLayout CHAR(1),
		AddendaRecord_foradvice VARCHAR(7),
		BeneficiaryCode CHAR(10),
		BeneficiaryBranch CHAR(10),
		BeneficiaryEmail CHAR(40),
		BeneficiaryFax CHAR(40),
		MBBReturnedTransactionNumber CHAR(20),
		MBBReturnedTransactionStatusCode CHAR(2),
		MBBReturnedErrorCode CHAR(8),
		MBBReturnedReason CHAR(40),
		Filler VARCHAR(MAX)
	)

	INSERT INTO #DetailRecordType
	(
		Recordtype,
		CompanyTranNo,
		CustomerProduct,
		Paymentmode,
		TransactionAmount,
		Debitaccountnumber,
		Debitreference,
		Debitdescription,
		PaymentDate,
		InvoiceDate,
		BankCodeindicator,
		Receivingbankcode,
		Beneficiary_Creditaccountnumber,
		Nameofbeneficiary,
		BeneficiaryNewIC,
		BeneficiaryOldIC,
		BeneficiaryBusinessRegistrationNo,
		BeneficiaryPolice_ArmyID_PassportNo,
		Beneficiarynon_residentIndicator_Y_N,
		Purposecode,
		FormP_Rno,
		Byorderof,
		Creditreferenceorinvoicenumber,
		CreditDescription,
		COcollectioninstruction,
		COdraweebranch,
		COcollectionbranch,
		COauthorisedperson_Name,
		COauthorisedperson_IC,
		COmailingaddressline1,
		COmailingaddressline2,
		COmailingaddressline3,
		COmailingaddressline4,
		COmailingpostcode,
		COmailingcity,
		COmailingstate,
		COmailingcountry,
		Chargesborneby,
		COAdviceLayout,
		InstrumentDate,
		InstrumentMICRNumber,
		MCFundingAC,
		AddendaRecordLayout,
		AddendaRecord_foradvice,
		BeneficiaryCode,
		BeneficiaryBranch,
		BeneficiaryEmail,
		BeneficiaryFax,
		MBBReturnedTransactionNumber,
		MBBReturnedTransactionStatusCode,
		MBBReturnedErrorCode,
		MBBReturnedReason,
		Filler
	)
	SELECT 
	'D',
	TTS.ContractNo,
	'PAYMENT',
	'',
	TTS.NetAmountSetl,
	TTS.AcctNo,
	'',
	'',
	CONVERT(varchar,@idteProcessDate,112) as [YYYYMMDD],
	CONVERT(varchar,TTS.ContractDate,112) as [YYYYMMDD],
	'',
	GR6.[Bank (Dropdown)],
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	''
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled TTS 
	LEFT JOIN CQBTempDB.export.Tb_FormData_1409 ACCOUNT ON TTS.AcctNo = ACCOUNT.[AccountNumber (textinput-5)]
	LEFT JOIN CQBTEMPDB.EXPORT.TB_FORMDATA_1410 CUSTOMER ON ACCOUNT.[CustomerID (selectsource-1)] = CUSTOMER.[CustomerID (textinput-1)]
	LEFT JOIN CQBTEMPDB.[export].[Tb_FormData_1410_grid6] GR6 ON CUSTOMER.RecordID = GR6.RecordID

	-- Trailer Record Type

	CREATE TABLE #TrailerRecordType
	(
		Recordtype CHAR(1),
		Totalitem VARCHAR(5),
		Totalamount VARCHAR(15),
		Hashtotal VARCHAR(15),
		Totalitemsuccessful VARCHAR(5),
		Totalitemrejected VARCHAR(5),
		Totalsuccessfulamount VARCHAR(15),
		Totalrejectedamount VARCHAR(15),
		Filler VARCHAR(MAX)
	)
	INSERT INTO #TrailerRecordType
	(
		Recordtype,
		Totalitem,
		Totalamount,
		Hashtotal,
		Totalitemsuccessful,
		Totalitemrejected,
		Totalsuccessfulamount,
		Totalrejectedamount,
		Filler
	)
	SELECT 
	'T',
	'',
	'',
	'',
	'',
	'',
	'',
	'',
	''
	FROM GlobalBO.contracts.Tb_Contract


	--RESULT SET 
		

		
	SELECT Recordtype +''+ ClientCode +''+ PIRReferenceNo +''+ Processingreal_time_batch +''+ TestingACverificationindicator
	+''+ ConfidentialIndicator +''+ FileUploadDate +''+ FilePaymentDate +''+ FileRemarks +''+ CMSReturnedBatchID +''+ Filler
	FROM #HeaderRecordType
	
	UNION

	SELECT Recordtype +''+ CompanyTranNo +''+ CustomerProduct +''+ Paymentmode +''+ TransactionAmount +''+ Debitaccountnumber +''+ 
		Debitreference +''+ Debitdescription +''+ PaymentDate +''+ InvoiceDate +''+ BankCodeindicator +''+ Receivingbankcode +''+ 
		Beneficiary_Creditaccountnumber +''+ Nameofbeneficiary +''+ BeneficiaryNewIC +''+ BeneficiaryOldIC +''+ BeneficiaryBusinessRegistrationNo +''+ 
		BeneficiaryPolice_ArmyID_PassportNo +''+ Beneficiarynon_residentIndicator_Y_N +''+ Purposecode +''+ FormP_Rno +''+ Byorderof +''+ 
		Creditreferenceorinvoicenumber +''+ CreditDescription +''+ COcollectioninstruction +''+ COdraweebranch +''+ 
		COcollectionbranch +''+ COauthorisedperson_Name +''+ COauthorisedperson_IC +''+ COmailingaddressline1 +''+ COmailingaddressline2 +''+ 
		COmailingaddressline3 +''+ COmailingaddressline4 +''+ COmailingpostcode +''+ COmailingcity +''+ COmailingstate +''+ 
		COmailingcountry +''+ Chargesborneby +''+ COAdviceLayout +''+ InstrumentDate +''+ InstrumentMICRNumber +''+ 
		MCFundingAC +''+ AddendaRecordLayout +''+ AddendaRecord_foradvice +''+ BeneficiaryCode +''+ BeneficiaryBranch +''+ 
		BeneficiaryEmail +''+ BeneficiaryFax +''+ MBBReturnedTransactionNumber +''+ MBBReturnedTransactionStatusCode +''+ 
		MBBReturnedErrorCode +''+ MBBReturnedReason +''+ Filler
		FROM #DetailRecordType

     UNION

	 SELECT Recordtype +''+ Totalitem +''+ Totalamount +''+ Hashtotal +''+ Totalitemsuccessful +''+ Totalitemrejected +''+ 
		Totalsuccessfulamount +''+ Totalrejectedamount +''+ Filler
		FROM #TrailerRecordType


END