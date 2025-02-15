USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_getMenuNameByCond]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_getMenuNameByCond]           
@PageType nvarchar(MAX)=''      
AS            
BEGIN        
 if @PageType='gantt'      
 BEGIN      
  select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where Type in(4,11))      
 END      
 ELSE  if @PageType='import'      
 BEGIN    
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where IsImportEnabled=1)      
   or id in(select menuid from obps_TopLinks where Type in(20))    
 END      
 ELSE  if @PageType='chart'      
 BEGIN    
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  id in(select menuid from obps_TopLinks where Type in(21,22,23,24,2526,27))      
 END    
 ELSE    
 BEGIN    
 if @PageType='attach'      
   select Id,DisplayName from obps_MenuName where IsVisible=1 and  (id in(select menuid from obps_TopLinks where Type =19)    
   or id in(select menuid from obps_TopLinks where IsUploadEnabled=1) )    
 END      
END   
  
  
GO
