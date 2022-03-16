/****** Object:  Procedure [process].[Usp_MarkNakedShortSellContracts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_MarkNakedShortSellContracts]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_MarkNakedShortSellContracts]
Created By        : Nishanth Chowdhary
Created Date      : 06/10/2017
Last Updated Date : 
Description       : this sp is used to import the accounts from ClientData on a daily basis
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_MarkNakedShortSellContracts] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		DECLARE @dteBusDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate'); --'2018-04-02'; --

		SET @dteBusDate  ='2020-12-31';

		declare @logs table(
			[MessageLog] varchar(8000),
			LogDateTime datetime
		);
		
		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'START - Archive NakedShortSellDetails');

		--INSERT INTO NakedShortSellDetails_Archive
		--SELECT *, GETDATE() FROM NakedShortSellDetails;

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Archive NakedShortSellDetails');

		TRUNCATE TABLE NakedShortSellDetails;

		INSERT INTO NakedShortSellDetails
			([BusinessDate],[RowNum],[ContractNo],[ContractDate],[AcctNo],[ClientCd],[InstrumentId],[TransType],[TradedQty],[TotQty],[ShortSellQty],[Tag4],FundSourceId)

		select @dteBusDate, ROW_NUMBER() OVER (partition by AcctNo, InstrumentId  ORDER BY [Src],TradeDate, tag2, ContractNo) RowNum,
			[ContractNo],TradeDate,[AcctNo],[ClientCd],[InstrumentId],[TransType],[TradedQty],[TotQty],[ShortSellQty],[Tag4] ,FundSourceId
		from 
			(
			--ALL SETTLED BUY HOLDINGS 
			select 1 [Src],'P1' AS ContractNo, @dteBusDate AS TradeDate, CA.AcctNo, CL.ClientCd, CA.InstrumentId, 'TRBUY' AS TransType, Balance + UnavailableBalance AS TradedQty, 
				   0.00 AS TotQty, 0.00 AS ShortSellQty, '  ' AS Tag4 , 'P1' AS tag2, CA.FundSourceId
			from GlobalBO.holdings.Tb_CustodyAssets CA
			inner join (SELECT DISTINCT AcctNo, InstrumentId, FundSourceId
						FROM GlobalBO.contracts.Tb_ContractOutstanding WHERE CPartyInd='N' AND ContractStatus='O' AND TradeDate=@dteBusDate) C
			on CA.AcctNo = C.AcctNo and CA.InstrumentId = C.InstrumentId and CA.FundSourceId = C.FundSourceId
			inner join GlobalBO.setup.Tb_Account A
			on CA.AcctNo = A.AcctNo
			inner join (
				SELECT ClientId, ClientCd, 'I' AS ClientType FROM GlobalBO.setup.Tb_Personnel 
				UNION ALL
				SELECT CorporateClientId AS ClientId, CorporateClientCd AS ClientCd, 'CI' AS ClientType FROM GlobalBO.setup.Tb_CorporateClient) CL
			ON  A.MainClientId = CL.ClientId AND A.AcctType = CL.ClientType
		
			--where AcctNo='23244-1' and InstrumentId=7600
			--AND CA.Balance > 0 AND CA.FinalBalance < 0
			--AND CA.FinalBalance > 0

			UNION ALL
		
			--TRANSACTIONS SETTLING ON BIZ DAY OR RIGHTS/IPO RELEASE CREATED ON BIZ DAY (AND SETTLING ON BIZ + 2)
			select 2 [Src],'P2' AS TransNo, TS.TransDate AS TradeDate, TS.AcctNo, CL.ClientCd, TS.InstrumentId, 
				   CASE WHEN SUM(TradedQty) > 0 THEN 'INTI' ELSE 'INTO' END TransType, SUM(TradedQty) AS TradedQty, 
				   0.00 AS TotQty, 0.00 AS ShortSellQty, '  ' AS Tag4 , 'P2' AS tag2,TS.FundSourceId
			from GlobalBO.transmanagement.Tb_Transactions AS TS
			inner join GlobalBO.transmanagement.Tb_TransactionApproval AS TA
			on TS.RecordId = TA.ReferenceID
			inner join (SELECT DISTINCT AcctNo, InstrumentId, FundSourceId
						FROM GlobalBO.contracts.Tb_ContractOutstanding WHERE CPartyInd='N' AND ContractStatus='O' AND TradeDate=@dteBusDate) C
			on TS.AcctNo = C.AcctNo and TS.InstrumentId = C.InstrumentId and TS.FundSourceId = C.FundSourceId
			inner join GlobalBO.setup.Tb_Account A
			on TS.AcctNo = A.AcctNo
			INNER JOIN (
				SELECT ClientId, ClientCd, 'I' AS ClientType FROM GlobalBO.setup.Tb_Personnel 
				UNION 
				SELECT CorporateClientId AS ClientId, CorporateClientCd AS ClientCd, 'CI' AS ClientType FROM GlobalBO.setup.Tb_CorporateClient) CL
			on A.MainClientId = CL.ClientId AND A.AcctType = CL.ClientType		
			WHERE TS.TransType IN ('INTI','INTO','INMI','INMO') 
				AND (TS.SetlDate = @dteBusDate
					OR (TS.TransDate <= @dteBusDate AND SetlDate > @dteBusDate ))
			AND TA.AppLevel = '3' AND TA.AppStatus <> 'R'
			GROUP BY TS.TransDate, TS.AcctNo, CL.ClientCd, TS.InstrumentId,TS.FundSourceId

			UNION ALL
		
			--ALL CONTRACTS ON BIZ DAY
			select 3 [Src],'P3' + ContractNo, TradeDate, C.AcctNo, CL.ClientCd, InstrumentId, TransType, TradedQty,
				   0.00 AS TotQty, 0.00 AS ShortSellQty, '  ' AS Tag4  , 'P3' + tag2 AS tag2,C.FundSourceId
			from GlobalBO.contracts.Tb_ContractOutstanding AS C
			inner join GlobalBO.setup.Tb_Account A
			on C.AcctNo = A.AcctNo
			INNER JOIN (
				SELECT ClientId, ClientCd, 'I' AS ClientType FROM GlobalBO.setup.Tb_Personnel 
				UNION 
				SELECT CorporateClientId AS ClientId, CorporateClientCd AS ClientCd, 'CI' AS ClientType FROM GlobalBO.setup.Tb_CorporateClient) CL
			on A.MainClientId = CL.ClientId AND A.AcctType = CL.ClientType		
			WHERE CPartyInd='N' AND ContractStatus='O'  AND TradeDate=@dteBusDate
			
			UNION ALL
		
			--ALL CONTRACTS OS ON BIZ DAY
			select 3 [Src],'P3' + ContractNo, TradeDate, C.AcctNo, CL.ClientCd, C.InstrumentId, TransType, TradedQty,
				   0.00 AS TotQty, 0.00 AS ShortSellQty, '  ' AS Tag4   , 'P3' + tag2 AS tag2 ,C.FundSourceId
			from GlobalBO.contracts.Tb_ContractOutstanding AS C
			inner join (SELECT DISTINCT AcctNo, InstrumentId, FundSourceId
						FROM GlobalBO.contracts.Tb_ContractOutstanding WHERE CPartyInd='N' AND ContractStatus='O' AND TradeDate=@dteBusDate ) CT
			on CT.AcctNo = C.AcctNo and CT.InstrumentId = C.InstrumentId and CT.FundSourceId = C.FundSourceId
			inner join GlobalBO.setup.Tb_Account A
			on C.AcctNo = A.AcctNo
			INNER JOIN (
				SELECT ClientId, ClientCd, 'I' AS ClientType FROM GlobalBO.setup.Tb_Personnel 
				UNION 
				SELECT CorporateClientId AS ClientId, CorporateClientCd AS ClientCd, 'CI' AS ClientType FROM GlobalBO.setup.Tb_CorporateClient) CL
			on A.MainClientId = CL.ClientId AND A.AcctType = CL.ClientType		
			WHERE CPartyInd='N' AND ContractStatus='O'AND TradeDate<@dteBusDate) SSF

		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into NakedShortSellDetails');

		
		UPDATE A SET A.TotQty = runningTotal  FROM 
		NakedShortSellDetails AS A INNER JOIN
			(
			SELECT
				 SUM (TradedQty) OVER (PARTITION BY AcctNo,FundsourceId,InstrumentId ORDER BY Rownum) As runningTotal ,
				 Rownum,
				 AcctNo, InstrumentId,FundsourceId
			from 
				NakedShortSellDetails
			) AS B 
		ON A.AcctNo = B.AcctNo AND A.RowNum = B.RowNum AND A.InstrumentId = B.InstrumentId AND A.FundsourceId = B.FundsourceId ;
		
		
		 UPDATE NakedShortSellDetails SET ShortSellQty = TotQty WHERE TotQty < 0 AND TradedQty < 0 AND TradedQty < TotQty AND TransType ='TRSELL'
	     UPDATE NakedShortSellDetails SET ShortSellQty = TradedQty WHERE TotQty < 0 AND TradedQty < 0 AND TradedQty >= TotQty AND TransType ='TRSELL'
 
		
	
		SELECT 
			ROW_NUMBER() OVER (ORDER BY A.AcctNo, A.InstrumentId,A.ROWNUM) AS Rownum, 
			a.AcctNo , a.InstrumentId ,  case when  a.RowNum = c.minRowNum then a.TotQty else A.TradedQty  end TradedQty, 
			A.FundsourceId, A.ContractNo,ShortSellQty	INTO #OUT
		FROM  NakedShortSellDetails AS A INNER JOIN 					
			(	SELECT 
					a.AcctNo , a.InstrumentId , min(b.RowNum) as minRowNum
				from NakedShortSellDetails as a inner join 	 
					(
						SELECT 
							AcctNo , InstrumentId,min(RowNum) as RowNum 
						from 
							NakedShortSellDetails  
						WHERE 
							ShortSellQty <> 0 and TransType ='trsell' 
						GROUP BY AcctNo , InstrumentId
					) AS B
				ON a.AcctNo = b.AcctNo and a.InstrumentId = b.InstrumentId and a.RowNum > b.RowNum and a.TradedQty > 0
				GROUP BY
					A.AcctNo , A.InstrumentId  
				) AS C 
			ON A.AcctNo  = C.AcctNo AND A.InstrumentId = C.InstrumentId AND A.TransType ='TRSELL' and a.RowNum > = minRowNum
		ORDER BY A.AcctNo, A.InstrumentId,A.ROWNUM

		SELECT 
			ROW_NUMBER() OVER (ORDER BY A.AcctNo, A.InstrumentId,A.ROWNUM) AS Rownum, 
			a.AcctNo , a.InstrumentId , case when  a.RowNum = c.minRowNum then a.TotQty else A.TradedQty  end TradedQty, 
			A.FundsourceId, A.ContractNo,0 AS MatchQtyOut,ShortSellQty	INTO #IN
		FROM  NakedShortSellDetails AS A INNER JOIN 					
			(SELECT 
					a.AcctNo , a.InstrumentId , min(b.RowNum) as minRowNum
				from NakedShortSellDetails as a inner join 	 
					(
						SELECT 
							AcctNo , InstrumentId,min(RowNum) as RowNum 
						from 
							NakedShortSellDetails  
						WHERE 
							ShortSellQty <> 0 and TransType ='trsell' 
						GROUP BY AcctNo , InstrumentId
					) AS B
				ON a.AcctNo = b.AcctNo and a.InstrumentId = b.InstrumentId and a.RowNum > b.RowNum and a.TradedQty > 0
				GROUP BY
					A.AcctNo , A.InstrumentId  
				) AS C 
			ON A.AcctNo  = C.AcctNo AND A.InstrumentId = C.InstrumentId AND A.TransType ='TRBUY' and a.RowNum > = c.minRowNum
		ORDER BY A.AcctNo, A.InstrumentId,A.ROWNUM

			TRUNCATE TABLE [dbo].[Tb_IDSS];

			UPDATE #IN SET MatchQtyOut = 0 ; 

			DECLARE @ProcessOutRowId BIGINT = 1;	
		
			WHILE EXISTS (SELECT 1 FROM #OUT WHERE Rownum = @ProcessOutRowId)
			BEGIN 
			
				DECLARE @AcctNo VARCHAR(25), @InstrumentId BIGINT, @FundSourceId BIGINT, 
						@RemainingInQty decimal(24,9)=0, @TotOutQty decimal(24,9)=0, @strTransNo varchar(50),
						@MatchQty decimal(24,9)=0,@TradedQtyIn decimal(24,9)=0 ;
			
				SELECT 
					@AcctNo = AcctNo, 
					@InstrumentId = InstrumentId, 
					@FundSourceId = FundSourceId,
					@strTransNo = ContractNo,
					@TotOutQty = TradedQty
				FROM 
					#OUT 
				WHERE 
					Rownum = @ProcessOutRowId;

				--select @AcctNo ,@InstrumentId,@FundSourceId;

				DECLARE @ProcessInRowId BIGINT = (SELECT MIN(Rownum) FROM #IN 	 WHERE AcctNo = @AcctNo and InstrumentId = @InstrumentId and FundSourceId = @FundSourceId AND TradedQty - @MatchQty > 0  );
				set @MatchQty = 0;
				
					
					WHILE  (@TotOutQty < 0 ) and exists 
												(select 1 FROM 
													#IN  
												WHERE 
													AcctNo = @AcctNo and InstrumentId = @InstrumentId and FundSourceId = @FundSourceId and RowNum = @ProcessInRowId   )
					BEGIN

						SELECT  
							@MatchQty = ABS(CASE WHEN  @TotOutQty + TradedQty  - ISNULL(MatchQtyOut,0) < 0  THEN TradedQty  - ISNULL(MatchQtyOut,0) ELSE @TotOutQty  END)   ,											
							@TotOutQty = @TotOutQty + TradedQty  - ISNULL(MatchQtyOut,0),
							@strTransNo = ContractNo	,
							@TradedQtyIn = TradedQty
						FROM 
							#IN  
						WHERE 
							AcctNo = @AcctNo and InstrumentId = @InstrumentId and FundSourceId = @FundSourceId and RowNum = @ProcessInRowId;



						UPDATE #IN  SET MatchQtyOut  = CASE WHEN @TotOutQty > 0 THEN @MatchQty ELSE TradedQty END 
						WHERE 
							AcctNo = @AcctNo and InstrumentId = @InstrumentId and FundSourceId = @FundSourceId and RowNum = @ProcessInRowId;		
													
						INSERT INTO [dbo].[Tb_IDSS]
								   ([BusinessDate]  ,[TransNoOut],[InstrumentId],[TradedQtyOut],[MatchQty],[RemaingQty],[TransNoIn],[TradedQtyIn],[ShortSellQty])
						SELECT 
							@dteBusDate ,ContractNo,[InstrumentId],[TradedQty],@MatchQty
							,case when @TotOutQty > = 0 then 0 else  @TotOutQty end  AS [RemaingQty]
							,@strTransNo
							,@TradedQtyIn 
							,ShortSellQty
						FROM
							#OUT 
						WHERE AcctNo = @AcctNo and InstrumentId = @InstrumentId and FundSourceId = @FundSourceId AND RowNum = @ProcessOutRowId
						
						
						if @TotOutQty <= 0 
						begin
							SET @ProcessInRowId = @ProcessInRowId + 1
						end						
						--select @RemainingInQty,@TotOutQty,@decTradedPrice,@ProcessInRowId,@AcctNo,@InstrumentId,@FundSourceId;
					
					END
										
						SELECT @ProcessOutRowId = @ProcessOutRowId + 1;
					
				END



		INSERT INTO @logs (LogDateTime, [MessageLog]) values (GETDATE(), 'END - Insert Into NakedShortSellDetails after While Loop');
			
		UPDATE NakedShortSellDetails
		SET Tag4 = '<i K="IDSS" V="' + CAST(CAST(A.ShortSellQty AS BIGINT) AS VARCHAR) + '"/>'
		FROM 
			DBO.NakedShortSellDetails AS A INNER JOIN [dbo].[Tb_IDSS]  AS B ON
			A.ContractNo = B.transnoout
		WHERE
			A.TransType ='TRSELL' AND A.ShortSellQty < 0 AND B.RemaingQty =0;
		
		UPDATE NakedShortSellDetails
		--SET Tag4 = Tag4 + REPLACE(Tag4,'<i K="NakedShort" V="1" />','<i K="NakedShort" V="' + CAST(CAST(ISNULL(B.RemaingQty,A.ShortSellQty) AS BIGINT) AS VARCHAR) + '" />')
		SET Tag4 = Tag4 + '<i K="NakedShort" V="' + CAST(CAST(ISNULL(B.RemaingQty,A.ShortSellQty) AS BIGINT) AS VARCHAR) + '"/>'
		FROM 
			DBO.NakedShortSellDetails AS A LEFT JOIN [dbo].[Tb_IDSS]  AS B ON
			A.ContractNo = B.transnoout
		WHERE
			A.TransType ='TRSELL' AND A.ShortSellQty < 0 AND ISNULL(B.RemaingQty,A.ShortSellQty) < 0

		--UPDATE CO
		--SET CO.Tag4 = ISNULL(CO.Tag4,'') + SS.Tag4, co.ModifiedBy ='Usp_MarkNakedShortSellContracts' , co.ModifiedDate = GETDATE ()
		--FROM GlobalBO.contracts.Tb_ContractOutstanding AS CO
		--INNER JOIN NakedShortSellDetails AS SS
		--ON 'P3' + CO.ContractNo = SS.ContractNo AND SS.BusinessDate = CO.TradeDate
		--WHERE SS.ContractDate = @dteBusDate AND SS.Tag4 <> '' and ContractStatus='O';
				
		--DROP TABLE #SSFIFO;
		DROP TABLE #in;
		DROP TABLE #out;
	

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
												  SELECT LogDateTime, 'GlobalBOTH.process.Usp_MarkNakedShortSellContracts', '', [MessageLog] 
												  from @logs;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);
		
		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_MarkNakedShortSellContracts: Failed'

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		      
		ROLLBACK TRANSACTION;

		SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

		insert into GlobalBOLocal.dbo.LogDiagnostics(LogDateTime, Module, ReferenceNo, [MessageLog])	
												  SELECT LogDateTime, 'process.Usp_MarkNakedShortSellContracts', '', [MessageLog] 
												  from @logs;
		
		EXEC [master].[dbo].DBA_SendEmail   
		@istrMailTo             = @strEmailTo,
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = @strEmailSubj, 
		@istrimportance         = 'high', 
		@istrfrom_address       = @strEmailFrom, 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END