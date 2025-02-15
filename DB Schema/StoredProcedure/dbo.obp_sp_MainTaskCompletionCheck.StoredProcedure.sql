USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_MainTaskCompletionCheck]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       Procedure [dbo].[obp_sp_MainTaskCompletionCheck]                                                  
(@var_RID int)                                                  
as                                                  
Begin                                 
        
        
/*If MainTask is moved to Backlog from Committed*/        
Declare @var_CommitStatus nvarchar(max), @var_CommitDate date    
Declare @var_CreatedUserType int        
    
Select @var_CreatedUserType=UserTypeId from obps_users where username= (Select top 1 Createdby from obp_Taskheader where id= @var_RID )        
Select @var_CommitStatus=Sprint,@var_CommitDate=CommittedDate from obp_Taskheader where Sprint='Backlog' and CommittedDate is not null and id= @var_RID        
        
/*Clear the entries when task is moved from Committed to Backlog Status*/        
    
If @var_CommitStatus='Backlog' and @var_CommitDate is not null        
Begin        
update obp_Taskheader        
set TaskStatus='NS',TimeBuffer='',BlackExcedDays=0,Color2=null,Color3=null,TaskDuration=null,        
TaskActStartDt=null,TaskActEstDt=null,PlannedStartDt=null,        
ActualFinishDate=null,OnHoldReason=null,ActualDuration=null,ActFinishDate=null,FKBy='N',th_SeqNo=null,CommittedDate=null,ClientClosureAcceptance=null        
,ClientClosureAcceptanceDate=null        
where Sprint='Backlog' and CommittedDate is not null and id= @var_RID        
        
update obp_Taskheader        
set TaskStatus='NS',TimeBuffer='',BlackExcedDays=0,Color2=null,Color3=null,TaskDuration=null,        
TaskActStartDt=null,TaskActEstDt=null,PlannedStartDt=null,        
ActualFinishDate=null,OnHoldReason=null,ActualDuration=null,ActFinishDate=null,FKBy='N',th_SeqNo=null,CommittedDate=null,ClientClosureAcceptance=null        
,ClientClosureAcceptanceDate=null        
where  ParentId= @var_RID        
        
End        
        
/*Make all Task Auto Committed for Non OPS users*/          
Declare @var_comp nvarchar(max),@var_Createdby nvarchar(max)          
Set @var_comp=(Select isnull(company,'') from obps_users where UserName=(Select createdby from obp_Taskheader where id=@var_RID))          
          
-- select * from obp_Taskheader order by id desc where sprint='Committed'          
If @var_comp='GC'          
Begin          
 update obp_Taskheader set Sprint='Committed',CommittedDate=cast(getdate() as date) where id=@var_RID and isnull(Sprint,'') not in ('Committed','Completed')  and  CommittedDate is null        
End          
        
--update obp_Taskheader set CommittedDate=getdate() where id=16256        
          
/*Check for Committed Column*/                                
Update obp_Taskheader set Sprint= (Select sprint from obp_Taskheader where id=@var_RID)                                
where ParentId=@var_RID                              
                            
/*Get the Committed Date*/                            
Update obp_Taskheader set CommittedDate=getdate() where id=@var_RID and Sprint='Committed' and CommittedDate is null                            
                              
/*Additional Checks for Single MainTask*/                                        
Declare @isEditFlg int = 0                                        
Set @isEditFlg=(Select isnull(isEdit,0) from obp_Taskheader where id=@var_RID)                                        
                                        
If @isEditFlg=1                                        
Begin                         
                                    
                                 
                                
/*Delete the task if selected status is DEL*/                                   
Delete from obp_Taskheader where id=@var_RID and TaskStatus='DEL'                       
                      
/*Add Implementer Details*/                            
Declare @var_TypeId int,@var_Implementer nvarchar(500),@var_SR_Implementer nvarchar(500) ,@var_MainAssingToUser nvarchar(max)                     
                      
Select                       
--TH.Createdby,             
@var_TypeId= U.UserTypeId          
--, @var_Implementer=CM.Implementer           
, @var_Implementer=( SELECT top 1 abc = STUFF(       
(Select '/ '+username from obps_users t1 where t1.company='OPS' FOR XML PATH(''))           
, 1          
, 1          
, ''          
) from obps_users t2  where t2.company='OPS'          
group by id)          
,@var_SR_Implementer='%'+CM.Implementer+'%'      
,@var_MainAssingToUser=CM.Implementer                    
 --,CM.ClientName                      
