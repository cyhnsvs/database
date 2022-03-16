/****** Object:  Procedure [reports].[Usp_Receipt_GeneratePDF_HTML]    Committed by VersionSQL https://www.versionsql.com ******/

  
CREATE PROCEDURE [reports].[Usp_Receipt_GeneratePDF_HTML](    
	@idteDate DATE,
	@iintReceiptId BIGINT,
	@istrAcctNo VARCHAR(20)
	
  )  
AS    
/*  
* Created by:      SRIRAM  
* Date:            12-05-2021  
* Used by:                
* Called by:        
* Project UIN :   
* RFA No.   :   
* Modified BY :    SRIRAM.R  
*
* Purpose: This sp is used to generate the PDF after successful receipt  
*  
* 
* Has been modified by + date + project UIN + note:  
* 
EXEC [reports].[Usp_Receipt_GeneratePDF_HTML] '2021-09-09',80,'56467' 
*/  
  
BEGIN    
SET NOCOUNT ON;  
SET ANSI_PADDING ON;    
BEGIN TRY  

   --Work Flow Start--

	DECLARE @istrClientName VARCHAR(100);
	DECLARE @istrClientAddress1 VARCHAR(MAX);
	DECLARE @istrClientAddress2 VARCHAR(MAX);
	DECLARE @istrClientAddress3 VARCHAR(MAX);
	DECLARE @istrClientAddressTown VARCHAR(MAX);
	DECLARE @istrClientAddressState VARCHAR(MAX);
	DECLARE @istrClientAddressCountry VARCHAR(MAX);
	DECLARE @istrClientAddressPostCode VARCHAR(MAX);


	DECLARE @istrClientCode VARCHAR(100);
	DECLARE @istrDealerCode VARCHAR(100);

	 DECLARE @Logo1 VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')
	 DECLARE @Logo2 VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MalaccaSecuritiesLogo')


	SELECT 
	@istrClientName = Customer.[CustomerName (textinput-3)],
	@istrClientAddress1 = Customer.[Address1 (textinput-35)],
	@istrClientAddress2 = Customer.[Address2 (textinput-36)],
	@istrClientAddress3 = Customer.[Address3 (textinput-37)],
	@istrClientAddressTown =Customer.[Town (textinput-38)],
	@istrClientAddressState =Customer.[State (textinput-39)],
	@istrClientAddressCountry=Customer.[Country (selectsource-27)],
	@istrClientAddressPostCode =Customer.[Postcode (textinput-40)],
	@istrClientCode = Account.[CustomerID (selectsource-1)],
	@istrDealerCode=Account.[DealerCode (selectsource-21)]  from GlobalBOLocal.RPS.Tb_ReceiptTransaction_Temp A
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account
	ON Account.[AccountNumber (textinput-5)]=A.AcctNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer
	ON Customer.[CustomerID (textinput-1)]  = Account.[CustomerID (selectsource-1)]
	Where A.ReceiptId=@iintReceiptId

	DECLARE @istrAddress VARCHAR(MAX)='';

	IF(ISNULL(@istrClientAddress1,'')<>'')
		BEGIN
		SET @istrAddress +='<label style="text-align:center">'+  @istrClientAddress1 +'</label><br>'
		END
	IF(ISNULL(@istrClientAddress2,'')<>'')
		BEGIN
		SET @istrAddress +='<label style="text-align:center">'+  @istrClientAddress2 +'</label><br>'
		END
	IF(ISNULL(@istrClientAddress3,'')<>'')
		BEGIN
		SET @istrAddress +='<label style="text-align:center">'+  @istrClientAddress3 +'</label><br>'
		END
	IF(ISNULL(@istrClientAddressTown,'')<>'')
		BEGIN
		SET @istrAddress +='<label style="text-align:center">'+  @istrClientAddressTown +'</label>'
		END
	IF(ISNULL(@istrClientAddressState,'')<>'')
		BEGIN
		SET @istrAddress +='<label style="text-align:center">'+  @istrClientAddressState +'</label><br>'
		END
	IF(ISNULL(@istrClientAddressCountry,'')<>'')
		BEGIN
		SET @istrAddress +='<label style="text-align:center">'+  @istrClientAddressCountry +'</label>'
		END
	IF(ISNULL(@istrClientAddressPostCode,'')<>'')
		BEGIN
		SET @istrAddress +='<label style="text-align:center"> , '+  @istrClientAddressPostCode +'</label><br>'
		END
	
	
	-- TRANSACTIONS
	SELECT DISTINCT
	    TR.TransDate,
		TR.TransReference,
		EX.ExchCommonName,
		I.ShortName,
		TR.QtyToSettle,
		TR.TradedPrice,
		TR.AmountToSettle,
		TR.IntToSettle,
		TR.AmountToSettle + TR.IntToSettle AS TotalAmount
	INTO #Transaction FROM 
		GlobalBOLocal.RPS.Tb_ReceiptTransaction_Temp TR
	INNER JOIN 
		GlobalBO.setup.Tb_Instrument I ON TR.InstrumentCd = I.InstrumentCd
	INNER JOIN 
		GlobalBO.setup.Tb_Exchange EX on I.HomeExchCd =EX.ExchCd 
	INNER JOIN 
		GlobalBOLocal.RPS.Receipt_Temp R ON TR.ReceiptId = R.ReceiptId
	WHERE
		TR.ReceiptId = @iintReceiptId 
		
	-- RECEIPT
	SELECT DISTINCT
	    L3.Value2 AS ClientBank,
		L1.Value2 AS Type,
		R.ReceiptReference,
		R.CreatedDate,
		L2.Value2 AS CompanyBank,
		R.Amount,
		CASE WHEN ISNULL(RefundExcess,'') <> 'No' THEN ExcessAmount ELSE 0 END AS RefundAmount
	INTO #Receipt FROM 
		GlobalBOLocal.RPS.Receipt_Temp R
	INNER JOIN 
		GlobalBOLocal.RPS.Tb_ReceiptTransaction_Temp TR ON R.ReceiptId = TR.ReceiptId
	LEFT JOIN 
		GlobalBOLocal.setup.Tb_Lookup L1 ON R.[Type] = L1.Value1 AND L1.CodeType = 'ReceiptType'
	LEFT JOIN 
		GlobalBOLocal.setup.Tb_Lookup L2 ON R.[Type] = L2.Value1 AND L2.CodeType = 'ReceiptCompanyBank'
	LEFT JOIN 
		GlobalBOLocal.setup.Tb_Lookup L3 ON R.[Type] = L3.Value1 AND L3.CodeType = 'ReceiptClientBank'
	WHERE
		TR.ReceiptId = @iintReceiptId 

	SELECT '<tr>' + '<td>' + ISNULL(CAST(TransDate AS VARCHAR),'') + '</td>'
				  + '<td>' + ISNULL(TransReference,'') + '</td>'
				  + '<td>' + ISNULL(ExchCommonName,'') + '</td>'
				  + '<td>' + ISNULL(ShortName,'') + '</td>'
				  + '<td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(QtyToSettle AS money),1),'')  + '</td>' 
				  + '<td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(TradedPrice AS money),1),'')  + '</td>'
				  + '<td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(AmountToSettle AS money),1),'') + '</td>'
				  + '<td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(IntToSettle AS money),1),'') + '</td>'
				  + '<td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(TotalAmount AS money),1),'')+ '</td>'
				  + '<td>' + 'MYR' + '</td>'
				  + '</tr>' AS data
	INTO #TransactionCombined FROM #Transaction

	SELECT '<tr>' + '<td>' + ISNULL(ClientBank,'')  + '</td>'
				  + '<td>' + ISNULL(Type,'') + '</td>'
				  + '<td>' + ISNULL(ReceiptReference,'')  + '</td>'
				  + '<td>' + ISNULL(CASt(CreatedDate AS VARCHAR),'') + '</td>'
				  + '<td>' + ISNULL(CompanyBank,'') + '</td>'
				  + '<td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(Amount AS money),1),'0.00') + '</td>'
				  + '<td>' + 'MYR' + '</td>'

				  + '</tr>' AS data
	INTO #ReceiptCombined FROM #Receipt

	DECLARE @val1 Varchar(MAX); 
	SELECT @val1 = COALESCE(@val1 + '' + data, data) FROM #TransactionCombined
	DECLARE @val2 Varchar(MAX); 
	SELECT @val2 = COALESCE(@val2 + '' + data, data) FROM #ReceiptCombined 


	DECLARE @totalTransactionAmount decimal(24, 2);
	SET @totalTransactionAmount =(SELECT SUM(ISNULL(TotalAmount,0.00)) FROM #Transaction );

	
	DECLARE @total VARCHAR(MAX)
	SET @total = '<tfoot><tr><th id="total" colspan="8" style="text-align:right">SettlementAmount : </th><td style="text-align:right">'  + ISNULL(CONVERT(VARCHAR,CAST(@totalTransactionAmount AS money),1),'') + '</td><td>MYR</td></tr></tfoot>';
				  

	DECLARE @totalReceiptAmount decimal(24, 2);
	SET @totalReceiptAmount =(SELECT SUM(ISNULL(Amount,0.00))  FROM #Receipt );
	
	DECLARE @excessTrstAmt  decimal(24, 2);
	SET @excessTrstAmt =(ISNULL(@totalTransactionAmount,0.00) - ISNULL(@totalReceiptAmount,0.00));

	
	DECLARE @excessRefundAmt  decimal(24, 2);
	SET @excessRefundAmt =(SELECT ISNULL(A.RefundAmount,0.00) FROM (SELECT TOP 1* FROM  #Receipt ) AS A);



	DECLARE @total1 VARCHAR(MAX)
	SET @total1 = '<tfoot>
					<tr>
					   <th id="totalReceipt" colspan="5" style="text-align:right">Received Amount : </th><td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(@totalReceiptAmount AS money),1),'0.00') + '</td><td>MYR</td>
					</tr>
					<tr>
					   <th id="exTrstAmt" colspan="5" style="text-align:right">Excess Trust Amount : </th><td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(@excessTrstAmt AS money),1),'0.00') + '</td><td>MYR</td>
					</tr>
					<tr>
					   <th id="exRefndAmt" colspan="5" style="text-align:right">Excess Refund Amount : </th><td style="text-align:right">' + ISNULL(CONVERT(VARCHAR,CAST(@excessRefundAmt AS money),1),'0.00') + '</td><td>MYR</td>
					</tr>
					</tfoot>';
				  

	DECLARE @header1 VARCHAR(MAX)
	SELECT @header1 = '<tr><th style="width:200px">Trx.Date</th><th style="width:200px">Trx.Reference</th><th style="width:250px">Exchange</th><th style="width:200px">CounterName</th><th style="width:150px">Quantity</th><th style="width:150px">Price</th><th style="width:150px">Trx.Amount</th><th style="width:150px">Int.Charges</th><th style="width:150px">Total</th></tr>'

	DECLARE @header2 VARCHAR(MAX)
	SELECT @header2 = '<tr><th style="width:15%">Clients Bank</th><th style="width:15%">Pay Type</th><th style="width:20%">Trx.Ref No / Cheque No</th><th style="width:20%">Chq Date/Deposited Date</th><th style="width:21%">Deposited Bank</th><th style="width:9%">Amount</th></tr>'

	DECLARE @html VARCHAR(MAX);
	SET @html = '<html><head><style>
				table {
				  font-family: arial, sans-serif;
				  border-collapse: collapse;
				  font-size:20px;
				}
				
				td,th{
				 border: 1px solid #dddddd;
				  text-align: center;
				  padding: 8px;
				}
				
				img{
				width: 20%;
				height: auto;
				}

				
				.center 
				{
				  margin: auto;
				  width: 100%;
				  padding: 2px;
				  font-size:20px;

				}
				.rTableCell
				{ 
					display: table-cell; font-Size: 20px; 
				} 
				
				.rTable 
				{ 
					display: table; 
				} 
				
				.rTableRow
				{
					display: table-row; 
				}

				</style>
				</head>
				<div style="text-align:left;font-weight:bold" class="center"><label style="text-align:center">OFFICIAL RECEIPT</label></div><br>
				<div style="text-align:center;font-weight:bold" class="center"><img style="float: left;" src="'+@Logo1+'"/></div><br><br>
				<br><br><br><br>
				<div><div style="text-align:left;float:left;width:65%" class="center"><label style="text-align:center">Client Name: '+ISNULL( @istrClientName,'') +' </label></div> <div style="float:right;width:30%" class="center"><label style="text-align:center">Receipt Number: ' + CAST(@iintReceiptId AS VARCHAR(20))  + '</label></div> </div>
				<div style="height:200px"><div style="text-align:left;float:left;width:65%"><div class="rTable"><div class="rTableRow"><div class="rTableCell"> <label style="text-align:center">Client Address: </label></div><div class="rTableCell">'+ ISNULL(@istrAddress, '')+'</div> </div></div></div>
                <div style="float:right;width:30%" class="center"><br><label style="text-align:center">Transaction Date and Time: '+Cast(GETDATE() AS VARCHAR(20))+'</label><br>
                <label style="text-align:center">Entered By: </label><br>
                <label style="text-align:center">ClientCode & DealerCode: '+ ISNULL(@istrClientCode,'') +','+ISNULL(@istrDealerCode,'')+'</label></div>
				</div>

				<div class="center" style=display:'+CASE WHEN ISNULL(@val1,'') = '' THEN 'none' ELSE 'unset' END +'><table><tbody>' + @header1 + ISNULL(@val1,'') + '</tbody>' + ISNULL(@total, '') + '</table></div><br><br>
				<div class="center" style=display:'+CASE WHEN ISNULL(@val2,'') = '' THEN 'none' ELSE 'unset' END +'><table style="width: 100%;"><tbody>' + @header2 + ISNULL(@val2,'') + '</tbody>'+ ISNULL(@total1,'') +'</table></div>'+'<br>
		        <div style="text-align:left;font-weight:bold" class="center"><label style="text-align:center">**NOTICE**</label></div>
			    <div class="center"><label>Please check and ensure that the figure and amount tally with the amount paid.</label></div><br>
                <div class="center"><label>Generated by computer, no signature required.</label></div><br><br>
				<div style="text-align:center;font-weight:bold" class="center"><img style="float: left;" src="'+@Logo2+'"/></div><br><br>'+'</body></html>'
	SELECT @html
	
	
END TRY  
BEGIN CATCH   
        --print 'error'  
  IF ERROR_NUMBER() IS NULL  
   RETURN;  
  
  DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);  
  SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');  
  SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;  
  RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);  
           
 END CATCH  
  
SET NOCOUNT OFF;  
END 