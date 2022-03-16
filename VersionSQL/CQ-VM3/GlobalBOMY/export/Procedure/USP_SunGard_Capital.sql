/****** Object:  Procedure [export].[USP_SunGard_Capital]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_SunGard_Capital]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (Line char(50)
 ,Path char(50)
 ,Userid char(50)
 ,Client char(50)
 ,DailyCapital char(50)
 ,LongCapital char(50)
 ,ShortCapital char(50)
 ,CapitalOrder char(50)
 ,QuantityOrder char(50)
 ,NbOrdersSec char(50)
 ,Credit char(50)
 ,Ratio char(50)
 ,Currency char(50)
 ,Nbmessages char(50)
 ,PnL char(50)
 ,UnrealisedPnL char(50)
 ,RealisedPnl char(50)
 ,Qutolockout char(50)
 ,PnLmode char(50)
 ,CalculationMode char(50)
 ,CapitalAdjustment char(50)
 ,LongCapitalAdjustment char(50)
 ,ShortCapitalAdjustment char(50)
 ,CreditAdjustment char(50)
 ,ManipCap char(50)
 ,ManipPrct char(50)
 ,StartTime char(50)
 ,EndTime char(50)
 ,FilterType char(50)
 ,PnLAdjustment char(50)
 ,FilterName char(50)
 ,CapitalRatio char(50)
 ,IsRejectRecycled char(50)
 ,CapitalAdjustmentValidityDate char(50)
 ,LongCapitalAdjustmentValidityDate char(50)
 ,ShortCapitalAdjustmentValidityDate char(50)
 ,CreditAdjustmentValidityDate char(50)
 ,PnlAdjustmentValidityDate char(50)
 ,AddFeestoCapital char(50)
 ,RelativeCapital char(50)
 ,RelativeLongCapital char(50)
 ,RelativeShortCapital char(50)
 ,RelativeCredit char(50)
 ,PreventCrossCurrency char(50)
 ,FilterServerNode char(50)
 ,FilterServerSubnode char(50)
 );
INSERT INTO #Detail(Line
,Path
,Userid
,Client
,DailyCapital
,LongCapital
,ShortCapital
,CapitalOrder
,QuantityOrder
,NbOrdersSec
,Credit
,Ratio
,Currency
,Nbmessages
,PnL
,UnrealisedPnL
,RealisedPnl
,Qutolockout
,PnLmode
,CalculationMode
,CapitalAdjustment
,LongCapitalAdjustment
,ShortCapitalAdjustment
,CreditAdjustment
,ManipCap
,ManipPrct
,StartTime
,EndTime
,FilterType
,PnLAdjustment
,FilterName
,CapitalRatio
,IsRejectRecycled
,CapitalAdjustmentValidityDate
,LongCapitalAdjustmentValidityDate
,ShortCapitalAdjustmentValidityDate
,CreditAdjustmentValidityDate
,PnlAdjustmentValidityDate
,AddFeestoCapital
,RelativeCapital
,RelativeLongCapital
,RelativeShortCapital
,RelativeCredit
,PreventCrossCurrency
,FilterServerNode
,FilterServerSubnode
)
VALUES('Line' ,'Path' ,'Userid' ,'Client' ,'DailyCapital' ,'LongCapital' ,'ShortCapital' ,'CapitalOrder' ,'QuantityOrder' ,'NbOrdersSec' ,'Credit' ,'Ratio' ,'Currency' ,'Nbmessages' ,'PnL' ,'UnrealisedPnL' ,'RealisedPnl' ,'Qutolockout' ,'PnLmode' ,'CalculationMode' ,'CapitalAdjustment' ,'LongCapitalAdjustment' ,'ShortCapitalAdjustment' ,'CreditAdjustment' ,'ManipCap' ,'ManipPrct' ,'StartTime' ,'EndTime' ,'FilterType' ,'PnLAdjustment' ,'FilterName' ,'CapitalRatio' ,'IsRejectRecycled' ,'CapitalAdjustmentValidityDate' ,'LongCapitalAdjustmentValidityDate' ,'ShortCapitalAdjustmentValidityDate' ,'CreditAdjustmentValidityDate' ,'PnlAdjustmentValidityDate' ,'AddFeestoCapital' ,'RelativeCapital' ,'RelativeLongCapital' ,'RelativeShortCapital' ,'RelativeCredit' ,'PreventCrossCurrency' ,'FilterServerNode' ,'FilterServerSubnode' )
---RESULT SET
SELECT Line+Path+Userid+Client+DailyCapital+LongCapital+ShortCapital+CapitalOrder+QuantityOrder+NbOrdersSec+Credit+Ratio+Currency+Nbmessages+PnL+UnrealisedPnL+RealisedPnl+Qutolockout+PnLmode+CalculationMode+CapitalAdjustment+LongCapitalAdjustment+ShortCapitalAdjustment+CreditAdjustment+ManipCap+ManipPrct+StartTime+EndTime+FilterType+PnLAdjustment+FilterName+CapitalRatio+IsRejectRecycled+CapitalAdjustmentValidityDate+LongCapitalAdjustmentValidityDate+ShortCapitalAdjustmentValidityDate+CreditAdjustmentValidityDate+PnlAdjustmentValidityDate+AddFeestoCapital+RelativeCapital+RelativeLongCapital+RelativeShortCapital+RelativeCredit+PreventCrossCurrency+FilterServerNode+FilterServerSubnode  FROM #Detail
 

 
DROP TABLE #Detail 
END