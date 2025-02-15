USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertRowAttrib]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_admin_InsertRowAttrib]  
@linkid nvarchar(MAX)='',  
@tabname nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@mappedcol nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@isbackground nvarchar(MAX)='', 
@cellctrlcol nvarchar(MAX)='',
@ddlsp nvarchar(MAX)='',
@celleditcol nvarchar(MAX)=''  
AS  
BEGIN  
 DECLARE @tabid nvarchar(MAX)='',@count int=0;  
 SET @count=(select count(*) from obps_TableId where TableName=@tabname)  
  
 IF @count>0  
 BEGIN  
  SET @tabid=(select tableid from obps_TableId where TableName=@tabname)  
  INSERT INTO obps_RowAttrib(TableID,TableName,ColName,MappedCol,GridId,IsBackground,CellEditColName,CellCtrlTypeColName,DdlCtrlSpColName,LinkId)  
  values(@tabid,@tabname,@colname,@mappedcol,@gridid,@isbackground,@celleditcol,@cellctrlcol,@ddlsp,@linkid)  
  select '1'  
 END  
 ELSE  
  Select '0'  
END  
  
GO
