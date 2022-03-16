/****** Object:  Procedure [reports].[Usp_ReceiptGenerate_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_ReceiptGenerate_SendEmail]
    @idteDate DATE,
	@iintReceiptId BIGINT,
	@istrAcctNo VARCHAR(20)
AS  
/*
* Created by:      Sriram
* Date:            28 April 2021
* Used by:         
* Called by:       
* Project UIN:	   
* RFA:			   
*
*
* Input Parameters:
* NONE
*
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* 1.  
EXEC [reports].[Usp_MailContent] '2020-12-30', '015816102'
*/

BEGIN  
SET NOCOUNT ON;


	DECLARE @CustomerName VARCHAR(50);

	DECLARE @TransactionDate DATE;

	DECLARE @ReceiptReference VARCHAR(50);

	DECLARE @Amount DECIMAL(24,2);


	
	SELECT 
	   @TransactionDate= TR.TransDate,
	  @Amount=TR.AmountToSettle + TR.IntToSettle 
	FROM 
		GlobalBOLocal.RPS.Tb_ReceiptTransaction_Temp TR
	INNER JOIN 
		GlobalBOLocal.RPS.Receipt_Temp R ON TR.ReceiptId = R.ReceiptId
	WHERE
		TR.ReceiptId = @iintReceiptId AND TR.CreatedOn=@idteDate
		
	SELECT 
		@ReceiptReference=R.ReceiptReference,
		@CustomerName = C.[CustomerName (textinput-3)]
		 FROM 
		GlobalBOLocal.RPS.Receipt_Temp R
	INNER JOIN 
		GlobalBOLocal.RPS.Tb_ReceiptTransaction_Temp TR ON R.ReceiptId = TR.ReceiptId
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A
		ON A.[AccountNumber (textinput-5)]=TR.AcctNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C
		ON C.[CustomerID (textinput-1)]  = A.[CustomerID (selectsource-1)]
	
	WHERE
		TR.ReceiptId =@iintReceiptId AND TR.CreatedOn=@idteDate
		



     DECLARE @ostrMailContent NVARCHAR(MAX)='';

     DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')

	  SET @ostrMailContent = '<html>
						<body><img src="'+@Logo+'"  /> <br><br>
						Dear '+ @CustomerName +'<br><br>
                        Your payment of RM1,000 has been credited to your trust account successfully.<br>
						If you wish to continue trading in the U.S. stock market, please submit the enclosed declaration form that was duly signed by you and send to your dealer representative or email to <font <font color="blue"><u>foreign@msec.com.my</u></font> .<br><br>
                        Transaction Date  :'+ CAST(@TransactionDate as VARCHAR) +'<br>
                        Receipt Reference :'+ @ReceiptReference +'<br>
                        Amount            :'+ CAST(@Amount AS VARCHAR) +' <br><br>
                        The final amount is subject to confirmation on Daily Transaction Statement. Please contact our customer service at 1300 22 1233 or email to support@mplusonline.my if you have any enquiry. <br>
						Regards,<br>
						Malacca Securities Sdn Bhd<br><br>
						This is a system generated email. Please do not reply to this email.
						</body></html>';

		SELECT @ostrMailContent;


	
SET NOCOUNT OFF;
END