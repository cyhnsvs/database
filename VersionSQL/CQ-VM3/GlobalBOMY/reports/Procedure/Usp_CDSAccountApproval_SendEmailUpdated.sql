/****** Object:  Procedure [reports].[Usp_CDSAccountApproval_SendEmailUpdated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_CDSAccountApproval_SendEmailUpdated]
	@istrAcctNo VARCHAR(100)
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
EXEC [reports].[Usp_CDSAccountApproval_SendEmailUpdated] '010037402'

*/

BEGIN  
SET NOCOUNT ON;
       DECLARE @ostrMailContent NVARCHAR(MAX)='';
	  

	  /* Workflow - Start*/         
	
	
	DECLARE @ClientName VARCHAR(100),
	  @AccountNo VARCHAR(100)
	 ,@CDSAccountNo VARCHAR(100)
	 ,@CDSAccountOpenDate VARCHAR(100)
	 ,@DealerRepresentativeCode VARCHAR(100)
	 ,@DealerRepresentativeName VARCHAR(100)
	 ,@DealerRepresentativeContactNo VARCHAR(100)
	 ,@DealerRepresentativeEmail VARCHAR(100);


	SELECT DISTINCT
	  @ClientName                     = C.[CustomerName (textinput-3)]
	 ,@AccountNo                      = A.[AccountNumber (textinput-5)]
	 ,@CDSAccountNo                   = A.[CDSNo (textinput-19)]
	 ,@CDSAccountOpenDate             = CAST(FORMAT(A.CreatedTime, 'dd/MM/yyyy') AS VARCHAR(20))
	 ,@DealerRepresentativeCode       = D.[DealerCode (textinput-35)]
	 ,@DealerRepresentativeName       = D.[Name (textinput-3)]
	 ,@DealerRepresentativeContactNo  = D.[Phone (textinput-16)]
	 ,@DealerRepresentativeEmail      = D.[WorkEmail (textinput-20)]

		
    FROM
		CQBTempDB.export.Tb_FormData_1409 A 
		
	    INNER JOIN  CQBTempDB.export.Tb_FormData_1410 C
		ON A.[CustomerID (selectsource-1)]  = C.[CustomerID (textinput-1)] 

		INNER JOIN CQBTempDB.export.Tb_FormData_1377 D
		ON A.[DealerCode (selectsource-21)] = D.[DealerCode (textinput-35)]

		WHERE A.[AccountNumber (textinput-5)] = @istrAcctNo



	DECLARE @istrClientAddress1 VARCHAR(MAX);
	DECLARE @istrClientAddress2 VARCHAR(MAX);
	DECLARE @istrClientAddress3 VARCHAR(MAX);
	DECLARE @istrClientAddressTown VARCHAR(MAX);
	DECLARE @istrClientAddressState VARCHAR(MAX);
	
		
	SELECT 
	@istrClientAddress1 = Customer.[Address1 (textinput-35)],
	@istrClientAddress2 = Customer.[Address2 (textinput-36)],
	@istrClientAddress3 = Customer.[Address3 (textinput-37)],
	@istrClientAddressTown =Customer.[Town (textinput-38)],
	@istrClientAddressState =Customer.[State (textinput-39)]
	from 
	CQBTempDB.export.Tb_FormData_1409 Account
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer
	ON Customer.[CustomerID (textinput-1)]  = Account.[CustomerID (selectsource-1)]
	Where Account.[AccountNumber (textinput-5)] = @istrAcctNo

    DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')


	
	SET @ostrMailContent= '<html>

							<head>
								<style>
								table {
								  border-collapse: collapse;
								      }
				
								 th{
								  text-align: left;
								   }
				
								</style>
							</head>
						<body><img style="float:Right;" src="'+@Logo+'"/> <br><br><br>
						DATE : '+ CAST(FORMAT(GETDate(), 'dd/MM/yyyy') AS VARCHAR(20)) +'<br><br>
						'+ @ClientName +'(Applicant Name and Correspondance Address)<br>
						'+@istrClientAddress1+'<br>
						'+@istrClientAddress2+'<br>
						'+@istrClientAddress3+'<br>
						'+@istrClientAddressState+'<br>
						'+@istrClientAddressTown+'<br><br>



						Dear Valued Client,<br><br>

						<b style="text-decoration: underline;">APPLICATION OF TRADING ACCOUNT</b><br><br>

						We are pleased to inform that your application for trading account has been approved 
						and you may commence your trading with immediate effect. <b>Your Account details are as follows:</b><br><br>
						<table> <tr> <td> Account Number </td>	<th> : '+ @AccountNo +'</th> </tr>
								<tr> <td> CDS Account Number </td>	<th> : '+ @CDSAccountNo +'</th> </tr>
								<tr> <td> Date of Account Open </td> <th> : '+ @CDSAccountOpenDate +' </th></tr>
								<tr style="height: 20px"> <td></td> <td></td></tr>

 								<tr style="height: 20px"> <td><b>Your Dealer Representative details: </b></td> <td></td></tr>
								<tr> <td>Name </td> <th> : '+ @DealerRepresentativeName +' </th></tr>
								<tr> <td>DR Code </td> <th> : '+ @DealerRepresentativeCode +' </th></tr>
								<tr> <td>Contact No. </td><th> : '+ @DealerRepresentativeContactNo +' </th></tr>
								<tr> <td>Email Address </td><th> : '+ @DealerRepresentativeEmail +' </th></tr>
						</table><br><br>

						Thank you.<br><br>

						This is a <u>computer generated</u> letter and is deemed to have been signed.<br><br>
						
						<b style="color:red;">Website: </b> https://www.mplusonline.com.my  | <b style="color:red;">Email: </b> support@mplusonline.com.my  
						| <b style="color:red;"> Contact: </b><u style="color:#0645AD">1300 22 1233</u><br><br>
						
						This email (and the attachments, if any) may contain privileged or confidential information. If you are not the intended recipient as indicated in 
						this message or as is otherwise apparent, you are not authorised to copy, forward or otherwise distribute this message in any form to any person(s) 
						whomsoever. Malacca Securities Sdn Bhd cannot warrant the accuracy or completeness of the contents of this email and makes no representations as to the same.
						Should you suspect that the message may have been intercepted or tampered with, please contact the sender immediately. <br>
				</body></html>'
						

	

	SELECT  @ostrMailContent;	

	/* WorkFlow - End */

	
SET NOCOUNT OFF;
END