USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Pl_Type03]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      proc [dbo].[obp_sp_Pl_Type03]                                                          
(@var_user nvarchar(100)=''                
,@var_pid int='',                                                          
@var_clientid int='')                                                          
as                                                          
begin                                                          
                                                          
DECLARE @SearchLetter nvarchar(100)                                                          
SET @SearchLetter ='%'+ @var_user + '%'      

                                                          
 select td.id,        
 case when th.Sprint='Committed' then 1 else 0 end 'iscelledit1',                              
 th.color1,td.color2,td.color3                                                  
 ,td.id as 'Task No'                                             
 ,td.th_TaskHeader as th_taskheader__obp_taskheader                                          
                                                 
,td.PlannedStartDt  as plannedstartdt__obp_taskheader                                      
 ,td.TaskDuration as taskduration__obp_taskheader                  
--,convert(nvarchar(4),datepart(yyyy,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(mm,td.TaskActEstDt))+'/'+convert(nvarchar(4),datepart(dd,td.TaskActEstDt)) as 'Planned Finish'                 
,convert(nvarchar(10),cast(td.TaskActEstDt as date)) as TaskActEstDt__obp_taskheader          
,td.TaskActStartDt as 'taskactstartdt__obp_taskheader'                   
,td.TaskStatus as taskstatus__obp_taskheader                                                           
 ,td.TimeBuffer as timebuffer__obp_taskheader                                                                                                                          
 ,td.th_Remarks as th_remarks__obp_taskheader                                          
 ,td.ShareToUser as sharetouser__obp_taskheader                                                                                    
 --,convert(nvarchar(10),cast(td.ModifiedDate as date)) as ModifiedDate__obp_taskheader                                                                      
 ,convert(char(10),td.ModifiedDate,126) 'LastModDt'  
  from   (Select * from obp_taskheader where id=@var_pid) th                                                                                                       
  right join  obp_taskheader td                                                          
  --on th.id=td.TaskHeaderID                                                          
  on th.id=td.ParentId                                                          
  --Added on 24-05-2021--to have access control form obp_ClientMaster table                                                           
  left join obp_ClientMaster cm on th.ClientID=cm.id                                                                                                      
 where                           
  --td.taskheaderid=@var_pid  or  td.ParentId=@var_pid                                            
  td.ParentId=@var_pid                
  and td.isActive=1               
  order by isnull(td.PlannedStartDt,'2050-01-01'),isnull(td.TaskActEstDt,'2050-01-01')                      

                                                           
end           
      
GO
