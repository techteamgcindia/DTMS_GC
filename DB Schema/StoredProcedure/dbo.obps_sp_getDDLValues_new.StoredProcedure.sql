USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getDDLValues_new]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getDDLValues_new]          
@colname nvarchar(MAX)='',          
@gridid nvarchar(MAX)='',          
@usrname NVARCHAR(MAX)='',          
@linkid int='',
@ddlSelectedValue nvarchar(MAX)=''
AS          
BEGIN          
           
 DECLARE @sp nvarchar(MAX)='',          
 @colnew nvarchar(MAX)='',          
 @tabname nvarchar(MAX)='',          
 @indx int,          
 @gid int,
 @dependentcolname nvarchar(50)='',
 @dependentcoltable int='',
 @dependentddlValue nvarchar(100),
 @col varchar(MAX),                  
 @val varchar(MAX)='',
 @depddl int=0,
 @ddlval nvarchar(100)=''
        
 SET @indx=(select CHARINDEX ('__',@colname,0 ))          
 SET @gid=(SELECT SUBSTRING(@gridid,5,1))          
 SET @colnew=(SELECT SUBSTRING(@colname, 1,@indx-1))          
 SET @tabname=(SELECT SUBSTRING(@colname, @indx+2, LEN(@colname)))          
 SET @sp=(SELECT dropdownlink from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
 and LinkId=@linkid)    
 
 if((SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
 and LinkId=@linkid)!=null)
 BEGIN
	 SET @depddl=1
	 SET @dependentcolname=(select colname from obps_colattrib where id=(SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
	 and LinkId=@linkid))
	 SET @dependentcoltable=(select TableName from obps_colattrib where id=(SELECT DependentDDLColid from obps_ColAttrib where COLNAME=@colnew and TableName=@tabname and dropdownlink is not null --and gridid=@gid         
	 and LinkId=@linkid))
	                   
		DECLARE CUR_TEST CURSOR FAST_FORWARD FOR                  
		SELECT SUBSTRING (items,0,CHARINDEX(':',items,0)) as colname,SUBSTRING (items,CHARINDEX(':',items,0)+1,len(items)) as colval                  
		FROM [dbo].[Split_UpdateSp] (@ddlSelectedValue, '^') ;                  
                   
		OPEN CUR_TEST                  
		FETCH NEXT FROM CUR_TEST INTO @col,@val                  
                   
			WHILE @@FETCH_STATUS = 0                  
			BEGIN 
				if(@col=(select (@dependentcolname+'__'+@dependentcoltable)))
					SET @ddlval=@val
			FETCH NEXT FROM CUR_TEST INTO @col,@val                  
			END		               
		CLOSE CUR_TEST                  
		DEALLOCATE CUR_TEST 
 END

 --SELECT dropdownlink from obps_ColAttrib where COLNAME='Stage' and TableName='obp_Leaddetails' and dropdownlink is not null and gridid=@gid and LinkId=@linkid          
 if len(rtrim(ltrim(@sp)))>0      
 BEGIN
 if(@depddl=1)
	exec @sp @usrname,@linkid,@gridid,@ddlval  
 else
	exec @sp @usrname,@linkid,@gridid    
 END
 --exec @sp @usrname    
END 
GO