from (Select * from obp_Taskheader ) TH                        
join obps_users U on U.UserName=TH.Createdby                      
join obp_ClientMaster cm on cm.id =TH.ClientID                      
where Th.id = @var_RID                      
                      
if @var_TypeId=2                      
Begin                      
 If (Select isnull(count(*),0) from  obp_Taskheader where id=@var_RID and ShareToUser like @var_SR_Implementer)=0                      
    --Update obp_Taskheader set ShareToUser=ShareToUser+' / '+@var_Implementer where id=@var_RID                      
 Update obp_Taskheader set ShareToUser=ShareToUser+' / '+@var_Implementer,AssignToMain=@var_MainAssingToUser where id=@var_RID                      
End                      
                      
/*End - Add Implementer Details*/                         
                             
                          
/*If Task Status becomes Blank*/                              
update obp_TaskHeader set TaskStatus= case when isnull(TaskActStartDt,'1900-01-01') > '1900-01-01' then 'IP' else 'NS' end where id=@var_RID and isnull(TaskStatus,'')='' and isEdit=1                           
                            
                                  
/*To make TaskActualStart Date =today date if not provided for IP Tasks*/                                          
update obp_TaskHeader set TaskActStartDt=cast(getdate() as date)  where id=@var_rid and isnull(TaskActStartDt,'1900-01-01') ='1900-01-01' and TaskStatus='IP'                                          
      
/*To make MainTaskAssignToUser */      
/*2024-04-09*/      
update obp_TaskHeader set AssignToMain=Createdby  where id=@var_rid and AssignToMain is null      
      
                                        
Exec obp_sp_SubTaskEstDateCal @var_rid                                        
                                        
Exec obp_sp_TimeBufferCal_SMT @var_rid                                        
                                        
/*Check If CP Status is Valid*/                                        
Declare @var_Cat nvarchar(100),@var_DR nvarchar(100),@var_FinishEstDt date,@var_TB nvarchar(100),@var_TS nvarchar(100)                                        
Select @var_Cat=isnull(TicketCatg1,'-'),@var_DR=isnull(OnHoldReason,'-'),@var_TB=isnull(color3,'-'),@var_TS=isnull(TaskStatus,'-'),@var_FinishEstDt=isnull(TaskActEstDt,'1900-01-01')                                         
from obp_Taskheader where id=@var_RID                                        
                                        
If (@var_TB='Black' and @var_TS='CP')                                        
Begin                                        
 If(@var_Cat='-' or @var_DR='-' or @var_FinishEstDt='1900-01-01')                                        
 Begin                                        
 update obp_Taskheader set TaskStatus='IP' where id=@var_RID                                        
 End                                        
End                                        
                                        
/*Trace is moved from here to end of script on 2024-03-12*/                  
                                        
End                                        
/*End - Additional Checks for Single MainTask*/                                    
                           
                                        
/*Comments to be added                                            
Also indicate which block can be removed when it is handled in UI                                  
*/                                                  
                                           
Declare @var_TicketCatg nvarchar(100),@var_TicketDelayReason nvarchar(200),@var_TimeBufferColor nvarchar(10)                                                  
Declare @var_CnfFlg int                                                   
Declare @vaR_STStatus nvarchar(10),@vaR_MTStatus nvarchar(10)                                                  
                                              
Set @var_CnfFlg=0                                              
                                                  
Select @vaR_MTStatus=TaskStatus,@var_TicketCatg=isnull(TicketCatg1,'-'),@var_TimeBufferColor=Color3,@var_TicketDelayReason=isnull(OnHoldReason,'-') from obp_TaskHeader where id=@var_RID  and ParentId=0                                                 
Set @vaR_STStatus=(Select isnull(max(TaskStatus),'-') from obp_TaskHeader where parentid=@var_RID and TaskStatus<>'CP' and isActive=1)                                                  
                                
--Select isnull(max(TaskStatus),'-') from obp_TaskHeader where parentid=11316 and TaskStatus<>'CP' and isDeleted=0                                              
Select @var_TicketCatg ,@var_TicketDelayReason ,@var_TimeBufferColor                                              
Select @vaR_MTStatus,@vaR_STStatus                                              
                                              
print @var_CnfFlg                                              
                                                  
If (@vaR_STStatus='-' and @vaR_MTStatus='IP')                                                  
Begin                                                  
Set @var_CnfFlg = 1                                                  
End                                                  
Else                                                  
Begin                                                  
Set @var_CnfFlg = 0                                                  
End                                              
                                            
