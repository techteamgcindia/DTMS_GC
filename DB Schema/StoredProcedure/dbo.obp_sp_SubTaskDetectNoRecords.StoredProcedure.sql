USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SubTaskDetectNoRecords]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[obp_sp_SubTaskDetectNoRecords]    
(@var_RID int)    
as    
Begin    
Declare @var_ParentId int, @var_RecCount int    
Declare @var_createdby nvarchar(100),@var_task nvarchar(max)    
    
Set @var_RecCount=0    
Set @var_ParentId=(Select ParentId from obp_Taskheader where id=@var_RID)    
    
Set @var_RecCount= (Select isnull(count(*),0) from obp_TaskHeader where ParentId=@var_ParentId and isActive=1 and TaskStatus not in ('DEL'))    
print @var_RecCount  
    
/*Insert First Sub Task for Main Task*/    
IF @var_RecCount=0    
Begin    
    
 Set @var_createdby=(Select Createdby from obp_Taskheader where id=@var_ParentId)    
 Set @var_task=(Select th_TaskHeader from obp_Taskheader where id=@var_ParentId)   
 print  @var_task  
  
 insert into obp_TaskHeader(ClientID,th_TaskHeader,CreatedDate,ModifiedDate,Createdby,isActive,ShareToUser,ScheduleType    
 ,ParentId)     
 values(1,@var_task,getdate(),getdate(),@var_createdby,1,@var_createdby,1,@var_ParentId);    
   
End    
    
End
GO
