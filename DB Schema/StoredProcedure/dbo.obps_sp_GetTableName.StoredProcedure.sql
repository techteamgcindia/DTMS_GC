USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetTableName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_GetTableName]        
@dropdowntableddl nvarchar(MAX)='',      
@ddlTables nvarchar(MAX)='',      
@tempTables nvarchar(MAX)=''      
AS        
BEGIN        
if @dropdowntableddl=''      
BEGIN      
 if @ddlTables='' and @tempTables=''      
 BEGIN      
  select id,tableid,lower(t.name) as table_name from sys.tables t         
   inner join obps_TableId on t.name=TableName        
   where t.name like 'obp_%' and  t.name not like 'obps_%'       
         
 END      
 else      
 BEGIN      
  if @tempTables=''      
  BEGIN      
   select name as table_name from sys.tables         
   where name like '%_DDL%' and  name not like 'obps_%'      
  END      
  ELSE      
  BEGIN      
   select name as table_name from sys.tables         
   where name like 'obp_%_temp' and  name not like 'obps_%'      
  END      
  END      
END      
ELSE      
BEGIN      
 select name as table_name from sys.tables         
 where name like 'obp_%' and  name not like 'obps_%' and  name not like 'obp_%_temp'      
END      
END  
GO
