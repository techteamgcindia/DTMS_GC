USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertGanttDependency]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_InsertGanttDependency]    
@str nvarchar(MAX)=NULL,        
@LinkId int='',        
@usr nvarchar(MAX)=''       
AS    
BEGIN    
DECLARE @preid nvarchar(MAX),@sid nvarchar(MAX),    
  @string1 nvarchar(MAX),@string2 nvarchar(MAX),    
  @col nvarchar(MAX),@val nvarchar(MAX),@tabname nvarchar(MAX)=''    
    
SET @tabname=(select DependencyTable from Obps_GanttConfiguration where LinkId=@LinkId)    
select @tabname  
    
DECLARE CUR_TEST CURSOR FAST_FORWARD FOR        
SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval        
FROM [dbo].[Split] (@str, ',') ;        
         
OPEN CUR_TEST        
FETCH NEXT FROM CUR_TEST INTO @col,@val        
        
 WHILE @@FETCH_STATUS = 0        
 BEGIN     
   if @col = 'predecessorid'        
   begin       
    SET @preid=@val        
   end        
   else if @col = 'successorid'        
   begin        
    SET @sid=@val        
   end      
      
    FETCH NEXT FROM CUR_TEST INTO @col,@val        
 END        
            
CLOSE CUR_TEST        
DEALLOCATE CUR_TEST     
    
    
SET @string1='update '+@tabname +' set predecessorid='+@preid+',successorid='+@sid+' where id='+@preid    
--update obp_GanttData set predecessorid=null,successorid=null where id=@key    
select @string1    
EXEC Sp_executesql  @string1    
    
END
GO
