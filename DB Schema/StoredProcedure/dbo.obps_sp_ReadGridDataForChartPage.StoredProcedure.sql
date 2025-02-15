USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadGridDataForChartPage]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadGridDataForChartPage]    
@usrname NVARCHAR(MAX)= NULL,    
@Id NVARCHAR(MAX)= NULL,    
@clientid NVARCHAR(MAX)='',    
@filterval1 nvarchar(MAX)='',          
@filterval2 nvarchar(MAX)='',          
@filterval3 nvarchar(MAX)='' ,        
@chartid nvarchar(MAX)=''     
AS    
BEGIN    
DECLARE @spname NVARCHAR(MAX)    
    
DECLARE @sp nvarchar(MAX)='';   
DECLARE @spaftersplit nvarchar(MAX)=''  
DECLARE @divspname nvarchar(MAX)=''  
   
set @sp=(SELECT DivSp FROM obps_charts where linkid=@id)  
  
if len(RTRIM(LTRIM(@sp)))>0            
begin            
  
 ;WITH   cte  
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@sp,';')  
     )  
  SELECT  @spaftersplit=value  
  FROM    cte  
  WHERE   ROW_NUM =@chartid  
  
  SET @divspname=(SELECT SUBSTRING(@spaftersplit,CHARINDEX ('__', @spaftersplit)+2,len(@spaftersplit)) )  
  
  IF len(RTRIM(LTRIM(@divspname)))>0  
  BEGIN  
   IF (@Id='' and @clientid='')    
   BEGIN    
    EXEC @divspname @usrname,@filterval1,@filterval2,@filterval3       
   END     
   ELSE IF (@Id<>'' and @clientid='')    
   BEGIN    
    EXEC @divspname @usrname,@Id ,@filterval1,@filterval2,@filterval3       
   END    
   ELSE    
   BEGIN    
    EXEC @divspname @usrname,@Id, @clientid ,@filterval1,@filterval2,@filterval3      
   END    
  END  
END  
END 
GO
