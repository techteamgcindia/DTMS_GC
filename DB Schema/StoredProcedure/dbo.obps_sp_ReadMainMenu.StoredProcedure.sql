USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadMainMenu]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[obps_sp_ReadMainMenu]      
@username nvarchar(MAX)=''      
AS      
BEGIN      
  
 DECLARE @count int=0;  
  
 set @count=(select count(*) from obps_MenuName  where MenuId in(        
 select LinkId from Obps_UserLinks where userid =        
 (select Id from Obps_Users where UserName=@username) and isdeleted=0))+100    
  
   select mainmenu.MenuItemId,mainmenu.ParentId,mainmenu.Text,mainmenu.NavigateURL from
 (select  top 1000 id*500
 'MenuItemId',0 'ParentId',DisplayName 'Text','' 'NavigateURL' from obps_MenuName  where MenuId in(        
 select LinkId from Obps_UserLinks where userid =        
 (select Id from Obps_Users where UserName=@username) and isdeleted=0) order by DisplayOrder asc)mainmenu 
 
 union      all
 select sublink.MenuItemId,sublink.ParentId,sublink.Text,sublink.NavigateURL from
 (select  top 1000 id  'MenuItemId',MenuId*500 'ParentId',LinkName 'Text','' 'NavigateURL' from obps_TopLinks      
 where id in(        
 select sublinkid from Obps_UserLinks where userid =        
 (select Id from Obps_Users where UserName=@username) and isdeleted=0)       
 order by SortOrder asc)sublink
     
END      
GO
