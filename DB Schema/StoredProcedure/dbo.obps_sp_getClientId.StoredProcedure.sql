USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getClientId]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getClientId]  
@clientname NVARCHAR(MAX)=''  --,
--@lId int=''
AS  
BEGIN  
	select id from obp_ClientMaster  where ClientName=@clientname
END  
  
GO
