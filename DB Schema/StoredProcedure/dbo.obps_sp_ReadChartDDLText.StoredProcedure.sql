USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadChartDDLText]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[obps_sp_ReadChartDDLText]  
@usrname nvarchar(MAX)='',  
@id nvarchar(MAX)='',          
@ddlid int='',      
@chartid nvarchar(MAX)=''          
AS           
BEGIN          
  
             
DECLARE @count int=0;              
DECLARE @ddlText nvarchar(MAX)='',@spname nvarchar(MAX)='';             
DECLARE @length int=0;            
DECLARE @ddlTextaftersplit nvarchar(MAX)='',@chartname nvarchar(MAX)=''      
  
if @chartid=1  
 SET @ddlText=(select Div1FilterText from obps_charts where linkid=@id)  
if @chartid=2  
 SET @ddlText=(select Div2FilterText from obps_charts where linkid=@id)  
if @chartid=3  
 SET @ddlText=(select Div3FilterText from obps_charts where linkid=@id)  
if @chartid=4  
 SET @ddlText=(select Div4FilterText from obps_charts where linkid=@id)         
if @chartid=5  
 SET @ddlText=(select Div5FilterText from obps_charts where linkid=@id)  
if @chartid=6  
 SET @ddlText=(select Div6FilterText from obps_charts where linkid=@id)  
  
    
if len(rtrim(ltrim(@ddlText)))>0    
BEGIN  
 ;WITH   cte  
     AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@ddlText,';')  
     )  
  SELECT  @ddlTextaftersplit=value  
  FROM    cte  
  WHERE   ROW_NUM =@ddlid  
  
 --SET @spname=(SELECT SUBSTRING(@spaftersplit,CHARINDEX ('__', @spaftersplit)+2,len(@spaftersplit)) )  
  
if len(RTRIM(LTRIM(@ddlTextaftersplit)))>0  
 select @ddlTextaftersplit   
else          
  select ''    
END  
END
GO
