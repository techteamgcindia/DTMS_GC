USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateTable]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[obps_sp_UpdateTable]
@tabname nvarchar(MAX)='',
@ColName nvarchar(MAX)='',
--@OldColName nvarchar(MAX)='',
@datatype nvarchar(MAX)='',
@Olddatatype nvarchar(MAX)='',
@default nvarchar(MAX)='',
@Olddefault nvarchar(MAX)='',
@allownull nvarchar(MAX)='',
@isusercol nvarchar(MAX)=''
AS
BEGIN
DECLARE @str nvarchar(MAX)=''
DECLARE @allownullstr nvarchar(MAX)=''

if @allownull='1'
BEGIN
SET @allownullstr='ALTER TABLE '+@tabname+' ALTER COLUMN '+@ColName+ ' '+ @datatype+'  NULL;'
END
else
SET @allownullstr='ALTER TABLE '+@tabname+' ALTER COLUMN '+@ColName+ ' '+ @datatype+'  NOT NULL;'
if(@allownullstr <>'' or @allownullstr is not null)
begin
select @allownullstr
exec (@allownullstr)
end

if @isusercol<>0
update obps_TableId set TableUserCol=@ColName where TableName=@tabname

if(@datatype='nvarchar')
set @datatype='nvarchar(MAX)'

if @datatype<>@Olddatatype
BEGIN
set @str='ALTER TABLE '+@tabname+' ALTER COLUMN '+@ColName+' ' +@datatype
END
if(@str <>'' or @str is not null)
BEGIN
exec (@str)
END



if @default<>''
BEGIN
exec obps_sp_UpdateDefaultValue @tabname,@ColName,@default
END
END
GO
