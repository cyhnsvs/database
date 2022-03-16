/****** Object:  Procedure [reports].[Usp_CDSAccountApproval_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_CDSAccountApproval_SendEmail]
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
EXEC [reports].[Usp_CDSAccountApproval_SendEmail] '010037402'
*/

BEGIN  
SET NOCOUNT ON;
       DECLARE @ostrMailContent NVARCHAR(MAX)='';
	  

	  /* Workflow - Start*/         
	
	
	DECLARE @ClientName VARCHAR(100),
	  @ClientCode VARCHAR(100)
	 ,@CDSAccountNo VARCHAR(100)
	 ,@CDSBrokerCode VARCHAR(100)
	 ,@CDSBranchCode VARCHAR(100)
	 ,@CDSAccountOpenDate VARCHAR(100)
	 ,@DealerRepresentativeCode VARCHAR(100)
	 ,@DealerRepresentativeName VARCHAR(100)
	 ,@DealerRepresentativeContactNo VARCHAR(100)
	 ,@DealerRepresentativeEmail VARCHAR(100);


	SELECT DISTINCT
	  @ClientName                     = C.[CustomerName (textinput-3)]
	 ,@ClientCode                     = C.[CustomerID (textinput-1)]
	 ,@CDSAccountNo                   = A.[CDSNo (textinput-19)]
	 ,@CDSBrokerCode                  = ''
	 ,@CDSBranchCode                  = A.[CDSACOpenBranch (selectsource-4)]
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



	SELECT '<tr>' + '<td>' + ISNULL(CDE.[BankName (textinput-4)],'') + '</td>'
				  + '<td style= "font-weight: bold"> :' + ISNULL(BNK.[Account Number (TextBox)],'') + '</td>'
				  + '</tr>' AS data
	INTO #BankAccount 
	FROM CQBTempDB.export.Tb_FormData_1409 ACC
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 CUS 
		ON ACC.[CustomerID (selectsource-1)]  = CUS.[CustomerID (textinput-1)] 
		LEFT JOIN CQBTempDB.export.Tb_FormData_1410_grid6 BNK
		ON CUS.RecordId = BNK.RecordId
		INNER JOIN CQBTempDB.export.Tb_FormData_1431 CDE
		ON CDE.[BankCode (textinput-1)] = BNK.[Bank (Dropdown)]
	WHERE  ACC.[AccountNumber (textinput-5)] = @istrAcctNo


	DECLARE @val1 Varchar(MAX); 
	SELECT @val1 = COALESCE(@val1 + '' + data, data) FROM #BankAccount	



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
						<body><img style="float: Left;" src="'+@Logo+'"/> <br><br><br>
						'+ @ClientName +'<br>
						'+@istrClientAddress1+'<br>
						'+@istrClientAddress2+'<br>
						'+@istrClientAddress3+'<br>
						'+@istrClientAddressState+'<br>
						'+@istrClientAddressTown+'<br><br>



						Dear Valued Client,<br><br>

						<p style="text-decoration: underline;">Application for New Trading Account</p><br>

						We are pleased to inform that your application for trading account has been approved.
						The following trading client code has been assigned to you:<br><br>
						<table> <tr> <td> Client Code </td>	<th> : '+ @ClientCode +'</th> </tr>
								<tr> <td> CDS Account No </td>	<th> : '+ @CDSAccountNo +'</th> </tr>
								<tr> <td> CDS Broker Code </td> <th> : '+ @CDSBrokerCode +'</th> </tr>
								<tr> <td> CDS Branch Code </td> <th> : '+ @CDSBranchCode +'</th> </tr>
								<tr> <td> Date of Account Open </td> <th> : '+ @CDSAccountOpenDate +' </th></tr>
								<tr style="height: 20px"> <td></td> <td></td></tr>
 						
					
								<tr> <td> Dealer Representative Code </td> <th> : '+ @DealerRepresentativeCode +' </th></tr>
								<tr> <td> Dealer Representative Name </td> <th> : '+ @DealerRepresentativeName +' </th></tr>
								<tr> <td> Dealer Representative Contact No. </td><th> : '+ @DealerRepresentativeContactNo +' </th></tr>
								<tr> <td> Dealer Representative Email </td><th> : '+ @DealerRepresentativeEmail +' </th></tr>
						</table><br><br>


						You may commence trading with us with immediate effect.<br><br>

						Kindly inform your Dealers Representative once you have performed Online Bank In/ Cheque Deposit/ Cash Deposit to any of our Malacca
						Securities Sdn Bhd bank account stated below: <br><br>
						<table>'+ @val1 +' </table><br>

						<b>For cheques please issue to "MALACCA SECURITIES SDN BHD TRUST ACCOUNT"</b> <br><br>

						Thank you.<br><br>

						Yours Faithfully,<br>
						MALACCA SECURITIES SDN BHD <br><br>
						<b style="color:red;">Website:</b>https://www.mplusonline.com.my | <b style="color:red;">Email:</b>support@mplusonline.com.my 
						<b style="color:red;">Main Office:</b> 06-337 1533  | <b style="color:red;"> Subang Jaya Branch:</b> 1300 22 1233|  <b style="color:red;">SS2 Branch:</b> 03-7876 1533  |  <b style="color:red;">Johor Bahru Branch: </b>07-335 1533  | 
						<b style="color:red;">Bayan Lepas Branch:</b> 04-642 1533 <br><br>
						This email (and the attachments, if any) may contain privileged or confidential information. If you are not the intended recipient as indicated in 
						this message or as is otherwise apparent, you are not authorised to copy, forward or otherwise distribute this message in any form to any person(s) 
						whomsoever. Malacca Securities Sdn Bhd cannot warrant the accuracy or completeness of the contents of this email and makes no representations as to the same.
						Should you suspect that the message may have been intercepted or tampered with, please contact the sender immediately. <br>
				</body></html>'
						

	

	SELECT  @ostrMailContent;	

	/* WorkFlow - End */

	
SET NOCOUNT OFF;
END