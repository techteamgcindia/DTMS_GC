USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGridData]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadGridData]                                
@gid NVARCHAR(MAX)=NULL,                                
@lId nvarchar(MAX) = '',                                
@usrname NVARCHAR(MAX)= NULL,                                
@Id nvarchar(MAX)= '',                                
@clientid NVARCHAR(MAX)='',                                
@ddlvalue NVARCHAR(MAX)='',    
@selectedgridval NVARCHAR(MAX)=''    
AS                                
BEGIN                                
 DECLARE @usrname_col NVARCHAR(MAX),        
    @depGrid int ,    
    @query NVARCHAR(MAX),                                
    @query_Key NVARCHAR(MAX),                                
    @pkey NVARCHAR(MAX),                                
    @tabname NVARCHAR(MAX),                                
    @spquery NVARCHAR(MAX) ,                                
    @count int,@par1 nvarchar(MAX)='',                          
 @par2 nvarchar(MAX)='' ,@par3 nvarchar(MAX)='' ,                          
 @par4 nvarchar(MAX)='' ,@par5 nvarchar(MAX)='',@ddlcount nvarchar(MAX)=''      
     
 DECLARE @spname NVARCHAR(MAX),@pagetype  int,@gridcount int,@selectedgridvalue nvarchar(MAX)    
    
  SET @pagetype=(select type from obps_TopLinks where id=@lId)    
  SET @gridcount=(select max(gridid) from obps_TopLinkExtended where Linkid=@lId)     
  SET @spname=(SELECT gridsp FROM obps_TopLinkExtended where gridid=@gid and Linkid=@lId)     
  set @depGrid=(SELECT DependentGrid FROM obps_TopLinkExtended where gridid=@gid and Linkid=@lId)    
    
    
  IF OBJECT_ID('tempdb..#gridid_Temp') IS NOT NULL DROP TABLE #gridid_Temp    
  create table #gridid_Temp(value nvarchar(MAX),RowNum int)    
  insert into #gridid_Temp(value,RowNum) SELECT value,    
     ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RowNum     
  FROM STRING_SPLIT(@selectedgridval,',');    
    
    SET @selectedgridvalue=(select value from #gridid_Temp where RowNum=@depGrid)    
       
  SET @count=(SELECT count(DISTINCT t.name)                                 
     FROM sys.sql_dependencies d                                 
     INNER JOIN sys.procedures p ON p.object_id = d.object_id                                
     INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id                                
     where p.name=@spname)                                
                          
                          
 (select @par1=isnull(par1,''),@par2=isnull(par2,''),@par3=isnull(par3,''),@par4=isnull(par4,''),@par5=isnull(par5,'')                           
   from obps_spPermissions where                           
   Gridid=@gid and Linkid=@lId and                           
   UserId=(select id from obps_Users where UserName=@usrname))                          
                          
 set @ddlcount=(select isnull(DdlSp,'') from obps_TopLinks where id=@lId)       
    
--------for tab pages-----------------    
if(@pagetype=2)    
BEGIN    
                    
  IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))<=0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                                
  BEGIN                            
  print '1.1'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@selectedgridvalue                              
  END                            
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                   
  BEGIN                      
  print '1.2'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2,@selectedgridvalue                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)               
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))           
  BEGIN                        
  print '1.3'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@selectedgridvalue                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                        
  print '1.4'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4,@selectedgridvalue                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                       
  print '1.5'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4,@par5,@selectedgridvalue                             
  END                          
                          
  --------------------when @ddl is not there--------------------------                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0) and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                           
  BEGIN                       
  print '1.6'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@selectedgridvalue                              
  END                             
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 )and (len(ltrim(rtrim(@par1)))>0)and                   
  (len(ltrim(rtrim(@par2)))>0)   and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                            
  BEGIN                         
  print '1.7'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2,@selectedgridvalue                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and  (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                            
  print '1.8'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@selectedgridvalue                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0 )and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                      
  print '1.9'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4,@selectedgridvalue                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                      
  print '1.10'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4,@par5,@selectedgridvalue                             
  END                    
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0)and (len(ltrim(rtrim(@par1)))<=0)and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                     
  BEGIN                      
  print '1.11'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@selectedgridvalue                   
  END                   
  else                     
  begin             
  print @selectedgridvalue    
   print '1.12'                    
   --select @spname,@usrname,@Id,@clientid  
   if LEN(@selectedgridvalue)>0
	   BEGIN
			print '1.12.1'   
		   EXEC @spname @usrname,@Id,@clientid,@selectedgridvalue 
	   END
   else
		BEGIN
			print '1.12.1'   
		   EXEC @spname @usrname,@Id,@clientid 
	   END
  end                  
END    
--------for non tab pages-----------------    
ELSE    
BEGIN             
  IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))<=0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                                
  BEGIN                            
  print '1'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1                              
  END                            
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                  
  and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                   
  BEGIN                      
  print '2'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                        
  print '3'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                        
  print '4'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0 )and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                       
  print '5'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue,@par1,@par2 ,@par3,@par4,@par5                             
  END                          
                          
  --------------------when @ddl is not there--------------------------                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0) and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                           
  BEGIN                       
  print '6'                    
   EXEC @spname @usrname,@Id,@clientid,@par1                              
  END                             
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 )and (len(ltrim(rtrim(@par1)))>0)and                   
  (len(ltrim(rtrim(@par2)))>0)   and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                            
  BEGIN                         
  print '7'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2                              
  END                           
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0 )and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and  (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                            
  print '8'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3                             
  END                          
                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0 )                          
    and (len(ltrim(rtrim(@par3)))>0 )and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                      
  print '9'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4                             
  END                          
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))<=0 or @ddlcount is null)and (len(ltrim(rtrim(@par1)))>0)and (len(ltrim(rtrim(@par2)))>0)                          
    and (len(ltrim(rtrim(@par3)))>0)and (len(ltrim(rtrim(@par4)))>0)and (len(ltrim(rtrim(@par5)))>0))                               
  BEGIN                      
  print '10'                    
   EXEC @spname @usrname,@Id,@clientid,@par1,@par2 ,@par3,@par4,@par5                             
  END                    
  ELSE IF ((len(ltrim(rtrim(@ddlcount)))>0)and (len(ltrim(rtrim(@par1)))<=0)and (len(ltrim(rtrim(@par2)))<=0)                          
    and (len(ltrim(rtrim(@par3)))<=0)and (len(ltrim(rtrim(@par4)))<=0)and (len(ltrim(rtrim(@par5)))<=0))                               
  BEGIN                      
  print '11'                    
   EXEC @spname @usrname,@Id,@clientid,@ddlvalue                   
  END                   
  else                     
  begin                  
   print '12'                    
   --select @spname,@usrname,@Id,@clientid                
   EXEC @spname @usrname,@Id,@clientid                      
  end       
END      
END 
GO
