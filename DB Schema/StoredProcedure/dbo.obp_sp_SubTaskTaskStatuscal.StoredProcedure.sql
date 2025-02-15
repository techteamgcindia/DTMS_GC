USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SubTaskTaskStatuscal]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obp_sp_SubTaskTaskStatuscal]                  
( @var_RID int )                  
as                  
Begin                
            
/*Make the TaskActualStart Date column as editable. Let the user punch the date when task is moved from NS-->CP*/              
/*Test the application*/            
                  
Declare @var_PrevTaskStatus nvarchar(10),@var_CurrentTaskStatus nvarchar(10)                  
Declare @var_PlanEstDate date          
Declare @var_TaskActStartDt date                
                  
Set @var_PrevTaskStatus=(Select top 1 isnull(TaskStatus,'NA') from obp_TaskHeader_Trace where id=@var_RID order by RecordDate desc)         
set @var_PrevTaskStatus=isnull(@var_PrevTaskStatus,'NA')               
Set @var_CurrentTaskStatus=(Select taskstatus from obp_TaskHeader where id=@var_RID)                  
set @var_PlanEstDate=(Select cast(isnull(TaskActEstDt,'1900-01-01') as date) from obp_TaskHeader where id=@var_RID)                  
set @var_TaskActStartDt=(Select cast(isnull(TaskActStartDt,'1900-01-01') as date) from obp_TaskHeader where id=@var_RID)          
                  
print @var_RID                  
print @var_CurrentTaskStatus                  
print @var_PrevTaskStatus                  
      
--insert into tb1_test values(getdate(),@var_RID,@var_PrevTaskStatus,@var_CurrentTaskStatus,@var_PlanEstDate,@var_TaskActStartDt,1)      
                  
/*Processing Task Status Transactions */                  
If (@var_PrevTaskStatus<>'NA'  and @var_PlanEstDate > '1900-01-01')                
Begin 
Print 'In-1'
 IF(@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='IP')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt= case when (@var_TaskActStartDt='1900-01-01') then cast(getdate() as date) else @var_TaskActStartDt end  where id=@var_RID                  
 print 'NS-IP'                  
 End                  
                  
 IF(@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='CP')                  
 Begin                  
   If @var_TaskActStartDt>'1900-01-01'          
    Update obp_TaskHeader set ActualFinishDate=cast(getdate() as date),ActualDuration=(datediff(dd,TaskActStartDt,getdate())+1) where id=@var_RID                  
   Else          
    Update obp_TaskHeader set TaskStatus='NS',TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
             
 End                  
                  
 IF(@var_PrevTaskStatus='IP' and @var_CurrentTaskStatus='CP')                  
 Begin                  
 Update obp_TaskHeader set ActualFinishDate=cast(getdate() as date),ActualDuration=(datediff(dd,TaskActStartDt,getdate())+1) where id=@var_RID                  
 End                  
                  
 If (@var_CurrentTaskStatus='DEL')                  
 Begin                   
 Exec obp_sp_SubTaskDetectNoRecords @var_RID              
              
 Delete from obp_TaskHeader where id=@var_RID                  
 End                  
                  
 IF(@var_PrevTaskStatus='CP' and @var_CurrentTaskStatus='IP')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt=cast(getdate() as date),ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
 End                  
                  
 IF(@var_PrevTaskStatus='CP' and @var_CurrentTaskStatus='NS')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
 End       
     
 IF(@var_PrevTaskStatus='IP' and @var_CurrentTaskStatus='NS')                  
 Begin                  
 Update obp_TaskHeader set TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL where id=@var_RID                  
 End 

print 'In-2' 
print @var_CurrentTaskStatus
print @var_PrevTaskStatus

 If (@var_PrevTaskStatus<>'Backlog' and @var_CurrentTaskStatus='Backlog') 
 --If (@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='Backlog') 
 Begin
 print 'B1'
 Update obp_taskheader set TaskStatus='Backlog' where id=(Select ParentId from obp_taskheader where id=@var_RID)
 End
                  
End                
--Else                
--Begin                
--Update obp_TaskHeader set TaskActStartDt=NULL,ActualFinishDate=NULL,ActualDuration=NULL,TaskStatus='NS' where id=@var_RID       
--End                  
/*End - Processing Task Status Transactions */        
      
--insert into tb1_test values(getdate(),@var_RID,@var_PrevTaskStatus,@var_CurrentTaskStatus,@var_PlanEstDate,@var_TaskActStartDt,2)      
      
/*For First time inserted SubTask*/              
IF(@var_PrevTaskStatus='NA')      
Begin      
--@var_CurrentTaskStatus                  
--@var_TaskActStartDt      
 If @var_CurrentTaskStatus='IP'       
 Begin      
  If @var_TaskActStartDt ='1900-01-01'      
  update obp_TaskHeader set @var_TaskActStartDt=cast(getdate() as date) where id=@var_RID;      
      
  If @var_TaskActStartDt >cast(getdate() as date)      
  update obp_TaskHeader set TaskActStartDt=cast(getdate() as date) where id=@var_RID;      
      
 End      
      
 If @var_CurrentTaskStatus<>'IP'      
  update obp_TaskHeader set TaskActStartDt=null,TaskStatus='NS' where id=@var_RID;      
      
End      
                
/*Deleting Task with Del Task Status*/          
If (@var_CurrentTaskStatus='DEL')                  
 Begin           
 Exec obp_sp_SubTaskDetectNoRecords @var_RID                  
           
 Delete from obp_TaskHeader where id=@var_RID                  
          
End             
/*End - Deleting Task with Del Task Status*/                  

/*To - Backlog*/ 
print @var_CurrentTaskStatus
print @var_PrevTaskStatus

 If (@var_PrevTaskStatus<>'Backlog' and @var_CurrentTaskStatus='Backlog') 
 --If (@var_PrevTaskStatus='NS' and @var_CurrentTaskStatus='Backlog') 
 Begin
 print 'B1'
 --Update obp_taskheader set TaskStatus='Backlog' where id=(Select ParentId from obp_taskheader where id=@var_RID)
 Update obp_taskheader set TaskStatus='Backlog' where id=@var_RID
 End

/*From - Backlog*/                  
If (@var_PrevTaskStatus='Backlog' and @var_CurrentTaskStatus<>'Backlog') 
 Begin
 print 'B2'
 Update obp_taskheader set TaskStatus='IP' where id=(Select ParentId from obp_taskheader where id=@var_RID)
 End

End 
GO
