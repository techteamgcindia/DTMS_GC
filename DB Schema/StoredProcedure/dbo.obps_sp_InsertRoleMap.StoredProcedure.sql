USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertRoleMap]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_InsertRoleMap]        
@tabname nvarchar(MAX)='',        
@tabid nvarchar(MAX)='',        
@colname nvarchar(MAX)='',        
@i nvarchar(MAX)='',        
@roleid int='',        
@gridid int='' ,    
@linkid int=''    
AS        
BEGIN        
	DECLARE @count int

	SET @count=(select count(*) from obps_RoleMap where LinkId=@linkid and RoleId=@roleid
				and gridid=@gridid and TableID=@tabid and TableName=@tabname and ColName=@colname)

	IF @count=0
	BEGIN
		if @roleid=''        
		BEGIN        
		INSERT INTO [dbo].[obps_RoleMap]        
				   ([RoleId],[TableID],[ColName],[IsEditable]        
				   ,[CreatedDate],[TableName],[gridid],[linkid],[isvisible],VisibilityIndex)        
			 VALUES        
				   (1,@tabid,@colname,1,getdate(),@tabname,@gridid,@linkid,1,NULL)        
		END        
		ELSE        
		BEGIN        
		 IF @gridid=''        
		 BEGIN        
		  INSERT INTO [dbo].[obps_RoleMap]        
			  ([RoleId],[TableID],[ColName],[IsEditable]        
			  ,[CreatedDate],[TableName],[gridid],[linkid],[isvisible],VisibilityIndex)        
		   VALUES        
			  (@roleid,@tabid,@colname,1,getdate(),@tabname,NULL,@linkid,1,NULL)       
		 END        
		 ELSE        
		 BEGIN        
		  INSERT INTO [dbo].[obps_RoleMap]        
			  ([RoleId],[TableID],[ColName],[IsEditable]        
			  ,[CreatedDate],[TableName],[gridid],[linkid],[isvisible],VisibilityIndex)        
		   VALUES        
			  (@roleid,@tabid,@colname,1,getdate(),@tabname,@gridid,@linkid,1,NULL)        
		 END        
		END        
	END
END        
  
GO
