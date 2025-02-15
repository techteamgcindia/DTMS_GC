USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_UpdateCalculatedRowAttribSettings]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_admin_UpdateCalculatedRowAttribSettings]  
@linkid nvarchar(MAX)='',  
@columnname nvarchar(MAX)='',  
@mappedcol nvarchar(MAX)='',  
@gridid nvarchar(MAX)='',  
@issamebackground nvarchar(MAX)='',  
@celleditcolname nvarchar(MAX)='',  
@id nvarchar(MAX)=''  
AS  
BEGIN  
  
update obps_calculatedRowAttrib set LinkId=@linkid,ColName=@columnname,  
  MappedCol=@mappedcol,GridId=@gridid,IsBackground=@issamebackground,  
  CellEditColName=@celleditcolname where id=@id  
  
END
GO
