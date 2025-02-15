USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_AllClientTasks]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     proc [dbo].[obp_sp_Pl_AllClientTasks]              
(@var_user nvarchar(100)=''                                                                                       
,@var_pid int=''                                                                                       
,@var_clientid int=''                                                                                        
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''            
)                                                                                                    
as                                                                                                    
begin                                                                                                    
                                                                                                    
DECLARE @SearchLetter nvarchar(100)                                                                                                    
SET @SearchLetter ='%'+ @var_user + '%'                                                                           
                                                                          
Declare @var_usertype int                                                                          
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)                            
print @var_usertype                                                                  
/*Client*/                                                                                                    
If @var_usertype=2                                                                         
Begin                                                                          
                                                                                     
select                                                                                       
th.id,                                                                                                    
th.color1,th.color2,th.color3                                                                                       
,th.id as 'TicketNo'                                                                                     
,cm.clientname as clientid__obp_taskheader                                                                                                  
,th.th_taskheader as th_taskheader__obp_taskheader                                                                        
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'Expected Delivery Date'         
,th.th_remarks as th_remarks__obp_taskheader                                         
 ,th.taskstatus as 'Task Status'                                                           
,cm.Implementer as 'Owner'           
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'LastModDate'        
                             
from obp_TaskHeader th                                                                                               
left join obp_ClientMaster cm  on th.ClientID=cm.id          
where                                                                                          
((cm.id in (select value from string_split(@var_par1,',')) ) )                                                                          
and isnull(th.Createdby,'') like @SearchLetter                                                                                     
and th.isActive=1                                                                         
--and th.taskheaderid is null                                                                                           
and isnull(th.ParentId,0) =0                                                                           
--and th.TaskStatus in (select value from string_split(@var_par3,','))                  
--and th.TicketType in (select value from string_split(@var_par2,','))                                                                          
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                
and th.TaskStatus not in ('CP','CL')                                                                                      
End                                                                          
  
/*                                                                          
/*Managers*/                                                                   
If @var_usertype=4                                                                         
Begin                                                                          
select                                                                                                          
th.id,                                                                                                    
th.color1,th.color2,th.color3                                                                                       
,th.id as 'TicketNo'                                                                                     
,cm.clientname as clientid__obp_taskheader                                                                                                  
,th.th_taskheader as th_taskheader__obp_taskheader                                                                        
,th.TimeBuffer as timebuffer__obp_taskheader                                                      
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                                             
 ,convert(nvarchar(4),datepart(yyyy,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.PlannedStartDt)) as 'PlannedStart'                                                 
,th.TaskDuration as 'Duration'                                         
,convert(nvarchar(4),datepart(yyyy,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActEstDt)) as 'Planned Finish'                       
,convert(nvarchar(4),datepart(yyyy,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,th.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,th.TaskActStartDt)) as 'ActualStart'                                                                     
/*,convert(nvarchar(4),datepart(yyyy,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(mm,th.ActualFinishDate))+'/'+convert(nvarchar(4),datepart(dd,th.ActualFinishDate)) as 'ActualFinish' */                                                      
 --,th.taskstatus as taskstatus__obp_taskheader                                                                               
 ,th.taskstatus as 'Task Status'                                                                                
,th.EstDueDate as estduedate__obp_taskheader                                                                      
                                     
,th.BlackExcedDays as BlackExcedDays__obp_taskheader                                                                       
                                                                 
