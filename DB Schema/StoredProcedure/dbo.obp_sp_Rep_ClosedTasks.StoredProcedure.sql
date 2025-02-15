USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Rep_ClosedTasks]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    proc [dbo].[obp_sp_Rep_ClosedTasks]               
(@var_user nvarchar(100)=''                                                                  
,@var_pid int=''                                                                  
,@var_clientid int=''  
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''    
)  
as                                                                  
Begin               
                                                                  
DECLARE @SearchLetter nvarchar(100),@var_usertype int                                                                  
SET @SearchLetter ='%'+ @var_user + '%'              

Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)

/*For clients*/
If @var_usertype = 2
Begin
	select                                                                                                   
	th.id   
	,th.color1,th.color2,th.color3                                                                                                   
	,th.id as 'TicketNo'                                                                                                 
	,cm.clientname as 'Client Name'
	,th.th_taskheader as 'Task Name'
	,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'Expected Delivery Date'                     
	,th.th_remarks as 'Remarks'
	,th.taskstatus as 'Task Status'
	,cm.Implementer as 'Owner'                       
	,convert(nvarchar(10),cast(th.ModifiedDate as date)) as 'LastModDate'        
	from obp_TaskHeader th                  
	left join obp_ClientMaster cm  on th.ClientID=cm.id                 
	where                                                                                                      
	isnull(th.Createdby,'') like @SearchLetter 
	and th.isActive=1 
	and isnull(th.ParentId,0) =0  
	and th.th_TaskHeader not in ('Click + Sign to Add Records') 
	and th.TaskStatus in ('CL')
	order by th.id desc  

End

