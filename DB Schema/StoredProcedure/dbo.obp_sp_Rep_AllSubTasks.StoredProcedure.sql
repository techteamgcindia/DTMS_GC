USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Rep_AllSubTasks]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[obp_sp_Rep_AllSubTasks]            
(@var_user nvarchar(100)=''            
--,@var_pid int,            
,@var_pid int='',            
@var_clientid int='')            
as            
begin            
            
DECLARE @SearchLetter nvarchar(100)            
SET @SearchLetter ='%'+ @var_user + '%'            
    
 select td.id,th.color1,td.color2,td.color3
 --,td.color4,td.color5                                
 ,td.id as 'Task No'              
 ,td.td_SeqNo as 'SeqNo'                
 ,td.th_TaskHeader as 'Task Name'                
                       
 ,convert(nvarchar(4),datepart(yyyy,td.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(mm,td.PlannedStartDt))+'/'+convert(nvarchar(4),datepart(dd,td.PlannedStartDt)) as 'Planned Start Date'                
 ,td.TaskDuration as 'Duration'         
,convert(nvarchar(4),datepart(yyyy,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,td.TaskActEstDt)) as 'Planned Finish'              
,convert(nvarchar(4),datepart(yyyy,td.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(mm,td.TaskActStartDt))+'/'+convert(nvarchar(4),datepart(dd,td.TaskActStartDt)) as 'Actual Start'    
,td.TaskStatus as 'taskstatus'            
 ,td.TimeBuffer as timebuffer__obp_taskheader                                                                     
 ,td.th_Remarks as 'Remarks'                
 ,convert(date,td.ModifiedDate) as ModifiedDate__obp_taskheader                
  from   (Select * from obp_taskheader where id=@var_pid) th                                   
  right join  obp_taskheader td                                
  on th.id=td.ParentId                                
  left join obp_ClientMaster cm on th.ClientID=cm.id                                
 where                                 
 --(cm.SuperUser like @SearchLetter or cm.PD like @SearchLetter or cm.PC like @SearchLetter or cm.RM like @SearchLetter or cm.Implementer like @SearchLetter                                 
 --or cm.consultant like @SearchLetter or cm.AccessToUser like @SearchLetter or th.ShareToUser like @SearchLetter)                                
 -- and   
  td.ParentId=@var_pid                     
  --and td.isDeleted=0                                
  order by td.td_SeqNo                      
            
end 
GO
