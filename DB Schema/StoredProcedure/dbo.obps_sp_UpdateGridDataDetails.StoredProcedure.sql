USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateGridDataDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_UpdateGridDataDetails]                            
 @gridid NVARCHAR(MAX)=NULL,                            
 @str nvarchar(MAX),                            
 @key nvarchar(50)=NULL,                            
 @LinkId NVARCHAR(MAX)=NULL,                            
 @usr nvarchar(MAX)='' ,                        
 @loc nvarchar(MAX)=''                        
AS                            
BEGIN                            
  DECLARE @query NVARCHAR(MAX),                            
  @tabname NVARCHAR(MAX),                            
  @pkey NVARCHAR(MAX),                            
  @indx int,                            
  @colname_new NVARCHAR(MAX),                            
  @count int,                            
  @datatype nvarchar(MAX),                            
  @col varchar(MAX),                            
  @colnew varchar(MAX)='',                            
  @val nvarchar(MAX)='',                            
  @querystr nvarchar(MAX)=''  ,                          
  @aftersavespname nvarchar(MAX)='',                          
  @isLocation nvarchar(2)='',                        
  @locationColName nvarchar(max)=''                        
                          
  DECLARE @ddlcoltosel nvarchar(MAX),@ddlcoltoinsert nvarchar(MAX),@ddltabletosel nvarchar(MAX),                            
@controltype varchar(MAX), @queryvalstr NVARCHAR(MAX),@ddlid nvarchar(MAX),@colid int,@isId int                            
                            
    SET NOCOUNT ON;                            
SET @tabname=(select GridTable from obps_TopLinkExtended where Linkid=@LinkId and GridId=@gridid)                         


IF @tabname is not null                            
BEGIN                            
                            
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                            
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval                            
FROM [dbo].[Split_UpdateSp] (@str, '^') ;                            
                             
OPEN CUR_TEST                            
FETCH NEXT FROM CUR_TEST INTO @col,@val                            
                             
WHILE @@FETCH_STATUS = 0                            
BEGIN                            
--select @col,@val                        
if CHARINDEX('__',@col) > 0                        
begin                        
SET @indx=(select CHARINDEX ('__',@col,0 ))                            
  --select 'value is '+@val                          
SET @colnew=(SELECT SUBSTRING(@col, 1,@indx-1))                            
SET @tabname=(SELECT SUBSTRING(@col, @indx+2, LEN(@col)))                            
SET @datatype=(SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE                             
TABLE_NAME = @tabname AND                             
COLUMN_NAME = @colnew)                            
--select @datatype                            
                    
set @controltype=(select ColControlType from obps_ColAttrib  where ColName=@colnew and TABLENAME = @tabname AND  linkid=@LinkId)                            
--if @datatype is not null                        
--begin                        
 if (CHARINDEX(@colnew,@querystr) <= 0  and lower(@colnew)<>'modifieddate'and lower(@colnew)<>'createddate')                      
 begin                        
  if LOWER(@controltype)='dropdownlist'                            
  begin                            
   --select 'inside'                            
   SET @colid=(SELECT id from obps_ColAttrib where colname=@colnew AND TABLENAME = @tabname and linkid=@linkid)                            
   SET @ddlcoltosel=(SELECT columntoselect from obps_dropdowntable where columnid=@colid)                             
   SET @ddlcoltoinsert=(SELECT columntoinsert from obps_dropdowntable where columnid=@colid)                            
   SET @ddltabletosel=(SELECT tabletoselect from obps_dropdowntable where columnid=@colid)                            
   SET @IsId=(SELECT IsId from obps_dropdowntable where columnid=@colid)                    
   --select @colid,@ddlcoltosel,@ddlcoltoinsert,@ddltabletosel,@IsId                            
IF @IsId=1                            
   BEGIN                            
    set @queryvalstr='select @ddlid=id from '+@ddltabletosel+' where '+@ddlcoltosel+'=N'''+@val+''''                   
    EXEC Sp_executesql  @queryvalstr,  N'@ddlid NVARCHAR(MAX) output',  @ddlid output                            
    SET @val=@ddlid                     
   --select @val,@queryvalstr,@ddltabletosel,@ddlcoltosel,@ddlid                          
   END                         
                         
   if @querystr=''                          
   begin                            
    set @querystr=@querystr+RTRIM(LTRIM(@ddlcoltoinsert)) +'='''+@val+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+RTRIM(LTRIM(@ddlcoltoinsert)) +'='''+@val+''''                            
   end                            
  end                      
  else  if @datatype='int'                            
  begin                            
   if @querystr=''                            
   begin                          
    set @querystr=@querystr+@colnew+'='+case when len(@val)>0 then @val else '''''' end                         
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'='+case when len(@val)>0 then @val else '''''' end                       
   end                            
  end                            
  else if @datatype='datetime' or @datatype='date'                            
  begin                            
   IF @val='null'                          
   BEGIN                            
    SET @val= ' '                            
   END                            
   if @querystr=''                            
   begin          
   set @querystr=@querystr+@colnew+'='''+ convert(CHAR(19),@val,120)+''''         
   -- set @querystr=@querystr+@colnew+'='''+ convert(CHAR(19),PARSE(@val AS datetime USING 'it-IT'),120)+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'='''+ convert(CHAR(19),@val,120)+''''                            
   end                            
  end                            
  else                            
  begin                            
   if @querystr=''                            
   begin                            
    set @querystr=@querystr+@colnew+'=N'''+@val+''''                            
   end                            
   else                            
   begin                            
    set @querystr=@querystr+','+@colnew+'=N'''+@val+''''                            
   end                            
  end                            
                        
 end                        
end                        
--select @querystr                            
--END                            
  FETCH NEXT FROM CUR_TEST INTO @col,@val                            
END                            
CLOSE CUR_TEST                            
DEALLOCATE CUR_TEST                            
                            
                            
SET @isLocation=(select IsLocation from obps_TopLinks where id=@LinkId)                        
if(@isLocation='1')                        
BEGIN                        
                         
 SET @locationColName=(select locationcolname from obps_locationconfig where linkid=@LinkId)                        
 SET @querystr=@querystr+','+@locationColName+'='''+@loc+''''                        
                        
END                        
if(len(@querystr)>0)                      
BEGIN                      
                  
 SET @pkey=(SELECT TableKey FROM Obps_TableId WHERE TableName=@tabname )--and Linkid=@LinkId)                  
            
 set @querystr='update '+@tabname+' set '+@querystr+',ModifiedDate='''+CONVERT(VARCHAR,GETDATE(),121)+''',ModifiedBy='''+@usr+''' where '+@pkey+'='+@key+''                 
 select (@querystr)                            
 EXEC (@querystr)                            
                          
  SET @aftersavespname=(SELECT AfterSaveSp FROM Obps_TopLinkextended where GridId=@gridid and Linkid=@LinkId)             
                            
  IF len(Ltrim(rtrim(@aftersavespname)))>1                         
  BEGIN                            
  EXEC @aftersavespname @key
  Select @aftersavespname 'AfterSaveSP', @key 'Key'
  END                            
 END                         
END                            
END   
  
GO
