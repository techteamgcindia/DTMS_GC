USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[SP_ImportData]    Script Date: 2024-04-27 8:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Proc [dbo].[SP_ImportData] as
BEGIN

truncate table [obp_Finolex].[dbo].[obp_OB_VY41]

IF (OBJECT_ID('allfilenames') IS NOT NULL)
drop table allfilenames;
 
IF (OBJECT_ID('bulkact') IS NOT NULL)
drop table bulkact;
 
CREATE TABLE ALLFILENAMES(WHICHPATH VARCHAR(255),WHICHFILE varchar(255))
CREATE TABLE BULKACT(RAWDATA VARCHAR (8000))
declare @filename varchar(255),
        @path     varchar(255),
        @sql      varchar(8000),
        @cmd      varchar(1000)
 
SET @path = 'E:\ImportYE41\'
SET @cmd = 'dir "' + @path + '" *.csv /b'
INSERT INTO  ALLFILENAMES(WHICHFILE)
EXEC Master..xp_cmdShell @cmd
UPDATE ALLFILENAMES SET WHICHPATH = @path where WHICHPATH is null

--cursor loop
    declare c1 cursor for SELECT WHICHPATH,WHICHFILE FROM ALLFILENAMES where WHICHFILE like 'OB_YV41%.csv%'
    open c1
    fetch next from c1 into @path,@filename
    While @@fetch_status <> -1
      begin
      --bulk insert won't take a variable name, so make a sql and execute it instead:
       set @sql = 'BULK INSERT OB_YV41 FROM ''' + @path + @filename + ''' '
           + '     WITH ( 
                   FIELDTERMINATOR = '','', 
                   ROWTERMINATOR = ''\n'', 
                   FIRSTROW = 2 
                ) '
   -- print @sql
    exec (@sql)
 
      fetch next from c1 into @path,@filename
      end
    close c1
    deallocate c1
end
GO
