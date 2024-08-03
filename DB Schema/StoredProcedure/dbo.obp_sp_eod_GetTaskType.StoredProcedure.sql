USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_eod_GetTaskType]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obp_sp_eod_GetTaskType]       
@usrnme nvarchar(MAX)='',          
@linkid int='' ,                  
@gridid nvarchar(MAX)=''      
,@id nvarchar(10)=''       
AS       
BEGIN     
select 1 as ID,'Planned' as name     
Union all    
select 2 as ID,'Un-Planned' as name     
END 
GO
