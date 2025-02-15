USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_checkTableExistance]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_checkTableExistance]      
@tablename NVARCHAR(MAX)=''      
AS      
BEGIN      
DECLARE @id int=''  
DECLARE @out int=0 ,@str1 nvarchar(MAX)='' 
DECLARE @count int=0,@sp nvarchar(MAX)='' 

DECLARE @gridcount int=0;
SET @gridcount=(SELECT count(*) from obps_TopLinkExtended where Linkid=@id)

while @gridcount>=0
BEGIN

set @sp=(select gridsp from obps_TopLinkExtended where Linkid=@id and GridId=@gridcount)

set @str1=('SELECT @out=count(Name)  
    FROM sys.procedures  
    WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE ''%'+@tablename+'%''   
    and name in('''+@sp+''')')  
    EXEC Sp_executesql  @str1,  N'@out NVARCHAR(MAX) output',  @out output  

SET @count=@count+@out 
SET @gridcount=@gridcount-1

END

if @count>0  
begin  
 select '1' as 'result'  
end  
else  
begin  
 select '0' as 'result'  
end  

END     
GO
