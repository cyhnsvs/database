/****** Object:  Procedure [export].[USP_IBG_UOB_UIEI130102]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_IBG_UOB_UIEI130102]
(
	@idteProcessDate DATETIME
)
AS
--EXEC [export].[USP_IBG_UOB_UIEI130102] '2021-10-04 18:00:00'
BEGIN
	
	SET NOCOUNT ON;
	
	--DECLARE @idteProcessDate DATETIME = '2021-10-04 18:00:00'
	DECLARE @dteNextProcessDate DATE = @idteProcessDate;

	CREATE TABLE #FILECONTROLHEADER
	(
		RecordType			CHAR(1),
		FileName			CHAR(10),
		FileCreationDate	CHAR(8),
		FileCreationTime	CHAR(6),
		CompanyID			CHAR(12),
		CheckSummary		CHAR(15),
		CompanyID_CIF		CHAR(19),
		Filler				CHAR(1731)
	);

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
		'0' as RecordType,
		'UIEI' + LEFT(REPLACE(CONVERT(varchar,@idteProcessDate,4),'.',''),4)+'01' as FileName,
		 REPLACE(CONVERT(varchar,@idteProcessDate,12),'.','') as FileCreationDate,
		 LEFT(REPLACE(CONVERT(varchar,@idteProcessDate,14),':',''),6) as FileCreationTime,
		 'MALSECSDNBHD' as CompanyID,
		 '' as CheckSummary,
		 'MALSECSDNBHD' as CompanyID_CIF,
		 '' as Filler;
	
	CREATE TABLE #BATCHHEADER 
	(
		RecordType CHAR(1),
		ServiceType CHAR(10),
		OriginatingBankCode CHAR(4),
		OriginatingBranchCode CHAR(3),
		OriginatingAccountNo CHAR(11),
		OriginatingACName CHAR(20),
		CreationDate CHAR(8),
		ValueDate CHAR(8),
		ROSReferenceNo CHAR(5),
		Filler CHAR(10),
		Batchnumber CHAR(20),
		PaymentAdviceHeaderLine1 CHAR(105),
		PaymentAdviceHeaderLine2 CHAR(105),
		Filler_1 CHAR(1492)
	);

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
		'1' as RecordType,
		'IBGINORM' as ServiceType,
		'0226' as OriginatingBankCode,
		'000' as OriginatingBranchCode,
		'1983020394' as OriginatingAccountNo,
		'MALACCA SECURITIES' as OriginatingACName,
		REPLACE(CAST(@idteProcessDate as date),'-','') as CreationDate,	
		REPLACE(CAST(@dteNextProcessDate as date),'-','') as ValueDate,
		'' as ROSReferenceNo,
		'' as Filler,
		'' as Batchnumber,
		'' as PaymentAdviceHeaderLine1,
		'' as PaymentAdviceHeaderLine2,
		'' as Filler_1;

	CREATE TABLE #BATCHDETAIL
	(
		IDD BIGINT IDENTITY,
		RecordType CHAR(1),
		ReceivingBankCode CHAR(4),
		ReceivingBranchCode CHAR(3),
		ReceivingAccountNo CHAR(17),
		ReceivingACName CHAR(20),
		TransactionCode CHAR(2),
		Amount CHAR(11),
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
		Filler2 CHAR(1054),
		TransAmount DECIMAL(28,9)
	);

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
		Filler1,
		BeneficiaryResidentindicator,
		PurposeCode,
		ReasonofPayment,
		Transactorrelationship,
		BeneficiaryOriginCountry,
		ApprovalCode,
		Filler2,
		TransAmount
	)
	SELECT 
		'2' AS RecordType,
		T.Tag3 AS ReceivingBankCode,
		'000' AS ReceivingBranchCode,
		T.Tag4 AS ReceivingAccountNo,
		LEFT(UPPER(C.[CustomerName (textinput-3)]),20) AS ReceivingACName,
		'24' AS TransactionCode,
		RIGHT(REPLICATE('0','11')+REPLACE(CAST(CAST(ABS(ROUND(T.Amount+T.TaxAmount,2)) as decimal(24,2)) as varchar(50)),'.',''), 11) AS Amount,
		'' AS Filler,
		'Y' AS IDverificationindicator,
		REPLACE(LEFT([IDType (selectsource-1)],1),'P','T') AS IDtype,
		REPLACE([IDNumber (textinput-5)],'-','') AS IDNumber,
		'' AS Otherpaymentdetails, --todo
		T.TransNo AS Recipientsreference,
		'Y' AS PrintPaymentAdviceIndicator,
		'E' AS DeliveryMode,
		'2' AS AdviceFormat,
		T.AcctNo AS BeneficiaryID,
		LEFT(UPPER(C.[CustomerName (textinput-3)]),35) AS BeneficiaryName_line1,
		CASE WHEN LEN(UPPER(C.[CustomerName (textinput-3)])) > 35 
			 THEN LEFT(SUBSTRING(UPPER(C.[CustomerName (textinput-3)]),36,LEN(C.[CustomerName (textinput-3)])),35) ELSE '' END AS BeneficiaryName_line2,
		'' AS BeneficiaryName_line3,
		'' AS BeneficiaryName_line4,
		LEFT(C.[Address1 (textinput-41)],35) AS BeneficiaryAddress_line_1_5,
		C.[Address2 (textinput-42)] AS BeneficiaryAddress_line_2,
		C.[Address3 (textinput-43)] AS BeneficiaryAddress_line_3,
		C.[State (selectsource-26)] AS BeneficiaryAddress_line_4,
		C.[Town (textinput-38)] AS BeneficiaryCity,
		C.[Country (selectsource-27)] AS BeneficiaryCountryCode,
		C.[Postcode (textinput-46)] AS BeneficiaryPostalCode,
		ISNULL(NULLIF(C.[Email (textinput-58)],''),'ibgmsec@gmail.com') AS EmailAddressofBeneficiary,
		'' AS FacsimileNumberofBeneficiary,
		'MYR' AS PaymentCurrency,
		'MALACCA SECURITIES' AS PayersName_Line_1,
		'' AS PayersName_Line_2,
		'' AS CustomersPayerreferencenumber,
		'' AS Filler,
		'Y' AS BeneficiaryResidentindicator,
		'' AS PurposeCode,
		'SALES PROCEED AND CONTRA GAIN' AS ReasonofPayment,
		'N' AS Transactorrelationship,
		'' AS BeneficiaryOriginCountry,
		'' AS ApprovalCode,
		'' AS Filler2,
		CAST(ABS(ROUND(T.Amount+T.TaxAmount,2)) as decimal(24,2)) AS TransAmount
	FROM GlobalBO.transmanagement.Tb_Transactions AS T
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionApproval AS TA
		ON T.RecordId = TA.ReferenceID AND TA.AppLevel='3' AND TA.AppStatus='A'
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON T.AcctNo = A.[AccountNumber (textinput-5)]
	LEFT JOIN CQBTempDB.export.Tb_FormData_1410 C 
		ON A.[CustomerID (selectsource-1)] = C.[CustomerID (textinput-1)]
	WHERE TransType = 'CHWD' AND TransDesc LIKE 'Auto Payment for Sales via IBG%' AND T.SetlDate = @dteNextProcessDate AND T.Tag3 <> ''
	--GROUP BY CASE WHEN A.[ParentGroup (selectsource-3)] = 'G' THEN A.[Financier (selectsource-25)] ELSE T.AcctNo END;

	CREATE TABLE #PAYMENTADVICEFORMAT
	(
		BatchDetailIDD BIGINT,
		RecordType CHAR(1),
		SpacingLines CHAR(2),
		PaymentAdviceDetails CHAR(105),
		Filler CHAR(1694)
	);

	INSERT INTO #PAYMENTADVICEFORMAT
	(
		BatchDetailIDD,
		RecordType,
		SpacingLines,
		PaymentAdviceDetails,
		Filler
	)
	SELECT IDD, '4' AS RecordType, '02' AS SpacingLines, 'IBG PAYMENT FOR SALES PROCEED AND CONTRA GAIN' AS PaymentAdviceDetails, '' AS Filler
	FROM #BATCHDETAIL;

	CREATE TABLE #BATCHTRAILER
	(
		RecordType CHAR(1),
		TotalDebitAmount CHAR(13),
		TotalCreditAmount CHAR(13),
		TotalDebitCount CHAR(7),
		TotalCreditCount CHAR(7),
		Filler CHAR(1761)
	);

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
		'9' AS RecordType,
		REPLICATE('0',13) AS TotalDebitAmount,
		REPLACE((SELECT CAST(ROUND(SUM(TransAmount),2) as decimal(13,2)) FROM #BATCHDETAIL),'.','') AS TotalCreditAmount,
		REPLICATE('0',7) AS TotalDebitCount,
		(SELECT COUNT(1) FROM #BATCHDETAIL) AS TotalCreditCount,
		'' AS Filler;

	--RESULT TYPE
	SELECT H 
	FROM 
	(
		SELECT 0 as seq, 0 AS IDD, RecordType, RecordType +''+ FileName +''+ FileCreationDate +''+ FileCreationTime +''+ CompanyID +''+ CheckSummary +''+ 
			CompanyID_CIF +''+ Filler AS H
		FROM #FILECONTROLHEADER

		UNION ALL

		SELECT 1 as seq, 0 IDD, RecordType, RecordType +''+ ServiceType +''+ OriginatingBankCode +''+ OriginatingBranchCode +''+ OriginatingAccountNo +''+ 
			OriginatingACName +''+ CreationDate +''+ ValueDate +''+ ROSReferenceNo +''+ Filler +''+ Batchnumber +''+ PaymentAdviceHeaderLine1 +''+ 
			PaymentAdviceHeaderLine2 +''+ Filler_1 AS BH
		FROM #BATCHHEADER

		UNION ALL

		SELECT 2 as seq, IDD, RecordType, RecordType +''+ ReceivingBankCode +''+ ReceivingBranchCode +''+ ReceivingAccountNo +''+ ReceivingACName +''+ 
			TransactionCode +''+ Amount +''+ Filler +''+ IDverificationindicator +''+ IDtype +''+ IDNumber +''+ Otherpaymentdetails +''+ 
			Recipientsreference +''+ PrintPaymentAdviceIndicator +''+ DeliveryMode +''+ AdviceFormat +''+ BeneficiaryID +''+ 
			BeneficiaryName_line1 +''+ BeneficiaryName_line2 +''+ BeneficiaryName_line3 +''+ BeneficiaryName_line4 +''+ BeneficiaryAddress_line_1_5 +''+ 
			BeneficiaryAddress_line_2 +''+ BeneficiaryAddress_line_3 +''+ BeneficiaryAddress_line_4 +''+ BeneficiaryCity +''+ 
			BeneficiaryCountryCode +''+ BeneficiaryPostalCode  +''+ EmailAddressofBeneficiary +''+ FacsimileNumberofBeneficiary +''+ 
			PaymentCurrency +''+ PayersName_Line_1 +''+ PayersName_Line_2 +''+ CustomersPayerreferencenumber +''+ Filler +''+ 
			BeneficiaryResidentindicator +''+ PurposeCode +''+ ReasonofPayment +''+ Transactorrelationship +''+ BeneficiaryOriginCountry +''+ 
			ApprovalCode +''+ Filler2 AS BD
		FROM #BATCHDETAIL

		UNION ALL

		SELECT 2 as seq, BatchDetailIDD, RecordType, RecordType +''+ SpacingLines +''+ PaymentAdviceDetails +''+ Filler AS PAF
		FROM #PAYMENTADVICEFORMAT

		UNION ALL

		SELECT 3 as seq, 999999 AS IDD, RecordType, RecordType +''+ TotalDebitAmount +''+ TotalCreditAmount +''+ TotalDebitCount +''+ 
			TotalCreditCount +''+ Filler AS T
		FROM #BATCHTRAILER
	) AS T
	ORDER BY seq, IDD, RecordType;

	DROP TABLE #BATCHDETAIL;
	DROP TABLE #BATCHHEADER;
	DROP TABLE #BATCHTRAILER;
	DROP TABLE #FILECONTROLHEADER;
	DROP TABLE #PAYMENTADVICEFORMAT;

END