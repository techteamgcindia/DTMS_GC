USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_admin_sp_DropColumn]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_admin_sp_DropColumn]  
@tabname nvarchar(MAX)='',  
@colname nvarchar(MAX)=''  
AS  
BEGIN  
DECLARE @str nvarchar(MAX)=''  
SET @str='ALTER TABLE '+@tabname+' DROP COLUMN '+@colname  
exec (@str)  
END  
GO
