USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getGanttDependency]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getGanttDependency]          
@lnkId nvarchar(MAX)='',      
@usrname nvarchar(MAX)='',    
@gridid nvarchar(MAX)=''    
AS          
BEGIN          
      
 select id,PredecessorId as 'PredecessorId',SuccessorId as 'SuccessorId',2 as 'Type'  from obp_TaskHeader  
 where ShareToUser like '%'+@usrname+'%'
 union  
 select id,PredecessorId as 'PredecessorId',SuccessorId as 'SuccessorId',3 as 'Type'  from obp_TaskDetails  
  where ShareToUser like '%'+@usrname+'%'
    
END   
  
  
GO
