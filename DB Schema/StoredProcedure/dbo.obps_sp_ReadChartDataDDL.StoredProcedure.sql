USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadChartDataDDL]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadChartDataDDL]     
@usrname nvarchar(MAX)='',  
@id nvarchar(MAX)='',            
@ddlid int='',      
@chartid nvarchar(MAX)='',
@filter1 nvarchar(MAX)='', 
@filter2 nvarchar(MAX)='', 
@filter3 nvarchar(MAX)='' 
AS            
BEGIN            
            
DECLARE @count int=0;            
DECLARE @ddlsp nvarchar(MAX)='',@spname nvarchar(MAX)='';           
DECLARE @length int=0;          
DECLARE @spaftersplit nvarchar(MAX)='',@chartname nvarchar(MAX)=''    

if @chartid=1
	SET @ddlsp=(select Div1FilterSp from obps_charts where linkid=@id)
if @chartid=2
	SET @ddlsp=(select Div2FilterSp from obps_charts where linkid=@id)
if @chartid=3
	SET @ddlsp=(select Div3FilterSp from obps_charts where linkid=@id)
if @chartid=4
	SET @ddlsp=(select Div4FilterSp from obps_charts where linkid=@id)       
if @chartid=5
	SET @ddlsp=(select Div5FilterSp from obps_charts where linkid=@id)
if @chartid=6
	SET @ddlsp=(select Div6FilterSp from obps_charts where linkid=@id)

  
if len(rtrim(ltrim(@ddlsp)))>0  
BEGIN
	;WITH   cte
			  AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))AS ROW_NUM,* FROM STRING_SPLIT(@ddlsp,';')
				 )
		SELECT  @spaftersplit=value
		FROM    cte
		WHERE   ROW_NUM =@ddlid

 --SET @spname=(SELECT SUBSTRING(@spaftersplit,CHARINDEX ('__', @spaftersplit)+2,len(@spaftersplit)) )

if len(RTRIM(LTRIM(@spaftersplit)))>0
 exec @spaftersplit @filter1,@filter2,@filter3,@usrname  
else        
  select ''  
END
END
GO
