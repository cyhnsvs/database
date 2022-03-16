/****** Object:  Procedure [export].[USP_FRA_IFCLIENTE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_FRA_IFCLIENTE] 
(
	@idteProcessDate DATE
)
AS
--EXEC [export].[USP_FRA_IFCLIENTE] '2021-03-01'
BEGIN

	SET NOCOUNT ON;

   CREATE TABLE #IFCLIENTE
   (
		COMPANYID CHAR(1),           
		BRANCHID CHAR(4),			 
		EAFID CHAR(3),				 
		ACCTNO CHAR(10),			 
		ACCTSBNO CHAR(4),			 
		REASONCLOS CHAR(50),		 
		CLTRACEIND CHAR(3),			 
		SMSCLTIND CHAR(1),			 
		TRUSCLTIND CHAR(1),			 
		SPONAME1 CHAR(60),			 
		SPONAME2 CHAR(60),			 
		SPOOCCUPCD CHAR(4),			 
		SPOIDTYPE CHAR(2),			 
		SPOIDNUM CHAR(15),			 
		SPOIDTYPE1 CHAR(2),			 
		SPOIDNUM1 CHAR(15),			 
		SPOTITLE CHAR(20),			 
		SPOPHONE1 CHAR(15),			 
		SPOPHONE2 CHAR(15),			 
		SPOINCTAX# CHAR(20),		 
		EXTREFNO1 CHAR(15),			 
		EXTREFNO2 CHAR(15),			 
		EXTREFNO3 CHAR(15),			 
		EXTREFNO4 CHAR(15),			 
		EXTREFNO5 CHAR(15),			 
		EXTBROKER CHAR(5),			 
		COUNTRYRES CHAR(3),			 
		COUNTRYNAT CHAR(3),			 
		MKTCD1 CHAR(10),			 
		MKTCD2 CHAR(10),			 
		SALESCD1 CHAR(10),			 
		SALESCD2 CHAR(10),			 
		INTRODCCD CHAR(10),			 
		INTROIND CHAR(1),			 
		INTRODATE CHAR(10),			
		PROFTSHRCD CHAR(3),			 
		BRKGSHRCD CHAR(3),			 
		SRVOFFCD CHAR(10),			 
		LEGALCCRIS CHAR(5),			 
		REMK1CCRIS CHAR(50),		 
		REMK2CCRIS CHAR(50),		 
		LEGALBRIS CHAR(5),			 
		REMK1BRIS CHAR(50),			 
		REMK2BRIS CHAR(50),			 
		LEGALCTOS CHAR(5),			 
		REMK1CTOS CHAR(50),			 
		REMK2CTOS CHAR(50),			 
		LEGALOA CHAR(5),			 
		REMK1OA CHAR(50),			 
		REMK2OA CHAR(50),			 
		LEGALCODE1 CHAR(5),			 
		REMK1CODE1 CHAR(50),		 
		REMK2CODE1 CHAR(50),		 
		LEGALCODE2 CHAR(5),			 
		REMK1CODE2 CHAR(50),		 
		REMK2CODE2 CHAR(50),		 
		IND1 CHAR(1),				 
		IND2 CHAR(1),				 
		IND3 CHAR(1),				 
		IND4 CHAR(1),				 
		IND5 CHAR(1),				 
		RATE1 CHAR(3),			
		RATE2 CHAR(3),			
		RATE3 CHAR(3),			
		RATE4 CHAR(3),			
		RATE5 CHAR(3),			
		TEXT1 CHAR(10),			
		TEXT2 CHAR(10),			
		TEXT3 CHAR(10),			
		TEXT4 CHAR(10),			
		TEXT5 CHAR(10),			
		QUANTITY1 CHAR(5),		
		QUANTITY2 CHAR(5),		
		QUANTITY3 CHAR(5),		
		QUANTITY4 CHAR(5),		
		QUANTITY5 CHAR(5),		
		AMOUNT1 CHAR(8),		
		AMOUNT2 CHAR(8),		
		AMOUNT3 CHAR(8),		
		AMOUNT4 CHAR(8),		
		AMOUNT5 CHAR(8),		
		DATE1 CHAR(10),			
		DATE2 CHAR(10),			
		DATE3 CHAR(10),			
		DATE4 CHAR(10),			
		DATE5 CHAR(10),			
		FNAMEEXT CHAR(40),		
		IDTYPECD CHAR(2),		
		IDNUMBER CHAR(15),		
		IDTYPECD1 CHAR(2),		
		IDNUMBER1 CHAR(15),		
		SYSREFNO1 CHAR(15),		
		SYSREFNO2 CHAR(15),		
		SYSREFNO3 CHAR(15),		
		SYSREFNO4 CHAR(15),		
		SYSREFNO5 CHAR(15),		
		PRTCMBSTM CHAR(1),		
		REFBYKYCME CHAR(60),	
		INTERIND CHAR(1),		
		ROLOVSHRCD CHAR(3),		
		SENDTOBFE CHAR(1),		
		USRCREATED CHAR(10),	
		DTCREATED CHAR(10),		
		TMCREATED CHAR(8),		
		USRUPDATED CHAR(10),	
		DTUPDATED CHAR(10),		
		TMUPDATED CHAR(8),		
		RCDSTAT CHAR(1),		
		RCDVERSION CHAR(3),		
		PGMLSTUPD CHAR(10),		
		TRIGGERACT CHAR(1),		
		ALWODDAVG CHAR(1)		
   )

   INSERT INTO #IFCLIENTE
   (
		COMPANYID,
		BRANCHID,
		EAFID,
		ACCTNO,
		ACCTSBNO,
		REASONCLOS,
		CLTRACEIND,
		SMSCLTIND,
		TRUSCLTIND,
		SPONAME1,
		SPONAME2,
		SPOOCCUPCD,
		SPOIDTYPE,
		SPOIDNUM,
		SPOIDTYPE1,
		SPOIDNUM1,
		SPOTITLE,
		SPOPHONE1,
		SPOPHONE2,
		SPOINCTAX#,
		EXTREFNO1,
		EXTREFNO2,
		EXTREFNO3,
		EXTREFNO4,
		EXTREFNO5,
		EXTBROKER,
		COUNTRYRES,
		COUNTRYNAT,
		MKTCD1,
		MKTCD2,
		SALESCD1,
		SALESCD2,
		INTRODCCD,
		INTROIND,
		INTRODATE,
		PROFTSHRCD,
		BRKGSHRCD,
		SRVOFFCD,
		LEGALCCRIS,
		REMK1CCRIS,
		REMK2CCRIS,
		LEGALBRIS,
		REMK1BRIS,
		REMK2BRIS,
		LEGALCTOS,
		REMK1CTOS,
		REMK2CTOS,
		LEGALOA,
		REMK1OA,
		REMK2OA,
		LEGALCODE1,
		REMK1CODE1,
		REMK2CODE1,
		LEGALCODE2,
		REMK1CODE2,
		REMK2CODE2,
		IND1,
		IND2,
		IND3,
		IND4,
		IND5,
		RATE1,
		RATE2,
		RATE3,
		RATE4,
		RATE5,
		TEXT1,
		TEXT2,
		TEXT3,
		TEXT4,
		TEXT5,
		QUANTITY1,
		QUANTITY2,
		QUANTITY3,
		QUANTITY4,
		QUANTITY5,
		AMOUNT1,
		AMOUNT2,
		AMOUNT3,
		AMOUNT4,
		AMOUNT5,
		DATE1,
		DATE2,
		DATE3,
		DATE4,
		DATE5,
		FNAMEEXT,
		IDTYPECD,
		IDNUMBER,
		IDTYPECD1,
		IDNUMBER1,
		SYSREFNO1,
		SYSREFNO2,
		SYSREFNO3,
		SYSREFNO4,
		SYSREFNO5,
		PRTCMBSTM,
		REFBYKYCME,
		INTERIND,
		ROLOVSHRCD,
		SENDTOBFE,
		USRCREATED,
		DTCREATED,
		TMCREATED,
		USRUPDATED,
		DTUPDATED,
		TMUPDATED,
		RCDSTAT,
		RCDVERSION,
		PGMLSTUPD,
		TRIGGERACT,
		ALWODDAVG
   )

   SELECT 
		'',
		ACCOUNT.[CDSACOpenBranch (selectsource-4)],
		'',
		ACCOUNT.[AccountNumber (textinput-5)],
		'',
		'',
		CUSTOMER.[RiskProfiling (textinput-156)],--CLTRACEIND 
		'',
		'',
		'',--10

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--20

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--30

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--40

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--50

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--60

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--70

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--80

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		CUSTOMER.[IDNumber (textinput-5)],--IDNUMBER
		'',--90

		CUSTOMER.[AlternateIDNumber (textinput-6)],--IDNUMBER1
		'',
		'',
		'',
		'',
		'',
		'',
		CASE 
			WHEN (CASE 
					WHEN CUSTOMER.[ModeofClientAcquisition (selectbasic-25)]='PNFTF' 
					THEN ',NFTF' ELSE '' 
				  END) +
		(CASE 
			WHEN CUSTOMER.[PromotionIndicator (selectsource-37)]='Y' 
			THEN ',16' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[IDSS (multipleradiosinline-17)]='Y' 
			THEN ',IDSS' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[LEAP (multipleradiosinline-36)]='Y' 
			THEN ',LEAP' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[FEAResidentofMalaysia (selectbasic-23)]='1' 
			THEN ',MCRB' ELSE '' 
		END) +
		--CASE WHEN B.ReferredByKYCList LIKE '%MCNB%' OR B.ReferredByKYCList LIKE '%MCRB%' THEN '1' ELSE '' END as  [FEAResidentofMalaysia (selectbasic-23)], --1 = resident, 2 = non-resident
		(CASE 
			WHEN CUSTOMER.[FEAResidentofMalaysia (selectbasic-23)] =1 AND CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='Y' 
			THEN ',MCRB' 
			WHEN [FEAResidentofMalaysia (selectbasic-23)] =1 AND CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='N' 
			THEN ',MCNB' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='Y' 
			THEN ',MCRB' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[ETFLI (multipleradiosinline-20)]='Y' 
			THEN ',ETFLI' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[BursaAnywhere (multipleradiosinline-34)]='Y' 
			THEN ',BA' ELSE '' 
		END) !=''
		THEN
		 SUBSTRING(( (CASE 
						WHEN CUSTOMER.[ModeofClientAcquisition (selectbasic-25)]='PNFTF' 
						THEN ',NFTF' ELSE '' 
					END) +
		(CASE 
			WHEN CUSTOMER.[PromotionIndicator (selectsource-37)]='Y' 
			THEN ',16' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[IDSS (multipleradiosinline-17)]='Y' 
			THEN ',IDSS' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[LEAP (multipleradiosinline-36)]='Y' 
			THEN ',LEAP' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[FEAResidentofMalaysia (selectbasic-23)]='1' 
			THEN ',MCRB' ELSE '' 
		END) +
		--CASE WHEN B.ReferredByKYCList LIKE '%MCNB%' OR B.ReferredByKYCList LIKE '%MCRB%' THEN '1' ELSE '' END as  [FEAResidentofMalaysia (selectbasic-23)], --1 = resident, 2 = non-resident
		(CASE 
			WHEN CUSTOMER.[FEAResidentofMalaysia (selectbasic-23)] =1 AND CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='Y' 
			THEN ',MCRB' 
			WHEN [FEAResidentofMalaysia (selectbasic-23)] =1 AND CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='N' 
			THEN ',MCNB' 
		END)+
		(CASE 
			WHEN CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='Y' 
			THEN ',MCRB' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[ETFLI (multipleradiosinline-20)]='Y' 
			THEN ',ETFLI' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[BursaAnywhere (multipleradiosinline-34)]='Y' 
			THEN ',BA' ELSE '' 
		END)),
		2, 
		LEN((CASE 
				WHEN CUSTOMER.[ModeofClientAcquisition (selectbasic-25)]='PNFTF' 
				THEN ',NFTF' ELSE '' 
			END) +
		(CASE 
			WHEN CUSTOMER.[PromotionIndicator (selectsource-37)]='Y' 
			THEN ',16' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[IDSS (multipleradiosinline-17)]='Y' 
			THEN ',IDSS' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[LEAP (multipleradiosinline-36)]='Y' 
			THEN ',LEAP' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[FEAResidentofMalaysia (selectbasic-23)]='1' 
			THEN ',MCRB' ELSE '' 
		END) +
		--CASE WHEN B.ReferredByKYCList LIKE '%MCNB%' OR B.ReferredByKYCList LIKE '%MCRB%' THEN '1' ELSE '' END as  [FEAResidentofMalaysia (selectbasic-23)], --1 = resident, 2 = non-resident
		(CASE 
			WHEN CUSTOMER.[FEAResidentofMalaysia (selectbasic-23)] =1 AND CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='Y' 
			THEN ',MCRB' 
			WHEN [FEAResidentofMalaysia (selectbasic-23)] =1 AND CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='N' 
			THEN ',MCNB' 
		END)+
		(CASE 
			WHEN CUSTOMER.[FEAhaveDomesticRinggitBorrowing (selectbasic-30)]='Y' 
			THEN ',MCRB' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[ETFLI (multipleradiosinline-20)]='Y' 
			THEN ',ETFLI' ELSE '' 
		END)+
		(CASE 
			WHEN CUSTOMER.[BursaAnywhere (multipleradiosinline-34)]='Y' 
			THEN ',BA' ELSE '' 
		END) )-1)  
		 ELSE '' END AS REFBYKYCME,
		'',
		'',--100

		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',
		'',--110

		'',
		''
	FROM 
		CQBTempDB.export.Tb_FormData_1409 ACCOUNT
	INNER JOIN 
		CQbTempDB.export.Tb_FormData_1410 CUSTOMER ON CUSTOMER.[CustomerID (textinput-1)] = ACCOUNT.[CustomerID (selectsource-1)]


   ---RESULT SET
   SELECT 
        COMPANYID + BRANCHID + EAFID + ACCTNO + ACCTSBNO + REASONCLOS + CLTRACEIND + SMSCLTIND + TRUSCLTIND + SPONAME1 +
		SPONAME2 + SPOOCCUPCD + SPOIDTYPE + SPOIDNUM + SPOIDTYPE1 + SPOIDNUM1 + SPOTITLE + SPOPHONE1 + SPOPHONE2 + SPOINCTAX# +
		EXTREFNO1 + EXTREFNO2 + EXTREFNO3 + EXTREFNO4 + EXTREFNO5 + EXTBROKER + COUNTRYRES + COUNTRYNAT + MKTCD1 + MKTCD2 +
		SALESCD1 + SALESCD2 + INTRODCCD + INTROIND + INTRODATE + PROFTSHRCD + BRKGSHRCD + SRVOFFCD + LEGALCCRIS + REMK1CCRIS +
		REMK2CCRIS + LEGALBRIS + REMK1BRIS + REMK2BRIS + LEGALCTOS + REMK1CTOS + REMK2CTOS + LEGALOA + REMK1OA + REMK2OA +
		LEGALCODE1 + REMK1CODE1 + REMK2CODE1 + LEGALCODE2 + REMK1CODE2 + REMK2CODE2 + IND1 + IND2 + IND3 + IND4 + IND5 +
		CAST(RATE1 AS CHAR(8)) + CAST(RATE2 AS CHAR(8)) + CAST(RATE3 AS CHAR(8)) + CAST(RATE4 AS CHAR(8)) + CAST(RATE5 AS CHAR(8)) + 
		TEXT1 + TEXT2 + TEXT3 + TEXT4 + TEXT5 + CAST(QUANTITY1 AS CHAR(8)) + CAST(QUANTITY2 AS CHAR(8)) + CAST(QUANTITY3 AS CHAR(8)) +
		CAST(QUANTITY4 AS CHAR(8)) + CAST(QUANTITY5 AS CHAR(8)) + CAST(AMOUNT1 AS CHAR(8)) + CAST(AMOUNT2 AS CHAR(8)) + 
		CAST(AMOUNT3 AS CHAR(8)) + CAST(AMOUNT4 AS CHAR(8)) + CAST(AMOUNT5 AS CHAR(8)) + CAST(DATE1 AS CHAR(8)) + CAST(DATE2 AS CHAR(8))
		 + CAST(DATE3 AS CHAR(8)) + CAST(DATE4 AS CHAR(8)) + CAST(DATE5 AS CHAR(8)) +
		FNAMEEXT + IDTYPECD + IDNUMBER + IDTYPECD1 + IDNUMBER1 + SYSREFNO1 + SYSREFNO2 + SYSREFNO3 + SYSREFNO4 + SYSREFNO5 +
		PRTCMBSTM + REFBYKYCME + INTERIND + ROLOVSHRCD + SENDTOBFE + USRCREATED + DTCREATED + TMCREATED + USRUPDATED +
		DTUPDATED + TMUPDATED + RCDSTAT + CAST(RCDVERSION AS CHAR(8)) + PGMLSTUPD + TRIGGERACT +ALWODDAVG
   FROM #IFCLIENTE

	DROP TABLE #IFCLIENTE

END