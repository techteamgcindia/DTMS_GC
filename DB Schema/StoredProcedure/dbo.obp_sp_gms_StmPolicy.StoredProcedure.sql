USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_gms_StmPolicy]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obp_sp_gms_StmPolicy]    
(@var_user nvarchar(100)=''                                        
,@var_pid int=''                                        
,@var_clientid int='')      
AS    
BEGIN    
    
select id  
,PolicyName   policyname__obp_gms_stmpolicy
,PolicyState  policystate__obp_gms_stmpolicy
,IncreaseByPerc   increasebyperc__obp_gms_stmpolicy
,DecreaseByPerc decreasebyperc__obp_gms_stmpolicy
,IncreaseTrigger   increasetrigger__obp_gms_stmpolicy
,DecreaseTrigger   decreasetrigger__obp_gms_stmpolicy
,CreatedDate UpdatedDate  
from   [dbo].[obp_gms_StmPolicy]  
    
END
GO
