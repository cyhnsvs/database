/****** Object:  Procedure [dbo].[Usp_OverDueOutstandingLosses_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_OverDueOutstandingLosses_SendEmail]
AS  
/*
* Created by:      Nathiya
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

	DECLARE @strMailBody VARCHAR(MAX);
	DECLARE @strFrom VARCHAR(200);  
	DECLARE @strTo VARCHAR(200);           
	DECLARE @strMailSubject VARCHAR(200); 

	CREATE TABLE #Losses
	(
		DealerName		VARCHAR(200),
		DealerCode		VARCHAR(10),
		AccountName		VARCHAR(200),
		AccountCode		VARCHAR(50),
		OSAmount		DECIMAL(13,2),
		OSInterest		DECIMAL(13,2),
		DealerEmail		VARCHAR(200),
		Processed		BIT
	)
	INSERT INTO #Losses
	(
		 DealerName	
		,DealerCode	
		,AccountName	
		,AccountCode	
		,OSAmount	
		,OSInterest	
		,DealerEmail	
		,Processed	
	)
	SELECT 
		Dealer.[Name (textinput-3)],
		Dealer.[DealerCode (textinput-35)],
		[CustomerName (textinput-3)],
		[CustomerID (textinput-1)],
		SUM(ABS(NetAmountSetl)),
		SUM(ABS(ClientBrokerageSetl)),
		Dealer.[WorkEmail (textinput-20)],
		0
	FROM 
		GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid T
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON T.AcctNo = Account.[AccountNumber (textinput-5)]
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 Customer ON Customer.[CustomerID (textinput-1)] = Account.[CustomerID (selectsource-1)]
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1377 Dealer ON Account.[DealerCode (selectsource-21)] = Dealer.[DealerCode (textinput-35)]
	WHERE 
		T.NetAmountSetl < 0
	GROUP BY
		Dealer.[Name (textinput-3)],Dealer.[DealerCode (textinput-35)],[CustomerName (textinput-3)],[CustomerID (textinput-1)],Dealer.[WorkEmail (textinput-20)]
		
	WHILE (SELECT COUNT(*) FROM #Losses WHERE Processed = 0) > 0
	BEGIN
		DECLARE @account VARCHAR(200);
		SET @account = (SELECT TOP 1 AccountName FROM #Losses)
		SET @strMailBody = '';
		
		SELECT @strMailBody = '<html><body>
							Dear Mr/Ms '+ DealerName +' (' + DealerCode + '),<br><br>
							We are writing to inform you that your client''s trading account is showing overdue outstanding losses as at ' + CONVERT(VARCHAR, GETDATE(), 103) + '. <br><br>
							The information is as follows : <br><br>
							a) Account Name : ' + AccountName + '<br>
							b) Account Code  : ' + AccountCode + '<br>
							c) Outstanding Amount : RM '+ OSAmount +'<br>
							d) Overdue Interest : RM '+ OSInterest +'<br><br>
							Remark : Additional overdue interest at 13% pa on a daily basis will be charged until full payment.<br><br>
							Should your client have forwarded the payment to us for settlement of the aforesaid outstanding amount, we wish to express our sincere gratitude and kindly disregard this notice. <br><br><br>
							Thank you. <br><br>
							Yours sincerely,<br><br>
							</body></html>',
			@strTo = 'nathiya.palanisamy@phillip.com.sg', -- DealerEmail
			@strMailSubject = '[IMPORTANT] Overdue Outstanding Losses of ' + AccountCode,
			@strFrom = 'nathiya.palanisamy@phillip.com.sg'
		FROM 
			#Losses WHERE AccountName = @account

		
		IF ISNULL(@strFrom,'')=''  
		SET   @strFrom='nathiya.palanisamy@phillip.com.sg';  
		IF ISNULL(@strTo,'')=''  
		SET   @strTo='nishanth@phillip.com.sg';     
		IF ISNULL(@strMailSubject,'')=''            
		SET @strMailSubject='[IMPORTANT] Overdue Outstanding Losses of {{Code}}';  
			  


		EXEC [master].[dbo].DBA_SendEmail
		@istrMailTo             = @strTo,
		@istrMailBody           = @strMailBody,
		@istrMailSubject        = @strMailSubject,
		@istrfrom_address       = @strFrom,
		@istrreply_to           = @strFrom,
		@istrbody_format        = 'HTML';

		UPDATE #Losses SET Processed = 1 WHERE AccountName = @account

	END

SET NOCOUNT OFF;
END