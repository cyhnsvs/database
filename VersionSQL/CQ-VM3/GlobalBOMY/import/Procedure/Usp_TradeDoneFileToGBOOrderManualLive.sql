/****** Object:  Procedure [import].[Usp_TradeDoneFileToGBOOrderManualLive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_TradeDoneFileToGBOOrderManualLive]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 02/04/2020
Last Updated Date :             
Description       : this sp is used to insert trade into Order manual live table
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
 
PARAMETERS
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');
		TRUNCATE TABLE GlobalBOLocal.import.Tb_OrderManualLive;
		TRUNCATE TABLE GlobalBOLocal.import.Tb_OrderManualLiveAuditLog;

		INSERT INTO GlobalBOLocal.import.Tb_OrderManualLive  
		(   
			OrderNo, 
			SubOrderNo, 
			CompanyId, 
			OrderAmendNo,
			AcctNo,
			AcctExecutiveCd,
			ChequeName,
			ProductCd,
			InstrumentCd,
			InstrumentName,
			Symbol,
			SymbolSuffix,
			ISINCd,
			InstrumentIdentifier,
			ExchCd,
			ContractMonth,
			StrikePrice,
			CPInd,
			ContractCd,
			SetlDate,
			InterestSetlDate,
			TradedCurrCd,
			TransType,
			TradeType,
			TradedQty,
			TradedPrice,
			APIPrice,
			TradeDate,
			TimeSlotId,
			AmalgamationInd,
			Facility,
			CPartyCd,
			CPartyAcctNo,
			Channel,
			SetlCurrCd,
			TradeSetlExchRate,
			FundSourceCd,
			DeliveryMethod,
			CloseOutRef,
			TradeAllocationCd,
			AccruedInterestAmount,
			BrokerageAmount,
			BrokerageExpense,
			ExchFeeAmount,
			ExchFeeTax,
			ChargesAmount,
			ChargesTax,
			CPBrokerageAmount,
			CPExchFeeAmount,
			CPExchFeeTax,
			CPChargesAmount,
			CPChargesTax,
			Tag1,
			Tag2,
			Tag3,
			Tag4,
			Tag5,
			ProcessInfo,
			OrderStatus,
			BrokerageValue,
			BrokerageType,
			AllocatedAmount,
			OperationRef,
			RecordId,
			ActionInd,
			CurrentUser,
			CreatedBy,
			CreatedDate
		)
		SELECT 
			SeqNo,
			TradeOrderSerialNo SubOrderNo,
			1 CompanyId,
			0 OrderAmendNo,
			B.AcctNo,
			AcctExecutiveCd,
			ChequeName,
			D.ProductCd,
			C.InstrumentCd,
			C.FullName InstrumentName,
			isnull(Symbol,'') As Symbol,
			isnull(SymbolSuffix,'') As SymbolSuffix,
			ISINCd,
			1 InstrumentIdentifier,
			'XKLS' ExchCd,
			ISNULL( ContractMonth,'') As ContractMonth,
			0 StrikePrice,
			'' CPInd,
			0 ContractCd,
			TransactionDate SetlDate,
			null InterestSetlDate,
			TradedCurrCd,
			CASE WHEN TradeType IN ('1','3') THEN 'TRBUY' 
				 WHEN TradeType IN ('2','4') THEN 'TRSELL' END TransType,
			CASE --WHEN OrderType = '0' THEN 'Normal' 
				WHEN OrderType In ('10','12','13','14') THEN 'OddLot'
				ELSE 'Normal' END As TradeType,
			TransQty,
			TradePrice,
			TradePrice APIPrice,
			TransactionDate,
			'' TimeSlotId,
			--CASE WHEN [AveragingOption (multipleradiosinline-1)] IN ('1','Y','Yes') THEN ''
			CASE WHEN AveragingOption IN ('1','Y','Yes') THEN ''
				 ELSE '-'
				 END AS AmalgamationInd,
			BFE.ContractTypeCode As Facility,
			CPartyAcctNo As CPartyCd,
			TradingAcctNo As CPartyAcctNo,
			CASE WHEN InternetInd = 'I' THEN 'Online' Else 'Offline' END As  Channel,
			'MYR' SetlCurrCd,
			1 TradeSetlExchRate,
			'Cash' As FundSourceCd,
			''DeliveryMethod,
			''CloseOutRef,
			'' TradeAllocationCd,
			0 AccruedInterestAmount,
			0 BrokerageAmount,
			0 BrokerageExpense,
			0 ExchFeeAmount,
			0 ExchFeeTax,
			0 ChargesAmount,
			0 ChargesTax,
			0 CPBrokerageAmount,
			0 CPExchFeeAmount,
			0 CPExchFeeTax,
			0 CPChargesAmount,
			0  CPChargesTax,
			TradeOrderNo Tag1,
			TradeOrderSerialNo Tag2,
			'' Tag3,
			'' Tag4,
			ISNULL(IA.IntroducerCode,'') +'|' + ISNULL(BM.BranchID,'001') Tag5,
			'' ProcessInfo,
			'A' OrderStatus,
			0 BrokerageValue,
			''  BrokerageType,
			0 AllocatedAmount,
			''  OperationRef,
			newid() RecordId,
			'I'ActionInd,
			'Auto-Bursa-Trade' CurrentUser,
			'Auto-Bursa-Trade' CreatedBy,
			getdate() CreatedDate
		--select distinct a.BursaStockCode
		FROM import.Tb_TradeDone_20211001 AS A
		INNER JOIN GlobalBOMY.import.Tb_Account AS IA
		ON A.AcctNo = IA.AccountNumber
		INNER JOIN GlobalBO.setup.Tb_Account AS B on 
		A.AcctNo = B.ExtRefKey
		--INNER JOIN CQBTempDB.export.Tb_FormData_1409 AS AI
		--ON A.AcctNo = AI.[AccountNumber (textinput-5)]
		INNER JOIN GlobalBO.setup.Tb_Instrument AS C 
		ON RTRIM(A.BursaStockCode) + '.XKLS' = C.InstrumentCd
		--WHERE C.instrumentid is null
		INNER JOIN GlobalBO.setup.Tb_ProductCategory AS D 
		ON C.ProductId = D.ProductId
		LEFT JOIN GlobalBO.setup.Tb_CounterPartyAccount As CP
		--ON '0' + A.CounterBrokerID = CP.TradingAcctNo AND A.CDSNo = CP.CPartyAcctNo
		ON CP.CPartyAcctNo='CPBURSA001'
		LEFT JOIN import.Tb_BFEOrderType As BFE
		ON BFE.BFEOrderType = A.OrderType
		LEFT JOIN GlobalBOMY.import.Tb_DealerRef AS DR
		ON IA.BrokerCodeDealerEAFIDDealerCode = DR.DealerCd
		LEFT JOIN GlobalBOMY.import.Tb_BranchMapping AS BM
		ON DR.SBranch = BM.SBranch
		WHERE A.MessageCode = '703';
		
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
	    
	    ROLLBACK TRANSACTION;
	    
        DECLARE @intErrorNumber INT
	        ,@intErrorLine INT
	        ,@intErrorSeverity INT
	        ,@intErrorState INT
	        ,@strObjectName VARCHAR(200)
			,@ostrReturnMessage VARCHAR(4000);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

   --     EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	  --      --,@ostrReturnMessage
			--,''
	  --      ,@intErrorLine
	  --      ,@strObjectName
	  --      ,NULL /*Code Section not available*/
	  --      ,'Process fail.';

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );

    END CATCH
    
    SET NOCOUNT OFF;
END