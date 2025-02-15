USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_Custom_TicketsView]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    proc [dbo].[obp_sp_Custom_TicketsView]  
  
@Lastrun Varchar(50)  
as  
Begin  
  
select th.id TicketID,cm.ClientName Client,th.th_Remarks 'Remarks',th.td_SeqNo as 'TouchTime',th.FKBy 'FullKit',th.TicketCatg1 Category,th.Sprint [Committed],th_TaskHeader [Task],th.AssignToMain [Assigned To],th.PlannedStartDt [Start], th.TaskActEstDt [Finish]
from  [dbo].[obp_Taskheader] th 
join obp_ClientMaster cm on cm.id = th.ClientID
where 
isnull(th.ParentId,0)=0 and 
th.th_TaskHeader not in ('Click + Sign to Add Records')
and th.isEdit=1
and th.TaskStatus<>'CP'
and 
th.Createdby in (Select UserName from obps_Users where Company='OPS' or UserTypeId in (2))

  
End
GO
