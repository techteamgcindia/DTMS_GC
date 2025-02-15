USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_TimeBufferCal_SMT]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[obp_sp_TimeBufferCal_SMT]                
( @var_RID int )                    
as                
Begin      
/*Comment: This method can be moved to UI */    
     
/*Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                      
Declare @var_headerticketid int,@var_PlannedStartDt datetime,@var_TaskActEstDt datetime,@var_TaskDuration int,@var_TaskActStartDt datetime                          
                          
Set @var_headerticketid = @var_RID
                
/*TimeBuffer*/                      
update obp_TaskHeader set TimeBuffer=case                       
when datediff(dd, PlannedStartDt,getdate())  < 0  then 'Cyan'                      
when datediff(dd, PlannedStartDt,getdate())  between 0 and (datediff(dd, PlannedStartDt,TaskActEstDt)/3) then 'Green'                                    
when datediff(dd, PlannedStartDt,getdate())  between ((datediff(dd, PlannedStartDt,TaskActEstDt)/3)+1) and ((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3) then 'Yellow'                                   
when datediff(dd, PlannedStartDt,getdate())  between (((datediff(dd, PlannedStartDt,TaskActEstDt)*2)/3)+1) and datediff(dd, PlannedStartDt,TaskActEstDt) then 'Red'                                   
when datediff(dd, PlannedStartDt,getdate()) > datediff(dd, PlannedStartDt,TaskActEstDt) then 'Black' end                                  
where                                     
id=@var_headerticketid  and                           
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                
                                
update obp_TaskHeader set TimeBuffer='Black' where id=@var_headerticketid  
--and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<=0                                
and  CONVERT(int,datediff(dd,PlannedStartDt,TaskActEstDt))<0         
and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                  
update obp_TaskHeader set color3=TimeBuffer where id=@var_headerticketid and  
TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                  
                                  
update obp_TaskHeader set BlackExcedDays=case when datediff(dd,TaskActEstDt,getdate()) > 0 then datediff(dd,TaskActEstDt,getdate()) else 0 end                                  
where id=@var_headerticketid  and TaskStatus in ('IP','NS') and TaskActEstDt is not null and th_TaskHeader <> 'Click + Sign to Add Records'                                   
--and timebuffer ='Black'                              
        
/*Color to be Red for tasks with same day*/        
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration<=1 and isnull(BlackExcedDays,0)<1 and  cast(TaskActEstDt as date)=cast(getdate()  as date)        
and TaskStatus <> 'CP'  and id=@var_headerticketid  
      
/*Color to be Green and Red for tasks with 2 days*/         
update  obp_TaskHeader set color3='Green',TimeBuffer='Green' where TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date)=cast(getdate()  as date)      
and TaskStatus <> 'CP'  and id=@var_headerticketid  
        
--and  cast((DATEADD(dd,1,PlannedStartDt)) as date) =cast(getdate()  as date)        
update  obp_TaskHeader set color3='Red',TimeBuffer='Red' where TaskDuration=2 and isnull(BlackExcedDays,0)<1 and  cast(PlannedStartDt as date) < cast(getdate()  as date)        
and TaskStatus <> 'CP'  and id=@var_headerticketid  
/*End - TimeBuffer*/          
                        
--update obp_TaskHeader set PlannedStartDt= TaskHeaderID                        
/*End - Updating TaskDuration, TaskEstDueDt,PlannedStartDt at Header Level*/                                    
--update obp_TaskDetails set Color1=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='NS' then 'Red' else 'White' end where id=@var_id                                    
update obp_TaskHeader set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end                                     
where id=@var_headerticketid  
                
                
End    
GO
