/****** Object:  Procedure [export].[USP_IBG_MAYBANK_UIBI010401]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_IBG_MAYBANK_UIBI010401]
(
	@idteProcessDate DATETIME
)
--EXEC [export].[USP_IBG_MAYBANK_UIBI010401] '2021-10-01'
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
		FileUploadDate CHAR(8),
		FilePaymentDate CHAR(8),
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
	SELECT 'H', 'MYMSSBHD', 'PAYMENT' + REPLACE(CAST(@idteProcessDate as date),'-',''), 'B', '', '', '', '', '', '', ''

	-- Detail Record Type

	CREATE TABLE #DetailRecordType
	(
		IDD BIGINT IDENTITY, 
		Recordtype CHAR(1),
		CompanyTranNo CHAR(20),
		CustomerProduct CHAR(10),
		Paymentmode CHAR(10),
		TransactionAmount VARCHAR(15),
		Debitaccountnumber CHAR(20),
		Debitreference CHAR(14),
		Debitdescription CHAR(40),
		PaymentDate CHAR(8),
		InvoiceDate CHAR(8),
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
		InstrumentDate CHAR(8),
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
		Filler VARCHAR(MAX),
		AcctHash BIGINT,
		AmountHash BIGINT,
		Amount decimal(24,2),
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
		Filler,
		AcctHash,
		AmountHash,
		Amount
	)
	SELECT 
			'D' AS Recordtype,
			T.TransNo AS CompanyTranNo,
			'PAYMENT' AS CustomerProduct,
			'' AS Paymentmode,
			RIGHT(REPLICATE('0','15')+REPLACE(CAST(CAST(ABS(ROUND(T.Amount+T.TaxAmount,2)) as decimal(24,2)) as varchar(50)),'.',''), 15) AS TransactionAmount,
			'' AS Debitaccountnumber, --todo MAYBANKACCNO for msec
			'' AS Debitreference,
			T.AcctNo AS Debitdescription,
			CONVERT(varchar,CAST(@idteProcessDate as date),112) as PaymentDate,
			'' as InvoiceDate,
			'' as BankCodeindicator,
			Tag2 as Receivingbankcode,
			Tag4 as Beneficiary_Creditaccountnumber,
			C.[CustomerName (textinput-3)] AS Nameofbeneficiary,
			CASE WHEN [IDType (selectsource-1)]='NC' THEN REPLACE(C.[IDNumber (textinput-5)],'-','') ELSE '' END as BeneficiaryNewIC,
			CASE WHEN [AlternateIDType (selectsource-2)]='OC' THEN REPLACE(C.[AlternateIDNumber (textinput-6)],'-','') ELSE '' END  as BeneficiaryOldIC,
			CASE WHEN [IDType (selectsource-1)]='BR' THEN REPLACE(C.[IDNumber (textinput-5)],'-','') ELSE '' END as BeneficiaryBusinessRegistrationNo,
			CASE WHEN [IDType (selectsource-1)] IN ('PN','AC') THEN REPLACE(C.[IDNumber (textinput-5)],'-','') ELSE '' END as BeneficiaryPolice_ArmyID_PassportNo,
			'' AS Beneficiarynon_residentIndicator_Y_N,
			'' as Purposecode,
			'' as FormP_Rno,
			'' as Byorderof,
			T.TransNo as Creditreferenceorinvoicenumber,
			T.AcctNo as CreditDescription,
			'' as COcollectioninstruction,
			'' as COdraweebranch,
			'' as COcollectionbranch,
			'' as COauthorisedperson_Name,
			'' as COauthorisedperson_IC,
			'' as COmailingaddressline1,
			'' as COmailingaddressline2,
			'' as COmailingaddressline3,
			'' as COmailingaddressline4,
			'' as COmailingpostcode,
			'' as COmailingcity,
			'' as COmailingstate,
			'' as COmailingcountry,
			'' as Chargesborneby,
			'' as COAdviceLayout,
			'' as InstrumentDate,
			'' as InstrumentMICRNumber,
			'' as MCFundingAC,
			'' as AddendaRecordLayout,
			'' as AddendaRecord_foradvice,
			'' as BeneficiaryCode,
			'' as BeneficiaryBranch,
			'' as BeneficiaryEmail,
			'' as BeneficiaryFax,
			'' as MBBReturnedTransactionNumber,
			'' as MBBReturnedTransactionStatusCode,
			'' as MBBReturnedErrorCode,
			'' as MBBReturnedReason,
			'' as Filler,
			--CASE WHEN ISNUMERIC(LEFT(REVERSE(T.Tag4),6)) = 1 THEN LEFT(REVERSE(T.Tag4),6) ELSE 0 END AS AcctHash,
			(CAST(RIGHT(T.Tag4,1) as bigint) + CAST(LEFT(RIGHT(T.Tag4,2),1) as bigint) + CAST(LEFT(RIGHT(T.Tag4,3),1) as bigint) 
			+ CAST(LEFT(RIGHT(T.Tag4,4),1) as bigint) + CAST(LEFT(RIGHT(T.Tag4,5),1) as bigint) + CAST(LEFT(RIGHT(T.Tag4,6),1) as bigint)) * 2 AS AcctHash,
			REPLACE(CAST(ABS(ROUND(T.Amount+T.TaxAmount,2)) as decimal(24,2)),'.','') % 2000 AS AmountHash,
			ABS(ROUND(T.Amount+T.TaxAmount,2)) AS Amount
	FROM GlobalBO.transmanagement.Tb_Transactions AS T
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
		ON T.RecordId = TA.ReferenceID AND TA.AppLevel='3' AND TA.AppStatus='A'
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON T.AcctNo = A.[AccountNumber (textinput-5)]
	LEFT JOIN CQBTempDB.export.Tb_FormData_1410 C 
		ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
	WHERE TransType = 'CHWD' AND TransDesc LIKE 'Auto Withdrawal from ECOS%';

	--select distinct [IDType (selectsource-1)] from CQBTempDB.export.Tb_FormData_1410 

	--LEFT JOIN CQBTEMPDB.[export].[Tb_FormData_1410_grid6] GR6 ON CUSTOMER.RecordID = GR6.RecordID

	--select * from GlobalBOMY.import.Tb_ECOS_WithdrawalInfo;

	--select * FROM GlobalBO.transmanagement.Tb_Transactions AS T
	--INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
	--	ON T.RecordId = TA.ReferenceID AND TA.AppLevel='3' AND TA.AppStatus='A'
	--WHERE TransType = 'CHWD' AND TransDesc LIKE 'Auto Withdrawal from ECOS%'

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
	SELECT 'T' as Recordtype, 
			(SELECT COUNT(1) FROM #DetailRecordType) as Totalitem, 
			(SELECT REPLACE(SUM(Amount),'.','') FROM #DetailRecordType) as Totalamount, 
			(SELECT SUM(AcctHash + AmountHash + IDD + IDD) FROM #DetailRecordType) as Hashtotal,
			'' as Totalitemsuccessful, 
			'' as Totalitemrejected, 
			'' as Totalsuccessfulamount, 
			'' as Totalrejectedamount, 
			'' as Filler;

	SELECT * FROM #HeaderRecordType;
	SELECT * FROM #DetailRecordType;
	SELECT * FROM #TrailerRecordType;

	--RESULT SET 
	SELECT H
	FROM 
	(
		SELECT '1' as seq, Recordtype +''+ ClientCode +''+ PIRReferenceNo +''+ Processingreal_time_batch +''+ TestingACverificationindicator
				+''+ ConfidentialIndicator +''+ FileUploadDate +''+ FilePaymentDate  +''+ FileRemarks +''+ CMSReturnedBatchID +''+ Filler AS H
		FROM #HeaderRecordType
	
		UNION

		SELECT '2' as seq, Recordtype +''+ CompanyTranNo +''+ CustomerProduct +''+ Paymentmode +''+ TransactionAmount +''+ Debitaccountnumber +''+ 
			Debitreference +''+ Debitdescription +''+ PaymentDate +''+ InvoiceDate +''+ 
			BankCodeindicator +''+ Receivingbankcode +''+ Beneficiary_Creditaccountnumber +''+ Nameofbeneficiary +''+ BeneficiaryNewIC +''+ BeneficiaryOldIC +''+ 
			BeneficiaryBusinessRegistrationNo +''+ BeneficiaryPolice_ArmyID_PassportNo +''+ Beneficiarynon_residentIndicator_Y_N +''+ Purposecode +''+ FormP_Rno +''+ 
			Byorderof +''+ Creditreferenceorinvoicenumber +''+ CreditDescription +''+ COcollectioninstruction +''+ COdraweebranch +''+ 
			COcollectionbranch +''+ COauthorisedperson_Name +''+ COauthorisedperson_IC +''+ COmailingaddressline1 +''+ COmailingaddressline2 +''+ 
			COmailingaddressline3 +''+ COmailingaddressline4 +''+ COmailingpostcode +''+ COmailingcity +''+ COmailingstate +''+ 
			COmailingcountry +''+ Chargesborneby +''+ COAdviceLayout +''+ InstrumentDate +''+ InstrumentMICRNumber +''+ 
			MCFundingAC +''+ AddendaRecordLayout +''+ AddendaRecord_foradvice +''+ BeneficiaryCode +''+ BeneficiaryBranch +''+ 
			BeneficiaryEmail +''+ BeneficiaryFax +''+ MBBReturnedTransactionNumber +''+ MBBReturnedTransactionStatusCode +''+ 
			MBBReturnedErrorCode +''+ MBBReturnedReason +''+ Filler AS D
		FROM #DetailRecordType

		 UNION

		 SELECT '3' as seq, Recordtype +''+ Totalitem +''+ Totalamount +''+ Hashtotal +''+ Totalitemsuccessful +''+ Totalitemrejected +''+ 
			Totalsuccessfulamount +''+ Totalrejectedamount +''+ Filler AS T
		FROM #TrailerRecordType
	) AS T;

	DROP TABLE #DetailRecordType;
	DROP TABLE #HeaderRecordType;
	DROP TABLE #TrailerRecordType;

END