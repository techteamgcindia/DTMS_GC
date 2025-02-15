USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertCalculatedRowAttrib]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_admin_InsertCalculatedRowAttrib]  
@linkid nvarchar(MAX)='',  
@tabname nvarchar(MAX)='',  
@colname nvarchar(MAX)='',  
@mappedcol nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@isbackground nvarchar(MAX)='',  
@celleditcol nvarchar(MAX)=''  
AS  
BEGIN  
  
  INSERT INTO obps_calculatedrowattrib(ColName,MappedCol,GridId,IsBackground,CellEditColName,LinkId)  
  values(@colname,@mappedcol,@gridid,@isbackground,@celleditcol,@linkid)  
  select '1'  

END  
GO
