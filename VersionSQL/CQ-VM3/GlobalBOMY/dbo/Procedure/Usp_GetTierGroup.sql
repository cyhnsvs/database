/****** Object:  Procedure [dbo].[Usp_GetTierGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_GetTierGroup]
    @iintCompanyId int,
	@strTierCategory varchar(20)
AS
BEGIN

SET NOCOUNT ON;
    
	SELECT CAST(TierGroupId as varchar(20))+'-'+TierGroupCd ItemValue,
		   Remarks ItemLabel,
		   '<table><tr><td colspan=''4''> <b> TierGroupCd : </b> ' + G.TierGroupCd +'&nbsp;&nbsp;<b> TierCategory : </b> '+ G.TierCategory +'&nbsp;&nbsp;<b>Remarks : </b> '+G.Remarks + '</td></tr></table>' + --AS HeaderLabel,
		   '<table>' +
		   CAST('<tr><th>TierCategory</th><th style="width:10px;"></th><th>FromValue</th><th style="width:20px;"></th><th>ToValue</th><th>Rate</th></tr>' + 
				(select replace (REPLACE(STUFF((select '<tr>' +'<td>' + cast ( TierCategory as varchar) + '</td>'
													+'<td style=''padding-left:2px''>></td>'
													+'<td class=''r''>' + cast ( CAST(ROUND(FromValue,2) as decimal(24,2)) as varchar) + '</td>' 
													+'<td style=''padding-left:3px''><=</td>'
													+'<td class=''r''>' + cast ( CAST(ROUND(ToValue,2,1) as decimal(24,2)) as varchar) + '</td>' 
													+'<td class=''r''>' + cast ( CAST(ROUND(Rate,4) as decimal(24,4))	 as varchar) + '</td>' +
													'</tr>' 
				from GlobalBO.setup.Tb_Tier T where T.TierGroupId= G.TierGroupId FOR XML PATH('')), 1, 0, ''),'&lt;','<'),'&gt;','>')+ '</table>') as varchar(4000)) AS DetailedInfo
    FROM GlobalBO.setup.Tb_TierGroup AS G
	WHERE TierCategory = @strTierCategory and CompanyId = @iintCompanyId;

	--select replace (REPLACE(STUFF((select '<tr>' +'<td>' + cast ( TierCategory as varchar) + '</td>' +'<td class=''r''>' + cast ( FromValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( ToValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( Rate  		 as varchar) + '</td>' + 
	--'</tr>' from setup.Tb_Tier T where T.TierGroupId= #result.NewValue            FOR XML PATH('')         ), 1, 0, ''),'&lt;','<'),'&gt;','>')+ '</table>') 
	--,
	--OldValuedesc= OldValuedesc + (
	--select replace (REPLACE(STUFF((select '<tr>' +'<td>' + cast ( TierCategory as varchar) + '</td>' +'<td class=''r''>' + cast ( FromValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( ToValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( Rate  		 as varchar) + '</td>' + 
	--'</tr>' from setup.Tb_Tier T where T.TierGroupId= #result.OldValue            FOR XML PATH('')         ), 1, 0, ''),'&lt;','<'),'&gt;','>')+ '</table>') 
	--where ColumnName='TierGroupId'

SET NOCOUNT OFF;

END