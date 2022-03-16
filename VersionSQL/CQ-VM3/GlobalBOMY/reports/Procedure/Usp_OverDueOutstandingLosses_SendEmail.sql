/****** Object:  Procedure [reports].[Usp_OverDueOutstandingLosses_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_OverDueOutstandingLosses_SendEmail]
	@idteDate DATE,
	@istrAcctNo VARCHAR(100)
AS  
/*
* Created by:      SRIRAM
* Date:            12 Feb 2021
* Used by:         GBO Process 
* Called by:       GBO Batch Process Manager Monitor
* Project UIN:	   
* RFA:			   
*
* Purpose: This sp is used to send email alert for OverDue outstanding Losses in Client's Trading Account.
*
* Input Parameters:
* NONE
*
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* 1.  
*/

BEGIN  
SET NOCOUNT ON;

		DECLARE @strMailBody VARCHAR(MAX)='';

		DECLARE @DealerName VARCHAR(200),
		@DealerCode		VARCHAR(10),
		@AccountName	VARCHAR(200),
		@AccountCode	VARCHAR(50),
		@OSAmount		DECIMAL(13,2),
		@OSInterest		DECIMAL(13,2);
		


	

	SELECT 
		@DealerName = D.[Name (textinput-3)],
		@DealerCode = D.[DealerCode (textinput-35)],
		@AccountName = [CustomerName (textinput-3)],
		@AccountCode = [CustomerID (textinput-1)],
		@OSAmount = SUM(ABS(NetAmountSetl)),
		@OSInterest = SUM(ABS(ClientBrokerageSetl))
		
	FROM 
		GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid T
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 A ON    A.[AccountNumber (textinput-5)] = T.AcctNo 
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 C ON C.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)]
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1377 D ON A.[DealerCode (selectsource-21)] = D.[DealerCode (textinput-35)]
	WHERE 
		T.NetAmountSetl < 0 AND T.AcctNo= @istrAcctNo
	GROUP BY
		D.[Name (textinput-3)],D.[DealerCode (textinput-35)],[CustomerName (textinput-3)],[CustomerID (textinput-1)],D.[WorkEmail (textinput-20)]
		
		

	   DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')

		SET @strMailBody = '<html><body>
	                       <img src="'+@Logo+'" /> <br><br>
							Dear Mr/Ms '+ @DealerName +' (' + @DealerCode + '),<br><br>
							We are writing to inform you that your client''s trading account is showing overdue outstanding losses as at ' + CONVERT(VARCHAR, @idteDate, 103) + '. <br><br>
							The information is as follows : <br><br>
							a) Account Name : ' + @AccountName + '<br>
							b) Account Code  : ' + @AccountCode + '<br>
							c) Outstanding Amount : RM  '+ CAST(@OSAmount AS VARCHAR) +'<br>
							d) Overdue Interest : RM  '+ CAST(@OSInterest AS VARCHAR)+'<br><br>
							Remark : Additional overdue interest at 13% pa on a daily basis will be charged until full payment.<br><br>
							Should your client have forwarded the payment to us for settlement of the aforesaid outstanding amount, we wish to express our sincere gratitude and kindly disregard this notice. <br><br><br>
							Thank you. <br><br>
							Yours sincerely,<br><br>
							</body></html>';

		SELECT @strMailBody
		
	

SET NOCOUNT OFF;
END