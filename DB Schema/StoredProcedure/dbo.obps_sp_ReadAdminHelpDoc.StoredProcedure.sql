USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadAdminHelpDoc]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadAdminHelpDoc]  
AS   
BEGIN  
  
DECLARE   
  @id int,   
  @usertype nvarchar(MAX),  
  @currusertype nvarchar(MAX)='',  
  @counter int;  
  
 IF OBJECT_ID(N'tempdb..#temp') IS NOT NULL      
 BEGIN      
  DROP TABLE #temp      
 END      
      
 select * into #temp from obps_HelpDoc  

 DECLARE cursor_help_doc CURSOR  
 FOR SELECT id,usertype FROM obps_HelpDoc  
 where UserType is not null and len(UserType)>0;  
  
 OPEN cursor_help_doc;  
  
 FETCH NEXT FROM cursor_help_doc INTO   
  @id,@usertype;  
  
 WHILE @@FETCH_STATUS = 0  
  BEGIN  
    
   IF OBJECT_ID(N'tempdb..#temp2') IS NOT NULL      
   BEGIN      
    DROP TABLE #temp2      
   END      
  set @usertype=','+@usertype
   SELECT row_number()over (order by items)id,items  into #temp2                
   FROM [dbo].[Split] (@usertype, ',') ;  
   

   update T set T.items=U.UserType  
   from #temp2 T inner join obps_UserType U  
   on T.items=U.UserTypeId --where U.id=T.items  

   set @counter=1  
    
   while(@counter<=(select count(*) from #temp2))  
   begin  
    if(@currusertype='')  
     set @currusertype=(select items from #temp2 where id=@counter)  
    else  
     set @currusertype=@currusertype+','+(select items from #temp2 where id=@counter)  
    set @counter=@counter+1  
   end  
   update #temp set UserType=@currusertype where id=@id  
   set @currusertype=''  
   FETCH NEXT FROM cursor_help_doc INTO @id,@usertype;  
  END;  
  
 CLOSE cursor_help_doc;  
  
 DEALLOCATE cursor_help_doc;  
  
 --select * from #temp where FileName!='' and DisplayName!=''  
  select  id ,groupname,DisplayName, filename,usertype 'UserTypeDesc',isactive from #temp order by id    
  

  
END  

GO
