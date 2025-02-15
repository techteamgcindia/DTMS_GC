USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadDataToolBarBtnClick]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[obps_sp_ReadDataToolBarBtnClick]  
@gid nvarchar(5)='',  
@linkid nvarchar(5)='',  
@usrname nvarchar(MAX)='',  
@btnname nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @spname nvarchar(MAX)=''  
  
if(LOWER(@btnname)='redbtn')  
 SET @spname=(SELECT redbtnsp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
else if(LOWER(@btnname)='yellowbtn')  
 SET @spname=(SELECT YellowBtnSp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
else if(LOWER(@btnname)='greenbtn')  
 SET @spname=(SELECT GreenBtnSp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
else if(LOWER(@btnname)='refreshbtn')  
 SET @spname=(SELECT RefreshSp from obps_TopLinkExtended where Linkid=@linkid and GridId=@gid )  
  
select @spname  
 IF len(RTRIM(LTRIM(@spname)))>0  
 exec @spname @gid,@usrname            
  
END  
GO
