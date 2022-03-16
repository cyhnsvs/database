/****** Object:  Procedure [api].[usp_getContractOS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure api.usp_getContractOS
(@clientNo varchar(50))
as
select CASE when TransType ='TRBUY' then 'Purchase' else TransType END  transType
, '' transDesc
, '' transNo
, '' transDate
, '' dueDate
, '' market
, '' stockCode
, '' stockShortName
, '' localPrice
, '' settlementCurrency
, '' quantity
, '' settlementAmount
, '' outstandingQuantity
, '' outstandingAmount
, '' localOutstandingOverdueInterest
, '' totalLocalOutstandingAmount
from GlobalBO.contracts.Tb_ContractOutstanding
where AcctNo=@clientNo