,th.th_remarks as th_remarks__obp_taskheader                                                     
,th.OnHoldReason as onholdreason__obp_taskheader                                                                                                   
,replace(th.ShareToUser,'/','')  as 'AssignToUser'                                                                                                     
,cm.Implementer as 'Incharge'                                                                   
,th.ModifiedDate as ModifiedDate__obp_taskheader                                                     
,th.CreatedDate as CreatedDate__obp_taskheader                                     
                                      
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'                         
,ActFinishDate as 'actfinishdate__obp_taskheader'                                                      
,FKBy as 'fkby__obp_taskheader'                                                                          
,th_SeqNo as 'th_seqno__obp_taskheader'                              
from obp_TaskHeader th                                                                                                    
left join obp_ClientMaster cm  on th.ClientID=cm.id                                               
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                              
--on tl.TicketId=th.id                                                                 
where                                                                                          
--((cm.id in (select value from string_split(@var_par1,',')) ) )     and       
th.ClientID >1 and     
th.isActive=1                                                                         
--and th.taskheaderid is null                                                                                           
and isnull(th.ParentId,0) =0                                              
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                           
and th.TaskStatus not in ('CP')                                                                          
--and th.ShareToUser like @SearchLetter                                           
and cast(th.CreatedDate as date) > '2023-03-01'                                             
                                          
                                                                      
End               
*/                                                                          
                                                                         
/*Tech - Buss Users*/                                                                          
If (@var_usertype=5    or @var_usertype=4)  
Begin                                          
Select                 
th.id,                 
case when (th.isedit=1 and th.Sprint='Committed') then 1 else 0 end 'iscelledit1',                                   
case when th.isedit=1 then 1 else 0 end 'iscelledit2',                             
case when th.isedit=1 then 1 else 0 end 'iscelledit3',                                   
case when th.isedit=1 then 1 else 0 end 'iscelledit4',                    
th.color1,th.color2,th.color3                                                                                       
,th.id as 'TicketNo'                                                       
--,th.id as id__obp_taskheader                                                    
,cm.clientname as clientid__obp_taskheader             
,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'           
,th.TicketCatg1 as ticketcatg1__obp_taskheader                                                  
,th.th_taskheader as th_taskheader__obp_taskheader            
,FKBy as 'fkby__obp_taskheader'                                   
,replace(th.ShareToUser,'/','')  as 'assigntouser'           
,th.TaskDuration as 'taskduration__obp_taskheader'          
,round(td_SeqNo,2) as 'td_seqno__obp_taskheader'           
,th.PlannedStartDt 'plannedstartdt__obp_taskheader'           
,convert(nvarchar(10),cast(th.TaskActEstDt as date)) 'Planned Finish'          
,ActFinishDate as 'actfinishdate__obp_taskheader'          
,th_SeqNo as 'th_seqno__obp_taskheader'          
,Sprint as 'sprint__obp_taskheader'          
,th.taskstatus as 'taskstatus__obp_taskheader'          
,th.TaskActStartDt 'taskactstartdt__obp_taskheader'          
,th.TimeBuffer as timebuffer__obp_taskheader          
,th.BlackExcedDays as blackexceddays__obp_taskheader           
,th.th_remarks as th_remarks__obp_taskheader          
,th.OnHoldReason as onholdreason__obp_taskheader          
,convert(nvarchar(10),cast(th.ModifiedDate as date)) as ModifiedDate__obp_taskheader            
,convert(nvarchar(10),cast(th.CreatedDate as date)) as CreatedDate__obp_taskheader          
/*,th.EstDueDate as estduedate__obp_taskheader*/          
          
from obp_TaskHeader th                                                                                                    
--left join obp_ClientMaster cm  on th.ClientID=cm.id                     
 join obp_ClientMaster cm  on th.ClientID=cm.id                                                                                           
--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl                                     
--on tl.TicketId=th.id                                              
where                                                                                          
((cm.id in (select value from string_split(@var_par1,',')) ) )     and                                                                
th.isActive=1                                                                         
--and th.taskheaderid is null                                                                                           
and isnull(th.ParentId,0) =0                                              
and th.th_TaskHeader not in ('Click + Sign to Add Records')                                                                           
and th.TaskStatus not in ('CP','CL')                                                                          
--and th.ShareToUser like @SearchLetter                                           
and cast(th.CreatedDate as date) > '2023-03-01'                                                             
End                                                                          
                                                                          
                                                          
                                                       
End                           
                
GO
