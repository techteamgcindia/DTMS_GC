USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUserLink]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[obps_sp_InsertUserLink]              
@usr nvarchar(MAX)='',              
@userid nvarchar(MAX)='',              
@username nvarchar(MAX)='',              
@linkid nvarchar(MAX)='',              
@linkname nvarchar(MAX)='',              
@sublinkid nvarchar(MAX)='',            
@isRole nvarchar(MAX)=''            
AS              
BEGIN              
BEGIN TRY  
 DECLARE @XML AS XML,@DELIMITER AS VARCHAR(10)   
 DECLARE @rol int=0,@sub int,@roleid int,@id int  
  
 SET @roleid=(select RoleId from obps_Users where UserId=@userid)              
  
 IF OBJECT_ID(N'tempdb..#temp1') IS NOT NULL      
 BEGIN      
  DROP TABLE #temp1     
 END     
  
  IF OBJECT_ID(N'tempdb..#temp2') IS NOT NULL      
 BEGIN      
  DROP TABLE #temp2      
 END     
  
  CREATE TABLE #temp1(id int,sublink int,rolemap int)--for adding splitted sublink and rolemap  
  CREATE TABLE #temp2(id int,rolemap int)--for adding splitted rolemap  
  
 SET @DELIMITER =','   
 SET @XML = CAST(( '<LINKID>'   
       + REPLACE(@sublinkid, ',', '</LINKID><LINKID>')   
       + '</LINKID>' ) AS XML)   
  
 INSERT INTO #temp1(id,sublink)  
 SELECT row_number() over (order by (select NULL)) 'id',N.value('.', 'VARCHAR(10)') AS VALUE  
 FROM   @XML.nodes('LINKID') AS T(N)  
  
 SET @XML = CAST(( '<ROLEID>'   
       + REPLACE(@isRole, ',', '</ROLEID><ROLEID>')   
       + '</ROLEID>' ) AS XML)   
  
 INSERT INTO #temp2(id,rolemap)  
 SELECT row_number() over (order by (select NULL)) 'id', N.value('.', 'VARCHAR(10)') AS VALUE  
 FROM   @XML.nodes('ROLEID') AS T(N)  
  
 --For adding rolemap to the temp1 table by joining with the sublink data table   
 update T1 set T1.rolemap=T2.rolemap  
  from #temp1 T1 inner join #temp2 T2   
  on T1.id=T2.id  
   
 --removing the sublinks of the main link where there is no change or insert is not required  
 delete from #temp1 where sublink=0  
  
 --inserting records to the obps_UserLinks table by taking data from #temp1 row by row  
 DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                  
 SELECT sublink,rolemap FROM #temp1;                  
                   
   OPEN CUR_TEST                  
   FETCH NEXT FROM CUR_TEST INTO @sub,@rol                  
                   
   WHILE @@FETCH_STATUS = 0                  
   BEGIN      
     if @rol=1  
     BEGIN  
      insert into obps_UserLinks(UserId,UserName,LinkId,LinkName,CreatedDate,CreatedBy,ModifiedBy,IsActive,IsDeleted,RoleId,sublinkid,IsRoleAttached)  
      select @userid,@username,@linkid,@linkname,GETDATE(),@usr,'',1,0,@roleid,@sub,@rol  
      SET @id = SCOPE_IDENTITY()              
      exec obps_sp_InsertRoleMapping @id              
     END  
     ELSE  
      insert into obps_UserLinks(UserId,UserName,LinkId,LinkName,CreatedDate,CreatedBy,ModifiedBy,IsActive,IsDeleted,RoleId,sublinkid,IsRoleAttached)  
      select @userid,@username,@linkid,@linkname,GETDATE(),@usr,'',1,0,@roleid,@sub,0  
  
      FETCH NEXT FROM CUR_TEST INTO @sub,@rol                  
   END        
     
   CLOSE CUR_TEST                  
 DEALLOCATE CUR_TEST    
END TRY  
BEGIN CATCH  
 SELECT ERROR_MESSAGE() AS ErrorMessage;  
END CATCH  
END  

GO
