USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_GetTaskStatus]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[obp_sp_GetTaskStatus]         
@usrnme nvarchar(MAX)='' ,        
@linkid int='' ,                
@gridid nvarchar(MAX)='' ,    
@id nvarchar(10)=''         
AS       
BEGIN       
  
Declare @var_CurrTS nvarchar(50) ,@var_UserType int   
Set @var_CurrTS=(Select Taskstatus from obp_Taskheader where id=@id)    
set @var_UserType=(Select UserTypeId from obps_users where UserName=@usrnme)    
  
/* select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]  */    
    
If @var_CurrTS='NS'    
Begin    
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('Backlog','IP','DEL')    
End    
    
If @var_CurrTS='IP'    
Begin    
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('Backlog','CP','DEL')    
End    
    
If @var_CurrTS='CP'  
Begin 
 If @var_UserType=2
 Begin
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('CL')     
 End
 Else
 Begin   
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('CP')    
 End
End    
  
    
If @var_CurrTS='Backlog'    
Begin    
 select id as ID,TaskStatusValue as name from [dbo].[obp_TaskStatusDDLValues]     
 where TaskStatusValue in ('IP','DEL')    
End    
    
END 
GO
