USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetToolBarText]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[obps_sp_GetToolBarText]  
@gridid int=''  
,@linkid nvarchar(3)=''  
,@id int  
AS  
BEGIN  
  
 select ''  
 --select top 1 plant from obp_custdist_header where id=@id  
  
END  
GO
