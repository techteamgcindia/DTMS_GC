USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_getColNameDatatype]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_getColNameDatatype]      
@tablename nvarchar(MAX)=''   ,  
@linkid nvarchar(MAX)=''  
AS      
BEGIN      
if(@tablename LIKE '%_temp')
	set @tablename=(select TempTableName from obps_ExcelImportConfig where LinkId=@linkid) 

SELECT column_name as 'Column Name', data_type as 'Data Type',case IS_NULLABLE      
            when 'NO' then 0      
            else 1      
            end as nullable      
FROM information_schema.columns       
WHERE table_name = @tablename      
END 
GO
