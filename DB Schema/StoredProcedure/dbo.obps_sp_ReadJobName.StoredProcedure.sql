USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadJobName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadJobName]  
@linkid nvarchar(5)=''  
,@username nvarchar(MAX)=''  
AS  
BEGIN  
  
select gridsp from obps_TopLinkExtended   
where gridid=1 and Linkid=@linkid  
  
END
GO
