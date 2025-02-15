USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_RoleClassGrid1]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_RoleClassGrid1]
@RoleName nvarchar(MAX)
AS
BEGIN

DECLARE @Data_Type nvarchar(150)
DECLARE @Column_Name nvarchar(150)

DECLARE @RoleId int
SET @RoleId=(select SUBSTRING(@RoleName, PATINDEX('%[0-9]%', @RoleName), LEN(@RoleName)))
print 'using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Onebeat_PL.Models
{
    public class '+@RoleName+'
    {'
DECLARE cur CURSOR FOR
select 

case 
	when Data_Type like 'nvarchar%' then
	'string'
	when Data_Type like '%datetime%' or  Data_Type like '%date%' then
	'DateTime'
	when Data_Type like 'bit%' then
	'int'
	else
	Data_Type
	end ,Column_Name
--into #inpclass
FROM INFORMATION_SCHEMA.COLUMNS
inner join Obp_RoleMap RM on Column_Name=RM.ColName
WHERE  RM.IsVisible=1 and TABLE_NAME in 
(SELECT DISTINCT t.name 
FROM sys.sql_dependencies d 
INNER JOIN sys.procedures p ON p.object_id = d.object_id
INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
where p.name='sp_ReadData_FirstGrid' ) and RoleId=@RoleId
OPEN cur

FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
WHILE @@FETCH_STATUS = 0
BEGIN   

PRINT 'public '+@Data_Type+ ' '+@Column_Name+' { get; set;}'
FETCH NEXT FROM cur INTO @Data_Type,@Column_Name;
END

CLOSE cur;
DEALLOCATE cur;
print '} }'
END
GO