/*                                            
If (@vaR_STStatus='-' and @vaR_MTStatus='IP')                                                  
 Set @var_CnfFlg = 1                                                 
Else                                                  
 Set @var_CnfFlg = 0                                                  
*/                                               
                                              
print @var_CnfFlg                                               
                                                  
If (@var_TicketCatg<>'-'  and @var_CnfFlg=1)                                              
Begin                                                  
Set @var_CnfFlg = 1                                                  
End                                                  
Else                                                  
Begin                                                  
Set @var_CnfFlg = 0                                                  
End                            
                                              
print @var_CnfFlg                                              
                                                  
If (@var_TimeBufferColor='Black' and @var_TicketDelayReason<>'-' and @var_CnfFlg=1)                                                  
Begin                                                  
Set @var_CnfFlg = 1                                        
End                                                  
Else                                                  
Begin                                                  
Set @var_CnfFlg = 0                                                  
End                                                  
                                              
print @var_CnfFlg                                                  
IF (@var_CnfFlg = 1)                                             
Begin                                                  
Update obp_TaskHeader set taskstatus='CP' where id=@var_RID and isnull(ParentId,0)=0                                                  
End                                                  
    
/*                
/*Client Close the tasks*/                                                  
If (Select isnull(ClientClosureAcceptance,'') from obp_Taskheader where id=@var_RID and TaskStatus='CP')='True'                
 Update obp_Taskheader set ClientClosureAcceptanceDate=cast(getdate() as date) where id = @var_RID and TaskStatus='CP' and ClientClosureAcceptance='True' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'                
*/    
    
/*Client Close the tasks*/      
If @var_CreatedUserType=2    
Begin    
     
If (Select isnull(TaskStatus,'') from obp_Taskheader where id=@var_RID )='CL'                
 Update obp_Taskheader set ModifiedDate = cast(getdate() as date),ActFinishDate=cast(getdate() as date)
 , ClientClosureAcceptanceDate=cast(getdate() as date),ClientClosureAcceptance='True'     
 where id = @var_RID and TaskStatus='CL' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'     
End    
    
/*Auto Close Non-Client tasks */    
If @var_CreatedUserType <> 2    
Begin    
     
If (Select isnull(TaskStatus,'') from obp_Taskheader where id=@var_RID )='CP'                
 Update obp_Taskheader set TaskStatus='CL',ModifiedDate = cast(getdate() as date),ActFinishDate=cast(getdate() as date) 
 ,ClientClosureAcceptanceDate=cast(getdate() as date),ClientClosureAcceptance='True'     
 where id = @var_RID and TaskStatus='CP' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'     
End    
    
/* Commented as Reopen is not required                
/*Client Re-open the tasks completed by Team*/                  
If (Select isnull(ClientClosureAcceptance,'') from obp_Taskheader where id=@var_RID and TaskStatus='CP')='Reopen'                
 Update obp_Taskheader set TaskStatus='IP',ClientClosureAcceptance='',Sprint='Committed' where id = @var_RID and TaskStatus='CP' and ClientClosureAcceptance='Reopen' and isnull(ClientClosureAcceptanceDate,'1900-01-01') = '1900-01-01'                
*/    
                
/*Insert Trace Record*/                                        
Insert into obp_TaskHeader_Trace                                                  
Select                                               
 id,                                              
ClientID,                                              
th_TaskHeader,                                              
TaskStatus,                                              
EstDueDate,                                              
th_Remarks,                                              
TimeBuffer,              
BlackExcedDays,                                              
Color1,                                              
Color2,                                              
Color3,                                              
isActive,                                              
AccessToUser,                                              
ShareToUser,                                              
ScheduleType,                     
TaskDuration,                                              
TaskActStartDt,                                            
TaskActEstDt,                                              
PlannedStartDt,                                              
Reason,                                              
ParentId,                                              
ActualFinishDate,                                              
OnHoldReason,                                              
TicketCatg1,                                              
ActualDuration,                                              
CreatedDate,                                              
ModifiedDate,                                              
Createdby,                                              
Modifiedby,                                              
'M-U',                                              
getdate(),                      
td_SeqNo,                                              
ActFinishDate,                                              
FKBy,                                              
th_SeqNo                                              
--*,'M-U',getdate()                                               
from obp_TaskHeader where id in (@var_rid)                                          
                                                                      
                                     
End                                       

GO
