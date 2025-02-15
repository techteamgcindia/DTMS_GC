USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_MaiTaskDatesCal]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[obp_sp_MaiTaskDatesCal]    
( @var_RID int )    
as    
Begin    
    
/*Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                  
Declare @var_headerticketid int,@var_PlannedStartDt datetime,@var_TaskActEstDt datetime,@var_TaskDuration int,@var_TaskActStartDt datetime                      
                      
Set @var_headerticketid =(Select top 1 ParentId from obp_TaskHeader where id=@var_RID)                      
Set @var_PlannedStartDt =(Select min(isnull(PlannedStartDt,'1900-01-01')) from obp_TaskHeader where ParentId=@var_headerticketid  and th_TaskHeader<>'Click + Sign to Add Records' and isnull(PlannedStartDt,'1900-01-01')<>'1900-01-01')                     
     
Set @var_TaskActEstDt =(Select max(isnull(TaskActEstDt,'1900-01-01')) from obp_TaskHeader where ParentId=@var_headerticketid and th_TaskHeader<>'Click + Sign to Add Records')                      
Set @var_TaskActStartDt =(Select min(isnull(TaskActStartDt,'1900-01-01')) from obp_TaskHeader where ParentId=@var_headerticketid and TaskActStartDt is not null and th_TaskHeader<>'Click + Sign to Add Records')                 
                
    
Select @var_headerticketid ,@var_PlannedStartDt ,@var_TaskActEstDt ,@var_TaskDuration,@var_TaskActStartDt                      
                      
if @var_PlannedStartDt<>'1900-01-01'                      
Begin                      
Update obp_TaskHeader set PlannedStartDt=@var_PlannedStartDt where id=@var_headerticketid                      
End                      
Else                      
Begin                      
Update obp_TaskHeader set PlannedStartDt=null where id=@var_headerticketid                      
End                      
                      
if @var_TaskActEstDt<>'1900-01-01'                      
Begin                      
Update obp_TaskHeader set TaskActEstDt=@var_TaskActEstDt where id=@var_headerticketid                      
End                      
Else                      
Begin                      
Update obp_TaskHeader set TaskActEstDt=null where id=@var_headerticketid                      
End                      
                      
if @var_TaskActStartDt<>'1900-01-01'                      
Begin                      
Update obp_TaskHeader set TaskActStartDt=@var_TaskActStartDt where id=@var_headerticketid                      
End                      
Else                      
Begin                      
Update obp_TaskHeader set TaskActStartDt=null where id=@var_headerticketid                      
End                      
                      
update obp_TaskHeader set TaskDuration= case when (isnull(@var_PlannedStartDt,'1900-01-01')<>'1900-01-01' and isnull(@var_TaskActEstDt,'1900-01-01')<>'1900-01-01') then                       
datediff(dd,@var_PlannedStartDt,@var_TaskActEstDt)+1 else null end                       
where id=@var_headerticketid     
    
    
End  
GO
