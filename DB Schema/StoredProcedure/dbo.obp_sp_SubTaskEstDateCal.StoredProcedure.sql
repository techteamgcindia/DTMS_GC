USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SubTaskEstDateCal]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[obp_sp_SubTaskEstDateCal]      
(@RID int)      
as      
Begin      
Declare @var_taskduration float,@var_taskplandt datetime      
Declare @var_CnfFlg int     
Declare @var_CurrTaskStatus nvarchar(50)  
      
Set @var_CnfFlg=0      
Set @var_taskduration=(Select taskduration from obp_TaskHeader where id=@RID)      
Set @var_taskplandt=(Select PlannedStartDt from obp_TaskHeader where id=@RID)      
Set @var_CurrTaskStatus=(Select TaskStatus from obp_TaskHeader where id=@RID)     
      
/*Check TaskDuration*/      
If isnull(@var_taskduration,-999) > -999      
Begin      
      
 /*Setting TaskDuration to min value*/      
 If (@var_taskduration < 1 and isnull(@var_taskduration,-999) > -999)      
 Begin      
  update obp_TaskHeader set TaskDuration=1 where id=@RID      
  set @var_taskduration=1      
  Set @var_CnfFlg=1      
 End      
      
 If isnull(@var_taskduration,-999) > 0      
 Begin      
  Set @var_CnfFlg=1      
 End      
      
End      
Else      
Begin      
 update obp_TaskHeader set TaskDuration=NULL where id=@RID      
 Set @var_CnfFlg=0      
End      
      
/*End - Check TaskDuration*/      
      
/*Check PlanStartDate*/      
      
If (@var_CnfFlg=1 and convert(date,isnull(@var_taskplandt,'1900-01-01'))<>'1900-01-01')      
Begin      
Set @var_CnfFlg=1      
End      
Else      
Begin      
Set @var_CnfFlg=0      
End      
      
      
/*End - Check PlanStartDate*/      
      
/*Setting PlannedEstDate*/      
      
IF @var_CnfFlg=1      
Begin      
 update obp_TaskHeader set TaskActEstDt=dateadd(DD,@var_taskduration-1,@var_taskplandt)  where id=@RID      
      
 update obp_TaskHeader set TaskActEstDt=dateadd(DD,(Select isnull(count(*),0) 'NWD' from obps_NonWorkingDays       
 where NonWorkingDays between isnull(PlannedStartDt,'1900-01-01') and isnull(TaskActEstDt,'1900-01-01')),TaskActEstDt)        
 where id=@RID      
      
End      
Else      
Begin   
 If @var_CurrTaskStatus<>'Backlog'  
 update obp_TaskHeader set TaskActEstDt=null,TaskActStartDt=null,TaskStatus='NS' where id=@RID      
 Else  
 update obp_TaskHeader set TaskActEstDt=null,TaskActStartDt=null where id=@RID      
End      
      
/*End - Setting PlannedEstDate*/      
      
/*Sprint Condition*/      
Update obp_Taskheader set Sprint ='Completed' where id=@RID and TaskStatus='CP'
End      

GO
