USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_GetDDLColName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_GetDDLColName]
@tabname nvarchar(MAX)=''  ,    
@ddltable nvarchar(MAX)='',
@linkid nvarchar(MAX)=''   
AS
BEGIN
IF @ddltable='yes'
 SELECT ORDINAL_POSITION 'id',COLUMN_NAME 'ColName'        
 FROM INFORMATION_SCHEMA.COLUMNS        
 WHERE TABLE_NAME = @tabname        
 and COLUMN_NAME not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')        
 ORDER BY ORDINAL_POSITION  
ELSE
	select id,ColName from obps_ColAttrib           
   where ColName not in ('id','id1','Color1','Color2','Color3','Color4','Color5','SeqNo','CreatedDate','ModifiedDate','Createdby','Modifiedby','isActive','isDeleted','AccessToUser','ShareToUser')          
   and IsActive=1 and LOWER(ColControlType)='dropdownlist' and TableName=@tabname  and LinkId=@linkid
END
GO
