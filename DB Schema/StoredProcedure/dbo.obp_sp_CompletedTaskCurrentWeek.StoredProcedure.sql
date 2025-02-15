USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_CompletedTaskCurrentWeek]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Completed Planned Tasks for Current Week*/  
/*Date: 2023-09-29; Author: Bharat; Reason: To get the list of Completed Tasks from Planned for Status Report */  
  
CREATE procedure [dbo].[obp_sp_CompletedTaskCurrentWeek]  
as  
Begin  
  
Select   
 CM.ClientName,TH.th_TaskHeader 'Task Name',TH.TaskStatus,cast(TH.PlannedStartDt as date) 'Planned Start Date'  
 ,cast(TH.TaskActEstDt as date) 'Planned Finish Date',TH.BlackExcedDays 'Delay Days'  
 ,TH.OnHoldReason 'Delay Reason',TH.AccessToUser 'Owner',replace(TH.ShareToUser,'/','') 'Task Assign To'  
from obp_TaskHeader TH  
join obp_ClientMaster CM on CM.id=TH.ClientID  
join obps_users US on US.UserName= TH.Createdby  
where   
 cast(TH.CreatedDate as date) > '2023-03-01' and  
 ClientID>1 and   
 ParentId=0 and  
 th_TaskHeader is not null and  
 DATEPART(WEEK,TH.PlannedStartDt) <=  (DATEPART(WEEK,GETDATE())) and  
 DATEPART(WEEK,TH.TaskActEstDt) >=  (DATEPART(WEEK,GETDATE())) and  
 TH.TaskStatus in ('CP')  
order by CM.ClientName,TH.TaskActEstDt  
  
End
GO
