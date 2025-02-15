USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadChartData]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadChartData]         
@usrname nvarchar(MAX)='',  
@id nvarchar(MAX)='',        
@filterval1 nvarchar(MAX)='',        
@filterval2 nvarchar(MAX)='',        
@filterval3 nvarchar(MAX)='' ,      
@chartid nvarchar(MAX)=''       
AS          
BEGIN          
          
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
 exec @divspname @filterval1,@filterval2,@filterval3          
end          
END
GO
