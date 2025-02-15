USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertSchedulerData]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertSchedulerData]    
@str VARCHAR(MAX)='',    
@Gridname NVARCHAR(MAX)='',    
@LinkId NVARCHAR(MAX)='',    
@usr nvarchar(MAX)=''    
AS    
BEGIN    
DECLARE  @Rule_ID int,    
  @ListType_ID int,    
  @Values VARCHAR(MAX)=NULL,    
  @col_name_strings varchar(MAX)='',    
  @col_val_strings varchar(MAX)='',    
  @insert_strings nvarchar(MAX)='',    
  @usrid nvarchar(500)='',    
  @tabnamequery nvarchar(MAX),    
  @tab_name nvarchar(500),    
  @query_Key nvarchar(MAX),    
  @pkey NVARCHAR(MAX),    
  @sout NVARCHAR(MAX),    
  @forkey nvarchar(MAX),    
  @forkeystr nvarchar(MAX) ,    
  @aftersavesp nvarchar(MAX)='',    
  @aftersavespname nvarchar(MAX)='',    
  @aftersavespnamequery nvarchar(MAX)=''    
    
DECLARE @col varchar(MAX)    
DECLARE @colnew varchar(MAX)=''    
DECLARE @val varchar(MAX),    
@indx int,    
 @gridid nvarchar(MAX),@ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),    
@controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int 
DECLARE @Start nvarchar(MAX)='', @End nvarchar(MAX)='', @Text nvarchar(MAX)='', @SchedulerType nvarchar(MAX)='',@include int=0
    
  
SET @Start=(select StartdateCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)  
SET @End=(select EnddateCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)     
SET @Text=(select TextCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)  
SET @SchedulerType=(select SchedulerTypeCol from obps_SchedulerDataMappingConfig where LinkId=@LinkId)
  
SET @gridid=(select substring(@Gridname, 5, 1))    
SET @tabnamequery=('(SELECT @tbname='+@Gridname+' FROM Obps_topLinks where '+@Gridname+'  is not null and Id='''+@LinkId+''')')    
EXEC Sp_executesql  @tabnamequery,  N'@tbname NVARCHAR(MAX) output',  @tab_name output    
  select @tab_name  
    
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR    
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval    
FROM [dbo].[Split] (@str, ',') ;    
     
OPEN CUR_TEST    
FETCH NEXT FROM CUR_TEST INTO @col,@val    
 select @col,@val    
  WHILE @@FETCH_STATUS = 0    
  BEGIN    
 
     set @include=0
	if @col='id'or @col='allDay' 
		set @include=0
	if(@col='Startdate')
	begin
		if (trim(@Start)<>'' or @Start is not null)
		begin
			set @include=1
			set @col=@Start
			set @val=dateadd(MINUTE,30,dateadd(hour,5,CONVERT(datetime,@val)))
		end
	end
	if(@col='Enddate')
	begin
		if (trim(@End)<>'' or @End is not null)
		begin
		select 'inside'
		select @End
			set @include=1
			set @col=@End
			set @val=dateadd(MINUTE,30,dateadd(hour,5,CONVERT(datetime,@val)))
		end
	end
	if(@col='Text')
	begin
		if (trim(@Text)<>'' or @Text is not null)
		begin
			set @include=1
			set @col=@Text
		end
	end
	if(@col='ScheduleType')
	begin
		if (trim(@SchedulerType)<>'' or @SchedulerType is not null)
		begin
			set @include=1
			set @col=@SchedulerType
		end
	end
    
  
  if @include=1
  begin

	if @col_name_strings=''      
	   begin      
	   set @col_name_strings=  RTRIM(LTRIM(@col))     
       set @col_val_strings= ''''+@val  
		--set @col_name_strings=@col_name_strings+@col+'='''+@val+''''      
	   end      
	   else      
	   begin      
	   set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@col))    
       set @col_val_strings=@col_val_strings+''','''+ @val    
		--set @col_name_strings=@col_name_strings+','+@col+'='''+@val+''''      
	   end

  end  
      
   IF @col = 'CreatedDate'    
   BEGIN    
    IF EXISTS(SELECT TOP 1 * FROM INFORMATION_SCHEMA.COLUMNS    
    WHERE [TABLE_NAME] = @tab_name AND [COLUMN_NAME] = 'CreatedDate')    
    BEGIN    
    
      if @col_name_strings=''     
      begin    
       select @col_name_strings    
       set @col_name_strings=  RTRIM(LTRIM(@col))     
       set @col_val_strings= ''''+@val    
      end    
      else     
      begin    
       set @col_name_strings=@col_name_strings+ ','+  RTRIM(LTRIM(@col))    
       set @col_val_strings=@col_val_strings+''','''+ @val    
      end    
    END    
   END    
        FETCH NEXT FROM CUR_TEST INTO @col,@val    
  END    
    
  set @col_val_strings=@col_val_strings+''''    
CLOSE CUR_TEST    
DEALLOCATE CUR_TEST    
  
if @col_name_strings<>''     
begin    
 set @col_name_strings=@col_name_strings+ ','    
 SET @col_name_strings=@col_name_strings+'Createdby'    
 SET @col_val_strings=@col_val_strings+','''+@usr+''''    
END    
  
    
set @insert_strings='insert into '+@tab_name+'('+@col_name_strings+')values('+@col_val_strings+')'    
select @insert_strings,@col_name_strings,@col_val_strings    
EXEC Sp_executesql  @insert_strings--,N'@sout NVARCHAR(MAX) output',  @sout output    
    
SET @aftersavesp=(SELECT SUBSTRING(@Gridname, 1,5)+'AfterSaveSp')    
    
 SET @aftersavespnamequery=('(SELECT @aftersavespname='+@aftersavesp+' FROM Obps_TopLinks where '+@aftersavesp+'  is not null and Id='''+@LinkId+''')')      
 EXEC Sp_executesql  @aftersavespnamequery,  N'@aftersavespname NVARCHAR(MAX) output', @aftersavespname output      
      
 IF len(@aftersavespname)>0     
 BEGIN    
 EXEC @aftersavespname     
 END     
    
END    
GO
