/****** Object:  Table [import].[Tb_ContractOS_OSTRADE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [import].[Tb_ContractOS_OSTRADE](
	[OSTRADEKEY] [varchar](50) NULL,
	[COMPANYID] [varchar](50) NULL,
	[BRANCHID] [varchar](50) NULL,
	[EAFID] [varchar](50) NULL,
	[ACCTNO] [varchar](50) NULL,
	[ACCTSBNO] [varchar](50) NULL,
	[CUSTKEY] [varchar](50) NULL,
	[CURRCODE] [varchar](50) NULL,
	[SUBACCTTYP] [varchar](50) NULL,
	[MRKTCD] [varchar](50) NULL,
	[PRODCD] [varchar](50) NULL,
	[PRODCD1] [varchar](50) NULL,
	[BROKERCD] [varchar](50) NULL,
	[DLREAFID] [varchar](50) NULL,
	[DEALERCD] [varchar](50) NULL,
	[TRADEACKEY] [varchar](50) NULL,
	[ALCOMPANY] [varchar](50) NULL,
	[ALBRANCH] [varchar](50) NULL,
	[ALEAFID] [varchar](50) NULL,
	[ALACCTNO] [varchar](50) NULL,
	[ALACCTSBNO] [varchar](50) NULL,
	[INTTRXID] [varchar](50) NULL,
	[TRXCD] [varchar](50) NULL,
	[TRXSUBCD] [varchar](50) NULL,
	[TRXREFNO] [varchar](50) NULL,
	[TRXREFSX] [varchar](50) NULL,
	[TRXREFVS] [varchar](50) NULL,
	[TRXDT] [varchar](50) NULL,
	[TRDPRICE] [varchar](50) NULL,
	[TRXQTY] [varchar](50) NULL,
	[TRXAMT] [varchar](50) NULL,
	[TRXAMTL] [varchar](50) NULL,
	[TRXEXRT] [varchar](50) NULL,
	[BALQTY] [varchar](50) NULL,
	[BALAMT] [varchar](50) NULL,
	[BALAMTL] [varchar](50) NULL,
	[PENDQTY] [varchar](50) NULL,
	[PENDAMT] [varchar](50) NULL,
	[PENDAMTL] [varchar](50) NULL,
	[PENDCTRQTY] [varchar](50) NULL,
	[PENDCTRAMT] [varchar](50) NULL,
	[FOREXGNLS] [varchar](50) NULL,
	[CURMTDINT] [varchar](50) NULL,
	[ACCRINTPD] [varchar](50) NULL,
	[DTINTCOMP] [varchar](50) NULL,
	[DTDUEDLV] [varchar](50) NULL,
	[RELDOCNO] [varchar](50) NULL,
	[FREEOFPAYM] [varchar](50) NULL,
	[LSTVSNO] [varchar](50) NULL,
	[MRKTTRADE] [varchar](50) NULL,
	[SCRIPLESS] [varchar](50) NULL,
	[BRKGBAL] [varchar](50) NULL,
	[DOCSTMBAL] [varchar](50) NULL,
	[CLRFEEBAL] [varchar](50) NULL,
	[SALETAXBAL] [varchar](50) NULL,
	[OTHCHGBAL] [varchar](50) NULL,
	[VATBAL] [varchar](50) NULL,
	[COMMBAL] [varchar](50) NULL,
	[BRKGAMT] [varchar](50) NULL,
	[CLRFEEAMT] [varchar](50) NULL,
	[DOCSTMAMT] [varchar](50) NULL,
	[SALESTAX] [varchar](50) NULL,
	[OTHCHG] [varchar](50) NULL,
	[VATAMT] [varchar](50) NULL,
	[COMMAMT] [varchar](50) NULL,
	[SBLTRXRATE] [varchar](50) NULL,
	[ODDLOTIND] [varchar](50) NULL,
	[CDSNUMBER] [varchar](50) NULL,
	[INTMETHOD] [varchar](50) NULL,
	[ONHOLD] [varchar](50) NULL,
	[USRUPDATED] [varchar](50) NULL,
	[DTUPDATED] [varchar](50) NULL,
	[TMUPDATED] [varchar](50) NULL,
	[RCDSTAT] [varchar](50) NULL,
	[RCDVERSION] [varchar](50) NULL,
	[PGMLSTUPD] [varchar](50) NULL,
	[TRIGGERACT] [varchar](50) NULL,
	[CAKEY] [varchar](50) NULL,
	[CADTLKEY] [varchar](50) NULL,
	[AMOUNT1] [varchar](50) NULL,
	[AMOUNT2] [varchar](50) NULL,
	[AMOUNT3] [varchar](50) NULL,
	[QUANTITY1] [varchar](50) NULL,
	[QUANTITY2] [varchar](50) NULL,
	[QUANTITY3] [varchar](50) NULL,
	[RCDKEY1] [varchar](50) NULL,
	[RCDKEY2] [varchar](50) NULL,
	[RCDKEY3] [varchar](50) NULL,
	[STKDIVIND] [varchar](50) NULL,
	[CSHDIVIND] [varchar](50) NULL,
	[RGTISSIND] [varchar](50) NULL,
	[SHORTSELL] [varchar](50) NULL,
	[CALLWARIND] [varchar](50) NULL,
	[ORGTRXDT] [varchar](50) NULL,
	[ENTITLRGT] [varchar](50) NULL,
	[PRCTYPE] [varchar](50) NULL,
	[RBLCD] [varchar](50) NULL,
	[NEXTRODATE] [varchar](50) NULL,
	[ISLSECIND] [varchar](50) NULL,
	[MRKTTRDREF] [varchar](50) NULL,
	[DTDUEPAY] [varchar](50) NULL,
	[ACCTTYPECD] [varchar](50) NULL,
	[ACCTGRPCD] [varchar](50) NULL,
	[REMARKCD] [varchar](50) NULL,
	[REMARKCD1] [varchar](50) NULL,
	[REMARKCD2] [varchar](50) NULL,
	[FINANCEIND] [varchar](50) NULL,
	[CHRGCD] [varchar](50) NULL,
	[FINANCEDT] [varchar](50) NULL,
	[TRXCOMPANY] [varchar](50) NULL,
	[TRXBRANCH] [varchar](50) NULL,
	[TRXEAFID] [varchar](50) NULL,
	[DLRBEAR] [varchar](50) NULL,
	[DLRBEARDT] [varchar](50) NULL,
	[CMPBEARAMT] [varchar](50) NULL,
	[DLRBEARAMT] [varchar](50) NULL,
	[DTLSTSETT] [varchar](50) NULL,
	[AMTLSTSETT] [varchar](50) NULL,
	[SETTTRXCD] [varchar](50) NULL,
	[DOCREF1] [varchar](50) NULL,
	[DOCREF2] [varchar](50) NULL,
	[SWIFTREF] [varchar](50) NULL,
	[ACNTRAPRTY] [varchar](50) NULL,
	[ASETOFPRTY] [varchar](50) NULL,
	[LSTRODATE] [varchar](50) NULL,
	[CURMTDCOM] [varchar](50) NULL,
	[CURMTDHND] [varchar](50) NULL,
	[MCDREFNO] [varchar](50) NULL,
	[LSTSETTQTY] [varchar](50) NULL,
	[RELEASEDT] [varchar](50) NULL,
	[INTRTCD] [varchar](50) NULL,
	[CURMTDINTD] [varchar](50) NULL,
	[ACCRINTPDD] [varchar](50) NULL,
	[AMOUNT4] [varchar](50) NULL,
	[AMOUNT5] [varchar](50) NULL,
	[QUANTITY4] [varchar](50) NULL,
	[QUANTITY5] [varchar](50) NULL,
	[DATE1] [varchar](50) NULL,
	[DATE2] [varchar](50) NULL,
	[DATE3] [varchar](50) NULL,
	[DATE4] [varchar](50) NULL,
	[TEXT1] [varchar](50) NULL,
	[TEXT2] [varchar](50) NULL,
	[TEXT3] [varchar](50) NULL,
	[TEXT4] [varchar](50) NULL,
	[DLVQTY] [varchar](50) NULL,
	[PENDCTRAML] [varchar](50) NULL,
	[PENDDLVQTY] [varchar](50) NULL,
	[HLDQTY] [varchar](50) NULL,
	[HLDAMT] [varchar](50) NULL,
	[REINSTATED] [varchar](50) NULL,
	[REINSTAMT] [varchar](50) NULL,
	[REINSTQTY] [varchar](50) NULL,
	[REINSTDATE] [varchar](50) NULL,
	[PARACGRPCD] [varchar](50) NULL
) ON [PRIMARY]