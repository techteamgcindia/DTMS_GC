USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadDivTypes]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[obps_sp_ReadDivTypes]    
@usrname nvarchar(MAX)='',    
@linkid nvarchar(MAX)=''    
AS    
BEGIN    
    
DECLARE @i int = 1    
    
DECLARE @div1Type nvarchar(MAX)='',@div2Type nvarchar(MAX)='',@div3Type nvarchar(MAX)='',    
  @div4Type nvarchar(MAX)='',@div5Type nvarchar(MAX)='',@div6Type nvarchar(MAX)=''    
DECLARE @div1ChartType nvarchar(MAX)='',@div2ChartType nvarchar(MAX)='',@div3ChartType nvarchar(MAX)='',    
  @div4ChartType nvarchar(MAX)='',@div5ChartType nvarchar(MAX)='',@div6ChartType nvarchar(MAX)=''     


DECLARE @divType nvarchar(MAX)='',@divTypeAfterSplit nvarchar(MAX)='',@type nvarchar(MAX)=''    
    
SET @divType=(SELECT DivSp from obps_charts where linkid=@linkid)    
    
if len(rtrim(ltrim(@divType)))>0      
BEGIN    
    
    
 WHILE @i <7    
 BEGIN    
  ;WITH   cte    
      AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@divType,';')    
      )    
   SELECT  @divTypeAfterSplit=value    
   FROM    cte    
   WHERE   ROW_NUM =@i    
    
  SET @type=(SELECT SUBSTRING(@divTypeAfterSplit,0,CHARINDEX ('__',@divTypeAfterSplit)))    
    
  if @i=1    
   SET @div1Type=@type    
  else if @i=2    
   SET @div2Type=@type    
  else if @i=3    
   SET @div3Type=@type    
  else if @i=4    
   SET @div4Type=@type    
  else if @i=5    
   SET @div5Type=@type    
  else if @i=6    
   SET @div6Type=@type    
    
  SET @i  = @i  + 1    
    
 END      
END    

 SELECT @div1Type,@div2Type,@div3Type,@div4Type,@div5Type,@div6Type    
END
GO