If @var_usertype <> 2
Begin
                
	select                                                                           
	st.id,                                                                                          
	st.color1,st.color2  
	,st.color3                                                                                    
	,th.id as 'TicketNo'                                             
	,cm.clientname as clientid__obp_taskheader                                              
	,th.th_taskheader as th_taskheader__obp_taskheader                                      
	,st.id as 'ActivityId'                                                                                  
	,st.th_taskheader  as 'Activity'                                       
	,case when st.TimeBuffer ='Cyan' then '0Cyan'                            
	 when st.TimeBuffer ='Green' then '1Green'                            
	 when st.TimeBuffer ='Yellow' then '2Yellow'                            
	 when st.TimeBuffer ='Red' then '3Red'                            
	 when st.TimeBuffer ='Black' then '4Black'                            
	end 'timebuffer__obp_taskheader'                             
	,th.TicketCatg1 as ticketcatg1__obp_taskheader                
	 ,convert(char(10),st.PlannedStartDt,126)     as 'PlannedStart'                                            
	,st.TaskDuration as 'Duration'                           
	 ,convert(char(10),st.TaskActEstDt,126)     as 'Planned Finish'                  
	  ,convert(char(10),st.TaskActStartDt,126)     as 'ActualStart'                  
	 ,st.taskstatus as taskstatus__obp_taskheader                                                                     
	,convert(char(10),st.EstDueDate,126)     as 'Requested Need Date'                 
	,st.BlackExcedDays as BlackExcedDays__obp_taskheader                
	,st.th_remarks as th_remarks__obp_taskheader                
	,replace(st.ShareToUser,'/','')  as 'AssignToUser'                 
	,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'                  
	,convert(char(10),st.ModifiedDate,126) 'LastModDt'                  
	,convert(char(10),st.CreatedDate,126)  'CreatedDate'                                                     
	,st.Createdby as createdby__obp_taskheader                               
	--,case when st.ActualFinishDate is null then convert(char(10),st.ModifiedDate,126)  else convert(char(10),st.ActualFinishDate,126) end 'ActualFinishDate'          
	, case       
	   when st.TaskStatus not in ('CP','CL') then  convert(char(10),st.ActualFinishDate,126)        
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is not null) then convert(char(10),st.ClientClosureAcceptanceDate,126)      
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is null) then convert(char(10),st.ModifiedDate,126)       
	  end 'ActualFinishDate'      
	, replace(th.Sprint,'Completed','Committed') 'Committed'                                                    
	from obp_TaskHeader st                                       
	join obp_TaskHeader th on th.id=st.ParentId                                                                 
	left join obp_ClientMaster cm on th.ClientID=cm.id                                                        
	--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl  on tl.TicketId=th.id                            
	where               
	((cm.id in (select value from string_split(@var_par1,',')) ) ) and  
	th.TaskStatus in ('CP','CL') and   
	 th.th_taskheader<>'Click + Sign to Add Records'                          
	 --and th.ParentId is null and                                         
	 and isnull(th.ParentId,0)=0 and                        
	 --st.isDeleted=0 and                         
	 st.th_taskheader<>'Click + Sign to Add Records'                          
	 and st.ParentId is not null                                       
	 --and th.TaskStatus  in ('IP','NS','IP-HOLD','CP')                                                        
	 and cm.ClientName not in ('GC_Prabhat')           
	 and isnull(th.TicketCatg1,'-')<>'Delete Task'   
	 and  cast(th.CreatedDate as date) > '2023-01-31'                     
	 --and th.id=16320              
                               
	union all              
              
	select                                                        
	st.id,               
	st.color1,st.color2,st.color3                                                                                    
	,th.id as 'TicketNo'                                             
	,cm.clientname as clientid__obp_taskheader                                              
	,th.th_taskheader as th_taskheader__obp_taskheader                                      
	,st.id as 'ActivityId'                                                                                  
	,st.th_taskheader  as 'Activity'                                       
	,case when st.TimeBuffer ='Cyan' then '0Cyan'                            
	 when st.TimeBuffer ='Green' then '1Green'                            
	 when st.TimeBuffer ='Yellow' then '2Yellow'                            
	 when st.TimeBuffer ='Red' then '3Red'                            
	 when st.TimeBuffer ='Black' then '4Black'                            
	end 'timebuffer__obp_taskheader'                             
	,th.TicketCatg1 as ticketcatg1__obp_taskheader                
	 ,convert(char(10),st.PlannedStartDt,126)     as 'PlannedStart'                                            
	,st.TaskDuration as 'Duration'                           
	 ,convert(char(10),st.TaskActEstDt,126)     as 'Planned Finish'                  
	  ,convert(char(10),st.TaskActStartDt,126)     as 'ActualStart'                  
	 ,st.taskstatus as taskstatus__obp_taskheader                                                                     
	,convert(char(10),st.EstDueDate,126)     as 'Requested Need Date'                 
	,st.BlackExcedDays as BlackExcedDays__obp_taskheader                
	,st.th_remarks as th_remarks__obp_taskheader                
	,replace(st.ShareToUser,'/','')  as 'AssignToUser'                 
	,case when TH.AccessToUser is null then TH.Createdby else TH.AccessToUser end 'Owner'                  
	,convert(char(10),st.ModifiedDate,126) 'LastModDt'                  
	,convert(char(10),st.CreatedDate,126)  'CreatedDate'                                                     
	,st.Createdby as createdby__obp_taskheader                               
	--,convert(char(10),st.ActualFinishDate,126)  'ActualFinishDate'         
	, case       
	   when st.TaskStatus not in ('CP','CL') then  convert(char(10),st.ActualFinishDate,126)        
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is not null) then convert(char(10),st.ClientClosureAcceptanceDate,126)      
	   When (st.TaskStatus in ('CP','CL')  and  st.ClientClosureAcceptanceDate is null) then convert(char(10),st.ModifiedDate,126)       
	  end 'ActualFinishDate'      
      
	, replace(th.Sprint,'Completed','Committed') 'Committed'       
	from obp_TaskHeader st                                       
	join obp_TaskHeader th on th.id=st.id               
	left join obp_ClientMaster cm on th.ClientID=cm.id                            
	--left join (select ticketid,min(estduedate) 'OriginalDueDt' from obp_TicketsLog where estduedate is not null and  TicketType='Header' group by ticketid ) tl  on tl.TicketId=th.id                 
	where                                                               
	((cm.id in (select value from string_split(@var_par1,',')) ) ) and  
	th.TaskStatus in ('CP','CL') and                
	 th.th_taskheader<>'Click + Sign to Add Records'                          
	 --and th.ParentId is null and                                         
	 and isnull(th.ParentId,0)=0 and                        
	 --st.isDeleted=0 and                         
	 st.th_taskheader<>'Click + Sign to Add Records'                          
	 and st.ParentId is not null                                       
	 --and th.TaskStatus  in ('IP','NS','IP-HOLD','CP')                                                        
	 and cm.ClientName not in ('GC_Prabhat')                                   
	 and isnull(th.TicketCatg1,'-')<>'Delete Task'                                          
	 and  cast(th.CreatedDate as date) > '2023-01-31'                                            
	 --and th.id=16320              
	 and th.Createdby=th.ShareToUser                                      
End
                                                   
END                     
                  
GO
