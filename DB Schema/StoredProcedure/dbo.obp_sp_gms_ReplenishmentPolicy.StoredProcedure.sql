USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_ReplenishmentPolicy]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[obp_sp_gms_ReplenishmentPolicy]  
(@var_user nvarchar(100)=''                                      
,@var_pid int=''                                      
,@var_clientid int='')    
AS  
BEGIN  
  
select id
,PolicyName policyname__obp_gms_ReplenishmentPolicy
,Mon mon__obp_gms_ReplenishmentPolicy
,Tue tue__obp_gms_ReplenishmentPolicy
,Wed wed__obp_gms_ReplenishmentPolicy
,Thur thur__obp_gms_ReplenishmentPolicy
,Fri fri__obp_gms_ReplenishmentPolicy
,alldays alldays__obp_gms_ReplenishmentPolicy
from   [dbo].obp_gms_ReplenishmentPolicy
  
END
GO
