/****** Object:  Procedure [export].[USP_SAP_GeneralLedger]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_SAP_GeneralLedger]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (ControlID decimal(1,0)
 ,CompanyCode char(4)
 ,DocType char(2)
 ,Documentno char(16)
 ,DocumentDate date
 ,PostingDate date
 ,ChequeNo char(18)
 ,Filename char(25)
 ,Customeracctno char(50)
 ,Currency char(5)
 ,BOSCOACode char(10)
 ,GLAccount char(10)
 ,CostCenter char(10)
 ,ProfitCenter char(10)
 ,InternalOrder char(12)
 ,PostingKey char(2)
 ,DocumentCurrencyDebitAmount decimal(22,0)
 ,DocumentCurrencyCreditAmount decimal(22,0)
 ,LocalCurrencyDebitAmount decimal(22,0)
 ,LocalCurrencyCreditAmount decimal(22,0)
 ,TaxCode char(6)
 ,HashedControlNo char(5)
 );
INSERT INTO #Detail(ControlID
,CompanyCode
,DocType
,Documentno
,DocumentDate
,PostingDate
,ChequeNo
,Filename
,Customeracctno
,Currency
,BOSCOACode
,GLAccount
,CostCenter
,ProfitCenter
,InternalOrder
,PostingKey
,DocumentCurrencyDebitAmount
,DocumentCurrencyCreditAmount
,LocalCurrencyDebitAmount
,LocalCurrencyCreditAmount
,TaxCode
,HashedControlNo
)
VALUES(1 ,'Comp' ,'ZK' ,'Documentno' ,getdate() ,getdate() ,'ChequeNo' ,'Filename' ,'Customeracctno' ,'Curre' ,'BOSCOACode' ,'GLAccount' ,'CostCenter' ,'ProfitCent' ,'InternalOrde' ,'40' ,1 ,1 ,1 ,1 ,'TaxCod' ,'Hashe' )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (ControlID decimal(1,0)
 ,HashedControlTotal decimal(10,0)
 ,TotalDataRow decimal(10,0)
 ,TotalDocCurrDebit decimal(22,0)
 ,TotalDocCurrCredit decimal(22,0)
 ,TotalLocCurrDebit decimal(22,0)
 ,TotalLocCurrCredit decimal(22,0)
 );
INSERT INTO #Trailer(ControlID
,HashedControlTotal
,TotalDataRow
,TotalDocCurrDebit
,TotalDocCurrCredit
,TotalLocCurrDebit
,TotalLocCurrCredit
)
VALUES(0 ,1 ,1 ,1 ,1 ,1 ,1 )
---RESULT SET
SELECT RIGHT(REPLICATE('0', 1) + CAST(ControlID as varchar(1)), 1)+CompanyCode+DocType+Documentno+FORMAT(DocumentDate , 'yyyyMMdd')+FORMAT(PostingDate , 'yyyyMMdd')+ChequeNo+Filename+Customeracctno+Currency+BOSCOACode+GLAccount+CostCenter+ProfitCenter+InternalOrder+PostingKey+RIGHT(REPLICATE('0', 22) + CAST(DocumentCurrencyDebitAmount as varchar(22)), 22)+RIGHT(REPLICATE('0', 22) + CAST(DocumentCurrencyCreditAmount as varchar(22)), 22)+RIGHT(REPLICATE('0', 22) + CAST(LocalCurrencyDebitAmount as varchar(22)), 22)+RIGHT(REPLICATE('0', 22) + CAST(LocalCurrencyCreditAmount as varchar(22)), 22)+TaxCode+HashedControlNo  FROM #Detail
UNION ALL

---RESULT SET
SELECT RIGHT(REPLICATE('0', 1) + CAST(ControlID as varchar(1)), 1)+
--RIGHT(REPLICATE('0', 10) + CAST(HashedControlTotal as char(10)), 10)+
--RIGHT(REPLICATE('0', 10) + CAST(TotalDataRow as char(10)), 10)+
space(10-len(cast(HashedControlTotal  as varchar(10)))) +  CAST(HashedControlTotal as varchar(10)) +
space(10-len(cast(TotalDataRow  as varchar(10)))) +  CAST(TotalDataRow as varchar(10)) +
RIGHT(REPLICATE('0', 22) + CAST(TotalDocCurrDebit as varchar(22)), 22)+
RIGHT(REPLICATE('0', 22) + CAST(TotalDocCurrCredit as varchar(22)), 22)+
RIGHT(REPLICATE('0', 22) + CAST(TotalLocCurrDebit as varchar(22)), 22)+
RIGHT(REPLICATE('0', 22) + CAST(TotalLocCurrCredit as varchar(22)), 22)  FROM #Trailer 
DROP TABLE #Detail
DROP TABLE #Trailer
END