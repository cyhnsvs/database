/****** Object:  Procedure [reports].[Usp_MRLicenseRenewalReminder_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_MRLicenseRenewalReminder_SendEmail]	
	@istrMRCode VARCHAR(100)
AS  
/*
* Created by:      SRIRAM
* Date:            12 Feb 2021
* Used by:         GBO Process 
* Called by:       GBO Batch Process Manager Monitor
* Project UIN:	   
* RFA:			   
*
* 
*
* Input Parameters:
*MR Code
*
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* 1. 
EXEC [reports].[Usp_MRLicenseRenewalReminder_SendEmail] 'A001/2018'
*/

BEGIN  
SET NOCOUNT ON;

		DECLARE @strMailBody VARCHAR(MAX)='';

		DECLARE @MRName VARCHAR(200),
				@ExpiryDate VARCHAR(20),
				@TrainingDays VARCHAR(10),
				@MinTrainingDays VARCHAR(20)
		
		--Testing--
		--SET @MRName = 'Sriram';
		--SET @ExpiryDate = '2021-06-09';
		--SET @CPEPoints  = '19';



		SET @MinTrainingDays = (SELECT GlValue FROM GlobalBO.setup.Tb_GlobalValues WHERE GlType = 'MRMinTrainingDays')

	----WorkFlow----
	
	SELECT 
		@MRName     = ISNULL(MRE.[Name (textinput-1)],''),
		@ExpiryDate = ISNULL(CAST(FORMAT(CAST(MRE.[AnniversaryDate (dateinput-2)]AS Datetime2), 'dd.MM.yyyy') AS varchar(20)),''),
		@TrainingDays  = ISNULL(CPE.[Training Days (TextBox)],'')
	FROM 
		CQBTempDB.export.Tb_FormData_1575 MRE 
	LEFT JOIN CQBTempDB.export.Tb_FormData_1575_grid4 CPE
		ON MRE.RecordId = CPE.RecordId
	WHERE MRE.[MRCode (textinput-17)]  = @istrMRCode;
	
	DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')

	SET @strMailBody = '<html><body>
	                    <img src="'+@Logo+'" /> <br><br>

						Hi '+@MRName+', <br><br>
						Please be reminded that your license will be expired on <b style="color:red;">'+CAST(@ExpiryDate AS VARCHAR)+'</b><br><br>
						Training Days needed before '+CAST(@ExpiryDate AS VARCHAR)+' : '+@MinTrainingDays+'  <br>
						Your Current Training Days : '+ CASE WHEN @TrainingDays ='' THEN '0' ELSE @TrainingDays END +' <br>
						SC does not grant any extension of time for non-compliance to CPE requirement as the license <
						holders are expected to observe the following clauses in Chapter 8 of the Licensing Handbook: <br><br>
						1. 8.01(5) where, "All  CMSRL  holders <b style="text-decoration: underline"> must </b> obtain  '+@MinTrainingDays+'  CPE  points  in  a  year  on  or  before 
						the anniversary date of their licence or cycle period as required in order to continue carrying out 
						the relevant regulated activity." <br><br>
						You may refer to the link below to check the <b> Instructor-LED or Online </b>  course that suit your 
						availability and register yourself with the training provider.<br><br>
						http://ers.seccom.com.my/cpepublic/SearchTrainingCalendar.aspx?ActiveTab=1 <br><br>
						Kindly revert soonest possible.<br><br>
 
						Thank you.<br>
						Best Regards,<br>
						Licensing Team<br>
						</body></html>';

	SELECT @strMailBody
		
	
SET NOCOUNT OFF;
END